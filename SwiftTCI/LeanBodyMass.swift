//
//  LeanBodyMass.swift
//  SwiftTCI
//
//  Derived from PyTCI - https://github.com/JMathiszig-Lee/PyTCI
//
//  Created by Ross Scott-Weekly on 24/5/19.
//
//  Copyright (c) 2019 Ross Scott-Weekly
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
//  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
//  IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
//  DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
//  OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE
//  OR OTHER DEALINGS IN THE SOFTWARE.


import Foundation

public enum WeightCalcError : Error {
    case SexDescriber(Message:String)
}

public enum BiologicalSex {
    case M
    case F
}

// Round the given value to a specified number
// of decimal places
// http://www.globalnerdy.com/2016/01/26/better-to-be-roughly-right-than-precisely-wrong-rounding-numbers-with-swift/

func round(_ value: Double, toDecimalPlaces places: Int) -> Double {
    let divisor = pow(10.0, Double(places))
    return round(value * divisor) / divisor
}

func SetSex(Sex:Character) throws -> BiologicalSex {
    let SexUppercase = Sex.uppercased()

    if SexUppercase == "M" {
        return .M
    }
    
    if SexUppercase == "F" {
        return .F
    }
    
    throw WeightCalcError.SexDescriber(Message: "Unknown sex \(Sex). This algorithm can only handle 'M' and 'F")
    
}

public func BMI(Height: Double, Weight: Double) -> Double {
    return Weight / pow((Height / 100),2.0)
}


public func james(Height: Double, Weight: Double, Sex: Character) throws -> Double {
    /* returns lean body mass as per james equations
    James, W. "Research on obesity: a report of the DHSS/MRC group" HM Stationery Office 1976 */

    let SexEnum = try SetSex(Sex: Sex)
        
    switch SexEnum {
    case .M:
        return 1.1 * Weight - 128 * ((Weight / Height) * (Weight / Height))
    case .F:
        return 1.07 * Weight - 148 * ((Weight / Height) * (Weight / Height))
    }
}


public func boer(Height: Double, Weight: Double, Sex: Character) throws -> Double {
    /* returns lean body mass as per Boer equation """
    Boer P. "Estimated lean body mass as an index for normalization of body fluid volumes in man." Am J Physiol 1984; 247: F632-5 */
    
    let SexEnum = try SetSex(Sex: Sex)
    var lbm : Double
    
    switch SexEnum {
    case .M:
        lbm = (0.407 * Weight) + (0.267 * Height) - 19.2
    case .F:
        lbm = (0.252 * Weight) + (0.473 * Height) - 48.3
    }
    
    return round(lbm, toDecimalPlaces: 1)
}

public func Hume66(Height: Double, Weight: Double, Sex: Character) throws -> Double {
    /* returns lean body mass as per the 1966 Hume paper """
     Hume, R "Prediction of lean body mass from height and weight.". J Clin Pathol. 1966 Jul; 19(4):389-91 */

    let SexEnum = try SetSex(Sex: Sex)
    var lbm : Double
    
    switch SexEnum {
    case .M:
        lbm = (0.32810 * Weight) + (0.33929 * Height) - 29.5336
    case .F:
        lbm = (0.29569 * Weight) + (0.41813 * Height) - 43.2933
    }
    
    return round(lbm, toDecimalPlaces: 1)
}

public func Hume71(Height: Double, Weight: Double, Sex: Character) throws -> Double {
    /* returns lean body mass from Hume & Weyers(1971)
    Relationship between total body water and surface area in normal and obese subjects. Hume R, Weyers E J Clin Pathol 24 p234-8 (1971 Apr) */
    
    let SexEnum = try SetSex(Sex: Sex)
    var lbm : Double
    
    switch SexEnum {
    case .M:
        lbm = (0.4066 * Weight) + (0.2668 * Height) - 19.19
    case .F:
        lbm = (0.2518 * Weight) + (0.4720 * Height) - 48.32
    }
    
    return round(lbm, toDecimalPlaces: 1)
}

public func Janmahasation(Height: Double, Weight: Double, Sex: Character) throws -> Double {
    /* lean body mass as per Janmahasation / Han 2005 */
    
    let SexEnum = try SetSex(Sex: Sex)
    var lbm : Double
    
    let bmi = BMI(Height:Height, Weight:Weight)

    switch SexEnum {
    case .M:
        lbm = (9270 * Weight) / (6680 + 216 * bmi)
    case .F:
        lbm  = (9270 * Weight) / (8780 + 244 * bmi)
    }
    
    return round(lbm, toDecimalPlaces: 1)

}

public func IdealBodyWeight(Height: Double, Sex:Character) throws -> Double {
    // ideal body weight as per ARDSnet/Devine

    let SexEnum = try SetSex(Sex: Sex)
    var ibm : Double
    
    switch SexEnum {
    case .M:
        ibm = 50.0 + 0.91 * (Height - 152.4)
    case .F:
        ibm = 45.5 + 0.91 * (Height - 152.4)
    }
    
    return round(ibm, toDecimalPlaces: 1)
}

public func AdjustedBodyWeight(Height: Double, Weight: Double, Sex: Character) throws -> Double {
    let ibw = try IdealBodyWeight(Height: Height, Sex: Sex)
    let abw = ibw + 0.4 * (Weight - ibw)
    
    return round(abw, toDecimalPlaces: 1)
}

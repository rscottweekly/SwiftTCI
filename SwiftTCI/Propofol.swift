//
//  Propofol.swift
//  SwiftTCI
//
//  Created by Ross Scott-Weekly on 25/5/19.
//  Copyright © 2019 Ross Scott-Weekly. All rights reserved.
//

import Foundation

public enum PropofolError : Error {
    case OldConcentrationError(msg:String)
    case AgeError(msg:String)
}

public enum ErrorWarnManagement {
    case Warn
    case Throw
    case Ignore
}

public class BasePropofol : ThreeBaseModel {
    var OldConcs: Dictionary<String, Double?> = ["X1":nil, "X2":nil, "X3":nil, "xeo":nil]
    
    public func SetConcs() {
        self.OldConcs = ["X1": self.x1, "X2": self.x2, "X3": self.x3, "xeo": self.xeo]
    }
    
    public func ResetConcs(clearOld : Bool = true) throws -> Void {
        // resets the concentrations to stored values
        guard let x1 = self.OldConcs["X1"]! else {
            throw PropofolError.OldConcentrationError(msg: "X1 not set")
        }
        
        guard let x2 = self.OldConcs["X2"]! else {
            throw PropofolError.OldConcentrationError(msg: "X2 not set")
        }
        
        guard let x3 = self.OldConcs["X3"]! else {
            throw PropofolError.OldConcentrationError(msg: "X3 not set")
        }
        
        guard let xeo = self.OldConcs["xeo"]! else {
            throw PropofolError.OldConcentrationError(msg: "xeo not set")
        }
        
        self.x1 = x1
        self.x2 = x2
        self.x3 = x3
        self.xeo = xeo
        
        if clearOld {
            OldConcs["X1"] = nil
            OldConcs["X2"] = nil
            OldConcs["X3"] = nil
            OldConcs["xeo"] = nil
        }
    }
    
    public func TenSeconds(_ mgpersec:Double) -> Double {
        for _ in 0..<10 {
            self.giveDrug(doseMilligrams: mgpersec)
            self.waitTime(timeSeconds: 1)
        }
        return self.x1
    }
    
    public func effectBolus(Target: Double) throws -> Double {
        // determines size of bolus needed over 10 seconds to achieve target at ttpe
        
        ///store concentrations so we can reset after search
        self.SetConcs()
        
        let ttpe = 90
        let bolus_seconds = 10.0
        var bolus = 10.0
        var mgpersec : Double
        var step : Double
        
        var effect_error = 100.0
        
        repeat  {
            mgpersec = bolus / bolus_seconds
            
            
            _ = self.TenSeconds(mgpersec)
            self.waitTime(timeSeconds: ttpe - 10)
        
            effect_error = ((self.xeo - Target) / Target) * 100.0
        
            step = Double(effect_error) / -5.0
            bolus += step
            try self.ResetConcs(clearOld: false)

        } while !(-1 < effect_error) && (effect_error < 1)
        
        //reset concentrations
        return round(mgpersec * 10, toDecimalPlaces: 2)
    }
    
    public func PlasmaInfusion(Target: Double, Time:Int16) throws -> [(Double, Double)] {
        // Returns list of infusion rates to maintain desired plasma concentations
        //        returns:
        //        list of infusion rates over 10 seconds
        
        self.SetConcs()
        let sections : Int = Int(round(Double(Time) / 10))
        
        var pumpInstructions = [(Double, Double)]()
        
        for _ in 0..<sections {
            let firstCP = self.TenSeconds(3)
            try self.ResetConcs()
            
            let secondCP = self.TenSeconds(12)
            try self.ResetConcs()
            
            let gradient = (secondCP / firstCP) / 9
            let offset = firstCP - (gradient * 3)
            
            let finalmgPerSec : Double
            //Do not allow a negative drug dose
            if (Target - offset) / gradient < 0 {
                finalmgPerSec = 0.0
            }
            else {
                finalmgPerSec = (Target - offset) / gradient
            }
            
            let sectionCP = self.TenSeconds(finalmgPerSec)
            self.SetConcs()
            
            pumpInstructions.append((finalmgPerSec, sectionCP))
            
        }
        return pumpInstructions
    }
    
}


public class Schnider:BasePropofol{
    /* Implementation of the schnider model

    UNITS:
     age: years
     weight: kilos
     height: cm
     sex: 'm' or 'f'
 
    */

    public init(Age:Int, Weight: Double, Height: Double, Sex:Character) throws {
        super.init()
        
        let leanBodyMass = try james(Height: Height, Weight: Weight, Sex: Sex)
        
        self.v1 = 4.27
        self.v2 = 18.9 - 0.391 * (Double(Age) - 53.0)
        self.v3 = 238.0
        
        self.k10 = (0.443 + 0.0107 * (Weight - 77.0) - 0.0159 * (leanBodyMass - 59.0) + 0.0062 * (Height - 177.0))
        self.k12 = 0.302 - 0.0056 * (Double(Age) - 53.0)
        self.k13 = 0.196
        self.k21 = 1.29 - 0.024 * (Double(Age) - 53) / self.v2
        self.k31 = 0.0035
        
        self.keo = 0.456
    }
}


public class Marsh:BasePropofol {
    public init(Weight: Double) {
        super.init()
        self.v1 = 0.228 * Weight
        self.v2 = 0.463 * Weight
        self.v3 = 2.893 * Weight
        
        self.k10 = 0.119
        self.k12 = 0.112
        self.k13 = 0.042
        self.k21 = 0.055
        self.k31 = 0.0031
        
        self.keo = 0.26
    }
}

public class Kataria:BasePropofol {
    public var warnings : [String] {get {
        return self._warnings
        }}
    var _warnings : [String]
    
    
    public init(Weight: Double, Age: Double, WarningMethod:ErrorWarnManagement = .Throw) throws {
        self._warnings = Array<String> ()
        
        super.init()
        
        if (Age < 2.99) || (Age>12) {
            let message = "Age out of range of model validation (3-11)"
            switch WarningMethod {
            case .Throw:
                throw PropofolError.AgeError(msg: message)
            case .Warn:
                _warnings.append(message)
            case .Ignore:
                break
            }
        }
        
        self.v1 = 0.38 * Weight
        self.v2 = (0.59 * Weight) + (3.1 * Age) - 13
        self.v3 = 6.12 * Weight
        
        self.Q1 = 0.037 * Weight
        self.Q2 = 0.063 * Weight
        self.Q3 = 0.025 * Weight
        
        self.fromClearances()
        
        self.keo = 0
    }
    
}

public class Paedfusor:BasePropofol {
    public var warnings : [String] {get {
        return self._warnings
        }}
    var _warnings : [String]
    public init(Weight: Double, Age: Double,  WarningMethod:ErrorWarnManagement = .Throw) throws {
        _warnings = Array<String> ()
        super.init()
        
        if (Age < 1) || (Age>12) {
            let message = "Age out of range of model intention (1-11)"
            switch WarningMethod {
            case .Throw:
                throw PropofolError.AgeError(msg: message)
            case .Warn:
                _warnings.append(message)
            case .Ignore:
                break
            }
        }
        
        self.v1 = 0.46 * Weight
        self.v2 = 0.95 * Weight
        self.v3 = 5.85 * Weight
        self.k10 = 0.1527 * (pow(Weight, -0.3))
        self.k12 = 0.114
        self.k13 = 0.042
        self.k21 = 0.055
        self.k31 = 0.0033
        
        self.keo = 0

        
    }
}


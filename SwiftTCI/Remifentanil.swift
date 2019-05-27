//
//  Remifentanil.swift
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

public class RemifentatilBaseModel : ThreeBaseModel {
    
}

public class Minto : RemifentatilBaseModel {
    public init(Height: Double, Weight: Double, Age: Double, Sex: Character) throws {
        super.init()
        let leanBodyMass = try james(Height: Height, Weight: Weight, Sex: Sex)

        
        self.v1 = 5.1 - 0.0201 * (Age - 40) + 0.072 * (leanBodyMass - 55)
        self.v2 = 9.82 - 0.0811 * (Age - 40) + 0.108 * (leanBodyMass - 55)
        self.v3 = 5.42
        
        self.k10 = (
            2.6 - 0.0162 * (Age - 40) + 0.0191 * (leanBodyMass - 55)
            ) / self.v1
        self.k12 = (2.05 - 0.0301 * (Age - 40)) / self.v1
        self.k13 = (0.076 - 0.00113 * (Age - 40)) / self.v1
        self.k21 = self.k12 * (self.v1 / self.v2)
        self.k31 = self.k13 * (self.v1 / self.v3)
        
        self.keo = 0.595 - 0.007 * (Age - 40)
    }
}

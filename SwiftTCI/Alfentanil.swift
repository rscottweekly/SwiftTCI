//
//  Alfentanil.swift
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

public class AlfentatilBaseModel : ThreeBaseModel {
    
}

public class Maitre : AlfentatilBaseModel {
    public init(Height: Double, Weight: Double, Age: Double, Sex: Character) throws {
        super.init()
        
        let SexEnum = try SetSex(Sex: Sex)
        
        self.v1 = Weight * (SexEnum == .M ? 0.111 : 0.128)
        
        self.k12 = 0.104
        self.k13 = 0.017
        self.k21 = 0.0673


        if Age > 40 {
            self.k31 = 0.0126 - (0.000113 * (Age - 40))
            self.Q1 = 0.356 - (0.00269 * (Age - 40))
        }
        else {
            self.k31 = 0.0126
            self.Q1 = 0.356
        }
        
        //calulated stuff as source paper gives mix of clearance and rate constants
        self.k10 = self.Q1 / self.v1
        self.v2 = self.v1 * (self.k12 / self.k21)
        self.v3 = self.v1 * (self.k13 / self.k31)
        
        self.keo = 0.77
        
        
    }
}

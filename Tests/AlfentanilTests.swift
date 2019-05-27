//
//  AlfentanilTests.swift
//  Tests
//
//  Derived from PyTCI - https://github.com/JMathiszig-Lee/PyTCI
//
//  Created by Ross Scott-Weekly on 27/5/19.
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
import Nimble
import Quick
import SwiftTCI

class AlfentanilTests : QuickSpec {
    override func spec() {
        var testPatient : Maitre!
        
        describe("Test a male") {
            beforeEach {
                testPatient = try! Maitre(Height: 170, Weight: 70, Age: 30, Sex: "M")
            }
            
            it("calculates volumes correctly") {
                expect{testPatient.v1}.to(beCloseTo(7.77, within: 0.01))
                expect{testPatient.v2}.to(beCloseTo(12.01, within:0.01))
                expect{testPatient.v3}.to(beCloseTo(10.48, within: 0.01))
            }
            it("calculates Q correctly") {
                expect{testPatient.Q1}.to(beCloseTo(0.356, within: 0.001))
            }
        }
        describe("Test a female") {
            beforeEach {
                testPatient = try! Maitre(Height:165, Weight: 80, Age: 60, Sex: "F")
            }
            it("Calculates V1 Correctly") {
                expect{testPatient.v1}.to(beCloseTo(10.24, within:0.01))
            }
        }
    }
}

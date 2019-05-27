//
//  TestPropofol.swift
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
import Quick
import Nimble
import SwiftTCI

class PropofolTests: QuickSpec {
    override func spec() {
        describe("Test Schnier Model on 40yo, 140cm, 70kg male"){
            var testPatient : Schnider!
            beforeEach {
                testPatient = try! Schnider(Age: 40, Weight: 70.0, Height:170.0, Sex:"M")
            }
            
            describe("Test Vds") {
                it("V2") {
                    expect{testPatient.v2}.to(beCloseTo(23.9, within: 0.1))
                }
            }
            
            describe("Test initial rate constants"){
                it("k10") {
                    expect{testPatient.k10}.to(beCloseTo(0.384/60, within:0.001))
                }
                it("k12") {
                    expect{testPatient.k12}.to(beCloseTo(0.375/60, within:0.001))
                }
                it("k21") {
                    expect{testPatient.k21}.to(beCloseTo(0.067, within:0.1))
                }
                
            }
            
            describe("Give dose of drug") {
                it("Set x1 works") {
                    testPatient.giveDrug(doseMilligrams: 200)
                    expect{testPatient.x1}.to(beCloseTo(46.84, within: 0.01))
                }
            }
            
            describe("Wait 1s") {
                it("See x1 works") {
                    testPatient.giveDrug(doseMilligrams: 200)
                    testPatient.waitTime(timeSeconds: 1)
                    expect{testPatient.x1}.to(beCloseTo(46.0933, within:0.01))
                }
                
            }
            
            describe("Wait 60s") {
                it("Correctly calculates x1 at 60s") {
                    testPatient.giveDrug(doseMilligrams: 200)
                    testPatient.waitTime(timeSeconds: 60)
                    expect{testPatient.x1}.to(beCloseTo(22.03, within:0.01))
                }
            }
        }
        describe("Using Marsh Model") {
            var testPatient:Marsh!
            describe("Checking Volumes"){
                testPatient = Marsh(Weight: 70)
                it("Calculates Volumes") {
                    expect{testPatient.v1}.to(beCloseTo(16.0, within: 0.1))
                    expect{testPatient.v2}.to(beCloseTo(32.4, within: 0.1))
                    expect{testPatient.v3}.to(beCloseTo(202.5, within: 0.1))
                }
            }
        }
        
        describe("Using Kataria Model") {
            var testPatient:Kataria!
            describe("Check V & Q") {
                testPatient = try! Kataria(Weight: 20, Age: 6)
                it("Has correct V") {
                    expect{testPatient.v1}.to(beCloseTo(7.6, within: 0.1))
                    expect{testPatient.v2}.to(beCloseTo(17.4, within:0.1))
                    expect{testPatient.v3}.to(beCloseTo(122.4, within:0.1))
                }
                it("Has correct Q"){
                    expect{testPatient.Q1}.to(beCloseTo(0.74, within: 0.01))
                    expect{testPatient.Q2}.to(beCloseTo(1.26, within: 0.01))
                    expect{testPatient.Q3}.to(beCloseTo(0.5, within:0.1))
                }
            }
            describe("Check Errors") {
                it("Throws errors if invalid ages") {
                    expect{try Kataria(Weight: 20, Age: 0)}.to(throwError())
                    expect{try Kataria(Weight: 20, Age: 14)}.to(throwError())
                    expect{try Kataria(Weight: 20, Age: 14, WarningMethod: .Throw)}.to(throwError())
                    expect{try Kataria(Weight: 20, Age: 14, WarningMethod: .Throw)}.to(throwError())
                }
            }
            describe("Check Warnings") {
                it("Warns if Age < 3 and Warn is Warning Method") {
                    testPatient = try! Kataria(Weight: 20, Age: 2, WarningMethod: .Warn)
                    expect{testPatient.warnings.count}.to(equal(1))
                    expect{testPatient.warnings[0]}.to(beginWith("Age out of range"))
                }
                it("Warngs if Age > 12 and Warn is Warning Method") {
                    testPatient = try! Kataria(Weight: 20, Age: 14, WarningMethod: .Warn)
                    expect{testPatient.warnings.count}.to(equal(1))
                    expect{testPatient.warnings[0]}.to(beginWith("Age out of range"))
                }
            }
            
        }
        
        describe("Using Paedfusor Model") {
            var testPatient:Paedfusor!
            describe("Check volumes and rate constants") {
                testPatient = try! Paedfusor(Weight: 20, Age: 6)
                it("has correct volumes"){
                    expect{testPatient.v1}.to(beCloseTo(9.2, within: 0.1))
                    expect{testPatient.v2}.to(beCloseTo(19, within: 0.1))
                    expect{testPatient.v3}.to(beCloseTo(117.0, within: 0.1))
                }
                it("has correct k10") {
                    expect{testPatient.k10}.to(beCloseTo(0.0624/60, within:0.001))
                }
            }
            
            describe("Check Warnings") {
                it("Warns if Age < 1 and Warn is Warning Method") {
                    testPatient = try! Paedfusor(Weight: 20, Age: 0.5, WarningMethod: .Warn)
                    expect{testPatient.warnings.count}.to(equal(1))
                    expect{testPatient.warnings[0]}.to(beginWith("Age out of range"))
                }
                it("Warngs if Age > 12 and Warn is Warning Method") {
                    testPatient = try! Paedfusor(Weight: 20, Age: 14, WarningMethod: .Warn)
                    expect{testPatient.warnings.count}.to(equal(1))
                    expect{testPatient.warnings[0]}.to(beginWith("Age out of range"))
                }
            }
        }
    }
}


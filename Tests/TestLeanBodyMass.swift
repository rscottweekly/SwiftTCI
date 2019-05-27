//
//  TestLeanBodyMass.swift
//  Tests
//
//  Derived from PyTCI - https://github.com/JMathiszig-Lee/PyTCI
//
//  Created by Ross Scott-Weekly on 26/5/19.
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

import Quick
import Nimble
import SwiftTCI

class LeanBodyMassTests: QuickSpec {
    override func spec() {
        describe("James Body Mass Tests") {
            it("Calculates a female correctly") {
                expect{try james(Height: 165.0, Weight: 90.0, Sex: "f")}.to(beCloseTo(52.2, within:0.25))
            }
            it("Calculates a male correctly") {
                expect{try james(Height: 180.0, Weight: 60.0, Sex: "m")}.to(beCloseTo(51.7, within: 0.25))
            }
            it("Throws an error if f/m not sent") {
                expect{try james(Height: 120.3, Weight: 70, Sex: "q")}.to(throwError())
            }
        }
        describe("Test BMI") {
            it("Calculates BMI Correctly") {
                expect{BMI(Height: 180, Weight: 60)}.to(beCloseTo(18.5, within: 0.1))
                expect{BMI(Height: 180, Weight: 80)}.to(beCloseTo(24.7, within:0.1))
            }
        }
        describe("Boer Body Mass Tests") {
            it("Calculates a male correctly") {
                expect{try boer(Height: 180, Weight: 60, Sex: "M" )}.to(beCloseTo(53.3))
            }
            it("Calculates a female correctly") {
                expect{try boer(Height: 165, Weight: 90, Sex: "F")}.to(beCloseTo(52.4))
            }
            it("Throws an error if f/m not sent") {
                expect{try boer(Height: 180, Weight: 50, Sex: "q")}.to(throwError())
            }
        }
        describe("Hume66 Body Mass Tests") {
            it("Calculates a male correctly") {
                expect{try Hume66(Height: 180, Weight: 60, Sex: "m")}.to(beCloseTo(51.2))
            }
            it("Calculates a female correctly") {
                expect{try Hume66(Height: 165, Weight: 90, Sex: "f")}.to(beCloseTo(52.3))
            }
            it("Throws an error if f/m not sent") {
                expect{try Hume66(Height: 180, Weight: 50, Sex: "q")}.to(throwError())
            }
        }
        describe("Hume71 Body Mass Tests") {
            it("Calculates a male correctly") {
                expect{try Hume71(Height: 180, Weight: 60, Sex: "m")}.to(beCloseTo(53.2))
            }
            it("Calculates a female correctly") {
                expect{try Hume71(Height: 165, Weight: 90, Sex: "f")}.to(beCloseTo(52.2))
            }
            it("Throws an error if f/m not sent") {
                expect{try Hume71(Height: 180, Weight: 50, Sex: "q")}.to(throwError())
            }
        }
        describe("Janmahasation Body Mass Tests") {
            it("Calculates a male correctly") {
                expect{try Janmahasation(Height: 180, Weight: 60, Sex: "m")}.to(beCloseTo(52.1))
            }
            it("Calculates a female correctly") {
                expect{try Janmahasation(Height: 165, Weight: 90, Sex: "f")}.to(beCloseTo(49.5))
            }
            it("Throws an error if f/m not sent") {
                expect{try Janmahasation(Height: 180, Weight: 60, Sex: "q")}.to(throwError())
            }
        }
        describe("Ideal Body Weight Tests"){
            it("Calculates a male correctly") {
                expect{try IdealBodyWeight(Height: 180, Sex: "m")}.to(beCloseTo(75.1))
            }
            it("Calculates a female correctly") {
                expect{try IdealBodyWeight(Height: 165, Sex: "f")}.to(beCloseTo(57.0))
            }
            it("Throws an error if f/m not sent"){
                expect{try IdealBodyWeight(Height: 165, Sex: "q")}.to(throwError())
            }
        }
        describe("Adjusted body weight tests") {
            it("Calculates a male correctly") {
                expect{try AdjustedBodyWeight(Height: 180, Weight: 80, Sex: "M")}.to(beCloseTo(77.1))
            }
            it("Calculates a female correctly"){
                expect{try AdjustedBodyWeight(Height: 165, Weight: 90, Sex: "f")}.to(beCloseTo(70.2))
            }
            it("Throws an error if f/m not sent"){
                expect{try AdjustedBodyWeight(Height: 125, Weight: 90, Sex: "z")}.to(throwError())
            }
        }
    }
}

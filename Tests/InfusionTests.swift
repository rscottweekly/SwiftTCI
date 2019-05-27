//
//  InfusionTests.swift
//  Tests
//
//  Derived from PyTCI - https://github.com/JMathiszig-Lee/PyTCI
//
//  Created by Ross Scott-Weekly on 28/5/19.
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

class infusionTests : QuickSpec {
    override func spec() {
        var testPatient : Schnider!
        describe("Check we measure concentrations"){
            beforeEach {
                testPatient = try! Schnider(Age: 40, Weight: 70, Height: 190, Sex: "M")
            }
            it("Resets Correctly") {
                testPatient.SetConcs()
                testPatient.giveDrug(doseMilligrams: 200)
                try! testPatient.ResetConcs()
                expect{testPatient.x1}.to(equal(0.0))
            }
            it("Sets Correct Effect Bolus") {
                expect{try! testPatient.effectBolus(Target: 6)}.to(beCloseTo(95.6, within:0.1))
            }
        }
    }
}



//
//def test_effect():
//"""test effect site targetting bolus """
//testpatient = propofol.Schnider(40, 70, 190, 'm')
//assert testpatient.effect_bolus(6) == 95.6

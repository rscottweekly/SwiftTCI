//
//  InfusionTests.swift
//  Tests
//
//  Created by Ross Scott-Weekly on 28/5/19.
//  Copyright © 2019 Ross Scott-Weekly. All rights reserved.
//

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

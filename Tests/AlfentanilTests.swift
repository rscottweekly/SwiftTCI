//
//  AlfentanilTests.swift
//  Tests
//
//  Created by Ross Scott-Weekly on 27/5/19.
//  Copyright © 2019 Ross Scott-Weekly. All rights reserved.
//

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

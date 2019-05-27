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
            testPatient = try! Maitre(Height: 170, Weight: 70, Age: 30, Sex: "M")
            it("calculates volumes correctly") {
                expect{testPatient.v1}.to(beCloseTo(7.77, within: 0.01))
                expect{testPatient.v2}.to(beCloseTo(12.01, within:0.01))
                expect{testPatient.v3}.to(beCloseTo(10.48, within: 0.01))
            }
            it("calculates Q correctly") {
                expect{testPatient.Q1}.to(beCloseTo(0.356, within: 0.001))
            }
        }
    }
}


//testpatient = alfentanil.Maitre(30, 70, 170, 'm')
//testpatient2 = alfentanil.Maitre(60, 80, 165, 'f')
//
//assert round(testpatient.v1, 2) == 7.77
//assert round(testpatient.v2, 2) == 12.01
//assert round(testpatient.v3, 2) == 10.48
//assert round(testpatient.q1, 3) == 0.356
//
//assert round(testpatient2.v1, 2) == 10.24
//
//with pytest.raises(ValueError):
//alfentanil.Maitre(20, 80, 180, 'g')

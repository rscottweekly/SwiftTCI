//
//  Alfentanil.swift
//  SwiftTCI
//
//  Created by Ross Scott-Weekly on 27/5/19.
//  Copyright © 2019 Ross Scott-Weekly. All rights reserved.
//

import Foundation

public class AlfentatilBaseModel : ThreeBaseModel {
    
}

public class Maitre : AlfentatilBaseModel {
    public init(Height: Double, Weight: Double, Age: Double, Sex: Character) throws {
        super.init()
        
        let SexEnum = try SetSex(Sex: Sex)
        
        self.v1 = Weight * (SexEnum == .M ? 0.11 : 0128)
        
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

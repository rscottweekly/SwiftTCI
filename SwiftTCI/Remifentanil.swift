//
//  Remifentanil.swift
//  SwiftTCI
//
//  Created by Ross Scott-Weekly on 27/5/19.
//  Copyright © 2019 Ross Scott-Weekly. All rights reserved.
//

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

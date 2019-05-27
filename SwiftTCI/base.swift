//
//  base.swift
//  SwiftTCI
//
//  Created by Ross Scott-Weekly on 24/5/19.
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

//Generic Three Compartment Model
public protocol ThreeCompartmentModel {
    
    var x1: Double {get set}
    var x2: Double {get set}
    var x3: Double {get set}
    var xeo: Double {get set}

    var v1 : Double {get set}
    var v2 : Double {get set}
    var v3 : Double {get set}
    var Q1 : Double {get set}
    var Q2 : Double {get set}
    var Q3 : Double {get set}

    var k10 : Double {get set}
    var k12 : Double {get set}
    var k13 : Double {get set}
    var k21 : Double {get set}
    var k31 : Double {get set}
    var keo : Double {get set}

    mutating func giveDrug(doseMilligrams:Double);

    mutating func waitTime(timeSeconds:Int);
}

public class ThreeBaseModel:ThreeCompartmentModel {
    public var x1 : Double;
    public var x2 : Double;
    public var x3 : Double;
    public var xeo : Double;
    
    public var v1 : Double;
    public var v2 : Double;
    public var v3 : Double;
    public var Q1 : Double;
    public var Q2 : Double;
    public var Q3 : Double;
    
    var _k10 : Double
    var _k12 : Double
    var _k13 : Double
    var _k21 : Double
    var _k31 : Double
    var _keo : Double
    
    // We are working in seconds so when we set k values, divide by 60
    public var k10 : Double {
        get {
            return self._k10
        }
        set(newk10) {
            self._k10 = newk10 / 60
        }
    }
    
    
    public var k12 : Double {
        get {
            return self._k12
        }
        set(newk12) {
            self._k12 = newk12 / 60
        }
    }
    
    public var k13 : Double {
        get {
            return self._k13
        }
        set(newk13) {
            self._k13 = newk13 / 60
        }
    }
    
    public var k21 : Double {
        get {
            return self._k21
        }
        set(newk21) {
            self._k21 = newk21 / 60
        }
    }
    
    public var k31 : Double {
        get {
            return self._k31
        }
        set(newk31) {
            self._k31 = newk31 / 60
        }
    }
    
    public var keo : Double {
        get {
            return self._keo
        }
        set(newkeo) {
            self._keo = newkeo / 60
        }
    }
    
    
    init() {
        self.x1 = 0.0
        self.x2 = 0.0
        self.x3 = 0.0
        self.xeo = 0.0
        
        self.v1 = 0.0
        self.v2 = 0.0
        self.v3 = 0.0
        self.Q1 = 0.0
        self.Q2 = 0.0
        self.Q3 = 0.0
        
        self._k10 = 0.0
        self._k12 = 0.0
        self._k13 = 0.0
        self._k21 = 0.0
        self._k31 = 0.0
        self._keo = 0.0
    }
    
    func fromClearances() {
        /*
        Converts intercompartment clearances into rate constants
        Needed as we currently use them for the maths
        source http://www.pfim.biostat.fr/PFIM_PKPD_library.pdf page 8
        */
        self.k10 = self.Q1 / self.v1
        self.k12 = self.Q2 / self.v1
        self.k13 = self.Q3 / self.v1
        self.k21 = (self.k12 * self.v1) / self.v2
        self.k31 = (self.k13 * self.v1) / self.v3
    }
    
    public func giveDrug(doseMilligrams: Double) {
        // add bolus of drug to central compartment
        self.x1 = self.x1 + doseMilligrams / self.v1
    }
    
    
    public func waitTime(timeSeconds:Int) {
    // model distribution of drug between compartments over specified time period
    
        func one_second(){
            // time steps must be one second for accurate modelling
    
            let x1k10 = self.x1 * self.k10
            let x1k12 = self.x1 * self.k12
            let x1k13 = self.x1 * self.k13
            let x2k21 = self.x2 * self.k21
            let x3k31 = self.x3 * self.k31
            
            let xk1e = self.x1 * self.keo
            let xke1 = self.xeo * self.keo
            
            self.x1 = self.x1 + (x2k21 - x1k12 + x3k31 - x1k13 - x1k10)
            self.x2 = self.x2 + (x1k12 - x2k21)
            self.x3 = self.x3 + (x1k13 - x3k31)
            
            self.xeo = self.xeo + (xk1e - xke1)
        }
        
        for _ in 0..<timeSeconds {
            one_second()
        }
        
    }
}

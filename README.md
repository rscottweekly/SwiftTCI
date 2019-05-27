# SwiftTCI
Swift library for Target Controlled Infusion

This library is a transliteration of [PyTCI](https://github.com/JMathiszig-Lee/PyTCI) by Jakob Mathiszig-Lee into Swift. 
The code is now fully implemented and tested, but the ability to use it as a proper framework is a work in progress.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## Models
The library provides the following models:
* Propofol
  * Schnider
  * Marsh
  * Kataria
  * Paedfusor
* Remifentanil
  * Minto
* Alfentanil 
  * Maitre

## Body Mass Equations
The library also incorporates the same body mass equations as PyTCI. These are:
* James
* Boer
* Hume 1966
* Hume 1971
* Janmahasation
* Ideal Body Weight
* BMI
* Adjusted Body Weight


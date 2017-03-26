//
//  ViewController.swift
//  Calculator
//
//  Created by Farzin Faghihi on 2017-03-07.
//  Copyright © 2017 Farzin Faghihi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var currentCalculation: UILabel!
    
    var userIsInTheMiddleOfTyping = false
    
    @IBAction func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTyping {
            let textCurrentlyInDisplay = display.text!
            display.text = textCurrentlyInDisplay + digit
        } else {
            display.text = digit
            userIsInTheMiddleOfTyping = true
        }
    }
    
    var displayValue: Double {
        get {
            return Double(display.text!)!
        }
        set {
            display.text = String(newValue)
        }
    }
    
    @IBAction func backspace(_ sender: UIButton) {
        if userIsInTheMiddleOfTyping {
            display.text!.remove(at: display.text!.index(before: display.text!.endIndex))
            if (display.text!.isEmpty) {
                displayValue = 0
                userIsInTheMiddleOfTyping = false
            }
        }
    }
    
    private var brain = CalculatorBrain()
    
    @IBAction func performOperation(_ sender: UIButton) {
        if userIsInTheMiddleOfTyping {
            brain.setOperand(displayValue)
            userIsInTheMiddleOfTyping = false;
        }
        userIsInTheMiddleOfTyping = false
        if let mathematicalSymbol = sender.currentTitle {
            brain.performOperation(mathematicalSymbol)
            if let result = brain.result {
                displayValue = result
            }
        }
        currentCalculation.text = brain.description
        if (currentCalculation.text != " ") {
            if (brain.resultIsPending) {
                currentCalculation.text! += "..."
            } else {
                currentCalculation.text! += "="
            }
        } else {
            displayValue = 0
        }
    }
}


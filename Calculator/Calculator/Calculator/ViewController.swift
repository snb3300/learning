//
//  ViewController.swift
//  Calculator
//
//  Created by Shridhar Bhalekar on 6/20/16.
//  Copyright © 2016 Shridhar Bhalekar. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet private weak var displayLabel: UILabel!
    private var userInMiddleOfTyping = false
    private var brain = CalculatorBrain()
    
    @IBAction private func touchDigit(sender: UIButton) {
        var currentDisplayValue = displayLabel.text!
        if let value = sender.currentTitle {
            if userInMiddleOfTyping {
                currentDisplayValue += value
                displayLabel.text = currentDisplayValue
            } else {
                displayLabel.text = value
            }
            userInMiddleOfTyping = true;
        }
    }
    
    @IBAction func touchPeriod(sender: UIButton) {
        if let value = displayLabel.text {
            if !value.containsString(".") {
                displayLabel.text = value + "."
            }
        } else {
            displayLabel.text = "0."
        }
        userInMiddleOfTyping = true
    }
    
    private var displayValue : Double {
        get {
            return Double(displayLabel.text!)!
        }
        set {
            displayLabel.text = String(newValue)
        }
    }
    
    @IBAction private func performAction(sender: UIButton) {
        if userInMiddleOfTyping {
            brain.setOperand(displayValue)
            userInMiddleOfTyping = false
        }
        if let mathematicalSymbol = sender.currentTitle {
            brain.performOperation(mathematicalSymbol)
        }
        displayValue = brain.result
    }
}


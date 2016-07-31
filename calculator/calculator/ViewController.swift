//
//  ViewController.swift
//  calculator
//
//  Created by Florian Bienefelt on 6/30/16.
//  Copyright © 2016 Florian Bienefelt. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet private weak var display: UILabel!
    
    private var userIsInTheMiddleOfTyping = false
    
    @IBAction private func touchDigit(sender: UIButton) {
        
        let digit = sender.currentTitle!
        
        brain.updateDescription(digit)
        
        if userIsInTheMiddleOfTyping {
            let textCurrentlyInDisplay = display.text!
            
            if (digit==".") {
                if (textCurrentlyInDisplay.rangeOfString(".") == nil) {
                    display.text = textCurrentlyInDisplay + digit
                }

            } else {
                display.text = textCurrentlyInDisplay + digit
            }
            
            
            
        } else {
            display.text = digit
        }
        userIsInTheMiddleOfTyping = true
        
    }
    
    
    //Don't need this code for the assignment
//    var savedProgram: CalculatorBrain.PropertyList?
//    
//    @IBAction func save() {
//        savedProgram = brain.program
//    }
//    
//    
//    @IBAction func restore() {
//        if savedProgram != nil {
//            brain.program = savedProgram!
//            displayValue = brain.result
//        }
//    }
    //until here
    
    
    @IBOutlet private weak var operations: UILabel!
    
    
    private var displayValue: Double {
        get {
            return Double(display.text!)!
        }
        set {
            display.text = String(newValue)
        }
    }
    
    private var brain = CalculatorBrain()
    
    @IBAction private func performOperation(sender: UIButton) {
        if userIsInTheMiddleOfTyping {
            brain.setOperand(displayValue)
            userIsInTheMiddleOfTyping = false
        }
        userIsInTheMiddleOfTyping = false
        if let mathematicalSymbol = sender.currentTitle {
            brain.performOperation(mathematicalSymbol)
            
            brain.updateDescription(sender.currentTitle!)
        }
        displayValue = brain.result
        operations.text = brain.getDescription()
        
    }
    
    
    @IBAction func clear(sender: UIButton) {
        display.text = " "
        operations.text = " "
        userIsInTheMiddleOfTyping = false
        brain.clear()
    }
    
    @IBAction func setM(sender: UIButton) {
        brain.variableValues["M"] = displayValue
        
        displayValue = brain.result
    }
    
    @IBAction func getM(sender: UIButton) {
        brain.setOperand("M")
        
        displayValue = brain.result
    }
    
    
}








//
//  ViewController.swift
//  SwiftCalculator
//
//  Created by Martin Calvert on 8/2/15.
//  Copyright (c) 2015 Martin Calvert. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // Outlets
    @IBOutlet weak var display: UILabel!

    // Variables
    var userIsTypingNumber = false
    var opperandStack = Array<Double>()
    var displayValue: Double{
        get{
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set{
            display.text = "\(newValue)"
        }
    }
    var lastOperation = UIButton()
    
    // Methods
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsTypingNumber{
            display.text = display.text! + digit
        }
        else {
            display.text = digit
            userIsTypingNumber = true
        }
    }
    
    @IBAction func enter() {
        userIsTypingNumber = false
        opperandStack.append(displayValue)
        if opperandStack.count >= 2{
            operate(lastOperation)
        }
    }
    
    @IBAction func operate(sender: UIButton) {
        let operation = sender.currentTitle!
        lastOperation = sender
        if userIsTypingNumber{
            enter()
        }
        switch operation{
            case "✖️": performOperation { $0 * $1 }
            case "➗": performOperation { $0 / $1 }
            case "➖": performOperation { $0 - $1 }
            case "➕": performOperation { $0 + $1 }
            case "√": performOperation { sqrt($0) }
            default: break
        }
    }
    
    func performOperation(operation: (Double, Double) -> Double) {
        if opperandStack.count >= 2{
            displayValue = operation(opperandStack.removeLast(), opperandStack.removeLast())
            opperandStack.append(displayValue)
        }
    }
    
    private func performOperation(operation: Double -> Double) {
        if opperandStack.count >= 1{
            displayValue = operation(opperandStack.removeLast())
            opperandStack.append(displayValue)
        }
    }
    
    @IBAction func reset(sender: UIButton) {
        displayValue = 0
        opperandStack = Array<Double>()
        userIsTypingNumber = false
    }

}


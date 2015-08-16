//
//  ViewController.swift
//  SwiftCalculator
//
//  Created by Martin Calvert on 8/2/15.
//  Copyright (c) 2015 Martin Calvert. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // View init
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.lightGrayColor()
    }
    
    // Outlets
    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var history: UILabel!
    
    // Variables
    
    var userIsTypingNumber = false
    var brain = CalculatorBrain()
    var displayValue: Double{
        get{
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set{
            display.text = "\(newValue)"
        }
    }
    
    // Methods
    // Adds digit to the display
    @IBAction func appendDigit(sender: UIButton) {
        var digit = sender.currentTitle!
        switch digit{
            case "pi": digit = "\(M_PI)"
            case ".":
                if display.text!.rangeOfString(".") != nil {
                    digit = "" }
            default: break
        }
        if userIsTypingNumber{
            display.text = display.text! + digit
        }
        else {
            display.text = digit
            userIsTypingNumber = true
        }
    }
    
    // Pushes number onto the stack
    @IBAction func enter() {
        userIsTypingNumber = false
        if let value = brain.pushOperand(displayValue){
            displayValue = value
        } else{
            displayValue = 0
        }
    }

    // Performs operation
    @IBAction func operate(sender: UIButton) {
        if userIsTypingNumber{
            enter()
        }
        if let operation = sender.currentTitle{
            if let result = brain.performOperand(operation){
                displayValue = result
            }
            else{
                displayValue = 0
            }
        }
    }
    
    @IBAction func reset(sender: UIButton) {
        displayValue = 0
        userIsTypingNumber = false
        history.text = ""
    }

}


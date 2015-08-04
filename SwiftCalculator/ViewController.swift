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
    
    @IBAction func clear() {
        display.text = "0"
        userIsTypingNumber = false
    }

}


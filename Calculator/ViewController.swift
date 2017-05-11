//
//  ViewController.swift
//  Calculator
//
//  Created by Jon Butland on 5/9/17.
//  Copyright © 2017 jbutland. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var userTyping = false
    
    @IBOutlet weak var Display: UILabel!
    
    @IBAction func touchNumber(_ sender: UIButton) {
        let number = sender.currentTitle!
        if Display.text!.contains(".") && number == "." {

        }
        else {
            if userTyping {
                let textDisplay = Display!.text!
                Display.text = textDisplay + number
            }else if !userTyping && number == "."{
                Display.text = "0" + number
                userTyping = true
            }else if Display.text == "0" && number == "0"{
            }else{
                Display.text = number
                userTyping = true
                
            }

        }
        
    }
    var displayValue: Double{
        get {
            return Double(Display.text!)!
        }
        set {
            if floor(newValue) == newValue{
                Display.text = String(Int(newValue))
            }
            else{
                Display.text = String(newValue)
            }
        }
    }
    
    private var controller = CalculatorController()
    
    @IBAction func performOperation(_ sender: UIButton) {
        
        if userTyping {
            controller.setOperand(displayValue)
            userTyping = false
        }
        if let mathSymbol = sender.currentTitle {
            controller.performOperation(mathSymbol)
        }
        if let result = controller.result {
            displayValue = result
        }
    }
}


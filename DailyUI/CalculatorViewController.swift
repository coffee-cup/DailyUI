//
//  CalculatorViewController.swift
//  DailyUI
//
//  Created by Jake Runzer on 2015-10-28.
//  Copyright © 2015 Jake Runzer. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController {

    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var chainLabel: UILabel!
    
    @IBOutlet weak var dotButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!
    
    @IBOutlet weak var divideButton: UIButton!
    @IBOutlet weak var timesButton: UIButton!
    @IBOutlet weak var subtractButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var equalButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    var dotPressed = false
    var currentOperator: String?
    
    func addText(number: String) {
        var text = resultLabel.text ?? ""
        if text == "0" && number != "." {
            text = ""
        }
        text += String(number)
        resultLabel.text = text
    }
    
    func deleteNumber() {
        var text: String = resultLabel.text ?? ""
        var deleted: String? = nil
        if text.characters.count >= 1 {
            deleted = text.substringFromIndex(text.endIndex.advancedBy(-1))
            text = text.substringToIndex(text.endIndex.advancedBy(-1))
        }
        if text == "" {
            text = "0"
        }
        if deleted != nil && deleted == "." {
            dotPressed = false
        }
        resultLabel.text = text
    }
    
    func operatorPressed(op: String) {
        currentOperator = op
        if op == "+" {
            
        } else if op == "-" {
            
        } else if op == "x" {
            
        } else if op == "/" {
            
        }
    }
    
    @IBAction func numberButtonDidTouch(sender: AnyObject) {
        if let button = sender as? UIButton {
            if let number = Int(button.titleLabel?.text ?? "") {
                addText(String(number))
            }
        }
    }
    
    @IBAction func dotButtonDidTouch(sender: AnyObject) {
        if !dotPressed {
            addText(".")
            dotPressed = true
        }
    }
    
    @IBAction func operatorButtonDidTouch(sender: AnyObject) {
        if let label = sender as? UILabel {
            if label.text != nil {
                operatorPressed(label.text!)
            }
        }
    }
    
    @IBAction func clearButtonDidTouch(sender: AnyObject) {
        resultLabel.text = "0"
        dotPressed = false
    }

    @IBAction func backButtonDidTouch(sender: AnyObject) {
        deleteNumber()
    }
}

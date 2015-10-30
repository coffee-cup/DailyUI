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
    @IBOutlet weak var firstOperandLabel: SpringLabel!
    @IBOutlet weak var operatorLabel: SpringLabel!
    @IBOutlet weak var secondOperandLabel: SpringLabel!

    @IBOutlet weak var dotButton: ZFRippleButton!
    @IBOutlet weak var clearButton: ZFRippleButton!
    
    @IBOutlet weak var divideButton: ZFRippleButton!
    @IBOutlet weak var timesButton: ZFRippleButton!
    @IBOutlet weak var subtractButton: ZFRippleButton!
    @IBOutlet weak var addButton: ZFRippleButton!
    @IBOutlet weak var equalButton: ZFRippleButton!
    @IBOutlet weak var backButton: ZFRippleButton!
    
    @IBOutlet weak var zeroButton: ZFRippleButton!
    @IBOutlet weak var oneButton: ZFRippleButton!
    @IBOutlet weak var twoButton: ZFRippleButton!
    @IBOutlet weak var threeButton: ZFRippleButton!
    @IBOutlet weak var fourButton: ZFRippleButton!
    @IBOutlet weak var fiveButton: ZFRippleButton!
    @IBOutlet weak var sixButton: ZFRippleButton!
    @IBOutlet weak var sevenButton: ZFRippleButton!
    @IBOutlet weak var eightButton: ZFRippleButton!
    @IBOutlet weak var nineButton: ZFRippleButton!
    
    var tintButtons: [ZFRippleButton]!
    var operatorButtons: [ZFRippleButton]!
    
    let equalTint = Sweetercolor(hex: 0xE0F7FA).color
    let addTint = Sweetercolor(hex: 0xFCE4EC).color
    let subTint = Sweetercolor(hex: 0xFFF8E1).color
    let multTint = Sweetercolor(hex: 0xE8EAF6).color
    let divideTint = Sweetercolor(hex: 0xF3E5F5).color
    
    let equalMain = Sweetercolor(hex: 0x84FFFF).color
    let addMain = Sweetercolor(hex: 0xFF4081).color
    let subMain = Sweetercolor(hex: 0xFFD740).color
    let multMain = Sweetercolor(hex: 0x536DFE).color
    let divideMain = Sweetercolor(hex: 0xE040FB).color
    
    let addDefault = Sweetercolor(hex: 0xFF80AB).color
    let subDefault = Sweetercolor(hex: 0xFFE57F).color
    let multDefault = Sweetercolor(hex: 0x8C9EFF).color
    let divideDefault = Sweetercolor(hex: 0xEA80FC).color
    
    let addDim = Sweetercolor(hex: 0xFF80AB, alpha: 0.5).color
    let subDim = Sweetercolor(hex: 0xFFE57F, alpha: 0.5).color
    let multDim = Sweetercolor(hex: 0x8C9EFF, alpha: 0.5).color
    let divideDim = Sweetercolor(hex: 0xEA80FC, alpha: 0.5).color
    
    let exitTint = Sweetercolor(hex: 0xef5350).color
    let exitMain = Sweetercolor(hex: 0xff5252).color
    
    @IBOutlet weak var resultMain: UIView!
    
    var animatingFirst = false
    var animatingSecond = false
    var animatingOperator = false
    var firstAnimatingSet = false
    var secondAnimatingSet = false
    var operatorAnimatingSet = false
    var firstLatest = ""
    var secondLatest = ""
    var operatorLatest = ""
    
    var dotPressed = false
    var exitTriggered = false
    var equalJustComputed = false
    var previousZero = false
    var backButtonPressed = false
    var currentOperator: String?
    var currentTintColour: UIColor!
    var currentMainColour: UIColor!
    var operand: String?
    
    override func viewDidAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        currentTintColour = equalTint
        currentMainColour = equalMain
        
        tintButtons = [zeroButton, oneButton, twoButton, threeButton, fourButton, fiveButton, sixButton, sevenButton, eightButton, nineButton]
        operatorButtons = [addButton, subtractButton, timesButton, divideButton]
        
        firstOperandLabel.text = ""
        operatorLabel.text = ""
        secondOperandLabel.text = ""
        
        animateColours()
    }
    
    func operationValid() -> Bool {
        let text = resultLabel.text ?? "0"
        return (text != "0" && text != "0.") || operand != nil
    }
    
    func equalValid() -> Bool {
        let text = resultLabel.text ?? "0"
        return (text != "0" && text != "0.") && operand != nil && !equalJustComputed
    }
    
    func canFloatBeInt(num: Float) -> Bool {
        if num < Float(Int.max) && num > Float(Int.min) {
            let intVal = Float(Int(num))
            return (num - intVal) == Float(0)
        }
        return false
    }
    
    func animateDuration(duration: Double, animation: () -> ()) {
        UIView.animateWithDuration(duration, delay: 0, options: UIViewAnimationOptions.AllowUserInteraction, animations: animation, completion: nil)
    }
    
    func springRight(duration: NSTimeInterval, delay: NSTimeInterval , animations: () -> ()) {
        UIView.animateWithDuration(duration, delay: delay, usingSpringWithDamping: 0.8, initialSpringVelocity: 1.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: animations, completion: nil)
    }
    
    func animateOperand(text: String, label: SpringLabel, doNotSet: Bool = false, forceIn: Bool = false) {
        // animate back in if 0
        if previousZero && text == "" {
            return
        } else if text == "0" || forceIn {
            previousZero = true
            backButtonPressed = false
            if label == firstOperandLabel {
                animatingFirst = true
            } else {
                animatingSecond = true
            }
            UIView.animateWithDuration(0.7, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                    label.transform = CGAffineTransformMakeTranslation(-400, 0)
                }, completion: {finished in
                    label.text = ""
                    if label == self.firstOperandLabel {
                        self.animatingFirst = false
                    } else {
                        self.animatingSecond = false
                    }
            })
        } else {
            previousZero = false
            
            if !doNotSet {
                label.text = text
            }
            label.opacity = 1
            
            var animating = false
            if (label == firstOperandLabel && animatingFirst) || (label == secondOperandLabel && animatingSecond) {
                animating = true
            }
            
            // dont animate if not first number
            if (text.characters.count > 1 && text != "0.") || backButtonPressed {
                if (animating) {
                    let triggerTime = (Int64(NSEC_PER_MSEC) * 700)
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, triggerTime), dispatch_get_main_queue(), { () -> Void in
                        self.animateOperand(text, label: label, forceIn: forceIn)
                    })
                }
                backButtonPressed = false
                return
            }
            
            if (label == firstOperandLabel && animatingFirst) || (label == secondOperandLabel && animatingSecond) {
                let triggerTime = (Int64(NSEC_PER_MSEC) * 700)
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, triggerTime), dispatch_get_main_queue(), { () -> Void in
//                    self.animateOperand(text, label: label, forceIn: forceIn)
                    self.animateOperand(text, label: label, doNotSet: true, forceIn: forceIn)
                })
            } else {
                print("animating operator \(text)")
                label.animation = "slideLeft"
                label.damping = 0.8
                label.curve = "EaseInOut"
                label.animateNext({
                    if label == self.firstOperandLabel {
                        self.firstOperandLabel.text = self.firstLatest
                    } else {
                        self.secondOperandLabel.text = self.secondLatest
                    }
                })
            }
        }
    }
    
    func animateFirstOperand(forceIn: Bool = false) {
        print("animating first operator \(forceIn)")
        let text = resultLabel.text ?? "0"
        firstLatest = text
        print("\(text) \n")
        let label = firstOperandLabel
        animateOperand(text, label: label, forceIn: forceIn)
    }
    
    func animateSecondOperand(forceIn: Bool = false) {
        print("animating second operator \(forceIn)")
        let text = resultLabel.text ?? "0"
        secondLatest = text
        let label = secondOperandLabel
        animateOperand(text, label: label, forceIn: forceIn)
    }
    
    func animateOperator(doNotSet: Bool = false, forceIn: Bool = false) {
        print("animating operator \(forceIn)")
        let text = currentOperator ?? ""
        operatorLatest = text
        if text != "" && !forceIn {
            if animatingOperator {
                let triggerTime = (Int64(NSEC_PER_MSEC) * 700)
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, triggerTime), dispatch_get_main_queue(), { () -> Void in
                    self.animateOperator(forceIn: forceIn)
                })
            } else {
                if !doNotSet {
                    operatorLabel.text = text
                }
                operatorLabel.animation = "slideLeft"
                operatorLabel.damping = 0.8
                operatorLabel.curve = "EaseInOut"
                operatorLabel.animateNext({
                    self.operatorLabel.text = self.operatorLatest
//                    if self.currentOperator != nil {
//                        self.operatorLabel.text = self.currentOperator!
//                    }
                })
            }
        } else if (operand != nil && currentOperator != nil) || forceIn {
            animatingOperator = true
            UIView.animateWithDuration(0.7, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                    self.operatorLabel.transform = CGAffineTransformMakeTranslation(-300, 0)
                }, completion: {finished in
                    self.operatorLabel.text = ""
                    self.animatingOperator = false
            })
        }
    }
    
    func animateColours() {
        var tint = equalTint
        var ripple = equalMain
        let op = currentOperator ?? ""
        if currentOperator != nil {
            switch op {
                case "+":
                    tint = addTint
                    ripple = addMain
                case "-":
                    tint = subTint
                    ripple = subMain
                case "x":
                    tint = multTint
                    ripple = multMain
                case "/":
                    tint = divideTint
                    ripple = divideMain
            default:
                tint = equalTint
                ripple = equalMain
            }
        }
        
        currentTintColour = tint
        currentMainColour = ripple
        
        let duration = 0.5
        for btn in tintButtons {
            animateDuration(duration, animation: {
                btn.backgroundColor = tint
                btn.rippleColor = ripple
            })
        }
        
        animateDuration(duration, animation: {
            self.clearButton.backgroundColor = tint
            self.clearButton.rippleColor = ripple
        })
        
        animateDuration(duration, animation: {
            self.dotButton.backgroundColor = tint
            self.dotButton.rippleColor = ripple
        })
        
        animateDuration(duration, animation: {
            self.backButton.backgroundColor = tint
            self.backButton.rippleColor = ripple
        })
        
        animateDuration(duration, animation: {
            self.resultMain.backgroundColor = ripple
        })
        
        var addColour = addDim
        var subColour = subDim
        var multColour = multDim
        var divideColour = divideDim
        
        if op != "" {
            if op == "+" {
                addColour = addMain
            } else if op == "-" {
                subColour = subMain
            } else if op == "x" {
                multColour = multMain
            } else if op == "/" {
                divideColour = divideMain
            }
        } else {
            addColour = addDefault
            subColour = subDefault
            multColour = multDefault
            divideColour = divideDefault
        }
        
        animateDuration(duration, animation: {
            self.addButton.backgroundColor = addColour
            self.subtractButton.backgroundColor = subColour
            self.timesButton.backgroundColor = multColour
            self.divideButton.backgroundColor = divideColour
        })
    }
    
    func computeResult() {
        let opr = operand ?? "0"
        let text = resultLabel.text ?? ""
        let num1 = Float(opr) ?? Float(0)
        let num2 = Float(text) ?? Float(0)
        var result = Float(0)
    
        switch currentOperator ?? "" {
            case "+":
                result = num1 + num2
            case "-":
                result = num1 - num2
            case "x":
                result = num1 * num2
            case "/":
                result = num1 / num2
        default:
            result = Float(0)
        }
        
        var resultText = ""
        if canFloatBeInt(result) {
            let intResult = Int(result)
            operand = String(intResult)
            resultText = String(intResult)
        } else {
            operand = String(result)
            resultText = String(result)
        }
        resultLabel.text = resultText
        equalJustComputed = true
    }
    
    func addText(number: String) {
        if equalJustComputed {
            resetVars()
        }
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
        backButtonPressed = true
        
        if operand == nil {
            animateFirstOperand()
        } else {
            animateSecondOperand()
        }
    }
    
    func animateExitTrigger() {
        if exitTriggered {
            animateDuration(0.5, animation: {
                self.backButton.backgroundColor = self.exitTint
                self.backButton.rippleColor = self.exitMain
            })
        } else {
            animateDuration(0.5, animation: { () -> () in
                self.backButton.backgroundColor = self.currentTintColour
                self.backButton.rippleColor = self.currentMainColour
            })
        }
    }
    
    @IBAction func numberButtonDidTouch(sender: AnyObject) {
        exitTriggered = false
        animateExitTrigger()
        if let button = sender as? UIButton {
            if let number = Int(button.titleLabel?.text ?? "") {
                addText(String(number))
                backButtonPressed = false
                
                if equalJustComputed {
                    animateOperator(true)
                    animateSecondOperand(true)
                    animateFirstOperand()
                    equalJustComputed = false
                } else {
                    if operand == nil {
                        animateFirstOperand()
                    } else {
                        animateSecondOperand()
                    }
                }
            }
        }
    }
    
    @IBAction func dotButtonDidTouch(sender: AnyObject) {
        exitTriggered = false
        animateExitTrigger()
        if !dotPressed || equalJustComputed {
            addText(".")
            dotPressed = true
            
            if equalJustComputed {
                animateOperator(true)
                animateSecondOperand(true)
                animateFirstOperand()
                equalJustComputed = false
            } else {
                if operand == nil {
                    animateFirstOperand()
                } else {
                    print("animating second with dot")
                    animateSecondOperand()
                }
            }
        }
    }
    
    @IBAction func equalButtonDidTouch(sender: AnyObject) {
        if equalValid() {
            computeResult()
            currentOperator = ""
            exitTriggered = false
            animateColours()
        }
    }
    
    @IBAction func operatorButtonDidTouch(sender: AnyObject) {
        exitTriggered = false
        if let btn = sender as? UIButton {
            if let text = btn.titleLabel?.text {
                if operationValid() {
                    let firstOpr = resultLabel.text ?? ""
                    var resetText = false
                    if operand == nil || equalJustComputed {
                        resetText = true
                        operand = resultLabel.text!
                    }
                    currentOperator = text
                    if equalJustComputed {
                        firstLatest = firstOpr
                        animateOperand(firstOpr, label: firstOperandLabel)
                        animateSecondOperand(true)
                    }
                    equalJustComputed = false
                    animateOperator()
                    if resetText {
                        resultLabel.text = "0"
                        dotPressed = false
                    }
                    animateColours()
                }
            }
        }
    }
    
    func resetVars() {
        resultLabel.text = "0"
        operand = nil
        dotPressed = false
        currentOperator = ""
        backButtonPressed = false
        exitTriggered = false
        animateColours()
    }
    
    @IBAction func clearButtonDidTouch(sender: AnyObject) {
        resetVars()
        equalJustComputed = false
        
        // chain
        animateFirstOperand(true)
        animateSecondOperand(true)
        animateOperator(forceIn: true)
    }

    @IBAction func backButtonDidTouch(sender: AnyObject) {
        if exitTriggered {
            dismissViewControllerAnimated(true, completion: nil)
        } else {
            if let text = resultLabel.text {
                if text == "0" {
                    exitTriggered = true
                    animateExitTrigger()
                } else {
                    deleteNumber()
                }
            }
        }
    }
}

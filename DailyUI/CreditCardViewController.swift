//
//  CreditCardViewController.swift
//  DailyUI
//
//  Created by Jake Runzer on 2015-10-23.
//  Copyright © 2015 Jake Runzer. All rights reserved.
//

import UIKit

enum CardType {
    case Visa, Mastercard
    func description () -> String {
        switch self {
        case .Visa:
            return "visaLogo"
        case .Mastercard:
            return "mastercardLogo"
        }
    }
}

class CreditCardViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var formView: UIView!
    @IBOutlet weak var cardView: DesignableView!
    
    @IBOutlet weak var cardNumber1: UILabel!
    @IBOutlet weak var cardNumber2: UILabel!
    @IBOutlet weak var cardNumber3: UILabel!
    @IBOutlet weak var cardNumber4: UILabel!
    @IBOutlet weak var cardLogo: SpringImageView!
    
    @IBOutlet weak var cardName: UILabel!
    @IBOutlet weak var cardExpires: UILabel!
    
    @IBOutlet weak var cardNumberField: DesignableTextField!
    @IBOutlet weak var expiresField: DesignableTextField!
    @IBOutlet weak var securityField: DesignableTextField!
    @IBOutlet weak var nameField: DesignableTextField!
    
    @IBOutlet weak var purchaseButton: DesignableButton!
    @IBOutlet weak var progressView: DesignableView!
    @IBOutlet weak var progressConstraint: NSLayoutConstraint!
    
    var previousExpires = ""
    var cardType: CardType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        createGradient()
        
        cardNumberField.delegate = self
        expiresField.delegate = self
        securityField.delegate = self
        nameField.delegate = self
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        resetCard()
        progressConstraint.constant = purchaseButton.frame.width
        self.view.layoutIfNeeded()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        cardLogo.hidden = true
        cardName.text = ""
        cardExpires.text = ""
    }
    
    func resetCard() {
        cardNumber1.text = "XXXX"
        cardNumber2.text = "XXXX"
        cardNumber3.text = "XXXX"
        cardNumber4.text = "XXXX"
        
        cardName.text = ""
        cardExpires.text = ""
    }
    
    func createGradient() {
        let view = scrollView
        
        let gradient : CAGradientLayer = CAGradientLayer()
        gradient.frame = view.bounds
        
//        let blueBlue = Sweetercolor(hex: 0x192fd8)
        let blueBlue = UIColor.blueColor()
//        let purpleBlue = Sweetercolor(hex: 0x391be2)
        let purpleBlue = UIColor.yellowColor()
        let arrayColors = [blueBlue, purpleBlue]
        
        gradient.colors = arrayColors
        gradient.startPoint = CGPoint(x: 1, y: 0)
        gradient.endPoint = CGPoint(x: 0, y: 1)
        view.layer.insertSublayer(gradient, atIndex: 0)
    }
    
    @IBAction func purchaseButtonDidTouch(sender: AnyObject) {
        animatePurchase()
    }
    
    @IBAction func backButtonDidTouch(sender: AnyObject) {
        self.view.endEditing(true)
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func updateProgess() {
        let cardValid = (cardNumberField.text ?? "").characters.count >= 4
        let expireVaid = (expiresField.text ?? "").characters.count == 5
        let securityValid = (securityField.text ?? "").characters.count == 3
        let nameValid = (nameField.text ?? "").characters.indexOf(" ") != nil && (nameField.text ?? "") != " "
        
        let totalValid = 4
        
        var validCount = 0
        if cardValid {
            validCount++
        }
        if expireVaid {
            validCount++
        }
        if securityValid {
            validCount++
        }
        if nameValid {
            validCount++
        }
        
        let progess: Float = Float(validCount) / Float(totalValid)
        
        if progess == 1 {
            purchaseButton.enabled = true
        } else {
            purchaseButton.enabled = false
        }
        
        animateProgress(progess)
    }
    
    func animateProgress(progress: Float) {
        var endColour = Sweetercolor(hex: 0x23fa1a, alpha: 0.3)
        if progress == 1.0 {
            endColour = Sweetercolor(hex: 0x23FB1A)
        }
        
        let buttonWidth = purchaseButton.frame.width
        let newWidth = buttonWidth * CGFloat(progress)
        let const = buttonWidth - newWidth
        
        self.progressConstraint.constant = const
        UIView.animateWithDuration(0.5, animations: {
            self.progressView.backgroundColor = endColour.color
            self.view.layoutIfNeeded()
        })
    }
    
    // check regex of card number to determine card type
    func animateCardLogo() {
        let text = cardNumberField.text ?? ""
        var type: CardType? = nil
        
        if text.rangeOfString("^4\\d?", options: .RegularExpressionSearch) != nil {
            type = CardType.Visa
        } else if text.rangeOfString("^5[1-5]\\d?", options: .RegularExpressionSearch) != nil {
            type = CardType.Mastercard
        }
        
        if type != nil && type != cardType {
            // animate logo into view
            cardLogo.animation = "slideDown"
            cardLogo.curve = "easeInOut"
            cardLogo.hidden = false
            cardLogo.image = UIImage(named: type!.description())
            cardLogo.animate()
        } else if type == nil {
            // remove logo from view
            cardLogo.animation = "fall"
            cardLogo.animate()
        }
        cardType = type
    }
    
    // the purchase animation
    func animatePurchase() {
        progressView.cornerRadius = 90
        let formHeight = formView.frame.height
        UIView.animateWithDuration(1.1, animations: {
            self.progressView.transform = CGAffineTransformMakeScale(100, 100)
            }, completion: {finished in
                self.backButtonDidTouch(self)
        })
        
        self.purchaseButton.setTitle("Complete", forState: UIControlState.Normal)
        UIView.animateWithDuration(0.5, delay: 0.2, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            self.purchaseButton.transform = CGAffineTransformMakeTranslation(0, (formHeight/2 * -1) + 25)
            }, completion: {finished in
        })
    }

    @IBAction func cardNameDidTouch(sender: AnyObject) {
        nameField.becomeFirstResponder()
    }
    
    @IBAction func cardNumberDidTouch(sender: AnyObject) {
        cardNumberField.becomeFirstResponder()
    }
    
    @IBAction func cardExpiresDidTouch(sender: AnyObject) {
        expiresField.becomeFirstResponder()
    }
    
    @IBAction func resignButtonDidTouch(sender: AnyObject) {
        self.view.endEditing(true)
    }
    
    // MARK : Text Fields

    func parseNumber(number: String) {
        let length = number.characters.count
        var num_sets = ["XXXX", "XXXX", "XXXX", "XXXX"]
        
        // grab numbers in groups of 4
        for (var i=0; i<4; i++) {
            let start = i * 4
            var end = start + 4
            
            if start >= length {
                break
            }
            var offset = 0
            if end >= length {
                offset = end - length
                end = length
            }
            
            let range = Range<String.Index>(start: number.startIndex.advancedBy(start), end: number.startIndex.advancedBy(end))
            num_sets[i] = number.substringWithRange(range)
            
            // fill the rest with X's
            for (var j=0;j<offset;j++) {
                num_sets[i] += "X"
            }
        }
        
        cardNumber1.text = num_sets[0]
        cardNumber2.text = num_sets[1]
        cardNumber3.text = num_sets[2]
        cardNumber4.text = num_sets[3]
    }

    @IBAction func formTextDidChange(sender: AnyObject) {
        let field = sender as! UITextField
        let length = (field.text ?? "").utf16.count
        
        if field == cardNumberField {
            parseNumber(field.text ?? "")
            if length >= 16 {
                expiresField.becomeFirstResponder()
            }
        } else if field == expiresField {
            
            // fill in the / when necessary
            if length == 2 && length > previousExpires.utf16.count {
                expiresField.text = expiresField.text! + "/"
            } else if length == 3 && length < previousExpires.utf16.count {
                expiresField.text = expiresField.text!.substringToIndex(expiresField.text!.startIndex.advancedBy(2))
            } else if length >= 3 && expiresField.text!.characters.indexOf("/") == nil {
                let text = expiresField.text!
                expiresField.text = text.substringToIndex(text.startIndex.advancedBy(2)) + "/" + text.substringFromIndex(text.startIndex.advancedBy(2))
            }
            cardExpires.text = expiresField.text ?? ""
            if length >= 5 {
                securityField.becomeFirstResponder()
            }
            previousExpires = expiresField.text ?? ""
        } else if field == securityField {
            if length >= 3 {
                nameField.becomeFirstResponder()
            }
        } else if field == nameField {
            cardName.text = nameField.text ?? ""
        }
        
        updateProgess()
        animateCardLogo()
    }
    
    @IBAction func formTextDidEditBegin(sender: AnyObject) {
    }
    
    @IBAction func formTextDidEditEnd(sender: AnyObject) {
        if let field = sender as? UITextField {
            // fix IOS 9 text "bounce" issue when end editing
            field.layoutIfNeeded()
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == nameField {
            textField.resignFirstResponder()
        }
        return true
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
     
        // set max lengths for form fields
        var max = text.utf16.count + string.utf16.count
        if textField == cardNumberField {
            max = 16
        }
        if textField == expiresField {
            max = 5
        }
        if textField == securityField {
            max = 3
        }
        
        let newLength = text.utf16.count + string.utf16.count - range.length
        return newLength <= max // Bool
    }
    
}

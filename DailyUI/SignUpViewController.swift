//
//  SignUpViewController.swift
//  DailyUI
//
//  Created by Jake Runzer on 2015-10-21.
//  Copyright © 2015 Jake Runzer. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var nameImageView: SpringImageView!
    @IBOutlet weak var emailImageView: SpringImageView!
    @IBOutlet weak var passwordImageView: SpringImageView!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var nameUnderlineView: UIView!
    @IBOutlet weak var emailUnderlineView: UIView!
    @IBOutlet weak var passwordUnderlineView: UIView!
    @IBOutlet weak var completeLineView: UIView!
    
    var completeOut = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        passwordTextField.delegate = self
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        animateComplete()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func animateComplete() {
        
        // if we want to put out an already out animation
        if allTextTheir() && completeOut {
            return
        }
        // if we just dont need to put an animation out
        if !allTextTheir() && !completeOut {
            return
        }
        
        var startxpos = CGFloat(-300)
        var endxpos = CGFloat(0)
        completeOut = false
        if allTextTheir() {
            completeOut = true
            startxpos = CGFloat(0)
            endxpos = CGFloat(-300)
        }
        completeLineView.transform = CGAffineTransformMakeTranslation(startxpos, 0)
        
        UIView.animateWithDuration(0.2, animations: {
            self.completeLineView.transform = CGAffineTransformMakeTranslation(endxpos, 0)
        })
    }
    
    func allTextTheir() -> Bool {
        if nameTextField.text != "" && emailTextField.text != "" && passwordTextField.text != "" {
            return true
        }
        return false
    }
    
    func animateUnderline(underline: UIView, on: Bool) {
        var startscale = CGFloat(1)
        var endscale = CGFloat(0)
        if on {
            startscale = CGFloat(0)
            endscale = CGFloat(1)
        }
        underline.transform = CGAffineTransformMakeScale(startscale, startscale)
        underline.hidden = false
        
        UIView.animateWithDuration(0.2, animations: {
            underline.transform = CGAffineTransformMakeScale(endscale, endscale)
        })
        
    }
    
    @IBAction func textEditDidBegin(sender: AnyObject) {
        var imageView: SpringImageView?
        var newImage: String = ""
        var underline: UIView?
        
        if sender as! NSObject == nameTextField {
            imageView = nameImageView
            newImage = "profileRed"
            underline = nameUnderlineView
        } else if sender as! NSObject == emailTextField {
            imageView = emailImageView
            newImage = "atRed"
            underline = emailUnderlineView
        } else if sender as! NSObject == passwordTextField {
            imageView = passwordImageView
            newImage = "lockRed"
            underline = passwordUnderlineView
        }
        
        if imageView != nil {
            imageView!.animation = "morph"
            imageView?.animateNext {
                imageView?.image = UIImage(named: newImage)
            }
            animateUnderline(underline!, on: true)
        }
    }
    
    @IBAction func textEditDidEnd(sender: AnyObject) {
        var imageView: SpringImageView?
        var newImage: String = ""
        var underline: UIView?
        
        let textView = sender as! UITextField
        if textView.text == "" {
            if sender as! NSObject == nameTextField {
                imageView = nameImageView
                newImage = "profileDark"
                underline = nameUnderlineView
            } else if sender as! NSObject == emailTextField {
                imageView = emailImageView
                newImage = "atDark"
                underline = emailUnderlineView
            } else if sender as! NSObject == passwordTextField {
                imageView = passwordImageView
                newImage = "lockDark"
                underline = passwordUnderlineView
            }
            
            if imageView != nil {
                imageView!.animation = "morph"
                imageView?.animateNext {
                    imageView?.image = UIImage(named: newImage)
                }
                animateUnderline(underline!, on: false)
            }
        }
    }
    
    @IBAction func textEditDidChange(sender: AnyObject) {
        animateComplete()
    }
    
    @IBAction func registerButtonDidTouch(sender: AnyObject) {
        self.view.endEditing(true)
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        if allTextTheir() {
            registerButtonDidTouch(self)
        }
        return true
    }
    
}

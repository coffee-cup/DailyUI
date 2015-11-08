//
//  SettingsViewController.swift
//  DailyUI
//
//  Created by Jake Runzer on 2015-11-05.
//  Copyright © 2015 Jake Runzer. All rights reserved.
//

import UIKit

enum SettingsView {
    case Picker, Profile, Connections, Back, None
    func description () -> String {
        switch self {
        case .Picker:
            return "picker"
        case .Profile:
            return "profile"
        case .Connections:
            return "connections"
        case .Back:
            return "back"
        case .None:
            return "none"
        }
    }
}

class SettingsViewController: UIViewController, ColourPickerDelegate {

    @IBOutlet weak var profileButtonView: UIView!
    @IBOutlet weak var pickerButtonView: UIView!
    @IBOutlet weak var connectionsButtonView: UIView!
    @IBOutlet weak var backButtonView: UIView!
    @IBOutlet weak var connectionImageButton: UIButton!
    @IBOutlet weak var backImageButton: UIButton!
    @IBOutlet weak var profileImageButton: UIButton!
    
    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var connectionsSubView: DesignableView!
    @IBOutlet weak var profileSubView: DesignableView!
    @IBOutlet weak var backgroundCircle: DesignableView!
    @IBOutlet weak var titleLabel: UILabel!
    
    let pickerColour = Sweetercolor(hex: 0xffe32c).color
    let profileColour = Sweetercolor(hex: 0x46ffd7).color
    let connectionsColour = Sweetercolor(hex: 0xc63dff).color
    let backColour = Sweetercolor(hex: 0xff3132).color
    
    let youtubeColour = Sweetercolor(hex: 0xcd201f).color
    let soundcloudColour = Sweetercolor(hex: 0xff3300).color
    let twitterColour = Sweetercolor(hex: 0x55acee).color
    
    @IBOutlet weak var usernameLabel: DesignableLabel!
    @IBOutlet weak var usernameField: DesignableTextField!
    @IBOutlet weak var passwordLabel: DesignableLabel!
    @IBOutlet weak var passwordField: DesignableTextField!
    @IBOutlet weak var profileImageView: DesignableImageView!
    
    @IBOutlet weak var authView: DesignableView!
    @IBOutlet weak var authImage: DesignableImageView!
    @IBOutlet weak var authLabel: DesignableLabel!
    @IBOutlet weak var authButton: DesignableButton!
    @IBOutlet weak var authCheck: DesignableImageView!
    var authUp = false
    
    @IBOutlet weak var soundcloudButton: DesignableButton!
    @IBOutlet weak var youtubeButton: DesignableButton!
    @IBOutlet weak var twitterButton: DesignableButton!
    
    var soundcloudAuthed = false
    var twitterAuthed = false
    var youtubeAuthed = false
    
    @IBOutlet weak var xButton: DesignableButton!
    
    var currentSubView: SettingsView = SettingsView.None
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        xButton.hidden = true
        profileSubView.hidden = true
        connectionsSubView.hidden = true
        authView.hidden = true
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func animateBackgroundColour(color: UIColor, completion: ((Bool) -> ())? = nil) {
        backgroundCircle.transform = CGAffineTransformMakeScale(1, 1)
        backgroundCircle.backgroundColor = color
        
        let height = self.view.frame.height
        let circleHeight = backgroundCircle.frame.height
        let scale: CGFloat = CGFloat(height / (circleHeight / 4)) + CGFloat(2)
        
        UIView.animateWithDuration(0.75, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                self.backgroundCircle.transform = CGAffineTransformMakeScale(scale, scale)
                self.backgroundCircle.backgroundColor = color.colorWithAlphaComponent(0.5)
            }, completion: completion)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ColourPickerSegue" {
            let toView = segue.destinationViewController as! ColourPickerViewController
            toView.delegate = self
        }
    }
    
    func animateAllSubsAway() {
        if currentSubView == .Back {
            xButton.animation = "fall"
            xButton.curve = "easeOut"
            xButton.animate()
            backImageButton.setBackgroundImage(UIImage(named: "back_settings"), forState: UIControlState.Normal)
        } else if currentSubView == .Connections {
            connectionsSubView.animation = "fall"
            connectionsSubView.curve = "easeOut"
            connectionsSubView.animateNext({
                if self.currentSubView != .Connections {
                    self.connectionsSubView.hidden = true
                }
            })
            connectionImageButton.setBackgroundImage(UIImage(named: "connection"), forState: UIControlState.Normal)
        } else if currentSubView == .Profile {
            profileSubView.animation = "fall"
            profileSubView.curve = "easeOut"
            profileSubView.animateToNext({
                if self.currentSubView != .Profile {
                    self.profileSubView.hidden = true   
                }
            })
            profileImageButton.setBackgroundImage(UIImage(named: "profile"), forState: UIControlState.Normal)
        } else if currentSubView == .Picker {
            
        }
    }
    
    func pickColour(colour: UIColor) {
        animateBackgroundColour(colour)
    }
    
    @IBAction func pickButtonDidTouch(sender: AnyObject) {
        if authUp {
            return
        }
        animateAllSubsAway()
        currentSubView = .Picker
        self.performSegueWithIdentifier("ColourPickerSegue", sender: sender)
        
        titleLabel.text = "Settings"
    }
    
    @IBAction func profileButtonDidTouch(sender: AnyObject) {
        if authUp {
            return
        }
        animateAllSubsAway()
        currentSubView = .Profile
        animateBackgroundColour(profileColour)
        
        let animation = "slideRight"
        let curve = "easeOut"
        let damping = CGFloat(0.8)
        
        titleLabel.text = "Profile"
        
        profileImageButton.setBackgroundImage(UIImage(named: "profile_filled"), forState: UIControlState.Normal)
        
        // profile animations
        profileImageView.animation = animation
        profileImageView.curve = curve
        profileImageView.damping = damping
        
        usernameLabel.animation = animation
        usernameLabel.curve = curve
        usernameLabel.damping = damping
        usernameLabel.delay = 0.2
        
        usernameField.animation = animation
        usernameField.curve = curve
        usernameField.damping = damping
        usernameField.delay = 0.2

        passwordLabel.animation = animation
        passwordLabel.curve = curve
        passwordLabel.damping = damping
        passwordLabel.delay = 0.4
        
        passwordField.animation = animation
        passwordField.curve = curve
        passwordField.damping = damping
        passwordField.delay = 0.4
        
        profileSubView.hidden = false
        subView.hidden = false
        profileSubView.transform = CGAffineTransformMakeTranslation(0, 0)
        profileImageView.animate()
        usernameLabel.animate()
        usernameField.animate()
        passwordLabel.animate()
        passwordField.animate()
    }
    
    @IBAction func connectionButtonDidTouch(sender: AnyObject) {
        if authUp {
            return
        }
        animateAllSubsAway()
        currentSubView = .Connections
        animateBackgroundColour(connectionsColour)
        
        titleLabel.text = "Integrations"
        
        let animation = "slideRight"
        let curve = "easeOut"
        let damping = CGFloat(0.8)
        
        connectionImageButton.setBackgroundImage(UIImage("connection_filled"), forState: UIControlState.Normal)
        
        soundcloudButton.animation = animation
        soundcloudButton.curve = curve
        soundcloudButton.damping = damping

        youtubeButton.animation = animation
        youtubeButton.curve = curve
        youtubeButton.damping = damping
        youtubeButton.delay = 0.2
        
        twitterButton.animation = animation
        twitterButton.curve = curve
        twitterButton.damping = damping
        twitterButton.delay = 0.4
        
        connectionsSubView.hidden = false
        connectionsSubView.transform = CGAffineTransformMakeTranslation(0, 0)
        soundcloudButton.animate()
        youtubeButton.animate()
        twitterButton.animate()
    }
    
    @IBAction func backButtonDidTouch(sender: AnyObject) {
        if authUp {
            return
        }
        animateAllSubsAway()
        currentSubView = .Back
        animateBackgroundColour(backColour)
        
        backImageButton.setBackgroundImage(UIImage(named: "back_filled"), forState: UIControlState.Normal)
        
        titleLabel.text = "Back"
        xButton.animation = "slideRight"
        xButton.curve = "easeOut"
        subView.hidden = false
        xButton.hidden = false
        xButton.animate()
    }
    
    @IBAction func xButtonDidTouch(sender: AnyObject) {
        backgroundCircle.hidden = true
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func dismissButtonDidTouch(sender: AnyObject) {
        if authUp {
            authView.animation = "fall"
            authView.curve = "easeOut"
            self.authUp = false
            authView.animateNext({
                if !self.authUp {
                    self.authView.hidden = true
                    self.authUp = false
                }
            })
        }
        self.view.endEditing(true)
    }
    
    @IBAction func authenticateButtonDidTouch(sender: AnyObject) {
        let authText = authLabel.text ?? ""
        var finalImage = "youtube_filled"
        if authText == "Youtube" {
            youtubeButton.setImage(UIImage(named: "youtube_filled_int"), forState: UIControlState.Normal)
            youtubeAuthed = true
            finalImage = "youtube_filled"
        } else if authText == "Soundcloud" {
            soundcloudButton.setImage(UIImage(named: "soundcloud_filled_int"), forState: UIControlState.Normal)
            soundcloudAuthed = true
            finalImage = "soundcloud_filled"
        } else if authText == "Twitter" {
            twitterButton.setImage(UIImage(named: "twitter_filled_int"), forState: UIControlState.Normal)
            twitterAuthed = true
            finalImage = "twitter_filled"
        }
        
        authImage.image = UIImage(named: finalImage)
        authButton.setTitle("", forState: UIControlState.Normal)
        authCheck.hidden = false
        authCheck.animation = "pop"
        authImage.animation = "pop"
        authImage.animate()
        authCheck.animate()
        
        let triggerTime = (Int64(NSEC_PER_MSEC) * 750)
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, triggerTime), dispatch_get_main_queue(), { () -> Void in
            self.dismissButtonDidTouch(sender)
            self.authCheck.hidden = true
        })
    }
    
    @IBAction func authButtonDidTouch(sender: AnyObject) {
        if let button = sender as? DesignableButton {
            var authText = "Youtube"
            var authImageName = "youtube"
            var authedImage = "youtube_int"
            var authColour: UIColor = UIColor.redColor()
            var alreadyAuthed = false
            if button == soundcloudButton {
                authText = "Soundcloud"
                authImageName = "soundcloud_empty"
                authColour = soundcloudColour
                alreadyAuthed = soundcloudAuthed
                soundcloudAuthed = soundcloudAuthed ? false : true
                authedImage = "soundcloud_int"
            } else if button == youtubeButton {
                authText = "Youtube"
                authImageName = "youtube_empty"
                authColour = youtubeColour
                alreadyAuthed = youtubeAuthed
                youtubeAuthed = youtubeAuthed ? false : true
                authedImage = "youtube_int"
            } else if button == twitterButton {
                authText = "Twitter"
                authImageName = "twitter_empty"
                authColour = twitterColour
                alreadyAuthed = twitterAuthed
                twitterAuthed = twitterAuthed ? false : true
                authedImage = "twitter_int"
            }
            
            if alreadyAuthed {
                button.setImage(UIImage(named: authedImage), forState: UIControlState.Normal)
                return
            }
        
            authView.hidden = false
            authView.transform = CGAffineTransformMakeTranslation(0, self.view.frame.height)
            authUp = true
            authLabel.hidden = true
            authImage.hidden = true
            authButton.hidden = true
            authCheck.hidden = true
            
            authLabel.text = authText
            authImage.image = UIImage(named: authImageName)
            authButton.setTitle("Start OAuth", forState: UIControlState.Normal)
            authButton.backgroundColor = authColour
            
            UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: CGFloat(0.8), initialSpringVelocity: 1, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                    self.authView.transform = CGAffineTransformMakeTranslation(0, 0)
                }, completion: {finsihed in
            })
            
            self.authLabel.hidden = false
            self.authImage.hidden = false
            self.authButton.hidden = false
            
            self.authImage.animation = "slideDown"
            self.authImage.damping = 0.8
            self.authImage.curve = "easeOut"
            self.authImage.delay = 0.2
            self.authLabel.animation = "slideRight"
            self.authLabel.damping = 0.8
            self.authLabel.curve = "easeOut"
            self.authLabel.delay = 0.2
            self.authButton.animation = "slideUp"
            self.authButton.damping = 0.8
            self.authButton.curve = "easeOut"
            self.authButton.delay = 0.2
            
            self.authImage.animate()
            self.authLabel.animate()
            self.authButton.animate()
        }
    }
    
}

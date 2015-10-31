//
//  AppIconViewController.swift
//  DailyUI
//
//  Created by Jake Runzer on 2015-10-31.
//  Copyright © 2015 Jake Runzer. All rights reserved.
//

import UIKit

class AppIconViewController: UIViewController {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet var panGesture: UIPanGestureRecognizer!
    
    var animator : UIDynamicAnimator!
    var attachmentBehavior : UIAttachmentBehavior!
    var snapBehavior : UISnapBehavior!
    var pushBehavior: UIPushBehavior!
    var itemBehavior: UIDynamicItemBehavior!
    
    let ThrowingThreshold: CGFloat = 3000
    let ThrowingVelocityPadding: CGFloat = 35
    
    let colorThreshold: CGFloat = 300
    let colorH = CGFloat(123)
    let colorS = CGFloat(97)
    let colorMinL = CGFloat(50)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        animator = UIDynamicAnimator(referenceView: view)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        view.backgroundColor = Sweetercolor(hue: colorH, saturation: colorS, brightness: CGFloat(100)).color
    }
    
    @IBAction func handleGesture(sender: AnyObject) {
        let myView = iconImageView
        let location = sender.locationInView(view)
        let boxLocation = sender.locationInView(myView)
        
        if sender.state == UIGestureRecognizerState.Began {
            if snapBehavior != nil {
                animator.removeBehavior(snapBehavior)
            }
            
            let centerOffset = UIOffsetMake(boxLocation.x - CGRectGetMidX(myView.bounds), boxLocation.y - CGRectGetMidY(myView.bounds));
            attachmentBehavior = UIAttachmentBehavior(item: myView, offsetFromCenter: centerOffset, attachedToAnchor: location)
            attachmentBehavior.frequency = 0
            
            animator.addBehavior(attachmentBehavior)
        }
        else if sender.state == UIGestureRecognizerState.Changed {
            attachmentBehavior.anchorPoint = location
            
            let translation = sender.translationInView(view)
            let distance = sqrt((translation.x * translation.x) + (translation.y * translation.y))
            
            let pDistance: CGFloat = distance / colorThreshold
            
            let r = (pDistance * CGFloat(colorMinL))
            let colour = Sweetercolor(hue: colorH, saturation: colorS, brightness: CGFloat(100 - r))
            view.backgroundColor = colour.color
        }
        else if sender.state == UIGestureRecognizerState.Ended {
            animator.removeBehavior(attachmentBehavior)
            
            let velocity = sender.velocityInView(view)
            let magnitude = sqrt((velocity.x * velocity.x) + (velocity.y * velocity.y))
            
            if magnitude > ThrowingThreshold {
                // 2
                let pushBehavior = UIPushBehavior(items: [myView], mode: .Instantaneous)
                pushBehavior.pushDirection = CGVector(dx: velocity.x / 10, dy: velocity.y / 10)
                pushBehavior.magnitude = magnitude / ThrowingVelocityPadding
                
                self.pushBehavior = pushBehavior
                animator.addBehavior(pushBehavior)
                
                // 3
                let angle = Int(arc4random_uniform(20)) - 10
                
                itemBehavior = UIDynamicItemBehavior(items: [myView])
                itemBehavior.friction = 0.2
                itemBehavior.allowsRotation = true
                itemBehavior.addAngularVelocity(CGFloat(angle), forItem: myView)
                animator.addBehavior(itemBehavior)
                
                // 4
                let timeOffset = Int64(0.4 * Double(NSEC_PER_SEC))
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, timeOffset), dispatch_get_main_queue()) {
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
            } else {
                snapBehavior = UISnapBehavior(item: myView, snapToPoint: view.center)
                snapBehavior.damping = 0.7
                animator.addBehavior(snapBehavior)
                
                UIView.animateWithDuration(0.5, animations: {
                    self.view.backgroundColor = Sweetercolor(hue: self.colorH, saturation: self.colorS, brightness: CGFloat(100)).color
                })
            }
        }
    }
    
}

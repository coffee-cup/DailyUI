//
//  NotFoundViewController.swift
//  DailyUI
//
//  Created by Jake Runzer on 2015-11-12.
//  Copyright © 2015 Jake Runzer. All rights reserved.
//

import UIKit

class NotFoundViewController: UIViewController {
    
    @IBOutlet weak var homeImageView: UIImageView!
    @IBOutlet weak var backImageView: UIImageView!
    @IBOutlet weak var homeButton: SpringButton!
    @IBOutlet weak var backButton: SpringButton!

    var homeOn = true

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        startFlipping()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func startFlipping() {
        if homeOn {
            homeImageView.image = UIImage(named: "HomeFilled")
            backImageView.image = UIImage(named: "BackEmpty")
        } else {
            homeImageView.image = UIImage(named: "HomeEmpty")
            backImageView.image = UIImage(named: "BackFilled")
        }
        
        let triggerTime = (Int64(NSEC_PER_MSEC) * 1000)
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, triggerTime), dispatch_get_main_queue(), { () -> Void in
            self.homeOn = !self.homeOn
            self.startFlipping()
        })
    }
    
    @IBAction func backButtonDidTouch(sender: AnyObject) {
        if let button = sender as? SpringButton {
            button.animation = "zoomOut"
            button.force = 8
            button.duration = 2
            button.curve = "easeOut"
            button.backgroundColor = Sweetercolor(hex: 0xED5B66).color
            button.animateNext({
                self.dismissViewControllerAnimated(true, completion: nil)
            })
            
            let triggerTime = (Int64(NSEC_PER_MSEC) * 400)
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, triggerTime), dispatch_get_main_queue(), { () -> Void in
                self.dismissViewControllerAnimated(true, completion:nil)
            })
        }
    }
}

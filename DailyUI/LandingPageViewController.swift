//
//  LandingPageViewController.swift
//  DailyUI
//
//  Created by Jake Runzer on 2015-11-01.
//  Copyright © 2015 Jake Runzer. All rights reserved.
//

import UIKit

class LandingPageViewController: UIViewController {

    @IBOutlet weak var exitView: UIView!
    
    override func viewDidLoad() {
        exitView.hidden = true
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: "handleTap:")
        self.view.addGestureRecognizer(gestureRecognizer)
    }
    
    func handleTap(gestureRecognizer: UIGestureRecognizer) {
        let location: CGPoint = gestureRecognizer.locationInView(self.view)
        exitView.hidden = false
        exitView.center = location
        exitView.transform = CGAffineTransformMakeScale(0, 0)
        
        UIView.animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.exitView.transform = CGAffineTransformMakeScale(40, 40)
            }, completion: {finished in
                self.exitView.hidden = true
                self.dismissViewControllerAnimated(true, completion: nil)
        })
    }
}

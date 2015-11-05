//
//  StoryTableViewCell.swift
//  DailyUI
//
//  Created by Jake Runzer on 2015-11-04.
//  Copyright © 2015 Jake Runzer. All rights reserved.
//

import UIKit

class StoryTableViewCell: UITableViewCell {

    @IBOutlet weak var storyBackImageView: UIImageView!
    @IBOutlet weak var titleLabel: DesignableLabel!
    @IBOutlet weak var snippetLabel: DesignableLabel!
    @IBOutlet weak var favButton: SpringButton!
    
    var fav = false
    
    @IBAction func favButtonDidTouch(sender: AnyObject) {
        fav = !fav
        
        let currCount = Int(favButton.titleLabel!.text!)
        var endText = String(currCount! + 1)
        var endImage = "heart_filled"
        if !fav {
            endText = String(currCount! - 1)
            endImage = "heart"
        }
        
        self.favButton.setTitle(endText, forState: UIControlState.Normal)
        self.favButton.setImage(UIImage(named: endImage), forState: UIControlState.Normal)
        
        favButton.animation = "pop"
        favButton.curve = "easeOut"
        favButton.animate()
        
        
//        UIView.animateWithDuration(0.75, animations: {
//            self.favButton.alpha = 0
//            }, completion: {finished in
//                self.favButton.setTitle(endText, forState: UIControlState.Normal)
//                self.favButton.setImage(endImage, forState: UIControlState.Normal)
//        })
        
//        UIView.animateWithDuration(0.75, animations: {
//            self.followButton.alpha = 0
//            }, completion: {finished in
//                self.followButton.setTitle(endText, forState: UIControlState.Normal)
//                self.followButton.setImage(UIImage(named: endImage), forState: UIControlState.Normal)
//                UIView.animateWithDuration(0.75, animations: {
//                    self.followButton.alpha = 1
//                    }, completion: {finished in
//                })
//        })
    }
}

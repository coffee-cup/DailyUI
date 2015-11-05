//
//  ProfileViewController.swift
//  DailyUI
//
//  Created by Jake Runzer on 2015-11-04.
//  Copyright © 2015 Jake Runzer. All rights reserved.
//

import Foundation
import UIKit

class TriangeView : UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override func drawRect(rect: CGRect) {
        
        let mask = CAShapeLayer()
        mask.frame = self.layer.bounds
        
        let width = self.layer.frame.size.width
        let height = self.layer.frame.size.height
        
        let path = CGPathCreateMutable()
        
        CGPathMoveToPoint(path, nil, width, 0)
        CGPathAddLineToPoint(path, nil, width, 0)
        CGPathAddLineToPoint(path, nil, width, height)
        CGPathAddLineToPoint(path, nil, 0, height)
        CGPathAddLineToPoint(path, nil, width, 0)
        
        mask.path = path
        
        // CGPathRelease(path); - not needed
        
        self.layer.mask = mask
        
        let shape = CAShapeLayer()
        shape.frame = self.bounds
        shape.path = path
        shape.fillColor = UIColor.clearColor().CGColor
        
        self.layer.insertSublayer(shape, atIndex: 0)
    }
}

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var followButton: DesignableButton!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var imageTopConstraint: NSLayoutConstraint!
    
    var following = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
//        imageTopConstraint.constant = 0
//        UIView.animateWithDuration(2, animations: {
//            self.view.layoutIfNeeded()
//        })
    }
    
    @IBAction func followButtonDidTouch(sender: AnyObject) {
        following = !following
        
        var endText = "following"
        var endImage = "sub"
        if !following {
            endText = "follow"
            endImage = "add"
        }
        
        UIView.animateWithDuration(0.75, animations: {
            self.followButton.alpha = 0
            }, completion: {finished in
                self.followButton.setTitle(endText, forState: UIControlState.Normal)
                self.followButton.setImage(UIImage(named: endImage), forState: UIControlState.Normal)
                UIView.animateWithDuration(0.75, animations: {
                    self.followButton.alpha = 1
                    }, completion: {finished in
                })
        })
    }
    
    @IBAction func backButtonDidTouch(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK : Table View
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stories.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 130
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("StoryCell", forIndexPath: indexPath) as! StoryTableViewCell
        let story = stories[indexPath.row]
        
        cell.titleLabel.text = story["title"]! 
        cell.storyBackImageView.image = UIImage(named: story["image"]!)
        cell.snippetLabel.text = story["snippet"]!
        cell.favButton.setTitle(story["favs"]!, forState: UIControlState.Normal)
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

    }
    
}

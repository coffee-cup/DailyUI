//
//  ColourPickerViewController.swift
//  DailyUI
//
//  Created by Jake Runzer on 2015-11-07.
//  Copyright © 2015 Jake Runzer. All rights reserved.
//

import UIKit

extension UIImage {
    func getPixelColor(pos: CGPoint) -> UIColor {
        
        let pixelData = CGDataProviderCopyData(CGImageGetDataProvider(self.CGImage))
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        
        let pixelInfo: Int = ((Int(self.size.width) * Int(pos.y)) + Int(pos.x)) * 4
        
        let r = CGFloat(data[pixelInfo]) / CGFloat(255.0)
        let g = CGFloat(data[pixelInfo+1]) / CGFloat(255.0)
        let b = CGFloat(data[pixelInfo+2]) / CGFloat(255.0)
        let a = CGFloat(data[pixelInfo+3]) / CGFloat(255.0)
        
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
}

protocol ColourPickerDelegate: class {
    func pickColour(colour: UIColor)
}

class ColourPickerViewController: UIViewController {

    @IBOutlet var panGesture: UIPanGestureRecognizer!
    @IBOutlet weak var colourView: UIView!
    @IBOutlet weak var rainbowImageView: UIImageView!
    
    weak var delegate: ColourPickerDelegate?
    
    @IBAction func backButtonDidTouch(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func handleGesture(sender: AnyObject) {
        let location = sender.locationInView(rainbowImageView)
        
        let width = rainbowImageView.frame.width
        let height = rainbowImageView.frame.height
        let original = UIImage(named: "rainbow")!
        let originalSize = original.size
        let scaledPoint: CGPoint = CGPoint(x: (location.x / width) * originalSize.width * 4, y: (location.y / height) * originalSize.height * 4)
        
        let colour = original.getPixelColor(scaledPoint)
        colourView.backgroundColor = colour
        
        delegate?.pickColour(colour)
    }
    
}

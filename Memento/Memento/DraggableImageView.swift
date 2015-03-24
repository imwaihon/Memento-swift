//
//  DraggableImageView.swift
//  tester
//
//  Created by Abdulla Contractor on 19/3/15.
//  Copyright (c) 2015 Abdulla Contractor. All rights reserved.
//

import Foundation
import UIKit

class DraggableImageView: UIImageView {
    
    private var currentPoint: CGPoint!
    private var name: String! = ""
    var parent: PalaceOverviewViewController!
    var tapGesture: UITapGestureRecognizer!
    var longPressGesture: UILongPressGestureRecognizer!
    
    init(image: UIImage!, name: String!, parent: PalaceOverviewViewController) {
        super.init(image: image)
        self.userInteractionEnabled = true
        self.name = name
        self.parent = parent
        tapGesture = UITapGestureRecognizer(target: self, action: "tapHandler:")
        tapGesture.numberOfTapsRequired = 1
        self.addGestureRecognizer(tapGesture)
        
        self.layer.shadowColor = UIColor.blackColor().CGColor
        self.layer.shadowOffset = CGSizeMake(2, 2);
        self.layer.shadowOpacity = 0.4;
        self.layer.shadowRadius = 1.0;
        self.clipsToBounds = false;
        
        longPressGesture = UILongPressGestureRecognizer(target: self, action: "longPressHandler:")
        //longPressGesture.numberOfTapsRequired = 1
        longPressGesture.minimumPressDuration = CFTimeInterval(1)
        //self.addGestureRecognizer(longPressGesture)
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.currentPoint = touches.anyObject()?.locationInView(self)
    }
    
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        var activePoint: CGPoint = touches.anyObject()!.locationInView(self)
        var newPoint: CGPoint = CGPoint(x: self.center.x + activePoint.x - currentPoint.x, y: self.center.y + (activePoint.y - currentPoint.y))
        self.center = newPoint
        let superview = self.superview
        if(superview != nil && superview is UIScrollView){
            let superV = superview as UIScrollView
            if(self.frame.maxX > superview!.frame.maxX + superV.contentOffset.x){
                superV.setContentOffset(CGPoint(x: superV.contentOffset.x + 10, y: superV.contentOffset.y), animated: false)
            }
        }
        parent.updateImagePosition(self.name, toPosition: self.center)
    }
    
    override func touchesCancelled(touches: NSSet!, withEvent event: UIEvent!) {
        NSLog("Cancelled")
        touchesMoved(touches, withEvent: event)
        
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        //NSLog("Ended")
        parent.updateImagePosition(self.name, toPosition: self.center)
        
    }
    
    
    func tapHandler(gesture: UIGestureRecognizer){
        NSLog("Go to \(name)")
    }
    
    func longPressHandler(gesture: UIGestureRecognizer){
        var pointOfTheTouch = gesture.locationInView(self)
        self.alpha = 0.7
        //let set = NSSet(pointOfTheTouch)
        //touchesBegan(set, withEvent: nil)
    }
    
}
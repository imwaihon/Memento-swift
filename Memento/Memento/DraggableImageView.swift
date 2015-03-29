//
//  DraggableImageView.swift
//  Helper UIImageView class for draggable UIImageViews
//
//  Memento
//
//  Created by Jingrong (: on 29/3/15.
//  Copyright (c) 2015 NUS CS3217. All rights reserved.
//

import UIKit

class DraggableImageView : UIImageView
{
    var dragStartPositionRelativeToCenter : CGPoint?
    
    override init(image: UIImage!) {
        super.init(image: image)
        
        self.userInteractionEnabled = true
        
        addGestureRecognizer(UIPanGestureRecognizer(target: self, action: "handlePan:"))
        
        layer.shadowColor = UIColor.blackColor().CGColor
        layer.shadowOffset = CGSize(width: 0, height: 3)
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 2
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func handlePan(nizer: UIPanGestureRecognizer!) {
        if nizer.state == UIGestureRecognizerState.Began {
            let locationInView = nizer.locationInView(superview)
            dragStartPositionRelativeToCenter = CGPoint(x: locationInView.x - center.x, y: locationInView.y - center.y)
            
            layer.shadowOffset = CGSize(width: 0, height: 20)
            layer.shadowOpacity = 0.3
            layer.shadowRadius = 6
            
            return
        }
        
        if nizer.state == UIGestureRecognizerState.Ended {
            dragStartPositionRelativeToCenter = nil
            
            layer.shadowOffset = CGSize(width: 0, height: 3)
            layer.shadowOpacity = 0.5
            layer.shadowRadius = 2
            
            return
        }
        
        let locationInView = nizer.locationInView(superview)
        
        UIView.animateWithDuration(0.1) {
            self.center = CGPoint(x: locationInView.x - self.dragStartPositionRelativeToCenter!.x,
                y: locationInView.y - self.dragStartPositionRelativeToCenter!.y)
        }
    }
}
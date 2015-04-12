//
//  DraggableEditButton.swift
//  Memento
//
//  Created by Jingrong (: on 13/4/15.
//  Copyright (c) 2015 NUS CS3217. All rights reserved.
//

import UIKit

class DraggableEditButton : UIButton {
    var dragStartPositionRelativeToCenter : CGPoint?
    
    // MARK: Overrides
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // init methods
        self.userInteractionEnabled = true
        self.multipleTouchEnabled = true
        
        addGestureRecognizer(UIPanGestureRecognizer(target: self, action: "handlePan:"))
        layer.shadowColor = UIColor.blackColor().CGColor
        layer.shadowOffset = CGSize(width: 0, height: 3)
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 2
    }
    
    private var roundRectLayer: CAShapeLayer?

    
    func handlePan(nizer: UIPanGestureRecognizer!) {
        if nizer.state == UIGestureRecognizerState.Began {
            let locationInView = nizer.locationInView(superview)
            dragStartPositionRelativeToCenter = CGPoint(x: locationInView.x - center.x, y: locationInView.y - center.y)
            
            self.layer.shadowOffset = CGSize(width: 0, height: 20)
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


//
//  DraggableImageView.swift
//  Helper UIImageView class for draggable UIImageViews
//  Possible extensions: Rotate, Resize
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
    
    weak var parentViewController = UIViewController()
    var lastRotation = CGFloat()
    var labelIdentifier = Int()
    var roomLabel = Int()
    var graphName = String()
    let rotateRec = UIRotationGestureRecognizer()
    var mementoManager = MementoManager.sharedInstance
    
    override init(image: UIImage) {
        super.init(image: image)
        
        self.userInteractionEnabled = true
        self.multipleTouchEnabled = true
        
        addGestureRecognizer(UIPanGestureRecognizer(target: self, action: "handlePan:"))
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: "handleTap:"))
        addGestureRecognizer(UIPinchGestureRecognizer(target: self, action: "handlePinch:"))
        
        // Function rotate images
        //rotateRec.addTarget(self, action: "rotatedView:")
        //self.addGestureRecognizer(rotateRec)
        

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
            mementoManager.setOverlayFrame(graphName, roomLabel: roomLabel, overlayLabel: self.labelIdentifier, newFrame: self.frame)
            
            return
        }
        
        let locationInView = nizer.locationInView(superview)
        
        UIView.animateWithDuration(0.1) {
            self.center = CGPoint(x: locationInView.x - self.dragStartPositionRelativeToCenter!.x,
                y: locationInView.y - self.dragStartPositionRelativeToCenter!.y)
        }
    }
    
    func handleTap(nizer: UITapGestureRecognizer!) {
        nizer.numberOfTapsRequired = 1
        
        weak var nodeViewController = parentViewController as? NodeViewController
        if nodeViewController != nil {
            if nodeViewController!.deleteToggler {
                // Delete mode active
                mementoManager.removeOverlay(graphName, roomLabel: roomLabel, overlayLabel: labelIdentifier)
                nodeViewController!.deleteView(self)
                
            }
        }
    }
    
    func handlePinch(nizer: UIPinchGestureRecognizer!) {
        if (nizer.state == UIGestureRecognizerState.Began || nizer.state == UIGestureRecognizerState.Changed) {
            self.transform = CGAffineTransformScale(self.transform, nizer.scale, nizer.scale)
            nizer.scale = 1
        }
        if nizer.state == UIGestureRecognizerState.Ended {
            mementoManager.setOverlayFrame(graphName, roomLabel: roomLabel, overlayLabel: self.labelIdentifier, newFrame: self.frame)
        }
    }
    
    
    
    
    func rotatedView(sender:UIRotationGestureRecognizer){
        var lastRotation = CGFloat()
        if(sender.state == UIGestureRecognizerState.Ended){
            lastRotation = 0.0;
        }
        var rotation = 0.0 - (lastRotation - sender.rotation)
        var point = rotateRec.locationInView(self)
        var currentTrans = sender.view!.transform
        var newTrans = CGAffineTransformRotate(currentTrans, rotation)
        sender.view!.transform = newTrans
        lastRotation = sender.rotation
    }

    
}
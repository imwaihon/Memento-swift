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
    weak var parentViewController: UIViewController?
    var labelIdentifier = Int()
    var roomLabel = Int()
    var graphName = String()
    var mementoManager = MementoManager.sharedInstance
    
    var dragStartPositionRelativeToCenter : CGPoint?
    
    // Screen size
    let screenWidth: CGFloat = UIScreen.mainScreen().bounds.width
    let screenHeight: CGFloat = UIScreen.mainScreen().bounds.height
    
    override init(image: UIImage) {
        super.init(image: image)
        
        self.userInteractionEnabled = true
        self.multipleTouchEnabled = true
        
        addGestureRecognizer(UIPanGestureRecognizer(target: self, action: "handlePan:"))
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: "handleTap:"))
        addGestureRecognizer(UIPinchGestureRecognizer(target: self, action: "handlePinch:"))
        //addGestureRecognizer(UIRotationGestureRecognizer(target: self, action: "handleRotate:"))
        
        layer.shadowColor = UIColor.blackColor().CGColor
        layer.shadowOffset = CGSize(width: 0, height: 3)
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 2
        
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /* Gesture Recognizers */
    
    // Function to handle pan gestures
    // Pan gestures would shift the DraggableImageView according to location of touch
    func handlePan(nizer: UIPanGestureRecognizer!) {
        if nizer.state == UIGestureRecognizerState.Began {
            let locationInView = nizer.locationInView(superview)
            // To prevent out of bounds
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
            
            // Place it on top of other subviews
            //self.superview?.bringSubviewToFront(self)
            
            return
        }
        
        let locationInView = nizer.locationInView(superview)
        var xCenter = locationInView.x - self.dragStartPositionRelativeToCenter!.x
        var yCenter = locationInView.y - self.dragStartPositionRelativeToCenter!.y
        
        // Check for out of screen boundary
        if  (self.isWithinBounds()){
            UIView.animateWithDuration(0.1) {
                self.center = CGPoint(x: xCenter, y: yCenter)
            }
        }
        UIView.animateWithDuration(0.1) {
            if  (self.isWithinBounds()){
                self.center = CGPoint(x: xCenter, y: yCenter)
            }
            // Call method again to realign for corners
            self.isWithinBounds()
        }
    }
    
    // Function to handle single tap gestures
    // Will delete this DraggableImageView if deleteToggler is set to true in NodeViewController
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
    
    // Function to handle pinch gesture
    // Will resize the DraggableImageView based on user's input gesture
    // Has a minimum and maximum size
    func handlePinch(nizer: UIPinchGestureRecognizer!) {
        if (nizer.state == UIGestureRecognizerState.Began || nizer.state == UIGestureRecognizerState.Changed) {
            // Scale up
            if (nizer.scale > 1.0){
                if (isWithinBounds()){
                    self.transform = CGAffineTransformScale(self.transform, nizer.scale, nizer.scale)
                    nizer.scale = 1.0
                }
            } else {
                // Scale down
                if (isMinimumSize()) {
                    self.transform = CGAffineTransformScale(self.transform, nizer.scale, nizer.scale)
                    nizer.scale = 1.0
                }
            }
            // Call method again to realign corners
            self.isWithinBounds()
        }
        
        if nizer.state == UIGestureRecognizerState.Ended {
            mementoManager.setOverlayFrame(graphName, roomLabel: roomLabel, overlayLabel: self.labelIdentifier, newFrame: self.frame)
        }
    }
    
    /* Helper functions */
    
    // Helper function to check if this view is still within the screen boundary
    // Aids in offsetting back to within bounds
    private func isWithinBounds() -> Bool {
        let minX = CGRectGetMinX(self.frame)
        let maxX = CGRectGetMaxX(self.frame)
        let minY = CGRectGetMinY(self.frame)
        let maxY = CGRectGetMaxY(self.frame)
        
        if ( minX < 0) {
            self.center.x = self.frame.width/2.0 + 2.0
            return false
        } else if ( maxX >= screenWidth) {
            self.center.x = screenWidth - self.frame.width/2.0 - 1.0
            return false
        } else if ( maxY >= screenHeight) {
            self.center.y = screenHeight - self.frame.height/2.0 - 1.0
            return false
        } else if ( minY < 0){
            self.center.y = self.frame.height/2.0 + 2.0
            return false
        } else {
            return true
        }
    }
    
    // Helper boolean function to determine if the DraggableImageView is of at least 125 * 125
    private func isMinimumSize() -> Bool {
        if (self.frame.width < 125.0 || self.frame.height < 125.0) {
            return false
        } else {
            return true
        }
    }
    
}
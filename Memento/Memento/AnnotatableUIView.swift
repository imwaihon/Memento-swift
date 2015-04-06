//
//  AnnotatableUIView.swift
//  Memento
//  Allows for text labelling on the UIView
//
//  Created by Jingrong (: on 4/4/15.
//  Copyright (c) 2015 NUS CS3217. All rights reserved.
//

import UIKit

class AnnotatableUIView: UIView {
    
    var parentViewController = UIViewController()
    var viewTag = Int()
    var backgroundImage = UIImageView()
    var annotation = String()
    
    // Constant tag addition to allow for replacement of UILabel
    let annotationTag = 1000
    
    init(frame: CGRect, parentController: UIViewController, tagNumber: Int, background: UIImageView) {
        super.init(frame: frame)
        self.parentViewController = parentController
        self.viewTag = tagNumber
        self.backgroundImage = background
        
        self.userInteractionEnabled = true
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: "handleTap:"))
    }

    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Add a simple annotation
    
    func handleTap(nizer: UITapGestureRecognizer!) {
        
        var inputTextField: UITextField?

        let loadPrompt = UIAlertController(title: "placeholder title", message: "Some stuff", preferredStyle: UIAlertControllerStyle.Alert)
        loadPrompt.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
        loadPrompt.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            // Remove previous text
            for eachLabel in self.backgroundImage.subviews as [UIView] {
                if eachLabel.tag == self.viewTag + self.annotationTag {
                    eachLabel.removeFromSuperview()
                }
            }
            
            // New Text
            self.annotation = inputTextField?.text as String!
            var label = UILabel(frame:CGRectMake(self.center.x, self.center.y, 25, 25))
            label.tag = self.viewTag + self.annotationTag
            label.text = self.annotation
            label.backgroundColor = UIColor(white: 1, alpha: 0.4)
            label.textColor = .whiteColor()
            label.font = UIFont(name: "Trebuchet MS", size: 25.0)
            label.sizeToFit()
            label.center = self.center
            self.backgroundImage.addSubview(label)
        }))
        loadPrompt.addTextFieldWithConfigurationHandler({(textField: UITextField!) in
            textField.placeholder = "Annotation here"
            inputTextField = textField
        })
        
        self.parentViewController.presentViewController(loadPrompt, animated: true, completion: nil)
    }
}

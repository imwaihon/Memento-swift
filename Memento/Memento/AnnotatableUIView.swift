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
    var label = UILabel()
    
    init(frame: CGRect, parentController: UIViewController, tagNumber: Int, background: UIImageView) {
        super.init(frame: frame)
        self.parentViewController = parentController
        self.viewTag = tagNumber
        self.backgroundImage = background
        self.label = UILabel(frame:CGRectMake(self.center.x, self.center.y, 25, 25))
        
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
            
            // Adding text to UILabel
            self.annotation = inputTextField?.text as String!
            self.updateText(self.annotation)
        }))
        loadPrompt.addTextFieldWithConfigurationHandler({(textField: UITextField!) in
            textField.placeholder = "Annotation here"
            inputTextField = textField
        })
        
        self.parentViewController.presentViewController(loadPrompt, animated: true, completion: nil)
    }
    
    // Updates text in 
    private func updateText(newText: String) {
        // Remove previous text
        self.label.removeFromSuperview()
        
        // Put in new text
        self.label.text = self.annotation
        self.label.backgroundColor = UIColor(white: 1, alpha: 0.4)
        self.label.textColor = .whiteColor()
        self.label.font = UIFont(name: "Trebuchet MS", size: 25.0)
        self.label.sizeToFit()
        self.label.center = self.center
        self.backgroundImage.addSubview(label)
    }
}

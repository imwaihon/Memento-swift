//
//  AnnotatableUIView.swift
//  Memento
//  Allows for text labelling
//
//  Created by Jingrong (: on 4/4/15.
//  Copyright (c) 2015 NUS CS3217. All rights reserved.
//

import UIKit

class AnnotatableUIView: UIView {
    
    var parentViewController = UIViewController()
    
    init(frame: CGRect, parentController: UIViewController) {
        super.init(frame: frame)
        self.parentViewController = parentController
        
        self.userInteractionEnabled = true
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: "handleTap:"))
    }

    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Add a simple annotation
    
    func handleTap(nizer: UITapGestureRecognizer!) {
        
        var annotation = String()
        
        var inputTextField: UITextField?

        let loadPrompt = UIAlertController(title: "placeholder title", message: "Some stuff", preferredStyle: UIAlertControllerStyle.Alert)
        loadPrompt.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
        loadPrompt.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            // Remove previous text
            for eachSubview in self.parentViewController.view.subviews as [UIView] {
                if eachSubview.tag == 789 {
                    eachSubview.removeFromSuperview()
                }
            }
            
            // New Text
            annotation = inputTextField?.text as String!
            var label = UILabel(frame:CGRectMake(self.center.x, self.center.y, 25, 25))
            label.tag = 789
            label.text = annotation
            label.backgroundColor = UIColor(white: 1, alpha: 0.4)
            label.textColor = .whiteColor()
            label.font = UIFont(name: "Trebuchet MS", size: 25.0)
            label.sizeToFit()
            label.center = self.center
            self.parentViewController.view.addSubview(label)
        }))
        loadPrompt.addTextFieldWithConfigurationHandler({(textField: UITextField!) in
            textField.placeholder = "Annotation here"
            inputTextField = textField
        })
        
        self.parentViewController.presentViewController(loadPrompt, animated: true, completion: nil)
        


    }
}

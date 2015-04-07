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
    var roomLabel = Int()
    var graphName = String()
    var annotation = String()
    var mementoManager = MementoManager.sharedInstance
    
    init(frame: CGRect, parentController: UIViewController, tagNumber: Int, background: UIImageView, graphName: String, roomLabel: Int) {
        super.init(frame: frame)
        self.parentViewController = parentController
        self.viewTag = tagNumber
        self.backgroundImage = background
        self.graphName = graphName
        self.roomLabel = roomLabel
        
        self.userInteractionEnabled = true
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: "handleTap:"))
    }

    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    
    // Add a simple annotation
    func handleTap(nizer: UITapGestureRecognizer!) {
        
        var inputTextField: UITextField?

        let loadPrompt = UIAlertController(title: "placeholder title", message: "\(self.annotation)", preferredStyle: UIAlertControllerStyle.Alert)
        loadPrompt.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
        loadPrompt.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            
            // Adding text to UILabel
            self.annotation = inputTextField?.text as String!
            self.mementoManager.setAssociationValue(self.graphName, roomLabel: self.roomLabel, placeHolderLabel: self.viewTag, value: self.annotation)
        }))
        loadPrompt.addTextFieldWithConfigurationHandler({(textField: UITextField!) in
            textField.placeholder = "Annotation here"
            inputTextField = textField
        })
        
        self.parentViewController.presentViewController(loadPrompt, animated: true, completion: nil)
    }
    
}

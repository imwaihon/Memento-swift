//
//  AnnotatableUIView.swift
//  Memento
//  Allows for text labelling on the UIView
//
//  Created by Jingrong (: on 4/4/15.
//  Copyright (c) 2015 NUS CS3217. All rights reserved.
//

import UIKit

class AnnotatableUIView: UIView, UIPopoverPresentationControllerDelegate {
    
    weak var parentViewController = UIViewController()
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
    
    // Add a simple annotation or delete, depending on NodeViewController parent
    func handleTap(nizer: UITapGestureRecognizer!) {
        weak var nodeViewController = parentViewController as? NodeViewController
        if nodeViewController != nil {
            if nodeViewController!.deleteToggler {
                // Delete mode active
                mementoManager.removePlaceHolder(graphName, roomLabel: roomLabel, placeHolderLabel: viewTag)
                nodeViewController!.deleteView(self)
                
            } else {
                var mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
                var popoverContent = mainStoryBoard.instantiateViewControllerWithIdentifier("AnnotationCard") as AnnotationCardViewController
                popoverContent.modalPresentationStyle = .Popover
                popoverContent.preferredContentSize = CGSizeMake(400,200)
                let popoverViewController = popoverContent.popoverPresentationController
                popoverViewController?.permittedArrowDirections = .Any
                popoverViewController?.delegate = self
                popoverViewController?.sourceView = self
                popoverViewController?.sourceRect = CGRect(
                    x: self.frame.width/2,
                    y: self.frame.height/2,
                    width: 0,
                    height: 0)
                popoverContent.previousText = self.annotation
                popoverContent.parent = self
                popoverContent.edittingEnabled = true
                self.parentViewController?.presentViewController(
                    popoverContent,
                    animated: true,
                    completion: nil)
                
            }
        }
    }
    
    func persistAnnotation(){
        self.mementoManager.setAssociationValue(self.graphName, roomLabel: self.roomLabel, placeHolderLabel: self.viewTag, value: self.annotation)
    }
    
}

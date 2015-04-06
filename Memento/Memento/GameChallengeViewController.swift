//
//  GameChallengeViewController.swift
//  Memento
//
//  Created by Chee Wai Hon on 31/3/15.
//  Copyright (c) 2015 NUS CS3217. All rights reserved.
//

import Foundation
import UIKit

class GameChallengeViewController: UIViewController, UINavigationControllerDelegate {
    
    // ImageView = whole screen
    
    @IBOutlet weak var imageView: UIImageView!
    
    var mementoManager = MementoManager.sharedInstance
    var saveLoadManager = SaveLoadManager.sharedInstance
    
    
    var roomLabel = Int()
    var palaceName = String()
    var gameMode = String()
    private var overlayList = [Overlay]()
    private var associationList = [Association]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageView.userInteractionEnabled = true
        self.view.userInteractionEnabled = true
        
        //setUpGestures()
        
        // Get view representation of room
        var roomRep = mementoManager.getMemoryPalaceRoomView(palaceName, roomLabel: roomLabel)!
        
        // Get image from graphical view
        imageView.image = getImageNamed(roomRep.backgroundImage)
        
        // Load
        overlayList = roomRep.overlays
        associationList = roomRep.associations
        loadLayouts()
        
    }
    
    // Function to load layouts
    private func loadLayouts() {
        // Load draggable image views/layers
        var draggableImageViewsToAdd = [DraggableImageView]()
        var counter = 0
        for eachOverlay in overlayList {
            var newFrame = eachOverlay.frame
            var newImageFile = eachOverlay.imageFile
            var newImage = saveLoadManager.loadOverlayImage(newImageFile)
            
            var newDraggableImageView = DraggableImageView(image: newImage!)
            newDraggableImageView.graphName = self.palaceName
            newDraggableImageView.roomLabel = self.roomLabel
            newDraggableImageView.labelIdentifier = counter
            counter += 1
            newDraggableImageView.frame = newFrame
            self.imageView.addSubview(newDraggableImageView)
        }
        
        // Load association list
        for eachAssociation in associationList {
            var newFrame = eachAssociation.placeHolder.view.frame
            var newLabel = eachAssociation.placeHolder.label
            
            var newAnnotatableView = AnnotatableUIView(frame: newFrame, parentController: self, tagNumber: newLabel, background: imageView, graphName: palaceName, roomLabel:roomLabel)
            newAnnotatableView.backgroundColor = .whiteColor()
            newAnnotatableView.alpha = 0.25
            newAnnotatableView.annotation = eachAssociation.value
            imageView.addSubview(newAnnotatableView)
        }
        
    }
    
    @IBAction func dismissView(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    private func getImageNamed(fileName : String) -> UIImage{
        let nsDocumentDirectory = NSSearchPathDirectory.DocumentDirectory
        let nsUserDomainMask = NSSearchPathDomainMask.UserDomainMask
        if let paths = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
        {
            if paths.count > 0
            {
                if let dirPath = paths[0] as? String
                {
                    let readPath = dirPath.stringByAppendingPathComponent(fileName)
                    let image    = UIImage(contentsOfFile: readPath)
                    // Do whatever you want with the image
                    return image!
                }
            }
        }
        return UIImage()
    }
    
}
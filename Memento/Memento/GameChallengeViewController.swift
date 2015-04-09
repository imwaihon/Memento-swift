//
//  GameChallengeViewController.swift
//  Memento
//
//  Created by Chee Wai Hon on 31/3/15.
//  Copyright (c) 2015 NUS CS3217. All rights reserved.
//

import Foundation
import UIKit

class GameChallengeViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var mementoManager = MementoManager.sharedInstance
    var saveLoadManager = SaveLoadManager.sharedInstance
    var gameEngine: GameEngine
    var roomLabel: Int
    var palaceName: String
    var gameMode: String
    
    required init(coder aDecoder: NSCoder) {
        self.gameEngine = GameEngine()
        self.roomLabel = Int()
        self.palaceName = String()
        self.gameMode = String()
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageView.userInteractionEnabled = true
        self.view.userInteractionEnabled = true
        
        gameEngine.setUpGame(palaceName, mode: gameMode)
        loadGameRoomLayout()
        setUpGestures()
        
        
        
    }
    private func setUpGestures() {
        
    }
    
    // Function to load current room layout
    private func loadGameRoomLayout() {
        imageView.image = getImageNamed(gameEngine.getCurrRoom().backgroundImage)
        
        
//        var draggableImageViewsToAdd = [DraggableImageView]()
//        var counter = 0
//        for eachOverlay in overlayList {
//            var newFrame = eachOverlay.frame
//            var newImageFile = eachOverlay.imageFile
//            var newImage = saveLoadManager.loadOverlayImage(newImageFile)
//            
//            var newDraggableImageView = DraggableImageView(image: newImage!)
//            newDraggableImageView.graphName = self.palaceName
//            newDraggableImageView.roomLabel = self.roomLabel
//            newDraggableImageView.labelIdentifier = counter
//            counter += 1
//            newDraggableImageView.frame = newFrame
//            self.imageView.addSubview(newDraggableImageView)
//        }
        
        var associationList = gameEngine.getCurrRoom().associations
        
        // Load association list
        for eachAssociation in associationList {
            var newFrame = eachAssociation.placeHolder.view.frame
            var newLabel = eachAssociation.placeHolder.label
            
            var newAnnotatableView = GameAnnotationView(frame: newFrame, gameViewController: self, tagNumber: newLabel, graphName: palaceName, roomLabel:roomLabel)
            newAnnotatableView.backgroundColor = .whiteColor()
            newAnnotatableView.alpha = 0.25
            newAnnotatableView.annotation = eachAssociation.value
            imageView.addSubview(newAnnotatableView)
        }
        
    }
    
    func selectAnnotation(associationLabel: Int, annotation: GameAnnotationView) {
        var valid = gameEngine.checkValidMove(associationLabel)
        
        if valid {
            annotation.disableView()
        } else {
            
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
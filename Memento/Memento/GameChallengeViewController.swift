//
//  GameChallengeViewController.swift
//  Memento
//
//  Created by Chee Wai Hon on 31/3/15.
//  Copyright (c) 2015 NUS CS3217. All rights reserved.
//

import Foundation
import UIKit

class GameChallengeViewController: UIViewController, GameEngineDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var timerLabel: UILabel!
    
    var mementoManager = MementoManager.sharedInstance
    var saveLoadManager = SaveLoadManager.sharedInstance
    var gameEngine: GameEngine
    var gameAnnotationViews: [GameAnnotationView]
    var gameLayerViews: [DraggableImageView]
    var roomLabel: Int
    var palaceName: String
    var gameMode: String
    var timer: NSTimer
    
    required init(coder aDecoder: NSCoder) {
        self.gameEngine = GameEngine()
        self.gameAnnotationViews = [GameAnnotationView]()
        self.gameLayerViews = [DraggableImageView]()
        self.roomLabel = Int()
        self.palaceName = String()
        self.gameMode = String()
        self.timer = NSTimer()
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageView.userInteractionEnabled = true
        self.view.userInteractionEnabled = true
        
        gameEngine.delegate = self
        gameEngine.setUpGame(palaceName, mode: gameMode)
        loadGameRoomLayout()
        setUpGestures()
        
    }
    private func setUpGestures() {
        
    }
    
    private func clearAllViews() {
        for view in gameAnnotationViews {
            view.removeFromSuperview()
        }
        
        for view in gameLayerViews {
            view.removeFromSuperview()
        }
        
        gameAnnotationViews.removeAll()
        gameLayerViews.removeAll()
    }
    
    // Function to load current room layout
    private func loadGameRoomLayout() {
        clearAllViews()
        imageView.image = getImageNamed(gameEngine.getCurrRoom().backgroundImage)
        
        var associationList = gameEngine.getCurrRoom().associations
        
        // Load association list
        for eachAssociation in associationList {
            var newFrame = eachAssociation.placeHolder.view.frame
            var newLabel = eachAssociation.placeHolder.label
            
            var newAnnotatableView = GameAnnotationView(frame: newFrame, gameViewController: self, tagNumber: newLabel, graphName: palaceName, roomLabel:roomLabel)
            newAnnotatableView.backgroundColor = .whiteColor()
            newAnnotatableView.alpha = 0.25
            newAnnotatableView.annotation = eachAssociation.value
            gameAnnotationViews.append(newAnnotatableView)
            imageView.addSubview(newAnnotatableView)
        }
        
        var layerList = gameEngine.getCurrRoom().overlays
        var counter = 0
        for eachOverlay in layerList {
            var newFrame = eachOverlay.frame
            var newImageFile = eachOverlay.imageFile
            var newImage = saveLoadManager.loadOverlayImage(newImageFile)
            
            var newDraggableImageView = DraggableImageView(image: newImage!)
            newDraggableImageView.userInteractionEnabled = false
            newDraggableImageView.graphName = self.palaceName
            newDraggableImageView.roomLabel = self.roomLabel
            newDraggableImageView.labelIdentifier = counter
            counter += 1
            newDraggableImageView.frame = newFrame
            gameLayerViews.append(newDraggableImageView)
            imageView.addSubview(newDraggableImageView)
        }
        
    }
    
    func selectAnnotation(associationLabel: Int, annotation: GameAnnotationView) {
        var valid = gameEngine.checkValidMove(associationLabel)
        
        if valid {
            annotation.disableView()
            annotation.showCorrectAnimation()
        } else {
            
        }
    }
    
    func startGame() {
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("updateTimer"), userInfo: nil, repeats: true)
    }
    
    func displayEndGame() {
        timer.invalidate()
        let endPrompt = UIAlertController(title: "FINISHED", message: "\(gameEngine.timeElapsed)", preferredStyle: UIAlertControllerStyle.Alert)
        endPrompt.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            
            self.dismissViewControllerAnimated(true, completion: nil)
            
        }))
        
        self.presentViewController(endPrompt, animated: true, completion: nil)
    }
    
    func reloadView() {
        loadGameRoomLayout()
    }
    
    func updateTimer() {
        gameEngine.timeElapsed += 1
        timerLabel.text = String(gameEngine.timeElapsed)
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
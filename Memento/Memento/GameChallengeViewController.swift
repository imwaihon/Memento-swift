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
        // Clear the current view
        clearAllViews()
        
        // Transition to the next image
        let toImage = Utilities.getImageNamed(gameEngine.getCurrRoom().backgroundImage)
        UIView.transitionWithView(self.imageView,
            duration: 1.0,
            options: UIViewAnimationOptions.TransitionFlipFromRight,
            animations: { self.imageView.image = toImage },
            completion: nil)
        
        // Load image layers
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
        
        // Load association list
        var associationList = gameEngine.getCurrRoom().associations
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
        
        // Check if there are any associations in this room
        gameEngine.checkIfNext()
    }
    
    // A particular annotation is selected
    // Asks game engine to check whether this is a valid move
    func selectAnnotation(associationLabel: Int, annotation: GameAnnotationView) -> Bool {
        var valid = gameEngine.checkValidMove(associationLabel)
        
        if valid {
            annotation.disableView()
            annotation.showCorrectAnimation()
            gameEngine.checkIfNext()
            return true
        } else {
            return false
        }
    }
    
    // Game Starts
    // Starts the timer
    func startGame() {
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("updateTimer"), userInfo: nil, repeats: true)
    }
    
    // Game Ends
    func displayEndGame() {
        timer.invalidate()
        let endPrompt = UIAlertController(title: "FINISHED", message: "\(gameEngine.timeElapsed)", preferredStyle: UIAlertControllerStyle.Alert)
        endPrompt.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            
            self.dismissViewControllerAnimated(true, completion: nil)
            
        }))
        
        self.presentViewController(endPrompt, animated: true, completion: nil)
    }
    
    // Game Pauses
    func pauseGame() {
        timer.invalidate()
    }
    
    // Game Resumes
    func resumeGame() {
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("updateTimer"), userInfo: nil, repeats: true)
    }
    
    // Reload the view
    func reloadView() {
        loadGameRoomLayout()
    }
    
    // Updates time by 1 every second on both view and engine
    func updateTimer() {
        gameEngine.timeElapsed += 1
        timerLabel.text = String(gameEngine.timeElapsed)
    }
    
    
    @IBAction func menuView(sender: UIButton) {
        pauseGame()
    }
    
    
    
}
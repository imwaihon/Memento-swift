//
//  GameChallengeViewController.swift
//  Memento
//
//  Created by Chee Wai Hon on 31/3/15.
//  Copyright (c) 2015 NUS CS3217. All rights reserved.
//

import Foundation
import UIKit

class GameChallengeViewController: UIViewController, GameEngineDelegate, GamePauseDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var annotationText: UILabel!
    
    var mementoManager = MementoManager.sharedInstance
    var saveLoadManager = SaveLoadManager.sharedInstance
    var gameEngine: GameEngine
    var gameAnnotationViews: [GameAnnotationView]
    var gameLayerViews: [DraggableImageView]
    var gameTickViews: [UIImageView]
    var roomLabel: Int
    var palaceName: String
    var gameMode: String
    var showAnnotation: Bool
    var timer: NSTimer
    var firstLoad: Bool
    
    required init(coder aDecoder: NSCoder) {
        self.gameEngine = GameEngine()
        self.gameAnnotationViews = [GameAnnotationView]()
        self.gameLayerViews = [DraggableImageView]()
        self.gameTickViews = [UIImageView]()
        self.roomLabel = Int()
        self.palaceName = String()
        self.gameMode = String()
        self.timer = NSTimer()
        self.showAnnotation = true
        self.firstLoad = true
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageView.userInteractionEnabled = true
        self.view.userInteractionEnabled = true
        
        gameEngine.delegate = self
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(false)
        if !gameEngine.startedGame && firstLoad {
            self.performSegueWithIdentifier("ShowBeforeStartSegue", sender: self)
            firstLoad = false
        } else if gameEngine.startedGame && !firstLoad {
            checkFinished()
        }
    }
    
    private func clearAllViews() {
        for view in gameAnnotationViews {
            view.removeFromSuperview()
        }
        
        for view in gameLayerViews {
            view.removeFromSuperview()
        }
        
        for view in gameTickViews {
            view.removeFromSuperview()
        }
        
        gameAnnotationViews.removeAll()
        gameLayerViews.removeAll()
        gameTickViews.removeAll()
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
        for eachOverlay in layerList {
            var newFrame = eachOverlay.frame
            var newImageFile = eachOverlay.imageFile
            var newImage = saveLoadManager.loadOverlayImage(newImageFile)
            
            var newDraggableImageView = DraggableImageView(image: newImage!)
            newDraggableImageView.userInteractionEnabled = false
            newDraggableImageView.graphName = self.palaceName
            newDraggableImageView.roomLabel = self.roomLabel
            newDraggableImageView.labelIdentifier = eachOverlay.label
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
            
            if showAnnotation {
                newAnnotatableView.backgroundColor = .whiteColor()
            } else {
                newAnnotatableView.backgroundColor = .clearColor()
            }
            
            newAnnotatableView.alpha = 0.25
            
            newAnnotatableView.annotation = eachAssociation.value
            gameAnnotationViews.append(newAnnotatableView)
            imageView.addSubview(newAnnotatableView)
        }
        
        // Check if there are any associations in this room
        gameEngine.checkIfNext()
        
        checkFinished()
    }
    
    // A particular annotation is selected
    // Asks game engine to check whether this is a valid move
    func selectAnnotation(associationLabel: Int, annotation: GameAnnotationView) -> Bool {
        var valid = gameEngine.checkValidMove(associationLabel)
        
        if valid {
            annotation.disableView()
            self.annotationText.text = annotation.annotation
            let tickImageView = UIImageView(image: UIImage(named: "greenTick"))
            tickImageView.frame =  CGRect(origin: CGPoint(x: annotation.center.x, y: annotation.center.y), size: CGSize(width: 1, height: 1))
            self.imageView.addSubview(tickImageView)
            self.gameTickViews.append(tickImageView)
            
            UIView.animateWithDuration(0.6,
                delay: 0.0,
                options: UIViewAnimationOptions.CurveEaseInOut ,
                animations: {
                    tickImageView.transform = CGAffineTransformMakeScale(50, 50)
                    
                },
                completion: { finished in
                    self.gameEngine.checkIfNext()
            })
            
            
            return true
        } else {
            return false
        }
    }
    
    // Game Starts
    // Starts the timer and game engine
    func startGame() {
        gameEngine.setUpGame(palaceName, mode: gameMode)
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("updateTimer"), userInfo: nil, repeats: true)
        loadGameRoomLayout()
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
    
    func checkFinished() {
        gameEngine.checkIfFinished()
    }
    
    @IBAction func menuView(sender: UIButton) {
        pauseGame()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "ShowBeforeStartSegue") {
            let gameStartViewController = segue.destinationViewController as GameBeforeStartViewController
            gameStartViewController.delegate = self
        } else if (segue.identifier == "PauseMenuSegue") {
            let pauseMenuViewController = segue.destinationViewController as GameModePauseMenuViewController
            pauseMenuViewController.delegate = self
        }
    }
    
}
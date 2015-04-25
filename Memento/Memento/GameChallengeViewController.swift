//
//  GameChallengeViewController.swift
//  Memento
//
//  Created by Chee Wai Hon on 31/3/15.
//  Copyright (c) 2015 NUS CS3217. All rights reserved.
//

// Main view controller for the game challenge
// Sets up GameEngine which preloads the required information to generate the views
// Reloads the view with the next set of views to be inserted when transitioning to the next room
// Displays animation when selecting annotation
// Show views when game ends or pause game

import Foundation
import UIKit

class GameChallengeViewController: UIViewController, GameEngineDelegate, GamePauseDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var annotationText: UILabel!
    
    var mementoManager = MementoManager.sharedInstance
    var gameEngine: GameEngine
    var gameAnnotationViews: [GameAnnotationView]
    var gameLayerViews: [DraggableImageView]
    var gameAnimationViews: [UIImageView]
    var roomLabel: Int
    var palaceName: String
    var gameMode: String
    var showAnnotation: Bool
    var showLayer: Bool
    var timer: NSTimer
    var firstLoad: Bool
    
    required init(coder aDecoder: NSCoder) {
        self.gameEngine = GameEngine()
        self.gameAnnotationViews = [GameAnnotationView]()
        self.gameLayerViews = [DraggableImageView]()
        self.gameAnimationViews = [UIImageView]()
        self.roomLabel = Int()
        self.palaceName = String()
        self.gameMode = String()
        self.timer = NSTimer()
        self.showAnnotation = true
        self.showLayer = true
        self.firstLoad = true
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageView.userInteractionEnabled = true
        self.view.userInteractionEnabled = true
        
        gameEngine.delegate = self
        
    }
    
    // If first time loading, start the game
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(false)
        if firstLoad {
            startGame()
            firstLoad = false
        }
    }
    
    // A particular annotation is selected
    // Queries game engine to check whether this is a valid move
    func selectAnnotation(associationLabel: Int, annotation: GameAnnotationView) -> Bool {
        var valid = gameEngine.checkValidMove(associationLabel)
        
        if valid {
            // Annotation view now disabled
            annotation.disableView()
            
            // If game mode is order, set current annotation text
            if gameMode == Constants.orderModeId {
                annotationText.text = annotation.annotation
            }
            
            // Displays green tick animation
            let tickImageView = UIImageView(image: UIImage(named: "greenTick"))
            tickImageView.frame =  CGRect(origin: CGPoint(x: annotation.center.x, y: annotation.center.y), size: CGSize(width: 1, height: 1))
            imageView.addSubview(tickImageView)
            gameAnimationViews.append(tickImageView)
            
            UIView.animateWithDuration(0.3,
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
            // Displays red cross animation
            let crossImageView = UIImageView(image: UIImage(named: "redCross"))
            crossImageView.frame =  CGRect(origin: CGPoint(x: annotation.center.x, y: annotation.center.y), size: CGSize(width: 1, height: 1))
            imageView.addSubview(crossImageView)
            
            UIView.animateWithDuration(0.3,
                delay: 0.0,
                options: UIViewAnimationOptions.CurveEaseInOut ,
                animations: {
                    crossImageView.transform = CGAffineTransformMakeScale(50, 50)
                    
                },
                completion: { finished in
                    UIView.animateWithDuration(0.1,
                        delay: 1.0,
                        options: UIViewAnimationOptions.CurveEaseInOut ,
                        animations: {
                            crossImageView.alpha = 0.0
                        },
                        completion: { finished in
                            crossImageView.removeFromSuperview()
                    })
            })
            
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
    
    // Game Ends - Display End Screen
    // Invalidates timer, go to end screen, clear all views
    // GameEngineDelegate
    func displayEndGame() {
        timer.invalidate()
        
        // Clear all views to avoid leak
        clearAllViews()
        self.performSegueWithIdentifier("EndGameSegue", sender: self)
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
    // GameEngineDelegate
    func reloadView() {
        loadGameRoomLayout()
    }
    
    // Updates time by 1 every second on both view and engine
    // Called every 1 second by a NSTimer timer
    func updateTimer() {
        gameEngine.timeElapsed += 1
        timerLabel.text = String(gameEngine.timeElapsed)
    }
    
    // Check if game is in finsihed state
    func checkFinished() {
        gameEngine.checkIfFinished()
    }
    
    // Update the next question annotation if it is in order mode
    // GameEngineDelegate
    func updateNextFindQuestion(updateText: String) {
        annotationText.text = updateText
    }
    
    @IBAction func menuView(sender: UIButton) {
        pauseGame()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "PauseMenuSegue") {
            let pauseMenuViewController = segue.destinationViewController as GameModePauseMenuViewController
            pauseMenuViewController.delegate = self
        } else if (segue.identifier == "EndGameSegue") {
            let endViewController = segue.destinationViewController as EndGameChallengeViewController
            endViewController.timeValue = gameEngine.timeElapsed
            endViewController.mistakeValue = gameEngine.mistakeCount
        }
    }
    
    // Cleans up all views that are no longer needed
    private func clearAllViews() {
        for view in gameAnnotationViews {
            view.removeFromSuperview()
        }
        
        for view in gameLayerViews {
            view.removeFromSuperview()
        }
        
        for view in gameAnimationViews {
            view.removeFromSuperview()
        }
        
        gameAnnotationViews.removeAll()
        gameLayerViews.removeAll()
        gameAnimationViews.removeAll()
    }
    
    // Private function to load current room layout
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
        
        // Load image layers if show layer is true
        if showLayer {
            var layerList = gameEngine.getCurrRoom().overlays
            for eachOverlay in layerList {
                var newFrame = eachOverlay.frame
                var newImageFile = eachOverlay.imageFile
                var newImage = Utilities.getImageNamed(newImageFile)
                
                var newDraggableImageView = DraggableImageView(image: newImage!)
                newDraggableImageView.userInteractionEnabled = false
                newDraggableImageView.graphName = self.palaceName
                newDraggableImageView.roomLabel = self.roomLabel
                newDraggableImageView.labelIdentifier = eachOverlay.label
                newDraggableImageView.frame = newFrame
                
                gameLayerViews.append(newDraggableImageView)
                imageView.addSubview(newDraggableImageView)
            }
        }
        
        // Load association list
        var associationList = gameEngine.getCurrRoom().associations
        for eachAssociation in associationList {
            var newFrame = eachAssociation.placeHolder.view.frame
            var newLabel = eachAssociation.placeHolder.label
            
            var newAnnotatableView = GameAnnotationView(frame: newFrame, gameViewController: self, tagNumber: newLabel, graphName: palaceName, roomLabel:roomLabel)
            
            // If show annotation is true, create visible annotation
            if showAnnotation {
                newAnnotatableView.backgroundColor = Utilities.hexStringToUIColor(eachAssociation.placeHolder.color)
            } else {
                newAnnotatableView.backgroundColor = .clearColor()
            }
            
            newAnnotatableView.alpha = 0.25
            
            newAnnotatableView.annotation = eachAssociation.value
            gameAnnotationViews.append(newAnnotatableView)
            imageView.addSubview(newAnnotatableView)
        }
        
        // Check if there are any associations in this room, if not just go to next
        gameEngine.checkIfNext()
        
    }
    
}
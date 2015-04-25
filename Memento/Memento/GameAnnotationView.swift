//
//  GameAnnotation.swift
//  Memento
//
//  Created by Chee Wai Hon on 6/4/15.
//  Copyright (c) 2015 NUS CS3217. All rights reserved.
//

// View that handles the annotations for the game mode
// If selected, notifies GameViewController

import Foundation
import UIKit

class GameAnnotationView: UIView {
    
    var mementoManager = MementoManager.sharedInstance
    weak var gameViewController: GameChallengeViewController?
    var viewTag: Int
    var roomLabel: Int
    var graphName: String
    var annotation: String

    init(frame: CGRect, gameViewController: GameChallengeViewController, tagNumber: Int, graphName: String, roomLabel: Int) {
        self.gameViewController = gameViewController
        self.viewTag = tagNumber
        self.graphName = graphName
        self.roomLabel = roomLabel
        self.annotation = String()
        super.init(frame: frame)
        
        self.userInteractionEnabled = true
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: "handleTap:"))
        
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func handleTap(nizer: UITapGestureRecognizer!) {
        var valid = self.gameViewController?.selectAnnotation(self.viewTag, annotation: self)
        
    }
    
    func disableView() {
        self.userInteractionEnabled = false
    }
}

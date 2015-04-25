//
//  GameEngine.swift
//  Memento
//
//  Created by Chee Wai Hon on 6/4/15.
//  Copyright (c) 2015 NUS CS3217. All rights reserved.
//

// Preloads the views that the current game requires and feeds the GameChallengeViewController as needed

import Foundation

class GameEngine {
    var mementoManager = MementoManager.sharedInstance
    var activePalaceName: String
    var mode: String
    var currRoomIndex: Int
    var currRoomAssociations: [Association]
    var palaceRooms: [MemoryPalaceRoomView]
    weak var delegate: GameEngineDelegate?
    var timeElapsed: Int
    var mistakeCount: Int
    var startedGame: Bool
    
    init() {
        self.activePalaceName = String()
        self.mode = String()
        self.palaceRooms = [MemoryPalaceRoomView]()
        self.currRoomIndex = 0
        self.currRoomAssociations = [Association]()
        self.timeElapsed = 0
        self.mistakeCount = 0
        self.startedGame = false

    }
    
    // Set up the initial game
    // Takes in the placeName and mode string to load the correct game and palace
    func setUpGame(palaceName: String, mode: String) {
        self.startedGame = true
        
        self.activePalaceName = palaceName
        self.mode = mode
        
        var rooms = mementoManager.getPalaceOverview(activePalaceName)!
    
        for room in rooms {
            palaceRooms.append(mementoManager.getMemoryPalaceRoomView(activePalaceName, roomLabel: room.label)!)
        }
        
        // Different modes
        if mode == Constants.orderModeId {
            currRoomAssociations.extend(palaceRooms.first!.associations)
        } else if mode == Constants.findModeId {
            currRoomAssociations.extend(Utilities.shuffleArray(palaceRooms.first!.associations))
            ifFindModeDoNext()
        }

    }
    
    // Set up the next room if it exists, else finish the game
    func setUpNext() {
        currRoomIndex += 1
        
        if currRoomIndex < palaceRooms.count {
            currRoomAssociations.extend(palaceRooms[currRoomIndex].associations)
            delegate?.reloadView()
            ifFindModeDoNext()
            
        } else {
            finishedGame()
        }
        
    }
    
    // Get the current active room
    func getCurrRoom() -> MemoryPalaceRoomView {
        return palaceRooms[currRoomIndex]
    }
    
    
    /* Check Functions */
    
    // Check whether this move is valid, takes in the current association label that is tapped
    func checkValidMove(associationLabel: Int) -> Bool {
        // Order Mode
        if mode == Constants.orderModeId {
            var validAssociationLabel = currRoomAssociations.first?.placeHolder.label
            
            if validAssociationLabel == associationLabel {
                currRoomAssociations.removeAtIndex(0)
                return true
            } else {
                mistakeCount += 1
                return false
            }
        
        // Find Mode
        } else if mode == Constants.findModeId {
            var validAssociationValue = currRoomAssociations.first?.value
            
            for i in 0..<currRoomAssociations.count {
                if currRoomAssociations[i].placeHolder.label == associationLabel {
                    if currRoomAssociations[i].value == validAssociationValue {
                        currRoomAssociations.removeAtIndex(i)
                        return true
                    } else {
                        mistakeCount += 1
                        return false
                    }
                }
            }
        }
        
        return false
    }
    
    func checkIfNext() {
        if currRoomAssociations.isEmpty {
            setUpNext()
        } else {
            ifFindModeDoNext()
        }
    }
    
    func checkIfFinished() {
        if currRoomIndex >= palaceRooms.count {
            finishedGame()
        }
    }
    
    func finishedGame() {
        delegate?.displayEndGame()
    }
    
    private func ifFindModeDoNext() {
        if mode == Constants.findModeId {
            var validAssociationValue = currRoomAssociations.first?.value
            if validAssociationValue != nil {
                delegate?.updateNextFindQuestion(validAssociationValue!)
            }
        }
    }
    
    
}
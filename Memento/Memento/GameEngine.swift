//
//  GameEngine.swift
//  Memento
//
//  Created by Chee Wai Hon on 6/4/15.
//  Copyright (c) 2015 NUS CS3217. All rights reserved.
//

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
    var startedGame: Bool
    
    init() {
        self.activePalaceName = String()
        self.mode = String()
        self.palaceRooms = [MemoryPalaceRoomView]()
        self.currRoomIndex = 0
        self.currRoomAssociations = [Association]()
        self.timeElapsed = 0
        self.startedGame = false

    }
    
    // Set up the initial game
    func setUpGame(palaceName: String, mode: String) {
        self.startedGame = true
        
        self.activePalaceName = palaceName
        self.mode = mode
        
        var rooms = mementoManager.getPalaceOverview(activePalaceName)!
    
        for room in rooms {
            palaceRooms.append(mementoManager.getMemoryPalaceRoomView(activePalaceName, roomLabel: room.label)!)
        }
        
        if mode == "Order" {
            currRoomAssociations.extend(palaceRooms.first!.associations)
        } else if mode == "Find" {
            currRoomAssociations.extend(Utilities.shuffleArray(palaceRooms.first!.associations))
        }

    }
    
    // Set up the next room
    func setUpNext() {
        currRoomIndex += 1
        
        if currRoomIndex < palaceRooms.count {
            currRoomAssociations.extend(palaceRooms[currRoomIndex].associations)
            delegate?.reloadView()
        } else {
            finishedGame()
        }
        
    }
    
    // Get the current active room
    func getCurrRoom() -> MemoryPalaceRoomView {
        return palaceRooms[currRoomIndex]
    }
    
    // Check whether this move is valid
    func checkValidMove(associationLabel: Int) -> Bool {
        // Order Mode
        if mode == "Order" {
            var validAssociationLabel = currRoomAssociations.first?.placeHolder.label
            
            if validAssociationLabel == associationLabel {
                currRoomAssociations.removeAtIndex(0)
                return true
            } else {
                return false
            }
        
        // Find Mode
        } else if mode == "Find" {
            var validAssociationValue = currRoomAssociations.first?.value
            
            for i in 0..<currRoomAssociations.count {
                if currRoomAssociations[i].placeHolder.label == associationLabel {
                    if currRoomAssociations[i].value == validAssociationValue {
                        currRoomAssociations.removeAtIndex(i)
                        return true
                    } else {
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
    
    
}
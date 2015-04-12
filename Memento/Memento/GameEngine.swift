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
    var delegate: GameEngineDelegate?
    var timeElapsed: Int
    
    init() {
        self.activePalaceName = String()
        self.mode = String()
        self.palaceRooms = [MemoryPalaceRoomView]()
        self.currRoomIndex = 0
        self.currRoomAssociations = [Association]()
        self.timeElapsed = 0

    }
    
    // Set up the initial game
    func setUpGame(palaceName: String, mode: String) {
        self.activePalaceName = palaceName
        self.mode = mode
        
        var rooms = mementoManager.getPalaceOverview(activePalaceName)!
    
        for room in rooms {
            palaceRooms.append(mementoManager.getMemoryPalaceRoomView(activePalaceName, roomLabel: room.label)!)
        }
        
        currRoomAssociations.extend(palaceRooms.first!.associations)
        
        delegate?.startGame()

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
        if mode == "order" {
            var validAssociationLabel = currRoomAssociations.first?.placeHolder.label
            
            if validAssociationLabel == associationLabel {
                currRoomAssociations.removeAtIndex(0)
                return true
            } else {
                return false
            }
        }
        
        return false
    }
    
    func checkIfNext() {
        if currRoomAssociations.isEmpty {
            setUpNext()
        }
    }
    
    func finishedGame() {
        delegate?.displayEndGame()
    }
    
    
}
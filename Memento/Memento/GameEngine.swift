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
    
    var palaceRooms: [MemoryPalaceRoomView]
    
    init(palaceName: String, mode: String) {
        self.activePalaceName = palaceName
        self.mode = mode
        self.palaceRooms = [MemoryPalaceRoomView]()
    }
    
    private func processPalace(palaceName: String) {
        var room = mementoManager.getMemoryPalaceRoomView(palaceName, roomLabel: 0)
        
        while room != nil {
            //palaceRooms.append(mementoManager.getMemoryPalaceRoomView())
        }
    }
    
}
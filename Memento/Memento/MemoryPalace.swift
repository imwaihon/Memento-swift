//
//  MemoryPalace.swift
//  Memento
//
//  Defines the functionalities of each memory palace at the abstract level.
//
//  Created by Qua Zi Xian on 27/3/15.
//  Copyright (c) 2015 NUS CS3217. All rights reserved.
//

import Foundation

protocol MemoryPalace {
    var icon: MemoryPalaceIcon { get }
    
    func addRoom(room: MemoryPalaceRoom)
    func getRoom(roomNumber: Int) -> MemoryPalaceRoom?
    func removeRoom(roomNumber: Int)
}
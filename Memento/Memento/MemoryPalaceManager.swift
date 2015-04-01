//
//  MemoryPalaceManager.swift
//  Memento
//
//  Defines the framework object for the component that manages the app's content.
//
//  Created by Qua Zi Xian on 27/3/15.
//  Copyright (c) 2015 NUS CS3217. All rights reserved.
//

import Foundation

protocol MemoryPalaceManager {
    
    var numberOfMemoryPalace: Int { get }
    
    func addMemoryPalace(named name: String, imageFile: String) -> String
    func getMemoryPalace(palaceName: String) -> MemoryPalace?
    func removeMemoryPalace(palaceName: String)
    func addMemoryPalaceRoom(palaceName: String, roomImage: String)
    func getMemoryPalaceRoom(palaceName: String, roomLabel: Int) -> MemoryPalaceRoom?
    func removeMemoryPalaceRoom(palaceName: String, roomLabel: Int)
}
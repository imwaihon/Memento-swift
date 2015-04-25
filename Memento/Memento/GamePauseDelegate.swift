//
//  GamePauseDelegate.swift
//  Memento
//
//  Created by Chee Wai Hon on 16/4/15.
//  Copyright (c) 2015 NUS CS3217. All rights reserved.
//

// Protocol for pause menu

import Foundation

protocol GamePauseDelegate: class {
    func resumeGame()
    func startGame()
}
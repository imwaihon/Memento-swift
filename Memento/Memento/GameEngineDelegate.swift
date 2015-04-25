//
//  GameEngineDelegate.swift
//  Memento
//
//  Created by Chee Wai Hon on 9/4/15.
//  Copyright (c) 2015 NUS CS3217. All rights reserved.
//

// Delegate for game engine to notify GameViewController

import Foundation

protocol GameEngineDelegate: class {
    func reloadView()
    func displayEndGame()
    func updateNextFindQuestion(updateText: String)
}
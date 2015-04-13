//
//  GameEngineDelegate.swift
//  Memento
//
//  Created by Chee Wai Hon on 9/4/15.
//  Copyright (c) 2015 NUS CS3217. All rights reserved.
//

import Foundation

protocol GameEngineDelegate: class {
    func reloadView()
    func startGame()
    func displayEndGame()
}
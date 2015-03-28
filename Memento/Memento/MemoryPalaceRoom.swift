//
//  MemoryPalaceRoom.swift
//  Memento
//
//  Defines the framework object representing a room in the memory palace.
//  To be subclassed by the user of the framework.
//
//  Created by Qua Zi Xian on 27/3/15.
//  Copyright (c) 2015 NUS CS3217. All rights reserved.
//

import Foundation

protocol MemoryPalaceRoom: class {
    var label: Int { get set }
    var icon: MemoryPalaceRoomIcon { get }
    var numPlaceHolders: Int { get }
    var associations: [Association] { get }
    
    func addPlaceHolder(placeHolder: PlaceHolder)
    func setAssociationValue(placeHolderNumber: Int, value: String?)
}
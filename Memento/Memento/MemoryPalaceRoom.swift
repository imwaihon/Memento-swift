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
import UIKit

protocol MemoryPalaceRoom: class {
    var graphName: String { get set }
    var label: Int { get set }
    var icon: MemoryPalaceRoomIcon { get }
    var numPlaceHolders: Int { get }
    var associations: [Association] { get }
    
    func addPlaceHolder(placeHolder: PlaceHolder) -> Bool
    func getAssociation(placeHolerLabel: Int) -> Association?
    func getPlaceHolder(placeHolderLabel: Int) -> PlaceHolder?
    func setPlaceHolderFrame(label: Int, newFrame: CGRect)
    func setAssociationValue(placeHolderNumber: Int, value: String)
    func removePlaceHolder(label: Int)
}
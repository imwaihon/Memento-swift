//
//  MementoNodeIcon.swift
//  Memento
//
//  The immutable icon representation of a room in the memory palace.
//
//  Fields:
//  graphName: String       The name of the memory palace this room is in
//  label: Int              The label assigned to this room
//  filename: String        The name of the background image file for this room
//  overlays: [Overlay]     The list of overlay objects in this room
//
//  Created by Qua Zi Xian on 23/3/15.
//  Copyright (c) 2015 NUS CS3217. All rights reserved.
//

import Foundation

struct MemoryPalaceRoomIcon: Equatable {
    let graphName: String
    let label: Int              //Used to retrieve/remove node from graph
    let filename: String        //Name of the image file to use, without any path component
    let overlays: [Overlay]
    
    init(graphName: String, label: Int, filename: String, overlays: [Overlay]) {
        self.graphName = graphName
        self.label = label
        self.filename = filename
        self.overlays = overlays
    }
}

func ==(lhs: MemoryPalaceRoomIcon, rhs: MemoryPalaceRoomIcon) -> Bool {
    return lhs.graphName == rhs.graphName && lhs.label == rhs.label && lhs.filename == rhs.filename
}
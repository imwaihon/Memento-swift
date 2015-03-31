//
//  MementoNodeIcon.swift
//  Memento
//
//  The icon representation of a node on the graph.
//
//  Created by Qua Zi Xian on 23/3/15.
//  Copyright (c) 2015 NUS CS3217. All rights reserved.
//

import Foundation

struct MemoryPalaceRoomIcon: Equatable {
    let label: Int              //Used to retrieve/remove node from graph
    let filename: String        //Used by view controller to load icon's image file
    let overlays: [Overlay]
    
    init(label: Int, filename: String, overlays: [Overlay]) {
        self.label = label
        self.filename = filename
        self.overlays = overlays
    }
}

func ==(lhs: MemoryPalaceRoomIcon, rhs: MemoryPalaceRoomIcon) -> Bool {
    return lhs.label == rhs.label && lhs.filename == rhs.filename
}
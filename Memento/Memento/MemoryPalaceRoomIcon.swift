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
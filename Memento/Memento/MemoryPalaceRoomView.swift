//
//  MemoryPalaceRoomView.swift
//  Memento
//
//  Defines the object representation of the memory palace room with required
//  data to render the room in view/edit mode.
//
//  Created by Qua Zi Xian on 1/4/15.
//  Copyright (c) 2015 NUS CS3217. All rights reserved.
//

import Foundation

struct MemoryPalaceRoomView {
    let graphName: String
    let label: Int
    let backgroundImage: String
    let overlays: [Overlay]
    let associations: [Association]
    
    init(graphName: String, label: Int, backgroundImage: String, overlays: [Overlay], associations: [Association]) {
        self.graphName = graphName
        self.label = label
        self.backgroundImage = backgroundImage
        self.overlays = overlays
        self.associations = associations
    }
}
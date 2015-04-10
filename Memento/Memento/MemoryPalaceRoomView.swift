//
//  MemoryPalaceRoomView.swift
//  Memento
//
//  Defines the object representation of the memory palace room with required
//  data to render the room in view/edit mode.
//
//  IMPORTANT!
//  To load the image file, use the exact path = imgResourceDir.stringByAppendingPathComponent(backgroundImage)
//
//  Created by Qua Zi Xian on 1/4/15.
//  Copyright (c) 2015 NUS CS3217. All rights reserved.
//

import Foundation

struct MemoryPalaceRoomView {
    let graphName: String
    let label: Int
    let backgroundImage: String //Name of the background image file, without any path component
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
//
//  MemoryPalaceRoomView.swift
//  Memento
//
//  Defines the immutable representation of the memory palace room with required
//  data to render the room in view/edit mode.
//
//  Fields:
//  graphName: String               The name of the memory palace this room is in
//  label: Int                      The label assigned to this room
//  backgroundImage: String         The name of the background image file for this room
//  overlays: [Overlay]             The list of overlay objects in this room
//  associations: [Association]     The list of associations in this room
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
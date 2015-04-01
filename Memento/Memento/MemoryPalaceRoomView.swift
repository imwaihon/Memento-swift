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
    let backgroundImage: String
    let overlays: [Overlay]
    let associations: [Association]
    
    init(backgroundImage: String, overlays: [Overlay], associations: [Association]) {
        self.backgroundImage = backgroundImage
        self.overlays = overlays
        self.associations = associations
    }
}
//
//  MementoGraphIcon.swift
//  Memento
//
//  The immutable icon representation of the memory palace in palace selection scene.
//
//  Fields:
//  graphName: String   The name of the memory palace
//  imageFile: String   The image file name of the 1st room's background image
//
//  Specifications
//  The view controller should be able to specify/identify the target memory
//  palace when calling app manager methods.
//
//  Created by Qua Zi Xian on 27/3/15.
//  Copyright (c) 2015 NUS CS3217. All rights reserved.
//

import Foundation

struct MemoryPalaceIcon: Equatable {
    let graphName: String       //The identifier for the graph
    let imageFile: String       //The file name of the image, without any path components
    
    init(graphName: String, imageFile: String){
        self.graphName = graphName
        self.imageFile = imageFile
    }
    
}

func ==(lhs: MemoryPalaceIcon, rhs: MemoryPalaceIcon) -> Bool {
    return lhs.graphName == rhs.graphName && lhs.imageFile == rhs.imageFile
}
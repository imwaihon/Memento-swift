//
//  MementoGraphIcon.swift
//  Memento
//
//  The icon representation of the graph in graph selection scene.
//
//  Specifications
//  The view controller should be able to specify/identify the target memory
//  palace when calling app manager methods.
//
//  Created by Qua Zi Xian on 27/3/15.
//  Copyright (c) 2015 NUS CS3217. All rights reserved.
//

import Foundation

struct MementoGraphIcon {
    let graphName: String       //The identifier for the graph
    let imageFile: String       //Used by view controller to load icon's image file
    
    init(graphName: String, imageFile: String){
        self.graphName = graphName
        self.imageFile = imageFile
    }
}
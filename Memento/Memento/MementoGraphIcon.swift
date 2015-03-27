//
//  MementoGraphIcon.swift
//  Memento
//
//  The icon representation of the graph in graph selection scene.
//
//  Created by Qua Zi Xian on 27/3/15.
//  Copyright (c) 2015 NUS CS3217. All rights reserved.
//

import Foundation

struct MementoGraphIcon {
    let graphNumber: Int        //Used as parameter when retrieving/removing graph from model
    let imageFile: String       //Used by view controller to load icon's image file
    
    init(number: Int, imageFile: String){
        graphNumber = number
        self.imageFile = imageFile
    }
}
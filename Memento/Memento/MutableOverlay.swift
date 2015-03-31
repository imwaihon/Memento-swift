//
//  MutableOverlay.swift
//  Memento
//
//  Defiens the overlay object managed by the MementoNode.
//
//  Created by Qua Zi Xian on 31/3/15.
//  Copyright (c) 2015 NUS CS3217. All rights reserved.
//

import Foundation
import UIKit

struct MutableOverlay {
    var frame: CGRect
    var imageFile: String
    
    init(frame: CGRect, imageFile: String) {
        self.frame = frame
        self.imageFile = imageFile
    }
    
    //Returns the immutable representation of this object.
    func makeImmuatble() -> Overlay {
        return Overlay(frame: frame, imageFile: imageFile)
    }
}
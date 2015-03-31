//
//  Overlay.swift
//  Memento
//
//  Defines the overlay object for display purpose.
//
//  Created by Qua Zi Xian on 31/3/15.
//  Copyright (c) 2015 NUS CS3217. All rights reserved.
//

import Foundation
import UIKit

struct Overlay {
    let frame: CGRect
    let imageFile: String
    
    init(frame: CGRect, imageFile: String) {
        self.frame = frame
        self.imageFile = imageFile
    }
    
    //Creates a mutable version of this overlay object.
    func makeMutable() -> MutableOverlay {
        return MutableOverlay(frame: frame, imageFile: imageFile)
    }
}
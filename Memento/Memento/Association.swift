//
//  Association.swift
//  Memento
//
//  Represents an association in the memory palace.
//
//  Specifications:
//  The associated value can be either short text or image.
//
//  Created by Qua Zi Xian on 23/3/15.
//  Copyright (c) 2015 NUS CS3217. All rights reserved.
//

import Foundation
import UIKit

struct Association {
    let frame: CGRect
    let value: AnyObject
    
    init(frame: CGRect, value: AnyObject){
        self.frame = frame
        self.value = value
    }
    
    //Checks if the area covered by this association conflicts with the given association.
    func hasConflictWith(assoc: Association) -> Bool {
        return CGRectIntersectsRect(frame, assoc.frame)
    }
}
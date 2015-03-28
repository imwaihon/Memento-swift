//
//  PlaceHolder.swift
//  Memento
//
//  Defines the superclass for association placeholder.
//  This is used in framework object interactions and is to be subclassed by the user of theframework.
//
//  Created by Qua Zi Xian on 27/3/15.
//  Copyright (c) 2015 NUS CS3217. All rights reserved.
//

import Foundation
import UIKit

class PlaceHolder: Equatable {
    let view: UIView
    var label: Int = 0
    
    init(frame: CGRect){
        view = UIView(frame: frame)
    }
    
    class func hasOverlap(placeHolder1: PlaceHolder, placeHolder2: PlaceHolder) -> Bool {
        return CGRectIntersectsRect(placeHolder1.view.frame, placeHolder2.view.frame)
    }
}

func ==(lhs: PlaceHolder, rhs: PlaceHolder) -> Bool {
    return lhs.view.frame == rhs.view.frame
}
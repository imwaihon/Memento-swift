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
    
    //Properties
    var stringEncoding: String {
        return NSStringFromCGRect(view.frame)
    }
    
    init(frame: CGRect){
        view = UIView(frame: frame)
    }
    
    //Decodes the string representation into a PlaceHodler object.
    //rep should be the type of string returned by stringEncoding property.
    class func decodeFromString(rep: String) -> PlaceHolder {
        return PlaceHolder(frame: CGRectFromString(rep))
    }
    
    class func hasOverlap(placeHolder1: PlaceHolder, placeHolder2: PlaceHolder) -> Bool {
        return CGRectIntersectsRect(placeHolder1.view.frame, placeHolder2.view.frame)
    }
}

func ==(lhs: PlaceHolder, rhs: PlaceHolder) -> Bool {
    return lhs.view.frame == rhs.view.frame
}
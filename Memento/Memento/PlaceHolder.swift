//
//  PlaceHolder.swift
//  Memento
//
//  Defines the superclass for association placeholder.
//  This is used in framework object interactions and is to be subclassed by the user of the framework.
//
//  Created by Qua Zi Xian on 27/3/15.
//  Copyright (c) 2015 NUS CS3217. All rights reserved.
//

import Foundation
import UIKit

class PlaceHolder: Equatable {
    let view: UIView
    let defaultColor = "FFFFFF"
    var label: Int = 0
    var color: String
    
    //Properties
    // Encoding scheme is <CGRect string>:<color>
    var stringEncoding: String {
        return NSStringFromCGRect(view.frame).stringByAppendingString(Constants.placeholderValueSeparator).stringByAppendingString(color)
    }
    
    init(frame: CGRect){
        view = UIView(frame: frame)
        color = defaultColor
    }
    
    init(frame: CGRect, color: String) {
        view = UIView(frame: frame)
        self.color = color
    }
    
    /// Decodes the string representation into a PlaceHodler object.
    /// rep should be the type of string returned by stringEncoding property.
    ///
    /// :param: rep The string encoding representing the placeholder to be decoded.
    /// :returns: The placeholder object represented by the given string encoding.
    class func decodeFromString(rep: String) -> PlaceHolder {
        let arr = rep.componentsSeparatedByString(Constants.placeholderValueSeparator)
        return arr.count > 1 ? PlaceHolder(frame: CGRectFromString(arr[0]), color: arr[1]): PlaceHolder(frame: CGRectFromString(arr[0]))
    }
    
    /// Checks if 2 placeholders overlap.
    ///
    /// :param: placeHolder1 The 1st placeholder.
    /// :param: placeHolder2 The 2nd placeholder.
    /// :returns: true if the 2 placeholders overlap. Returns false otherwise.
    class func hasOverlap(placeHolder1: PlaceHolder, placeHolder2: PlaceHolder) -> Bool {
        return CGRectIntersectsRect(placeHolder1.view.frame, placeHolder2.view.frame)
    }
}

func ==(lhs: PlaceHolder, rhs: PlaceHolder) -> Bool {
    return lhs.view.frame == rhs.view.frame
}
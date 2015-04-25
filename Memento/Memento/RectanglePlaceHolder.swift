//
//  RectanglePlaceHoler.swift
//  Memento
//
//  Defines the rectangular placeholder.
//
//  Created by Qua Zi Xian on 27/3/15.
//  Copyright (c) 2015 NUS CS3217. All rights reserved.
//

import Foundation
import UIKit

class RectanglePlaceHolder: PlaceHolder {
    let highlightArea: CGRect
    
    // Property
    // Encoding scheme is <CGRect string>:<color>
    override var stringEncoding: String{
        return NSStringFromCGRect(highlightArea).stringByAppendingString(Constants.placeholderValueSeparator).stringByAppendingString(color)
    }
    
    init(highlightArea: CGRect){
        self.highlightArea = highlightArea
        super.init(frame: highlightArea)
    }
    
    init(highlightArea: CGRect, color: String) {
        self.highlightArea = highlightArea
        super.init(frame: highlightArea, color: color)
    }
    
    /// Decodes the plist representation into a RectanglePlaceHolder.
    /// rep should be the type of string that is returned by stringEncoding property.
    ///
    /// :param: rep The string representation of the placeholder object to be decoded.
    /// :returns: The placeholder object represented by the given string encoding.
    override class func decodeFromString(rep: String) -> PlaceHolder {
        let arr = rep.componentsSeparatedByString(Constants.placeholderValueSeparator)
        return arr.count > 1 ? RectanglePlaceHolder(highlightArea: CGRectFromString(arr[0]), color: arr[1]): RectanglePlaceHolder(highlightArea: CGRectFromString(arr[0]))
    }
}
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
    
    override var stringEncoding: String{
        return NSStringFromCGRect(highlightArea)
    }
    
    init(highlightArea: CGRect){
        self.highlightArea = highlightArea
        super.init(frame: highlightArea)
        
        //Do something to the view to make it visible on screen
    }
    
    //Decodes the plist representation into a RectanglePlaceHolder.
    //rep should be the type of string that is returned by stringEncoding property.
    override class func decodeFromString(rep: String) -> PlaceHolder {
        return RectanglePlaceHolder(highlightArea: CGRectFromString(rep))
    }
}
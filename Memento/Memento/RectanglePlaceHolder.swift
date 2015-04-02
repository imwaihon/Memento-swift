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
    private let highlightArea: CGRect
    
    override var stringEncoding: String{
        return NSStringFromCGRect(highlightArea)
    }
    
    init(highlightArea: CGRect){
        self.highlightArea = highlightArea
        super.init(frame: highlightArea)
        
        //Do something to the view to make it visible on screen
    }
}
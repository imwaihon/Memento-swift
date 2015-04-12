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

struct MutableOverlay: Equatable {
    var label: Int
    var frame: CGRect
    var imageFile: String
    
    //Currently, the encoding format is <CGRect string>:<image name>
    //Design issue: Users can create 2 overlays of same size at the exact same locaiton with the same image.
    //This makes hashing using CGRect string or image file name not feasible.
    var stringEncoding: String {
        var str = NSStringFromCGRect(frame)
        str = str.stringByAppendingString(overlayValueSeparator)
        str = str.stringByAppendingString(imageFile)
        return str
    }
    
    init(frame: CGRect, imageFile: String) {
        self.label = 0
        self.frame = frame
        self.imageFile = imageFile
    }
    
    //Decode the given string representation into a MutableOverlay object.
    //rep must be a string returned by stringEncoding property of a MutableOverlay instance.
    static func decodeFromString(rep: String) -> MutableOverlay {
        let strArray = rep.componentsSeparatedByString(overlayValueSeparator)
        return MutableOverlay(frame: CGRectFromString(strArray[0]), imageFile: strArray[1])
    }
    
    //Returns the immutable representation of this object.
    func makeImmuatble() -> Overlay {
        return Overlay(label: label, frame: frame, imageFile: imageFile)
    }
}

func ==(lhs: MutableOverlay, rhs: MutableOverlay) -> Bool {
    return lhs.frame == rhs.frame && lhs.imageFile == rhs.imageFile
}
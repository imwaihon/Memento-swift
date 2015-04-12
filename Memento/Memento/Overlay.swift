//
//  Overlay.swift
//  Memento
//
//  Defines the overlay object for display purpose.
//
//  IMPORTANT!
//  To load the image file, use the exact path = imgResourceDir.stringByAppendingPathComponent(imageFile)
//
//  Created by Qua Zi Xian on 31/3/15.
//  Copyright (c) 2015 NUS CS3217. All rights reserved.
//

import Foundation
import UIKit

struct Overlay: Equatable {
    let label: Int
    let frame: CGRect
    let imageFile: String   //Name of the overlay image file, without any path component
    
    //Properties
    //Currently, the encoding format is <CGRect string>:<image name>
    //Design issue: Users can create 2 overlays of same size at the exact same locaiton with the same image.
    //This makes hashing using CGRect string or image file name not feasible.
    var stringEncoding: String {
        var str = NSStringFromCGRect(frame)
        str = str.stringByAppendingString(overlayValueSeparator)
        str = str.stringByAppendingString(imageFile)
        return str
    }
    
    init(label: Int, frame: CGRect, imageFile: String) {
        self.label = label
        self.frame = frame
        self.imageFile = imageFile
    }
    
    //Creates a mutable version of this overlay object.
    func makeMutable() -> MutableOverlay {
        return MutableOverlay(frame: frame, imageFile: imageFile)
    }
}

func ==(lhs: Overlay, rhs: Overlay) -> Bool {
    return lhs.label == rhs.label && lhs.frame == rhs.frame && lhs.imageFile == rhs.imageFile
}
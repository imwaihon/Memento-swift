//
//  Constants.swift
//  Memento
//
//  The file containing ALL constants used by the app.
//
//  Created by Qua Zi Xian on 27/3/15.
//  Copyright (c) 2015 NUS CS3217. All rights reserved.
//

import Foundation
import UIKit

struct Constants {
    //Graph Icon Display Constants(modify as needed by UI developer)
    //static let graphIconSize = CGSizeMake(100, 50)    //Tentative value

    //Graph Node Icon Display Constants(modify as needed by UI developer)
    //static let graphNodeIconSize = CGSizeMake(100, 50)
    
    //UIImage-related constants
    static let fullScreenImageFrame = CGRectMake(0, 0, 1024, 768)

    //Overlay encoding
    static let overlayValueSeparator = ";"

    //Graph plist representation keys
    static let nameKey = "name"
    static let nodesKey = "nodes"

    //Node plist representation keys
    static let bgImageKey = "backgroundImage"
    static let overlayKey = "overlays"
    static let placeHolderKey = "placeHolders"
    static let valueKey = "values"

    //Resources-related constants
    static let imgResourceDir = "sharedResource"
}
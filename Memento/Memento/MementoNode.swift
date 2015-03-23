//
//  MementoNode.swift
//  Memento
//
//  Represents a node in the memory palace.
//
//  Specifications:
//  Contains necessary information for display.
//  Changes that will affect the displayed information should update the appropriate view components.
//  Contains associations and links created by user.
//  Identify association/link selected by user.
//
//  Non-functional specifications
//  Easily identified by the graph containing it.
//
//  Created by Qua Zi Xian on 19/3/15.
//  Copyright (c) 2015 NUS CS3217. All rights reserved.
//

import Foundation
import UIKit

class MementoNode {
    var label: Int
    let imageFile: String
    let view: UIImageView
    //associations: [Association]
    //links: [Link]
    
    //Properties
    var icon: MementoNodeIcon {
        return MementoNodeIcon(label: label, filename: imageFile)
    }
    
    init(imageFile: String){
        label = 0
        self.imageFile = imageFile
        view = UIImageView(image: UIImage(named: imageFile))
    }
}
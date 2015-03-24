//
//  TextAssociation.swift
//  Memento
//
//  Represents the text association.
//
//  Created by Qua Zi Xian on 23/3/15.
//  Copyright (c) 2015 NUS CS3217. All rights reserved.
//

import Foundation
import UIKit

class TextAssociation: Association {
    let value: String
    
    init(frame: CGRect, value: String){
        self.value = value
        super.init(frame: frame)
        
        //Do other things to make view visible.
    }
}
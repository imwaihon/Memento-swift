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
    let view: UIView
    
    init(frame: CGRect, value: String){
        self.value = value
        
        //Initializing the UIView programmatically
        view = UIView(frame: frame)
        //Do other thigns to customize the view/make it visible.
        
        super.init(frame: frame)
    }
}
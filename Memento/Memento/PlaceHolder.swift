//
//  PlaceHolder.swift
//  Memento
//
//  Defines the superclass for association placeholder.
//  This is used in framework object interactions and is to be subclassed by the user of theframework.
//
//  Created by Qua Zi Xian on 27/3/15.
//  Copyright (c) 2015 NUS CS3217. All rights reserved.
//

import Foundation
import UIKit

class PlaceHolder {
    let view: UIView
    
    init(frame: CGRect){
        view = UIView(frame: frame)
    }
}
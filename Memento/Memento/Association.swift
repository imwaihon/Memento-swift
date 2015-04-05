//
//  Association.swift
//  Memento
//
//  Created by Qua Zi Xian on 28/3/15.
//  Copyright (c) 2015 NUS CS3217. All rights reserved.
//

import Foundation

struct Association: Equatable {
    let placeHolder: PlaceHolder
    let value: String
    
    init(placeHolder: PlaceHolder, value: String) {
        self.placeHolder = placeHolder
        self.value = value
    }
}

func ==(lhs: Association, rhs: Association) -> Bool {
    return lhs.placeHolder == rhs.placeHolder && lhs.value == rhs.value
}
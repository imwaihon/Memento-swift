//
//  Association.swift
//  Memento
//
//  Defines an immutable association object representation in memory palace room.
//
//  Fields:
//  placeHolder: PlaceHolder    The object marking out the association in the memory palace room
//  value: String               The association value
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
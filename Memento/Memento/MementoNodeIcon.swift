//
//  MementoNodeIcon.swift
//  Memento
//
//  The icon representation of a node on the graph.
//
//  Created by Qua Zi Xian on 23/3/15.
//  Copyright (c) 2015 NUS CS3217. All rights reserved.
//

import Foundation

struct MementoNodeIcon {
    let label: Int
    let filename: String
    
    init(label: Int, filename: String) {
        self.label = label
        self.filename = filename
    }
}
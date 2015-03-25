//
//  MementoGraph.swift
//  Memento
//
//  Represents a linear graph of images
//
//  Specifications:
//  Insert nodes.
//  Remove nodes.
//
//  Non-functional requirements:
//
//  Representation Invariant(s)
//  Graph should have at least 1 node.
//
//  Created by Qua Zi Xian on 19/3/15.
//  Copyright (c) 2015 NUS CS3217. All rights reserved.
//

import Foundation

class MementoGraph {
    private var nodes: [MementoNode]
    
    init(rootNode: MementoNode){
        nodes = [MementoNode]()
        nodes.append(rootNode)
        
        assert(checkRep())
    }
    
    //Checks that representation invariant is not violated
    private func checkRep() -> Bool {
        return nodes.count > 0
    }
}

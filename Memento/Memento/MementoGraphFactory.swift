//
//  MementoGraphFactory.swift
//  Memento
//
//  The factory object for the memory palace.
//
//  Specifications:
//  Generate a memory palace object using the minimal information required to construct one that does not
//  violate representation invariant.
//  Construct a memory palace instance from a saved template.
//
//  Created by Qua Zi Xian on 25/3/15.
//  Copyright (c) 2015 NUS CS3217. All rights reserved.
//

import Foundation

class MementoGraphFactory {
    private let nodeFactory: MementoNodeFactory
    
    init(){
        nodeFactory = MementoNodeFactory()
    }
    
    func makeGraph(named name: String, imageFile: String) -> MementoGraph {
        let rootNode = nodeFactory.makeNode(imageFile)
        return MementoGraph(name: name, rootNode: rootNode)
    }
    
    func decodeAndMakeGraph(data: NSDictionary) -> MementoGraph {
        var name = data[Constants.nameKey] as String
        var nodes = data[Constants.nodesKey] as NSArray
        var createdNodes = [MementoNode]()
        
        for node in nodes {
            createdNodes.append(nodeFactory.makeNode(node as NSDictionary))
        }
        
        var createdGraph = MementoGraph(name: name, rootNode: createdNodes[0])
    
        for index in 1..<createdNodes.count {
            createdGraph.addRoom(createdNodes[index])
        }
        
        return createdGraph
    }
}
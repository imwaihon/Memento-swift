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
    
    /// Creates a new memory palace with the given name and background image for the 1st room.
    ///
    /// :param: named The name of the memory palace.
    /// :param: imageFile The filename of 1st room's background image.
    /// :returns: A MementoGraph instance with the given name and 1st room with the given background image.
    func makeGraph(named name: String, imageFile: String) -> MementoGraph {
        let rootNode = nodeFactory.makeNode(imageFile)
        return MementoGraph(name: name, rootNode: rootNode)
    }
    
    /// Creates a memory palace from the given plist representation.
    ///
    /// :param: data The plist representation of the memory palace to make.
    /// :returns: A MementoGraph instance represented by the given plist representation.
    func decodeAndMakeGraph(data: NSDictionary) -> MementoGraph {
        let name = data[Constants.nameKey] as String
        let nodes = data[Constants.nodesKey] as NSArray
        var createdNodes = [MementoNode]()
        
        for node in nodes {
            createdNodes.append(nodeFactory.makeNode(node as NSDictionary))
        }
        
        let createdGraph = MementoGraph(name: name, rootNode: createdNodes[0])
        for index in 1..<createdNodes.count {
            createdGraph.addRoom(createdNodes[index])
        }
        
        return createdGraph
    }
}
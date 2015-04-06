//
//  MementoGraph.swift
//  Memento
//
//  Represents a linear graph of images
//
//  Specifications:
//  Insert nodes.
//  Remove nodes.
//  Convert into memory palace template.
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

class MementoGraph: MemoryPalace {
    private let _nodes: Map<Int, MementoNode>
    
    var name: String        //The name of the graph. Also the filename used for saving/loading.
    
    //Properties
    var icon: MemoryPalaceIcon {
        return MemoryPalaceIcon(graphName: name, imageFile: _nodes.valueForSmallestKey!.icon.filename)
    }
    var nodeIcons: [MemoryPalaceRoomIcon] {
        var arr = [MemoryPalaceRoomIcon]()
        let nodeArr = _nodes.inOrderTraversal()
        arr.reserveCapacity(nodeArr.count)
        for elem in nodeArr {
            arr.append(elem.1.icon)
        }
        return arr
    }
    var numRooms: Int {
        return _nodes.size
    }
    var plistRepresentation: NSDictionary {
        var rep = NSMutableDictionary()
        rep[nameKey] = name
        
        //Gets the nodes represetnations into an array
        let nodeArr = _nodes.inOrderTraversal()
        var nodePlist = [NSDictionary]()
        nodePlist.reserveCapacity(nodeArr.count)
        for node in nodeArr {
            nodePlist.append(node.1.plistRepresentation)
        }
        rep[nodesKey] = NSArray(array: nodePlist)
        return rep
    }
    
    init(name: String, rootNode: MementoNode) {
        self.name = name
        rootNode.graphName = name
        rootNode.label = 0
        _nodes = Map<Int, MementoNode>()
        _nodes[rootNode.label] = rootNode
        
        assert(checkRep())
    }
    
    //Adds a room to the memory palace.
    func addRoom(room: MemoryPalaceRoom) {
        (room as MementoNode).label = _nodes.isEmpty ? 0: _nodes.largestKey! + 1
        room.graphName = name
        _nodes[room.label] = (room as MementoNode)
    }
    
    //Gets the room identified by the given number.
    func getRoom(roomNumber: Int) -> MemoryPalaceRoom? {
        return _nodes[roomNumber]
    }
    
    //Removes the room identified by the specified number.
    //Does nothing if room identified by the given number does not exist.
    func removeRoom(roomNumber: Int) {
        if _nodes.size > 1 {
            _nodes.eraseValueForKey(roomNumber)
        }
        assert(checkRep())
    }
    
    //Checks that representation invariant is not violated
    private func checkRep() -> Bool {
        return _nodes.size > 0
    }
}

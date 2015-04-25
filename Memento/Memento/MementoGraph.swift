//
//  MementoGraph.swift
//  Memento
//
//  Represents a linear graph of rooms.
//
//  Abstraction functions:
//  Add room:       addRoom(room: MementoNode)
//  Get room:       getRoom(roomNumber: Int) -> MementoNode?
//  Remove room:    removeRoom(roomNumber: Int)
//
//  Representation Invariant(s)
//  Graph should have at least 1 node.
//
//  Created by Qua Zi Xian on 19/3/15.
//  Copyright (c) 2015 NUS CS3217. All rights reserved.
//

import Foundation

class MementoGraph {
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
        rep[Constants.nameKey] = name
        
        //Gets the nodes represetnations into an array
        let nodeArr = _nodes.inOrderTraversal()
        var nodePlist = [NSDictionary]()
        nodePlist.reserveCapacity(nodeArr.count)
        for node in nodeArr {
            nodePlist.append(node.1.plistRepresentation)
        }
        rep[Constants.nodesKey] = NSArray(array: nodePlist)
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
    
    /// Adds a room to the memory palace.
    ///
    /// :params: room The memory palace room to add.
    func addRoom(room: MementoNode) {
        room.label = _nodes.isEmpty ? 0: _nodes.largestKey! + 1
        room.graphName = name
        _nodes[room.label] = (room as MementoNode)
    }
    
    /// Gets the room identified by the given number.
    ///
    /// :param: roomNumber The label of the room to retrieve.
    /// :returns: The memory palace room with the given label. Returns nil if no such room is found.
    func getRoom(roomNumber: Int) -> MementoNode? {
        return _nodes[roomNumber]
    }
    
    /// Removes the room identified by the specified number. Does nothing if room identified by the given number does not exist.
    ///
    /// :param: roomNumber The label of the memory palace room to remove.
    func removeRoom(roomNumber: Int) {
        if _nodes.size > 1 {
            _nodes.eraseValueForKey(roomNumber)
        }
        assert(checkRep())
    }
    
    /// Gets the view representation of the room that comes after the specified room.
    ///
    /// :param: roomNumber The label of the memory palace room whose successor is to be retrieved.
    /// :returns: The memory palace room that immediately follows the room with the given label. Returns nil if no such room is found.
    func getNextRoomViewForRoom(roomNumber: Int) -> MemoryPalaceRoomView? {
        if let nextKey = _nodes.upperBoundOfKey(roomNumber) {
            return _nodes[nextKey]?.viewRepresentation
        }
        return nil
    }
    
    //Checks that representation invariant is not violated
    private func checkRep() -> Bool {
        return _nodes.size > 0
    }
}

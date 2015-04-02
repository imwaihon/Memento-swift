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
    private var _nodes: [MementoNode]
    
    var name: String        //The name of the graph. Also the filename used for saving/loading.
    
    //Properties
    var icon: MemoryPalaceIcon {
        return MemoryPalaceIcon(graphName: name, imageFile: _nodes[0].icon.filename)
    }
    var nodeIcons: [MemoryPalaceRoomIcon] {
        var arr = [MemoryPalaceRoomIcon]()
        for node in _nodes {
            arr.append(node.icon)
        }
        return arr
    }
    var numRooms: Int {
        return _nodes.count
    }
    var plistRepresentation: NSDictionary {
        var rep = NSMutableDictionary()
        rep[nameKey] = name
        
        //Gets the nodes represetnations into an array
        var nodes = NSMutableArray()
        for node in _nodes {
            nodes.addObject(node.plistRepresentation)
        }
        rep[nodesKey] = nodes
        return rep
    }
    
    init(name: String, rootNode: MementoNode) {
        self.name = name
        _nodes = [MementoNode]()
        _nodes.append(rootNode)
        
        assert(checkRep())
    }
    
    //Adds a room to the memory palace.
    func addRoom(room: MemoryPalaceRoom) {
        (room as MementoNode).label = _nodes.count
        _nodes.append(room as MementoNode)
    }
    
    //Gets the room identified by the given number.
    func getRoom(roomNumber: Int) -> MemoryPalaceRoom? {
        return isValidRoomNumber(roomNumber) ? _nodes[roomNumber]: nil
    }
    
    //Removes the room identified by the specified number.
    //Does nothing if room identified by the given number does not exist.
    func removeRoom(roomNumber: Int) {
        if _nodes.count == 1 || !isValidRoomNumber(roomNumber) {
            return
        }
        for i in (roomNumber+1)..<_nodes.count {
            _nodes[i].label--
        }
        _nodes.removeAtIndex(roomNumber)
        assert(checkRep())
    }
    
    private func isValidRoomNumber(roomNumber: Int) -> Bool {
        return roomNumber >= 0 && roomNumber < _nodes.count
    }
    
    //Checks that representation invariant is not violated
    private func checkRep() -> Bool {
        return _nodes.count > 0
    }
}

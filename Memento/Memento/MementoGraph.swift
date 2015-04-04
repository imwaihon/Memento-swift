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
    private var _nodesFT: FenwickTree
    
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
        _nodesFT = FenwickTree()
        _nodes.append(rootNode)
        
        assert(checkRep())
    }
    
    //Adds a room to the memory palace.
    func addRoom(room: MemoryPalaceRoom) {
        (room as MementoNode).label = _nodes.isEmpty ? 0: _nodes[_nodes.count - 1].label + 1
        room.graphName = name
        _nodes.append(room as MementoNode)
    }
    
    //Gets the room identified by the given number.
    func getRoom(roomNumber: Int) -> MemoryPalaceRoom? {
        if roomNumber < 0 {
            return nil
        }
        let offset = _nodesFT.query(roomNumber + 1)
        let idx = roomNumber - offset
        if idx >= 0 && idx < _nodes.count && _nodes[idx].label == roomNumber {
            return _nodes[idx]
        }
        return nil
    }
    
    //Removes the room identified by the specified number.
    //Does nothing if room identified by the given number does not exist.
    func removeRoom(roomNumber: Int) {
        if _nodes.count == 1 || roomNumber < 0 {
            return
        }
        let offset = _nodesFT.query(roomNumber + 1)
        let idx = roomNumber - offset
        if idx >= 0 && idx < _nodes.count && _nodes[idx].label == roomNumber {
            _nodesFT.update(roomNumber + 1, change: 1)
            if idx == _nodes.count - 1 {
                let prevLabel = _nodes[idx - 1].label
                _nodesFT.clearFromIndex(prevLabel + 1)
            }
            _nodes.removeAtIndex(idx)
        }
        assert(checkRep())
    }
    
    //Checks that representation invariant is not violated
    private func checkRep() -> Bool {
        return _nodes.count > 0
    }
}

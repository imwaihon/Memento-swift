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
    private var nodes: [MementoNode]
    
    var name: String        //The name of the graph. Also the filename used for saving/loading.
    
    //Properties
    var icon: MemoryPalaceIcon {
        return MemoryPalaceIcon(graphName: name, imageFile: nodes[0].icon.filename)
    }
    var nodeIcons: [MemoryPalaceRoomIcon] {
        var arr = [MemoryPalaceRoomIcon]()
        for node in nodes {
            arr.append(node.icon)
        }
        return arr
    }
    
    init(name: String, rootNode: MementoNode){
        self.name = name
        nodes = [MementoNode]()
        nodes.append(rootNode)
        
        assert(checkRep())
    }
    
    //Adds a room to the memory palace.
    func addRoom(room: MemoryPalaceRoom) {
        (room as MementoNode).label = nodes.count
        nodes.append(room as MementoNode)
    }
    
    //Gets the room identified by the given number.
    func getRoom(roomNumber: Int) -> MemoryPalaceRoom? {
        return isValidRoomNumber(roomNumber) ? nodes[roomNumber]: nil
    }
    
    private func isValidRoomNumber(roomNumber: Int) -> Bool {
        return roomNumber >= 0 && roomNumber < nodes.count
    }
    
    //Checks that representation invariant is not violated
    private func checkRep() -> Bool {
        return nodes.count > 0
    }
}

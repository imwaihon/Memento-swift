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
    var icon: MementoGraphIcon {
        return MementoGraphIcon(number: label, imageFile: nodes[0].icon.filename)
    }
    
    init(name: String, rootNode: MementoNode){
        self.name = name
        nodes = [MementoNode]()
        nodes.append(rootNode)
        super.init()
        
        assert(checkRep())
    }
    
    func getRoom(roomNumber: Int) -> MementoNode? {
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

//
//  MementoGraphTests.swift
//  Memento
//
//  Created by Qua Zi Xian on 23/3/15.
//  Copyright (c) 2015 NUS CS3217. All rights reserved.
//

import Foundation
import UIKit
import XCTest

class MementoGraphTests: XCTestCase {
    
    func testinit() {
        let graph = MementoGraph(name: "sampleGraph", rootNode: MementoNode(imageFile: "A.png"))
        XCTAssertEqual(graph.name, "sampleGraph")
        XCTAssertEqual(graph.numRooms, 1)
    }
    
    func testIcon() {
        let graph = MementoGraph(name: "sampleGraph", rootNode: MementoNode(imageFile: "A.png"))
        XCTAssertEqual(graph.icon, MemoryPalaceIcon(graphName: "sampleGraph", imageFile: "A.png"))
    }
    
    func testGetRoom() {
        let graph = MementoGraph(name: "sampleGraph", rootNode: MementoNode(imageFile: "A.png"))
        XCTAssertEqual(graph.getRoom(0)!.icon, MemoryPalaceRoomIcon(label: 0, filename: "A.png"))
        XCTAssertTrue(graph.getRoom(-1) == nil)
        XCTAssertTrue(graph.getRoom(2) == nil)
    }
    
    func testAddRoom() {
        let graph = MementoGraph(name: "sampleGraph", rootNode: MementoNode(imageFile: "A.png"))
        graph.addRoom(MementoNode(imageFile: "B.png"))
        XCTAssertEqual(graph.numRooms, 2)
        XCTAssertFalse(graph.getRoom(1) == nil)
        XCTAssertEqual(graph.getRoom(1)!.icon, MemoryPalaceRoomIcon(label: 1, filename: "B.png"))
    }
    
    func testRemoveRoom() {
        let graph = MementoGraph(name: "sampleGraph", rootNode: MementoNode(imageFile: "A.png"))
        graph.addRoom(MementoNode(imageFile: "B.png"))
        
        graph.removeRoom(0)
        XCTAssertEqual(graph.numRooms, 1)
        XCTAssertTrue(graph.getRoom(1) == nil)
        XCTAssertEqual(graph.getRoom(0)!.icon, MemoryPalaceRoomIcon(label: 0, filename: "B.png"))
        
        //Removes non-existent room
        graph.removeRoom(1)
        XCTAssertEqual(graph.numRooms, 1)
        XCTAssertEqual(graph.icon, MemoryPalaceIcon(graphName: "sampleGraph", imageFile: "B.png"))
        XCTAssertEqual(graph.getRoom(0)!.icon, MemoryPalaceRoomIcon(label: 0, filename: "B.png"))
        
        //Attempts to empty the graph
        graph.removeRoom(0)
        XCTAssertEqual(graph.numRooms, 1)
        XCTAssertEqual(graph.getRoom(0)!.icon, MemoryPalaceRoomIcon(label: 0, filename: "B.png"))
    }
}
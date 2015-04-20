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
        XCTAssertEqual(graph.getRoom(0)!.icon, MemoryPalaceRoomIcon(graphName: "sampleGraph", label: 0, filename: "A.png", overlays: []))
        
        //Invalid room numbers as palace has only 1 room
        XCTAssertTrue(graph.getRoom(-1) == nil)
        XCTAssertTrue(graph.getRoom(1) == nil)
    }
    
    func testAddRoom() {
        let graph = MementoGraph(name: "sampleGraph", rootNode: MementoNode(imageFile: "A.png"))
        graph.addRoom(MementoNode(imageFile: "B.png"))
        XCTAssertEqual(graph.numRooms, 2)
        XCTAssertFalse(graph.getRoom(1) == nil)
        XCTAssertEqual(graph.getRoom(1)!.icon, MemoryPalaceRoomIcon(graphName: "sampleGraph", label: 1, filename: "B.png", overlays: []))
    }
    
    func testRemoveRoom() {
        let graph = MementoGraph(name: "sampleGraph", rootNode: MementoNode(imageFile: "A.png"))
        graph.addRoom(MementoNode(imageFile: "B.png"))
        
        graph.removeRoom(0)
        XCTAssertEqual(graph.numRooms, 1)
        XCTAssertTrue(graph.getRoom(0) == nil)
        XCTAssertEqual(graph.getRoom(1)!.icon, MemoryPalaceRoomIcon(graphName: "sampleGraph", label: 1, filename: "B.png", overlays: []))
        
        //Removes non-existent room
        graph.removeRoom(0)
        XCTAssertEqual(graph.numRooms, 1)
        XCTAssertEqual(graph.icon, MemoryPalaceIcon(graphName: "sampleGraph", imageFile: "B.png"))
        XCTAssertEqual(graph.getRoom(1)!.icon, MemoryPalaceRoomIcon(graphName: "sampleGraph", label: 1, filename: "B.png", overlays: []))
        
        //Attempts to empty the graph
        graph.removeRoom(1)
        XCTAssertEqual(graph.numRooms, 1)
        XCTAssertEqual(graph.getRoom(1)!.icon, MemoryPalaceRoomIcon(graphName: "sampleGraph", label: 1, filename: "B.png", overlays: []))
    }
    
    func testPlistRepresentation() {
        let graph = MementoGraph(name: "graph1", rootNode: MementoNode(imageFile: "A.png"))
        let newNode = MementoNode(imageFile: "B.png")
        
        var rep = graph.plistRepresentation
        XCTAssertEqual(rep.objectForKey(Constants.nameKey) as String, graph.name)
        XCTAssertEqual((rep.objectForKey(Constants.nodesKey) as NSArray).count, 1);
        XCTAssertEqual((rep.objectForKey(Constants.nodesKey) as NSArray).objectAtIndex(0) as NSDictionary, (graph.getRoom(0)! as MementoNode).plistRepresentation)
        
        graph.addRoom(newNode)
        rep = graph.plistRepresentation
        XCTAssertEqual(rep.objectForKey(Constants.nameKey) as String, graph.name)
        XCTAssertEqual((rep.objectForKey(Constants.nodesKey) as NSArray).count, 2);
        XCTAssertEqual((rep.objectForKey(Constants.nodesKey) as NSArray).objectAtIndex(0) as NSDictionary, (graph.getRoom(0)! as MementoNode).plistRepresentation)
        XCTAssertEqual((rep.objectForKey(Constants.nodesKey) as NSArray).objectAtIndex(1) as NSDictionary, (graph.getRoom(1)! as MementoNode).plistRepresentation)
        
        graph.removeRoom(0)
        rep = graph.plistRepresentation
        XCTAssertEqual(rep.objectForKey(Constants.nameKey) as String, graph.name)
        XCTAssertEqual((rep.objectForKey(Constants.nodesKey) as NSArray).count, 1);
        XCTAssertEqual((rep.objectForKey(Constants.nodesKey) as NSArray).objectAtIndex(0) as NSDictionary, newNode.plistRepresentation)
    }
    
    func testGetNextRoomViewForRoom() {
        let graph = MementoGraph(name: "graph1", rootNode: MementoNode(imageFile: "A.png"))
        let newNode = MementoNode(imageFile: "B.png")
        graph.addRoom(newNode)
        
        XCTAssertEqual(graph.getNextRoomViewForRoom(0)!.label, 1)
        
        //The specified room is the last room, so there should not be any room
        XCTAssertTrue(graph.getNextRoomViewForRoom(1) == nil)
        
        //Tests invalid room numbers for the memory palace
        XCTAssertEqual(graph.getNextRoomViewForRoom(-1)!.label, 0)
        XCTAssertTrue(graph.getNextRoomViewForRoom(2) == nil)
        
        graph.removeRoom(0)
        
        //Gets the next logical room for a non-existent room
        XCTAssertEqual(graph.getNextRoomViewForRoom(0)!.label, 1)
        XCTAssertEqual(graph.getNextRoomViewForRoom(-1)!.label, 1)
    }
}
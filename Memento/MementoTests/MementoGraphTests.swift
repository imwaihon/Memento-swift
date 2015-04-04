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
        XCTAssertTrue(graph.getRoom(-1) == nil)
        XCTAssertTrue(graph.getRoom(2) == nil)
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
        XCTAssertEqual(graph.getRoom(1)!.icon, MemoryPalaceRoomIcon(graphName: "", label: 1, filename: "B.png", overlays: []))
        
        //Attempts to empty the graph
        graph.removeRoom(1)
        XCTAssertEqual(graph.numRooms, 1)
        XCTAssertEqual(graph.getRoom(1)!.icon, MemoryPalaceRoomIcon(graphName: "sampleGraph", label: 1, filename: "B.png", overlays: []))
    }
    
    func testPlistRepresentation() {
        let graph = MementoGraph(name: "graph1", rootNode: MementoNode(imageFile: "A.png"))
        let newNode = MementoNode(imageFile: "B.png")
        
        var rep = graph.plistRepresentation
        XCTAssertEqual(rep.objectForKey(nameKey) as String, graph.name)
        XCTAssertEqual((rep.objectForKey(nodesKey) as NSArray).count, 1);
        XCTAssertEqual((rep.objectForKey(nodesKey) as NSArray).objectAtIndex(0) as NSDictionary, (graph.getRoom(0)! as MementoNode).plistRepresentation)
        
        graph.addRoom(newNode)
        rep = graph.plistRepresentation
        XCTAssertEqual(rep.objectForKey(nameKey) as String, graph.name)
        XCTAssertEqual((rep.objectForKey(nodesKey) as NSArray).count, 2);
        XCTAssertEqual((rep.objectForKey(nodesKey) as NSArray).objectAtIndex(0) as NSDictionary, (graph.getRoom(0)! as MementoNode).plistRepresentation)
        XCTAssertEqual((rep.objectForKey(nodesKey) as NSArray).objectAtIndex(1) as NSDictionary, (graph.getRoom(1)! as MementoNode).plistRepresentation)
        
        graph.removeRoom(0)
        rep = graph.plistRepresentation
        XCTAssertEqual(rep.objectForKey(nameKey) as String, graph.name)
        XCTAssertEqual((rep.objectForKey(nodesKey) as NSArray).count, 1);
        XCTAssertEqual((rep.objectForKey(nodesKey) as NSArray).objectAtIndex(0) as NSDictionary, newNode.plistRepresentation)
    }
}
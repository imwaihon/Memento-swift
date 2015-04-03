//
//  MementoModelTests.swift
//  Memento
//
//  Unit tests for model.
//
//  Created by Qua Zi Xian on 28/3/15.
//  Copyright (c) 2015 NUS CS3217. All rights reserved.
//

import Foundation
import XCTest

class MementoModelTests: XCTestCase {
    
    func testAddPalace() {
        let model = MementoModel()
        let initNumPalace = model.numPalaces
        
        model.addPalace(MementoGraph(name: "graph1", rootNode: MementoNode(imageFile: "A.png")))
        XCTAssertEqual(model.numPalaces, initNumPalace+1)
        XCTAssertFalse(model.getPalace("graph1") == nil)
        
        model.addPalace(MementoGraph(name: "graph2", rootNode: MementoNode(imageFile: "B.png")))
        XCTAssertEqual(model.numPalaces, initNumPalace+2);
        XCTAssertFalse(model.getPalace("graph2") == nil)
        
        let duplicateGraph = MementoGraph(name: "graph1", rootNode: MementoNode(imageFile:"B.png"))
        model.addPalace(duplicateGraph)
        XCTAssertEqual(model.numPalaces, initNumPalace+3)
        XCTAssertEqual(duplicateGraph.name, "graph1(1)")
        XCTAssertFalse(model.getPalace("graph1(1)") == nil)
    }
    
    func testRemovePalace() {
        let model = MementoModel()
        let initNumPalace = model.numPalaces
        
        model.addPalace(MementoGraph(name: "graph1", rootNode: MementoNode(imageFile: "A.png")))
        model.addPalace(MementoGraph(name: "graph2", rootNode: MementoNode(imageFile: "B.png")))
        XCTAssertEqual(model.numPalaces, initNumPalace+2)
        XCTAssertFalse(model.getPalace("graph1") == nil)
        XCTAssertFalse(model.getPalace("graph2") == nil)
        
        model.removePalace("graph1")
        XCTAssertEqual(model.numPalaces, initNumPalace+1)
        XCTAssertTrue(model.getPalace("graph1") == nil)
        XCTAssertFalse(model.getPalace("graph2") == nil)
        
        model.removePalace("graph2")
        XCTAssertEqual(model.numPalaces, initNumPalace)
        XCTAssertTrue(model.getPalace("graph2") == nil)
    }
    
    func testAddRoom() {
        let model = MementoModel()
        let graph = MementoGraph(name: "graph1", rootNode: MementoNode(imageFile: "A.png"))
        let newRoom = MementoNode(imageFile: "B.png")
        let anotherRoom = MementoNode(imageFile: "C.png")
        
        model.addPalace(graph)
        model.addPalaceRoom(graph.name, room: newRoom)
        XCTAssertEqual(newRoom.label, 1)
        XCTAssertEqual(graph.numRooms, 2)
        XCTAssertTrue(graph.getRoom(newRoom.label) === newRoom)
        
        //Tries adding to non-existent graph
        model.addPalaceRoom("unknownGraph", room: anotherRoom)
        XCTAssertTrue(model.getMemoryPalaceRoom("unknownGraph", roomLabel: anotherRoom.label) == nil)
    }
    
    func testRemoveRoom() {
        let model = MementoModel()
        let graph = MementoGraph(name: "graph1", rootNode: MementoNode(imageFile: "A.png"))
        let newRoom = MementoNode(imageFile: "B.png")
        let newRoom2 = MementoNode(imageFile: "C.png")
        
        model.addPalace(graph)
        model.addPalaceRoom(graph.name, room: newRoom)
        model.addPalaceRoom(graph.name, room: newRoom2)
        XCTAssertEqual(graph.numRooms, 3)
        
        model.removeMemoryPalaceRoom(graph.name, roomLabel: newRoom.label)
        XCTAssertEqual(graph.numRooms, 2)
        XCTAssertEqual(newRoom2.label, 2)
        XCTAssertFalse(model.getMemoryPalaceRoom(graph.name, roomLabel: newRoom.label) === newRoom)
    }
}
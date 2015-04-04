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
        
        dispatch_sync(model.saveQueue, {() -> Void in
            SaveLoadManager.sharedInstance.deletePalace("graph1")
            SaveLoadManager.sharedInstance.deletePalace("graph1(1)")
            SaveLoadManager.sharedInstance.deletePalace("graph2")
        })
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
        
        dispatch_sync(model.saveQueue, {() -> Void in
            //Do nothing. Wait for file operations to complete.
        })
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
        
        dispatch_sync(model.saveQueue, {() -> Void in
            SaveLoadManager.sharedInstance.deletePalace("graph1")
        })
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
        
        dispatch_sync(model.saveQueue, {() -> Void in
            SaveLoadManager.sharedInstance.deletePalace(graph.name)
        })
    }
    
    /*func testDummytest() {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray
        let documentsDirectory = paths.objectAtIndex(0) as String
        let path = documentsDirectory.stringByAppendingPathComponent("data")
        
        let fileManager = NSFileManager.defaultManager()
        let palacesFilenames = fileManager.subpathsOfDirectoryAtPath(path, error: nil)! as [String]
        
        for filename in palacesFilenames {
            println(filename)
        }
        
        fileManager.removeItemAtPath(path.stringByAppendingPathComponent("graph2"), error: nil)
        fileManager.removeItemAtPath(path.stringByAppendingPathComponent("graph1(1)"), error: nil)
        fileManager.removeItemAtPath(path.stringByAppendingPathComponent("graph1"), error: nil)
        /*fileManager.removeItemAtPath(path.stringByAppendingPathComponent("graph1(2)"), error: nil)
        fileManager.removeItemAtPath(path.stringByAppendingPathComponent("graph1(3)"), error: nil)
        fileManager.removeItemAtPath(path.stringByAppendingPathComponent("graph1(4)"), error: nil)*/
    }*/
}
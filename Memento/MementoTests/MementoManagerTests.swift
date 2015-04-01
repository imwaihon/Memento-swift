//
//  MementoManagerTests.swift
//  Memento
//
//  High level black-box unit testing for data managerment component.
//  Do not change the namges of the unit tests.
//  Tests are execute by alphabetical order of their names and manager holds a singleton instance of the model.
//  So changes made to the model through the manager is propagated to othe rtest cases.
//
//  Created by Qua Zi Xian on 28/3/15.
//  Copyright (c) 2015 NUS CS3217. All rights reserved.
//

import Foundation
import XCTest

class MementoManagerTests: XCTestCase {
    func testAddMemoryPalace() {
        let manager = MementoManager()
        var initialNumPalace = manager.numberOfMemoryPalace
        
        manager.addMemoryPalace(named: "graph1", imageFile: "A.png")
        XCTAssertEqual(manager.numberOfMemoryPalace, initialNumPalace+1)
        XCTAssertFalse(manager.getMemoryPalace("graph1") == nil)
        XCTAssertEqual(manager.getMemoryPalace("graph1")!.icon, MemoryPalaceIcon(graphName: "graph1", imageFile: "A.png"))
        XCTAssertEqual(manager.addMemoryPalace(named: "graph1", imageFile: "B.png"), "graph1(1)")
        XCTAssertEqual(manager.numberOfMemoryPalace, initialNumPalace+2)
    }
    
    //Exact memory palace counting tests to be modified after adding save/load capabilities
    func testDeleteMemoryPalace() {
        let manager = MementoManager()
        
        let initialNumPalaces = manager.numberOfMemoryPalace
        
        XCTAssertFalse(manager.getMemoryPalace("graph1") == nil)
        XCTAssertFalse(manager.getMemoryPalace("graph1(1)") == nil)
        
        manager.removeMemoryPalace("graph1")
        XCTAssertEqual(manager.numberOfMemoryPalace, initialNumPalaces-1)
        XCTAssertTrue(manager.getMemoryPalace("graph1") == nil)
        
        manager.removeMemoryPalace("graph1(1)")
        XCTAssertEqual(manager.numberOfMemoryPalace, initialNumPalaces-2)
        XCTAssertTrue(manager.getMemoryPalace("graph1(1)") == nil)
    }
    
    //Exact testing to be modified after adding save/load capabilities
    func testGetMemoryPalaceIcons() {
        let manager = MementoManager()
        XCTAssertEqual(manager.getMemoryPalaceIcons(), [])
        
        let graph1Icon = MemoryPalaceIcon(graphName: "graph1", imageFile: "A.png")
        let graph2Icon = MemoryPalaceIcon(graphName: "graph2", imageFile: "B.png")
        let graph3Icon = MemoryPalaceIcon(graphName: "graph3", imageFile: "C.png")
        
        manager.addMemoryPalace(named: "graph1", imageFile: "A.png")
        XCTAssertEqual(manager.getMemoryPalaceIcons(), [graph1Icon])
        
        manager.addMemoryPalace(named: "graph2", imageFile: "B.png")
        XCTAssertEqual(manager.getMemoryPalaceIcons(), [graph1Icon, graph2Icon])
        
        manager.addMemoryPalace(named: "graph3", imageFile: "C.png")
        XCTAssertEqual(manager.getMemoryPalaceIcons(), [graph1Icon, graph2Icon, graph3Icon])
        
        manager.removeMemoryPalace("graph2")
        XCTAssertEqual(manager.getMemoryPalaceIcons(), [graph1Icon, graph3Icon])
        
        manager.removeMemoryPalace("graph3")
        XCTAssertEqual(manager.getMemoryPalaceIcons(), [graph1Icon])
        
        manager.removeMemoryPalace("graph1")
        XCTAssertEqual(manager.getMemoryPalaceIcons(), [])
    }
    
    
    
    func testInsertMemoryPalaceRoom() {
        let manager = MementoManager()
        let palaceName = manager.addMemoryPalace(named: "graph1", imageFile: "A.png")
        let room1 = MemoryPalaceRoomIcon(label: 0, filename: "A.png", overlays: [])
        let room2 = MemoryPalaceRoomIcon(label: 1, filename: "B.png", overlays: [])
        
        XCTAssertFalse(manager.getPalaceOverview(palaceName) == nil)
        XCTAssertEqual(manager.getPalaceOverview(palaceName)!, [room1])
        
        manager.addMemoryPalaceRoom(palaceName, roomImage: "B.png")
        XCTAssertEqual(manager.getPalaceOverview(palaceName)!, [room1, room2])
    }
    
    func testRemoveMemoryPalaceRoom() {
        let manager = MementoManager()
        let palaceName = manager.addMemoryPalace(named: "graph1", imageFile: "A.png")
        let room1 = MemoryPalaceRoomIcon(label: 0, filename: "A.png", overlays: [])
        let room2 = MemoryPalaceRoomIcon(label: 1, filename: "B.png", overlays: [])
        let newRoom2 = MemoryPalaceRoomIcon(label: 0, filename: "B.png", overlays: [])
        
        manager.addMemoryPalaceRoom(palaceName, roomImage: "B.png")
        XCTAssertEqual(manager.getPalaceOverview(palaceName)!, [room1, room2])
        
        //Invalid palace name
        manager.removeMemoryPalaceRoom("graph0", roomLabel: 0)
        XCTAssertEqual(manager.getPalaceOverview(palaceName)!, [room1, room2])
        
        //Invalid room labels
        manager.removeMemoryPalaceRoom(palaceName, roomLabel: -1)
        XCTAssertEqual(manager.getPalaceOverview(palaceName)!, [room1, room2])
        manager.removeMemoryPalaceRoom(palaceName, roomLabel: 100)
        XCTAssertEqual(manager.getPalaceOverview(palaceName)!, [room1, room2])
        
        manager.removeMemoryPalaceRoom(palaceName, roomLabel: 0)
        XCTAssertEqual(manager.getPalaceOverview(palaceName)!, [newRoom2])
        
        //Attempts to make graph empty
        manager.removeMemoryPalaceRoom(palaceName, roomLabel: 0)
        XCTAssertEqual(manager.getPalaceOverview(palaceName)!, [newRoom2])
    }
}
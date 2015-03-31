//
//  MementoManagerTests.swift
//  Memento
//
//  High level black-box unit testing for data managerment component.
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
    
    //Exact memory palace counting tests to be modified after adding save/load capabilities
    func testRemoveMemoryPalace() {
        let manager = MementoManager()
        
        manager.addMemoryPalace(named: "graph1", imageFile: "A.png")
        manager.addMemoryPalace(named: "graph2", imageFile: "B.png")
        manager.addMemoryPalace(named: "graph3", imageFile: "B.png")
        XCTAssertEqual(manager.numberOfMemoryPalace, 3)
        XCTAssertFalse(manager.getMemoryPalace("graph1") == nil)
        XCTAssertFalse(manager.getMemoryPalace("graph2") == nil)
        XCTAssertFalse(manager.getMemoryPalace("graph3") == nil)
        
        manager.removeMemoryPalace("graph2")
        XCTAssertEqual(manager.numberOfMemoryPalace, 2)
        XCTAssertFalse(manager.getMemoryPalace("graph1") == nil)
        XCTAssertTrue(manager.getMemoryPalace("graph2") == nil)
        XCTAssertFalse(manager.getMemoryPalace("graph3") == nil)
        
        manager.removeMemoryPalace("graph3")
        XCTAssertEqual(manager.numberOfMemoryPalace, 1)
        XCTAssertFalse(manager.getMemoryPalace("graph1") == nil)
        XCTAssertTrue(manager.getMemoryPalace("graph3") == nil)
    }
    
    func testAddMemoryPalaceRoom() {
        let manager = MementoManager()
        let palaceName = manager.addMemoryPalace(named: "graph1", imageFile: "A.png")
        let room1 = MemoryPalaceRoomIcon(label: 0, filename: "A.png")
        let room2 = MemoryPalaceRoomIcon(label: 1, filename: "B.png")
        
        XCTAssertFalse(manager.getPalaceOverview(palaceName) == nil)
        XCTAssertEqual(manager.getPalaceOverview(palaceName)!, [room1])
        
        manager.addMemoryPalaceRoom(palaceName, roomImage: "B.png")
        XCTAssertEqual(manager.getPalaceOverview(palaceName)!, [room1, room2])
    }
    
    func testRemoveMemoryPalaceRoom() {
        let manager = MementoManager()
        let palaceName = manager.addMemoryPalace(named: "graph1", imageFile: "A.png")
        let room1 = MemoryPalaceRoomIcon(label: 0, filename: "A.png")
        let room2 = MemoryPalaceRoomIcon(label: 1, filename: "B.png")
        let newRoom2 = MemoryPalaceRoomIcon(label: 0, filename: "B.png")
        
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
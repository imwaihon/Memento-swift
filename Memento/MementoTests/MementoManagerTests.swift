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
        XCTAssertEqual(manager.numberOfMemoryPalace, 2)
    }
    
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
}
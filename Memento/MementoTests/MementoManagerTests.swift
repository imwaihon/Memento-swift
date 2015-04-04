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
        let manager = MementoManager.sharedInstance
        let model = MementoModel.sharedInstance
        var initialNumPalace = manager.numberOfMemoryPalace
        
        XCTAssertEqual(manager.addMemoryPalace(named: "graph1", imageFile: "A.png"), "graph1")
        XCTAssertEqual(manager.numberOfMemoryPalace, initialNumPalace+1)
        XCTAssertFalse(manager.getMemoryPalace("graph1") == nil)
        XCTAssertEqual(manager.getMemoryPalace("graph1")!.icon, MemoryPalaceIcon(graphName: "graph1", imageFile: "A.png"))
        XCTAssertEqual(manager.addMemoryPalace(named: "graph1", imageFile: "B.png"), "graph1(1)")
        XCTAssertEqual(manager.numberOfMemoryPalace, initialNumPalace+2)
        
        model.removePalace("graph1")
        model.removePalace("graph1(1)")
        
        dispatch_sync(model.saveQueue, {() -> Void in
            
        })
        
        XCTAssertTrue(manager.getMemoryPalace("graph1") == nil)
        XCTAssertTrue(manager.getMemoryPalace("graph1(1)") == nil)
    }
    
    //Exact memory palace counting tests to be modified after adding save/load capabilities
    func testDeleteMemoryPalace() {
        let manager = MementoManager.sharedInstance
        let model = MementoModel.sharedInstance
        
        XCTAssertEqual(manager.addMemoryPalace(named: "graph1", imageFile: "A.png"), "graph1")
        manager.addMemoryPalace(named: "graph1", imageFile: "B.png")
        XCTAssertFalse(manager.getMemoryPalace("graph1") == nil)
        XCTAssertFalse(manager.getMemoryPalace("graph1(1)") == nil)
        
        let initialNumPalaces = manager.numberOfMemoryPalace
        
        manager.removeMemoryPalace("graph1")
        XCTAssertEqual(manager.numberOfMemoryPalace, initialNumPalaces-1)
        XCTAssertTrue(manager.getMemoryPalace("graph1") == nil)
        
        manager.removeMemoryPalace("graph1(1)")
        XCTAssertEqual(manager.numberOfMemoryPalace, initialNumPalaces-2)
        XCTAssertTrue(manager.getMemoryPalace("graph1(1)") == nil)
        
        dispatch_sync(model.saveQueue, {() -> Void in
            //Do nothing. Wait for file operations to complete before ending test case.
        })
    }
    
    //Exact testing to be modified after adding save/load capabilities
    func testGetMemoryPalaceIcons() {
        let manager = MementoManager.sharedInstance
        let model = MementoModel.sharedInstance
        
        for icon in manager.getMemoryPalaceIcons() {
            println(icon.graphName)
        }
        
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
        
        dispatch_sync(model.saveQueue, {() -> Void in
            //Do nothing. Wait for file operations to complete.
        })
    }
    
    func testInsertMemoryPalaceRoom() {
        let manager = MementoManager.sharedInstance
        let model = MementoModel.sharedInstance
        let palaceName = manager.addMemoryPalace(named: "graph1", imageFile: "A.png")
        let room1 = MemoryPalaceRoomIcon(graphName: palaceName, label: 0, filename: "A.png", overlays: [])
        let room2 = MemoryPalaceRoomIcon(graphName: palaceName,label: 1, filename: "B.png", overlays: [])
        
        XCTAssertFalse(manager.getPalaceOverview(palaceName) == nil)
        XCTAssertEqual(manager.getPalaceOverview(palaceName)!, [room1])
        
        manager.addMemoryPalaceRoom(palaceName, roomImage: "B.png")
        XCTAssertEqual(manager.getPalaceOverview(palaceName)!, [room1, room2])
        
        //Clean up directory
        model.removePalace(palaceName)
        
        dispatch_sync(model.saveQueue, {() -> Void in
            //DO nothing. Wait for deletion to complete.
        })
    }
    
    func testRemoveMemoryPalaceRoom() {
        let manager = MementoManager.sharedInstance
        let model = MementoModel.sharedInstance
        let palaceName = manager.addMemoryPalace(named: "graph1", imageFile: "A.png")
        let room1 = MemoryPalaceRoomIcon(graphName: "graph1", label: 0, filename: "A.png", overlays: [])
        let room2 = MemoryPalaceRoomIcon(graphName: "graph1", label: 1, filename: "B.png", overlays: [])
        
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
        XCTAssertEqual(manager.getPalaceOverview(palaceName)!, [room2])
        
        //Attempts to make graph empty
        manager.removeMemoryPalaceRoom(palaceName, roomLabel: 1)
        XCTAssertEqual(manager.getPalaceOverview(palaceName)!, [room2])
        
        //Clean up directory.
        model.removePalace(palaceName)
        
        dispatch_sync(model.saveQueue, {() -> Void in
           //Do nothing. Wait for clean up to complete.
        })
    }
    
    /*func testCleanup() {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray
        let documentsDirectory = paths.objectAtIndex(0) as String
        let path = documentsDirectory.stringByAppendingPathComponent("data")
        
        let fileManager = NSFileManager.defaultManager()
        let palacesFilenames = fileManager.subpathsOfDirectoryAtPath(path, error: nil)! as [String]
        
        for filename in palacesFilenames {
            println(filename)
        }
        
        fileManager.removeItemAtPath(path.stringByAppendingPathComponent("graph2(1)"), error: nil)
        fileManager.removeItemAtPath(path.stringByAppendingPathComponent("graph1(5)"), error: nil)
        fileManager.removeItemAtPath(path.stringByAppendingPathComponent("graph2(2)"), error: nil)
        fileManager.removeItemAtPath(path.stringByAppendingPathComponent("graph1(2)"), error: nil)
        fileManager.removeItemAtPath(path.stringByAppendingPathComponent("graph1(3)"), error: nil)
        fileManager.removeItemAtPath(path.stringByAppendingPathComponent("graph1(4)"), error: nil)
    }*/
}
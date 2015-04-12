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
import UIKit
import XCTest

class MementoManagerTests: XCTestCase {
    func testAddAndRemoveMemoryPalace() {
        let manager = MementoManager.sharedInstance
        let model = MementoModel.sharedInstance
        let image = UIImage(named: NSBundle.mainBundle().pathForResource("linuxpenguin", ofType: ".jpg")!)!
        var initialNumPalace = manager.numberOfMemoryPalace
        
        let res = manager.addMemoryPalace(named: "graph1", imageFile: "linuxpenguin.jpg", image: image)
        XCTAssertEqual(res.0, "graph1")
        XCTAssertEqual(res.1, "linuxpenguin.jpg")
        XCTAssertEqual(manager.numberOfMemoryPalace, initialNumPalace+1)
        XCTAssertTrue(fileExists("sharedResource/linuxpenguin.jpg"))
        XCTAssertFalse(manager.getMemoryPalace("graph1") == nil)
        XCTAssertEqual(manager.getMemoryPalace("graph1")!.icon, MemoryPalaceIcon(graphName: "graph1", imageFile: "linuxpenguin.jpg"))
        
        //Add memory palace with duplicate name
        XCTAssertEqual(manager.addMemoryPalace(named: "graph1", imageFile: "B.png"), "graph1(1)")
        XCTAssertFalse(manager.getMemoryPalace("graph1(1)") == nil)
        XCTAssertEqual(manager.numberOfMemoryPalace, initialNumPalace+2)
        
        //Adds another palace using the same image as graph1 to test reference counting in deletion
        XCTAssertEqual(manager.addMemoryPalace(named: "graph2", imageFile: "linuxpenguin.jpg"), "graph2")
        XCTAssertEqual(manager.numberOfMemoryPalace, initialNumPalace+3)
        XCTAssertFalse(manager.getMemoryPalace("graph2") == nil)
        XCTAssertEqual(manager.getMemoryPalace("graph2")!.icon, MemoryPalaceIcon(graphName: "graph2", imageFile: "linuxpenguin.jpg"))
        
        //Deletes 1 of the memory palace using the existing image
        manager.removeMemoryPalace("graph1")
        XCTAssertEqual(manager.numberOfMemoryPalace, initialNumPalace+2)
        XCTAssertTrue(manager.getMemoryPalace("graph1") == nil)
        XCTAssertTrue(fileExists("sharedResource/linuxpenguin.jpg"))    //Check for existing reference.
        
        //Remove last reference to the actual image.
        manager.removeMemoryPalace("graph2")
        XCTAssertEqual(manager.numberOfMemoryPalace, initialNumPalace+1)
        XCTAssertTrue(manager.getMemoryPalace("graph2") == nil)
        XCTAssertFalse(fileExists("sharedResource/linuxpenguin.jpg"))
        
        //Clean up the remaining test graph
        manager.removeMemoryPalace("graph1(1)")
        XCTAssertEqual(manager.numberOfMemoryPalace, initialNumPalace)
        XCTAssertTrue(manager.getMemoryPalace("graph1(1)") == nil)
        
        dispatch_sync(model.saveQueue, {() -> Void in
            //Wait for all asynchronous cleanup operations to be done.
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
    
    func testInsertAndRemoveMemoryPalaceRoom() {
        let manager = MementoManager.sharedInstance
        let model = MementoModel.sharedInstance
        let palaceName = manager.addMemoryPalace(named: "graph1", imageFile: "A.png")
        let image = UIImage(named: NSBundle.mainBundle().pathForResource("linuxpenguin", ofType: ".jpg")!)!
        let room1 = MemoryPalaceRoomIcon(graphName: palaceName, label: 0, filename: "A.png", overlays: [])
        let room2 = MemoryPalaceRoomIcon(graphName: palaceName,label: 1, filename: "linuxpenguin.jpg", overlays: [])
        let room3 = MemoryPalaceRoomIcon(graphName: palaceName, label: 2, filename: "linuxpenguin.jpg", overlays: [])
        
        XCTAssertFalse(manager.getPalaceOverview(palaceName) == nil)
        XCTAssertEqual(manager.getPalaceOverview(palaceName)!, [room1])
        
        //Adds room2 using new resource
        let res = manager.addMemoryPalaceRoom(palaceName, roomImage: "linuxpenguin.jpg", image: image)
        XCTAssertFalse(res == nil)
        XCTAssertEqual(res!.0, 1)
        XCTAssertEqual(res!.1, "linuxpenguin.jpg")
        XCTAssertEqual(manager.getPalaceOverview(palaceName)!, [room1, room2])
        XCTAssertTrue(fileExists("sharedResource/linuxpenguin.jpg"))
        
        //Adds room3 using existing resource
        if let res2 = manager.addMemoryPalaceRoom(palaceName, roomImage: "linuxpenguin.jpg") {
            XCTAssertEqual(res2, 2)
            XCTAssertEqual(manager.getPalaceOverview(palaceName)!, [room1, room2, room3])
        }
        
        //Tests adding room to non-existent memory palce.
        XCTAssertTrue(manager.addMemoryPalaceRoom("somePalace", roomImage: "B.png") == nil)
        
        //Removes room2
        manager.removeMemoryPalaceRoom(palaceName, roomLabel: 1)
        XCTAssertTrue(manager.getMemoryPalaceRoom(palaceName, roomLabel: 1) == nil)
        XCTAssertEqual(manager.getPalaceOverview(palaceName)!, [room1, room3])
        XCTAssertTrue(fileExists("sharedResource/linuxpenguin.jpg"))
        
        //Removes room3
        manager.removeMemoryPalaceRoom(palaceName, roomLabel: 2)
        XCTAssertTrue(manager.getMemoryPalaceRoom(palaceName, roomLabel: 2) == nil)
        XCTAssertEqual(manager.getPalaceOverview(palaceName)!, [room1])
        XCTAssertFalse(fileExists("sharedResource/linuxpenguin.jpg"))
        
        //Attempts to remove last remaining room
        manager.removeMemoryPalaceRoom(palaceName, roomLabel: 0)
        XCTAssertFalse(manager.getMemoryPalaceRoom(palaceName, roomLabel: 0) == nil)
        XCTAssertEqual(manager.getPalaceOverview(palaceName)!, [room1])
        
        //Clean up directory
        manager.removeMemoryPalace(palaceName)
        
        dispatch_sync(model.saveQueue, {() -> Void in
            //DO nothing. Wait for deletion to complete.
        })
    }
    
    func testAddPlaceHolder() {
    
    }
    
    func testSetPlaceHolderFrame() {
    
    }
    
    func testSwapPlaceHolders() {
        let manager = MementoManager.sharedInstance
        let model = MementoModel.sharedInstance
        let graph = MementoGraph(name: "graph1", rootNode: MementoNode(imageFile: "A.png"))
        let pHolder1 = RectanglePlaceHolder(highlightArea: CGRectMake(0, 0, 10, 20))
        let pHolder2 = RectanglePlaceHolder(highlightArea: CGRectMake(10, 0, 20, 20))
        
        //Memory palace not present.
        XCTAssertFalse(manager.swapPlaceHolders(graph.name, roomLabel: 0, pHolder1Label: 0, pHolder2Label: 1))
        
        model.addPalace(graph)
        
        //Both placeholers are not present
        XCTAssertFalse(manager.swapPlaceHolders(graph.name, roomLabel: 0, pHolder1Label: 0, pHolder2Label: 1))
        
        XCTAssertTrue(manager.addPlaceHolder(graph.name, roomLabel: 0, placeHolder: pHolder1))
        XCTAssertTrue(manager.addPlaceHolder(graph.name, roomLabel: 0, placeHolder: pHolder2))
        XCTAssertEqual(pHolder1.label, 0)
        XCTAssertEqual(pHolder2.label, 1)
        
        //Room not present.
        XCTAssertFalse(manager.swapPlaceHolders(graph.name, roomLabel: 1, pHolder1Label: 0, pHolder2Label: 1))
        
        //Swap actually takes place.
        XCTAssertTrue(manager.swapPlaceHolders(graph.name, roomLabel: 0, pHolder1Label: 0, pHolder2Label: 1))
        XCTAssertEqual(pHolder1.label, 1)
        XCTAssertEqual(pHolder2.label, 0)
        
        //Both placeholders do not exist.
        XCTAssertFalse(manager.swapPlaceHolders(graph.name, roomLabel: 0, pHolder1Label: 2, pHolder2Label: 8))
        
        //1 of the placeholders does not exist.
        manager.removePlaceHolder(graph.name, roomLabel: 0, placeHolderLabel: 0)
        XCTAssertFalse(manager.swapPlaceHolders(graph.name, roomLabel: 0, pHolder1Label: 1, pHolder2Label: 0))
        
        //Clean up directory
        model.removePalace(graph.name)
        
        dispatch_sync(model.saveQueue, {() -> Void in
            //Do nothing. Wait for cleanup to finish.
        })
    }
    
    func testSetAssociationValue() {
        let manager = MementoManager.sharedInstance
        let model = MementoModel.sharedInstance
        let graph = MementoGraph(name: "graph1", rootNode: MementoNode(imageFile: "A.png"))
    }
    
    func testRemovePlaceHolder() {
        
    }
    
    func testAddOverlay() {
    
    }
    
    func testSetOverlayFrame() {
        
    }
    
    func testRemoveOverlay() {
        
    }
    
    func testGetNextNodeView() {
        let manager = MementoManager.sharedInstance
        let model = MementoModel.sharedInstance
        let graph = MementoGraph(name: "graph1", rootNode: MementoNode(imageFile: "A.png"))
        let room2 = MementoNode(imageFile: "B.png")
        let room3 = MementoNode(imageFile: "C.png")
        
        model.addPalace(graph)
        model.addPalaceRoom(graph.name, room: room2)
        model.addPalaceRoom(graph.name, room: room3)
        XCTAssertEqual(room2.label, 1)
        XCTAssertEqual(room3.label, 2)
        
        XCTAssertEqual(manager.getNextNode(graph.name, roomLabel: 0)!.label, 1)
        XCTAssertEqual(manager.getNextNode(graph.name, roomLabel: 1)!.label, 2)
        XCTAssertTrue(manager.getNextNode(graph.name, roomLabel: 2) == nil)
        
        manager.removeMemoryPalaceRoom(graph.name, roomLabel: 1)
        XCTAssertEqual(manager.getNextNode(graph.name, roomLabel: 0)!.label, 2)
        XCTAssertEqual(manager.getNextNode(graph.name, roomLabel: 1)!.label, 2)
        XCTAssertTrue(manager.getNextNode(graph.name, roomLabel: 2) == nil)
        
        //Clean up directory
        model.removePalace(graph.name)
        
        dispatch_sync(model.saveQueue, {() -> Void in
            //Do nothing. Wait for cleanup to complete.
        })
    }
    
    private func fileExists(filename: String) -> Bool {
        let dir = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0] as String
        return NSFileManager.defaultManager().fileExistsAtPath(dir+"/\(filename)")
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
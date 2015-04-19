//
//  SaveLoadManagerTests.swift
//  Memento
//
//  Unit test for SaveLoadManager class
//
//  Created by Qua Zi Xian on 19/4/15.
//  Copyright (c) 2015 NUS CS3217. All rights reserved.
//

import Foundation
import XCTest

class SaveLoadManagerTests: XCTestCase {

    func testSaveAndLoadPalace() {
        let manager = SaveLoadManager.sharedInstance
        let filename = "graph1.plist"
        let palace = MementoGraph(name: "graph1", rootNode: MementoNode(imageFile: "A.png"))
        
        //Adds the first palace
        XCTAssertFalse(fileExists(filename))
        manager.savePalaceToFile(palace)
        XCTAssertTrue(fileExists(filename))
        
        //Test loading of single palace.
        //Also verifies that the save functionality is working correctly.
        var loadedPalace = manager.loadPalaceFromFile("graph1.plist")
        if loadedPalace != nil {
            XCTAssertEqual(loadedPalace!.plistRepresentation, palace.plistRepresentation)
        }

        //Cleanup
        deleteFile("graph1.plist")
    }
    
    func testDeletePalace() {
        let manager = SaveLoadManager.sharedInstance
        let filename = "graph1.plist"
        let palace = MementoGraph(name: "graph1", rootNode: MementoNode(imageFile: "A.png"))
        
        //Adds the palace
        XCTAssertFalse(fileExists(filename))
        manager.savePalaceToFile(palace)
        XCTAssertTrue(fileExists(filename))

        //Deletes the palace
        manager.deletePalace("graph1")
        XCTAssertFalse(fileExists("graph1.plist"))
    }
    
    private func fileExists(filename: String) -> Bool {
        let dirPath = (NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0] as String).stringByAppendingPathComponent("data")
        return NSFileManager.defaultManager().fileExistsAtPath(dirPath.stringByAppendingPathComponent(filename))
    }
    
    private func deleteFile(filename: String) {
        let dirPath = (NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0] as String).stringByAppendingPathComponent("data")
        NSFileManager.defaultManager().removeItemAtPath(dirPath.stringByAppendingPathComponent(filename), error: nil)
    }
}
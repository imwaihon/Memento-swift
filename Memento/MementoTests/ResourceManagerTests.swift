//
//  ResourceManagerTests.swift
//  Memento
//
//  Created by Qua Zi Xian on 9/4/15.
//  Copyright (c) 2015 NUS CS3217. All rights reserved.
//

import Foundation
import UIKit
import XCTest

class ResourceManagerTests: XCTestCase {
    func test() {
        let manager = ResourceManager(directory: "sharedResource")
    }
    
    func testAddAndRetainResource() {
        let manager = ResourceManager(directory: "sharedResource")
        let imageFile = UIImage(named: NSBundle.mainBundle().pathForResource("linuxpenguin", ofType: ".jpg")!)
        XCTAssertFalse(fileExists("linuxpenguin.jpg"))
        
        manager.retainResource("linuxpenguin.jpg", image: imageFile!)
        XCTAssertTrue(fileExists("sharedResource/linuxpenguin.jpg"))
        XCTAssertEqual(manager.referenceCountForResource("linuxpenguin.jpg"), 1)
        
        manager.retainResource("linuxpenguin.jpg")
        XCTAssertEqual(manager.referenceCountForResource("linuxpenguin.jpg"), 2)
        
        //Tests retaining on non-existent resource.
        XCTAssertEqual(manager.referenceCountForResource("B.png"), 0)
        manager.retainResource("B.png")
        XCTAssertEqual(manager.referenceCountForResource("B.png"), 0)
    }
    
    func testRemoveResource() {
        
    }
    
    private func fileExists(filename: String) -> Bool {
        let dir = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0] as String
        return NSFileManager.defaultManager().fileExistsAtPath(dir+"/\(filename)")
    }
}
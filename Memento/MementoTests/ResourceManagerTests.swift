//
//  ResourceManagerTests.swift
//  Memento
//
//  Currently testing on image resources only.
//  The tests must run in the order: testAddAndRetainResource, testReleaseAndRemoveResource.
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
        
        XCTAssertEqual(manager.retainResource("linuxpenguin.jpg", image: imageFile!), "linuxpenguin.jpg")
        XCTAssertTrue(fileExists("sharedResource/linuxpenguin.jpg"))
        XCTAssertEqual(manager.referenceCountForResource("linuxpenguin.jpg"), 1)
        
        manager.retainResource("linuxpenguin.jpg")
        XCTAssertEqual(manager.referenceCountForResource("linuxpenguin.jpg"), 2)
        
        //Tests adding image resource with duplicate name
        XCTAssertEqual(manager.retainResource("linuxpenguin.jpg", image: imageFile!), "linuxpenguin(1).jpg")
        XCTAssertTrue(fileExists("sharedResource/linuxpenguin(1).jpg"))
        XCTAssertEqual(manager.referenceCountForResource("linuxpenguin.jpg"), 2)
        XCTAssertEqual(manager.referenceCountForResource("linuxpenguin(1).jpg"), 1)
        
        //Tests retaining on non-existent resource.
        XCTAssertEqual(manager.referenceCountForResource("B.png"), 0)
        manager.retainResource("B.png")
        XCTAssertEqual(manager.referenceCountForResource("B.png"), 0)
    }
    
    func testReleaseAndRemoveResource() {
        let manager = ResourceManager(directory: "sharedResource")
        XCTAssertTrue(fileExists("sharedResource/linuxpenguin.jpg"))
        XCTAssertEqual(manager.referenceCountForResource("linuxpenguin.jpg"), 2)
        XCTAssertEqual(manager.referenceCountForResource("linuxpenguin(1).jpg"), 1)
        XCTAssertTrue(fileExists("sharedResource/linuxpenguin.jpg"))
        XCTAssertTrue(fileExists("sharedResource/linuxpenguin(1).jpg"))
        
        //Check reference count decrementing.
        manager.releaseResource("linuxpenguin.jpg")
        XCTAssertTrue(fileExists("sharedResource/linuxPenguin.jpg"))
        XCTAssertEqual(manager.referenceCountForResource("linuxpenguin.jpg"), 1)
        
        //Check resource deletion when reference count falls to 0.
        manager.releaseResource("linuxpenguin.jpg")
        XCTAssertFalse(fileExists("sharedResource/linuxpenguin.jpg"))
        XCTAssertEqual(manager.referenceCountForResource("linuxpenguin.jpg"), 0)
        manager.releaseResource("linuxpenguin(1).jpg")
        XCTAssertFalse(fileExists("sharedResource/linuxpenguin(1).jpg"))
        XCTAssertEqual(manager.referenceCountForResource("linuxpenguin(1).jpg"), 0)
        
        //Tests releasing non-existent resource
        manager.releaseResource("linuxpenguin.jpg")
        XCTAssertEqual(manager.referenceCountForResource("linuxpenguin.jpg"), 0)
    }
    
    private func fileExists(filename: String) -> Bool {
        let dir = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0] as String
        return NSFileManager.defaultManager().fileExistsAtPath(dir+"/\(filename)")
    }
}
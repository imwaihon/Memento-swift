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
    
    func testAddAndRetainResource() {
        let manager = ResourceManager(directory: "sharedResource")
        let imageFile = UIImage(named: NSBundle.mainBundle().pathForResource("linuxpenguin", ofType: ".jpg")!)
        let text = "Hello world"
        
        //Adds image resource
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
        
        //Adds text resource
        XCTAssertEqual(manager.retainResource("sampleText.txt", text: text), "sampleText.txt")
        XCTAssertEqual(manager.referenceCountForResource("sampleText.txt"), 1)
        
        //Tests conversion of file extension to txt
        XCTAssertEqual(manager.retainResource("sampleText2", text: text), "sampleText2.txt")
        XCTAssertEqual(manager.referenceCountForResource("sampleText2"), 0)
        XCTAssertEqual(manager.referenceCountForResource("sampleText2.txt"), 1)
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
        XCTAssertTrue(fileExists("sharedResource/linuxpenguin.jpg"))
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
        
        //Release text resources
        manager.releaseResource("sampleText.txt")
        XCTAssertEqual(manager.referenceCountForResource("sampleText.txt"), 0)
        manager.releaseResource("sampleText2.txt")
        XCTAssertEqual(manager.referenceCountForResource("sampleText2.txt"), 0)
    }
    
    private func fileExists(filename: String) -> Bool {
        let dir = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0] as String
        return NSFileManager.defaultManager().fileExistsAtPath(dir+"/\(filename)")
    }
}
//
//  MementoNodeTests.swift
//  Memento
//
//  Unit tests for memory palace room
//
//  Created by Qua Zi Xian on 28/3/15.
//  Copyright (c) 2015 NUS CS3217. All rights reserved.
//

import Foundation
import UIKit
import XCTest

class MementoNodeTests: XCTestCase {
    func testInit(){
        let node = MementoNode(imageFile: "A.png")
        XCTAssertEqual(node.icon, MemoryPalaceRoomIcon(label: 0, filename: "A.png", overlays: []))
        XCTAssertEqual(node.numPlaceHolders, 0)
    }
    
    func testAddPlaceHolder() {
        let node = MementoNode(imageFile: "A.png")
        let placeHolder1 = RectanglePlaceHolder(highlightArea: CGRectMake(0, 0, 30, 20))
        let placeHolder2 = RectanglePlaceHolder(highlightArea: CGRectMake(40, 50, 30, 20))
        let placeHolder3 = RectanglePlaceHolder(highlightArea: CGRectMake(69, 69, 20, 20))
        let assoc1 = Association(placeHolder: placeHolder1, value: nil)
        let assoc2 = Association(placeHolder: placeHolder2, value: nil)
        
        node.addPlaceHolder(placeHolder1)
        XCTAssertEqual(node.numPlaceHolders, 1)
        XCTAssertEqual(placeHolder1.label, 0)
        XCTAssertEqual(node.associations, [assoc1])
        
        node.addPlaceHolder(placeHolder2)
        XCTAssertEqual(node.numPlaceHolders, 2)
        XCTAssertEqual(placeHolder2.label, 1)
        XCTAssertEqual(node.associations, [assoc1, assoc2])
        
        node.addPlaceHolder(placeHolder3)
        XCTAssertEqual(node.numPlaceHolders, 2)
        XCTAssertEqual(placeHolder3.label, 0)
        XCTAssertEqual(node.associations, [assoc1, assoc2])
    }
    
    func testSetAssociationValue() {
        let node = MementoNode(imageFile: "A.png")
        let placeHolder1 = RectanglePlaceHolder(highlightArea: CGRectMake(0, 0, 30, 20))
        let placeHolder2 = RectanglePlaceHolder(highlightArea: CGRectMake(40, 50, 30, 20))
        let placeHolder3 = RectanglePlaceHolder(highlightArea: CGRectMake(70, 70, 20, 20))
        var assoc1 = Association(placeHolder: placeHolder1, value: nil)
        var assoc2 = Association(placeHolder: placeHolder2, value: nil)
        var assoc3 = Association(placeHolder: placeHolder3, value: nil)
        
        node.addPlaceHolder(placeHolder1)
        node.addPlaceHolder(placeHolder2)
        node.addPlaceHolder(placeHolder3)
        XCTAssertEqual(node.numPlaceHolders, 3)
        XCTAssertEqual(node.associations, [assoc1, assoc2, assoc3])
        
        node.setAssociationValue(0, value: "3")
        assoc1 = Association(placeHolder: placeHolder1, value: "3")
        XCTAssertEqual(node.associations, [assoc1, assoc2, assoc3])
        
        node.setAssociationValue(2, value: "4")
        assoc3 = Association(placeHolder: placeHolder3, value: "4")
        XCTAssertEqual(node.associations, [assoc1, assoc2, assoc3])
        
        node.setAssociationValue(0, value: nil)
        assoc1 = Association(placeHolder: placeHolder1, value: nil)
        XCTAssertEqual(node.associations, [assoc1, assoc2, assoc3])
    }
    
    func testPlistEncoding() {
        let node = MementoNode(imageFile: "A.png")
        let overlay1 = MutableOverlay(frame: CGRectMake(30, 30, 30, 30), imageFile: "B.png")
        let overlay2 = MutableOverlay(frame: CGRectMake(45, 0, 100, 77), imageFile: "C.png")
        let placeHolder1 = RectanglePlaceHolder(highlightArea: CGRectMake(30, 30, 30, 30))
        let placeHolder2 = RectanglePlaceHolder(highlightArea: CGRectMake(100, 200, 300, 400))
        
        //Tests initial state representation
        var rep = node.plistRepresentation
        XCTAssertEqual(rep[bgImageKey] as NSString, "A.png")
        XCTAssertEqual((rep.objectForKey(overlayKey) as NSArray).count, 0)
        XCTAssertEqual((rep.objectForKey(placeHolderKey) as NSArray).count, 0)
        XCTAssertEqual((rep.objectForKey(valueKey) as NSArray).count, 0)
        
        node.addOverlay(overlay1)
        node.addOverlay(overlay2)
        node.addPlaceHolder(placeHolder1)
        node.addPlaceHolder(placeHolder2)
        rep = node.plistRepresentation
        XCTAssertEqual(rep[bgImageKey] as NSString, "A.png")
        
        //Checking the overlay objects' conversion.
        //This is a way to decode the overlay from the node's plist representation.
        XCTAssertEqual((rep.objectForKey(overlayKey) as NSArray).count, 2)
        XCTAssertEqual(MutableOverlay.decodeFromString((rep.objectForKey(overlayKey) as NSArray).objectAtIndex(0) as String), overlay1)
        XCTAssertEqual(MutableOverlay.decodeFromString((rep.objectForKey(overlayKey) as NSArray).objectAtIndex(1) as String), overlay2)
        
        //Checking the placeholders' conversion.
        //This is a way to decode the placehodler from the node's plist representation.
        XCTAssertEqual((rep.objectForKey(placeHolderKey) as NSArray).count, 2)
        XCTAssertEqual(PlaceHolder.decodeFromString((rep.objectForKey(placeHolderKey) as NSArray).objectAtIndex(0) as String), placeHolder1)
        XCTAssertEqual(PlaceHolder.decodeFromString((rep.objectForKey(placeHolderKey) as NSArray).objectAtIndex(1) as String), placeHolder2)
        
        //Checking that null values are added corresponding to each placeholder.
        XCTAssertEqual((rep.objectForKey(valueKey) as NSArray).count, 2)
        XCTAssertEqual((rep.objectForKey(valueKey) as NSArray).objectAtIndex(0) as String, "")
        XCTAssertEqual((rep.objectForKey(valueKey) as NSArray).objectAtIndex(1) as String, "")
        
        node.setAssociationValue(1, value: "Hello")
        rep = node.plistRepresentation
        
        //Repeating the previous assertions to check that the other attribute states are unaffected.
        XCTAssertEqual(rep[bgImageKey] as NSString, "A.png")
        
        XCTAssertEqual((rep.objectForKey(overlayKey) as NSArray).count, 2)
        XCTAssertEqual(MutableOverlay.decodeFromString((rep.objectForKey(overlayKey) as NSArray).objectAtIndex(0) as String), overlay1)
        XCTAssertEqual(MutableOverlay.decodeFromString((rep.objectForKey(overlayKey) as NSArray).objectAtIndex(1) as String), overlay2)
        
        XCTAssertEqual((rep.objectForKey(placeHolderKey) as NSArray).count, 2)
        XCTAssertEqual(PlaceHolder.decodeFromString((rep.objectForKey(placeHolderKey) as NSArray).objectAtIndex(0) as String), placeHolder1)
        XCTAssertEqual(PlaceHolder.decodeFromString((rep.objectForKey(placeHolderKey) as NSArray).objectAtIndex(1) as String), placeHolder2)
        
        //Checking that null values are added corresponding to each placeholder.
        XCTAssertEqual((rep.objectForKey(valueKey) as NSArray).count, 2)
        XCTAssertEqual((rep.objectForKey(valueKey) as NSArray).objectAtIndex(0) as String, "")
        XCTAssertEqual((rep.objectForKey(valueKey) as NSArray).objectAtIndex(1) as String, "Hello")
        
    }
}
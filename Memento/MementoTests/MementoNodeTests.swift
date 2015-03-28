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
        XCTAssertEqual(node.icon, MemoryPalaceRoomIcon(label: 0, filename: "A.png"))
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
}
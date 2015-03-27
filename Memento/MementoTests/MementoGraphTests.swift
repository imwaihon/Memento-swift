//
//  MementoGraphTests.swift
//  Memento
//
//  Created by Qua Zi Xian on 23/3/15.
//  Copyright (c) 2015 NUS CS3217. All rights reserved.
//

import Foundation
import UIKit
import XCTest

class MementoGraphTests: XCTestCase {
    
    func testinit() {
        let graph = MementoGraph(name: "sampleGraph", rootNode: MementoNode(imageFile: "A.png"))
        XCTAssertEqual(graph.name, "sampleGraph")
    }
    
    func testIcon() {
        let graph = MementoGraph(name: "sampleGraph", rootNode: MementoNode(imageFile: "A.png"))
        let graphIcon = graph.icon
        XCTAssertEqual(graphIcon.graphName, graph.name)
        XCTAssertEqual(graphIcon.imageFile, "A.png")
    }
    
    func testGetRoom() {
        let graph = MementoGraph(name: "sampleGraph", rootNode: MementoNode(imageFile: "A.png"))
        XCTAssertEqual(graph.getRoom(0)!.icon.filename, "A.png")
        XCTAssertTrue(graph.getRoom(-1) == nil)
        XCTAssertTrue(graph.getRoom(2) == nil)
    }
    
    func testAddRoom() {
        let graph = MementoGraph(name: "sampleGraph", rootNode: MementoNode(imageFile: "A.png"))
        graph.addRoom(MementoNode(imageFile: "B.png"))
        XCTAssertFalse(graph.getRoom(1) == nil)
        XCTAssertEqual(graph.getRoom(1)!.icon.filename, "B.png")
    }
}
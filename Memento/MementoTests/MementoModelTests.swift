//
//  MementoModelTests.swift
//  Memento
//
//  Unit tests for model.
//
//  Created by Qua Zi Xian on 28/3/15.
//  Copyright (c) 2015 NUS CS3217. All rights reserved.
//

import Foundation
import XCTest

class MementoModelTests: XCTestCase {
    func testInit() {
        let model = MementoModel()
        XCTAssertEqual(model.numPalaces, 0)
    }
    
    func testAddPalace() {
        let model = MementoModel()
        
        model.addPalace(MementoGraph(name: "graph1", rootNode: MementoNode(imageFile: "A.png")))
        XCTAssertEqual(model.numPalaces, 1)
        XCTAssertFalse(model.getPalace("graph1") == nil)
        
        model.addPalace(MementoGraph(name: "graph2", rootNode: MementoNode(imageFile: "B.png")))
        XCTAssertEqual(model.numPalaces, 2);
        XCTAssertFalse(model.getPalace("graph2") == nil)
        
        let duplicateGraph = MementoGraph(name: "graph1", rootNode: MementoNode(imageFile:"B.png"))
        model.addPalace(duplicateGraph)
        XCTAssertEqual(model.numPalaces, 3)
        XCTAssertEqual(duplicateGraph.name, "graph1(1)")
        XCTAssertFalse(model.getPalace("graph1(1)") == nil)
    }
    
    func testRemovePalace() {
        let model = MementoModel()
        
        model.addPalace(MementoGraph(name: "graph1", rootNode: MementoNode(imageFile: "A.png")))
        model.addPalace(MementoGraph(name: "graph2", rootNode: MementoNode(imageFile: "B.png")))
        XCTAssertEqual(model.numPalaces, 2)
        XCTAssertFalse(model.getPalace("graph1") == nil)
        XCTAssertFalse(model.getPalace("graph2") == nil)
        
        model.removePalace("graph1")
        XCTAssertEqual(model.numPalaces, 1)
        XCTAssertTrue(model.getPalace("graph1") == nil)
        XCTAssertFalse(model.getPalace("graph2") == nil)
        
        model.removePalace("graph2")
        XCTAssertEqual(model.numPalaces, 0)
        XCTAssertTrue(model.getPalace("graph2") == nil)
    }
}
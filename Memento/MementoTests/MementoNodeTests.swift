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
import XCTest

class MementoNodeTests: XCTestCase {
    func testInit(){
        let node = MementoNode(imageFile: "A.png")
        XCTAssertEqual(node.icon, MemoryPalaceRoomIcon(label: 0, filename: "A.png"))
        XCTAssertEqual(node.numPlaceHolders, 0)
    }
}
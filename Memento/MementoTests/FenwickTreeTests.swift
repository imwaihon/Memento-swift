//
//  FenwickTreeTests.swift
//  Memento
//
//  Unit tests for Fenwick Tree data structure.
//
//  Created by Qua Zi Xian on 3/4/15.
//  Copyright (c) 2015 NUS CS3217. All rights reserved.
//

import Foundation
import XCTest

class FenwickTreeTests: XCTestCase {
    func testOperations() {
        let ft = FenwickTree()
        XCTAssertEqual(ft.query(8), 0)
        
        ft.update(5, change: 2)
        XCTAssertEqual(ft.query(4), 0)
        XCTAssertEqual(ft.query(5), 2)
        XCTAssertEqual(ft.query(8), 2)
    }
}
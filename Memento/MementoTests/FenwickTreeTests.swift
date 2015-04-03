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
        
        //Applies a typical change
        ft.update(5, change: 2)
        XCTAssertEqual(ft.query(4), 0)
        XCTAssertEqual(ft.query(5), 2)
        XCTAssertEqual(ft.query(8), 2)
        
        //Tests querying for index outside range
        XCTAssertEqual(ft.query(10), 2)
        XCTAssertEqual(ft.query(0), 0)
        XCTAssertEqual(ft.query(-3), 0)
        
        //Applies decrement in cumulative value
        ft.update(7, change: -1)
        XCTAssertEqual(ft.query(6), 2)
        XCTAssertEqual(ft.query(7), 1)
        XCTAssertEqual(ft.query(8), 1)
        
        //Causes the unerlying array to expand.
        ft.update(15, change: 3)
        XCTAssertEqual(ft.query(14), 1)
        XCTAssertEqual(ft.query(15), 4)
        XCTAssertEqual(ft.query(16), 4)
    }
}
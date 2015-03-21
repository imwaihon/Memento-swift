//
//  SetTests.swift
//  Memento
//
//  Created by Qua Zi Xian on 20/3/15.
//  Copyright (c) 2015 NUS CS3217. All rights reserved.
//

import Foundation
import XCTest

class SetTests: XCTestCase {
    func testConstructor() {
        let set = Set<Int>()
        XCTAssertTrue(set.isEmpty)
    }
    
    func testInsert() {
        let set = Set<Int>()
        for num in 1...7 {
            set.insert(num)
        }
        for num in 1...7 {
            XCTAssertTrue(set.contains(num))
        }
        XCTAssertEqual(set.size, 7)
    }
    
    func testSmallestElement() {
        let set = Set<Int>()
        XCTAssertTrue(set.smallestElement == nil)
        
        for num in 1...7 {
            set.insert(num)
        }
        XCTAssertEqual(set.smallestElement!, 1)
    }
    
    func testLargestElement() {
        let set = Set<Int>()
        XCTAssertTrue(set.largestElement == nil)
        
        for num in 1...7 {
            set.insert(num)
        }
        XCTAssertEqual(set.largestElement!, 7)
    }
    
    func testErase() {
        let set = Set<Int>()
        for num in 1...7 {
            set.insert(num)
        }
        
        set.erase(5)
        XCTAssertFalse(set.contains(5))
        XCTAssertEqual(set.size, 6)
        
        set.erase(1)
        XCTAssertFalse(set.contains(1))
        XCTAssertEqual(set.size, 5)
        XCTAssertEqual(set.smallestElement!, 2)
        
        set.erase(7)
        XCTAssertFalse(set.contains(7))
        XCTAssertEqual(set.size, 4)
        XCTAssertEqual(set.largestElement!, 6)
        
        set.erase(2)
        XCTAssertEqual(set.size, 3)
        set.erase(3)
        XCTAssertEqual(set.size, 2)
        set.erase(4)
        XCTAssertEqual(set.size, 1)
        set.erase(6)
        XCTAssertTrue(set.isEmpty)
    }
}

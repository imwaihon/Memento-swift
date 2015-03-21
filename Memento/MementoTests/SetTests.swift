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
        let values = [7, 10, 13, 17, 15, 5, 4, 14, 16, 2, 6, 3, 1, 15, 8, 9] //These values cause all possible balancing rotations
        for value in values {
            set.insert(value)
        }
        for value in values {
            XCTAssertTrue(set.contains(value))
        }
        XCTAssertEqual(set.size, 15)
    }
    
    func testSmallestElement() {
        let set = Set<Int>()
        let values = [7, 10, 13, 17, 15, 5, 4, 14, 16, 2, 6, 3, 1, 15, 8, 9]
        XCTAssertTrue(set.smallestElement == nil)
        
        for value in values {
            set.insert(value)
        }
        XCTAssertEqual(set.smallestElement!, 1)
    }
    
    func testLargestElement() {
        let set = Set<Int>()
        let values = [7, 10, 13, 17, 15, 5, 4, 14, 16, 2, 6, 3, 1, 15, 8, 9]
        XCTAssertTrue(set.largestElement == nil)
        
        for value in values {
            set.insert(value)
        }
        XCTAssertEqual(set.largestElement!, 17)
    }
    
    func testClear() {
        let set = Set<Int>()
        let values = [7, 10, 13, 17, 15, 5, 4, 14, 16, 2, 6, 3, 1, 15, 8, 9]
        for value in values {
            set.insert(value)
        }
        for value in values {
            XCTAssertTrue(set.contains(value))
        }
        XCTAssertEqual(set.size, 15)
        
        set.clear()
        XCTAssertTrue(set.isEmpty)
        for value in values {
            XCTAssertFalse(set.contains(value))
        }
    }
    
    func testErase() {
        let set = Set<Int>()
        let values = [7, 10, 13, 17, 15, 5, 4, 14, 16, 2, 6, 3, 1, 15, 8, 9]
        
        for value in values {
            set.insert(value)
        }
        XCTAssertEqual(set.size, 15)
        
        //Tests removal as well as handling of duplicates in insertion.
        set.erase(15)
        XCTAssertFalse(set.contains(15))
        XCTAssertEqual(set.size, 14)
        
        //Tests removal of element with 2 children, causing rotation at successor's parent.
        //Rotation/Balancing is only for efficiency but is complicated.
        //Hard to test for correctness except by testing for regressions caused by balancing.
        set.erase(5)
        XCTAssertEqual(set.size, 13)
        XCTAssertFalse(set.contains(5))
        
        //Tests removal of non-existent element
        set.erase(15)
        XCTAssertEqual(set.size, 13)
        
        //Tests removal of element with only left child
        set.erase(2)
        XCTAssertEqual(set.size, 12)
        XCTAssertFalse(set.contains(2))
        
        //Tests removal of element with only left child
        set.erase(13)
        XCTAssertEqual(set.size, 11)
        XCTAssertFalse(set.contains(13))
        
        //Tests removal of smallest element and leaf.
        set.erase(1)
        XCTAssertEqual(set.size, 10)
        XCTAssertFalse(set.contains(1))
        XCTAssertEqual(set.smallestElement!, 3)
        
        //Removal of element with 2 children, with the successor being the right child.
        set.erase(8)
        set.erase(9)
        
        //This causes left rotation about 3, followed by right rotation about 6.
        set.erase(7)
        XCTAssertEqual(set.size, 7)
        
        //Removal of root
        set.erase(10)
        XCTAssertEqual(set.size, 6)
        XCTAssertFalse(set.contains(10))
        
        //Removal of largest element
        set.erase(17)
        XCTAssertEqual(set.size, 5)
        XCTAssertFalse(set.contains(17))
        XCTAssertEqual(set.largestElement!, 16)
        
        //Cause right rotation about the root
        set.erase(16)
        
        //Cause left rotation about root
        set.erase(3)
        XCTAssertEqual(set.size, 3)
        
        //Removes the remaining elements
        set.erase(4)
        set.erase(14)
        set.erase(6)
        XCTAssertTrue(set.isEmpty)
    }
}

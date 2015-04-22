//
//  MapTests.swift
//  Memento
//
//  Unit tests for balanced Binary Search Tree map.
//
//  Created by Qua Zi Xian on 5/4/15.
//  Copyright (c) 2015 NUS CS3217. All rights reserved.
//

import Foundation
import XCTest

class MapTests: XCTestCase {
    func testInsertMapping() {
        let map = Map<Int, Character>()
        let keys = [2, 1, 4, 7, 5, 18]
        let values = Array<Character>("badger")
        
        XCTAssertTrue(map.isEmpty)
        XCTAssertEqual(map.size, 0)
        for i in 0..<keys.count {
            map.insertValueForKey(keys[i], value: values[i])
            XCTAssertEqual(map.size, i+1)
        }
        
        for i in 0..<keys.count {
            XCTAssertTrue(map.containsKey(keys[i]))
            XCTAssertEqual(map.valueForKey(keys[i])!, values[i])
        }
        
        //Tests adding of duplicate key.
        map.insertValueForKey(4, value: "g")
        XCTAssertEqual(map.size, keys.count)
        XCTAssertEqual(map.valueForKey(4)!, Character("g"))
    }
    
    func testSmallestKey() {
        let map = Map<Int, Character>()
        let keys = [2, 1, 4, 7, 5, 18]
        let values = Array<Character>("badger")
        
        XCTAssertTrue(map.smallestKey == nil)
        
        map.insertValueForKey(keys[0], value: values[0])
        XCTAssertEqual(map.smallestKey!, keys[0])
        map.insertValueForKey(keys[1], value: values[1])
        XCTAssertEqual(map.smallestKey!, keys[1])
        map.insertValueForKey(keys[2], value: values[2])
        XCTAssertEqual(map.smallestKey!, keys[1])
        
        map.eraseValueForKey(keys[2])
        XCTAssertEqual(map.smallestKey!, keys[1])
        map.eraseValueForKey(keys[1])
        XCTAssertEqual(map.smallestKey!, keys[0])
        map.eraseValueForKey(keys[0])
        XCTAssertTrue(map.smallestKey == nil)
    }
    
    func testLargestKey() {
        let map = Map<Int, Character>()
        let keys = [2, 1, 4, 7, 5, 18]
        let values = Array<Character>("badger")
        
        XCTAssertTrue(map.largestKey == nil)
        
        map.insertValueForKey(keys[0], value: values[0])
        XCTAssertEqual(map.largestKey!, keys[0])
        map.insertValueForKey(keys[1], value: values[1])
        XCTAssertEqual(map.largestKey!, keys[0])
        map.insertValueForKey(keys[2], value: values[2])
        XCTAssertEqual(map.largestKey!, keys[2])
        
        map.eraseValueForKey(keys[2])
        XCTAssertEqual(map.largestKey!, keys[0])
        map.eraseValueForKey(keys[1])
        XCTAssertEqual(map.largestKey!, keys[0])
        map.eraseValueForKey(keys[0])
        XCTAssertTrue(map.largestKey == nil)
    }
    
    func testValueForSmallestKey() {
        let map = Map<Int, Character>()
        let keys = [2, 1, 4, 7, 5, 18]
        let values = Array<Character>("badger")
        
        XCTAssertTrue(map.valueForSmallestKey == nil)
        
        map.insertValueForKey(keys[0], value: values[0])
        XCTAssertEqual(map.valueForSmallestKey!, values[0])
        map.insertValueForKey(keys[1], value: values[1])
        XCTAssertEqual(map.valueForSmallestKey!, values[1])
        map.insertValueForKey(keys[2], value: values[2])
        XCTAssertEqual(map.valueForSmallestKey!, values[1])
        
        map.eraseValueForKey(keys[2])
        XCTAssertEqual(map.valueForSmallestKey!, values[1])
        map.eraseValueForKey(keys[1])
        XCTAssertEqual(map.valueForSmallestKey!, values[0])
        map.eraseValueForKey(keys[0])
        XCTAssertTrue(map.valueForSmallestKey == nil)
    }
    
    func testValueForLargestKey() {
        let map = Map<Int, Character>()
        let keys = [2, 1, 4, 7, 5, 18]
        let values = Array<Character>("badger")
        
        XCTAssertTrue(map.valueForLargestKey == nil)
        
        map.insertValueForKey(keys[0], value: values[0])
        XCTAssertEqual(map.valueForLargestKey!, values[0])
        map.insertValueForKey(keys[1], value: values[1])
        XCTAssertEqual(map.valueForLargestKey!, values[0])
        map.insertValueForKey(keys[2], value: values[2])
        XCTAssertEqual(map.valueForLargestKey!, values[2])
        
        map.eraseValueForKey(keys[2])
        XCTAssertEqual(map.valueForLargestKey!, values[0])
        map.eraseValueForKey(keys[1])
        XCTAssertEqual(map.valueForLargestKey!, values[0])
        map.eraseValueForKey(keys[0])
        XCTAssertTrue(map.valueForLargestKey == nil)
    }
    
    func testRemoveMapping() {
        let map = Map<Int, Character>()
        let keys = [2, 1, 4, 7, 5, 18]
        let values = Array<Character>("badger")
        
        for i in 0..<keys.count {
            map.insertValueForKey(keys[i], value: values[i])
        }
        
        //Insert duplicate key
        map.insertValueForKey(keys[2], value: "g")
        XCTAssertEqual(map.size, keys.count)
        
        map.eraseValueForKey(keys[2])
        XCTAssertEqual(map.size, keys.count - 1)
        XCTAssertFalse(map.containsKey(keys[2]))
        XCTAssertTrue(map.containsKey(keys[0]))
        XCTAssertTrue(map.containsKey(keys[1]))
        XCTAssertTrue(map.containsKey(keys[3]))
        XCTAssertTrue(map.containsKey(keys[4]))
        XCTAssertTrue(map.containsKey(keys[5]))
        
        //Removes a non-existent key
        map.eraseValueForKey(keys[2])
        XCTAssertEqual(map.size, keys.count - 1)
        XCTAssertFalse(map.containsKey(keys[2]))
        XCTAssertTrue(map.containsKey(keys[0]))
        XCTAssertTrue(map.containsKey(keys[1]))
        XCTAssertTrue(map.containsKey(keys[3]))
        XCTAssertTrue(map.containsKey(keys[4]))
        XCTAssertTrue(map.containsKey(keys[5]))
        
        map.eraseValueForKey(keys[4])
        XCTAssertEqual(map.size, keys.count - 2)
        XCTAssertFalse(map.containsKey(4))
        XCTAssertTrue(map.containsKey(keys[0]))
        XCTAssertTrue(map.containsKey(keys[1]))
        XCTAssertTrue(map.containsKey(keys[3]))
        XCTAssertTrue(map.containsKey(keys[5]))
        
        map.eraseValueForKey(keys[1])
        XCTAssertFalse(map.containsKey(keys[1]))
        XCTAssertEqual(map.size, keys.count - 3)
        XCTAssertTrue(map.containsKey(keys[0]))
        XCTAssertTrue(map.containsKey(keys[3]))
        XCTAssertTrue(map.containsKey(keys[5]))
        
        map.eraseValueForKey(keys[5])
        XCTAssertFalse(map.containsKey(keys[5]))
        XCTAssertEqual(map.size, keys.count - 4)
        XCTAssertTrue(map.containsKey(keys[0]))
        XCTAssertTrue(map.containsKey(keys[3]))
        
        map.eraseValueForKey(keys[0])
        XCTAssertFalse(map.containsKey(keys[0]))
        XCTAssertEqual(map.size, keys.count - 5)
        XCTAssertTrue(map.containsKey(keys[3]))
        
        map.eraseValueForKey(keys[3])
        XCTAssertFalse(map.containsKey(keys[3]))
        XCTAssertEqual(map.size, keys.count - 6)
        XCTAssertEqual(map.size, 0)
        XCTAssertTrue(map.isEmpty)
    }
    
    func testInOrderTraversal() {
        let map = Map<Int, Character>()
        let keys = [2, 1, 4, 7, 5, 18]
        let values = Array<Character>("badger")
        let expectedArr = [(1, Character("a")), (2, Character("b")), (4, Character("d")), (5, Character("e")), (7, Character("g")), (18, Character("r"))]
        
        XCTAssertTrue(map.isEmpty)
        XCTAssertEqual(map.size, 0)
        for i in 0..<keys.count {
            map.insertValueForKey(keys[i], value: values[i])
        }
        
        let resArr = map.inOrderTraversal()
        XCTAssertEqual(resArr.count, expectedArr.count)
        for i in 0..<resArr.count {
            XCTAssertEqual(resArr[i].0, expectedArr[i].0)
            XCTAssertEqual(resArr[i].1, expectedArr[i].1)
        }
    }
    
    //tests subscript methods
    func testSubscript() {
        let map = Map<Int, Character>()
        let keys = [2, 1, 4, 7, 5, 18]
        let values = Array<Character>("badger")
        
        XCTAssertEqual(map.size, 0)
        for i in 0..<keys.count {
            map[keys[i]] = values[i]
        }
        
        for i in 0..<keys.count {
            XCTAssertEqual(map.valueForKey(keys[i])!, values[i])
            XCTAssertEqual(map[keys[i]]!, values[i])
        }
        
        XCTAssertTrue(map[3] == nil)
        
        map[keys[0]] = nil
        XCTAssertFalse(map.containsKey(keys[0]))
        XCTAssertTrue(map[keys[0]] == nil)
        
        map[keys[1]] = Character("e")
        XCTAssertEqual(map[keys[1]]!, Character("e"))
    }
    
    func testClear() {
        let map = Map<Int, Character>()
        let keys = [2, 1, 4, 7, 5, 18]
        let values = Array<Character>("badger")
        let expectedArr = [(1, Character("a")), (2, Character("b")), (4, Character("d")), (5, Character("e")), (7, Character("g")), (18, Character("r"))]
        
        for i in 0..<keys.count {
            map[keys[i]] = values[i]
        }
        
        var arr = map.inOrderTraversal()
        XCTAssertFalse(arr.isEmpty)
        
        for i in 0..<arr.count {
            XCTAssertEqual(arr[i].0, expectedArr[i].0)
            XCTAssertEqual(arr[i].1, expectedArr[i].1)
        }
        
        map.clear()
        XCTAssertTrue(map.inOrderTraversal().isEmpty)
        
        map[3] = Character("z")
        arr = map.inOrderTraversal()
        XCTAssertEqual(arr.count, 1)
        XCTAssertEqual(arr[0].0, 3)
        XCTAssertEqual(arr[0].1, Character("z"))
    }
    
    func testLowerBoundOfKey() {
        let map = Map<Int, Character>()
        let keys = [2, 1, 4, 7, 5, 18]
        let values = Array<Character>("badger")

        for i in 0..<keys.count {
            map[keys[i]] = values[i]
        }
        
        XCTAssertEqual(map.lowerBoundOfKey(7)!, 7)
        XCTAssertEqual(map.lowerBoundOfKey(11)!, 18)
        XCTAssertTrue(map.lowerBoundOfKey(19) == nil)
        XCTAssertEqual(map.lowerBoundOfKey(-1)!, 1)
    }
    
    func testUpperBoundOfKey() {
        let map = Map<Int, Character>()
        let keys = [2, 1, 4, 7, 5, 18]
        let values = Array<Character>("badger")

        for i in 0..<keys.count {
            map[keys[i]] = values[i]
        }

        XCTAssertEqual(map.upperBoundOfKey(5)!, 7)
        XCTAssertEqual(map.upperBoundOfKey(-1)!, 1)
        XCTAssertEqual(map.upperBoundOfKey(11)!, 18)
        XCTAssertTrue(map.upperBoundOfKey(18) == nil)
    }
}
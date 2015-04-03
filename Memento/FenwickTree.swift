//
//  FenwickTree.swift
//  Memento
//
//  Defines the Binary-Indexed Tree for Cumulative tables.
//  Update and query operations take O(log N) time.
//
//  Special notes:
//  Currently supports only Point-Update and Range-Query.
//  This implementation only works for cardinality that fits into a signed 32-bit integer.
//
//  Created by Qua Zi Xian on 3/4/15.
//  Copyright (c) 2015 NUS CS3217. All rights reserved.
//

import Foundation

class FenwickTree {
    private let defaultSize = 9
    private var arr: [Int]
    
    //Creates a Binary Indexed Tree with the default size.
    init() {
        arr = [Int](count: defaultSize, repeatedValue: 0)
    }
    
    //Creates a Binary Indexed Tree that is able to account for size number of items.
    init(size: Int) {
        var capacity = 1
        while capacity < size {
            capacity <<= 1
        }
        arr = [Int](count: capacity + 1, repeatedValue: 0)
    }
    
    //Gets the cumulative value of elements up to the specified element.
    //index is a 1-based indexing scheme.
    func query(index: Int) -> Int {
        if index < 1 {  //Deals with invalid indices
            return 0
        }
        if index >= arr.count {
            return query(arr.count-1)
        }
        var sum = 0
        var idx = index
        while idx > 0 {
            sum += arr[idx]
            idx -= LSOne(idx)
        }
        return sum
    }
    
    //Applies the change in value at the specified index.
    //index should follow 1-based indexing.
    //change represents how much to change the value by. Use negative value to apply a decrease.
    func update(index: Int, change: Int) {
        if index < 1 {
            return
        }
        let initialSize = arr.count
        if index >= initialSize {   //Array needs to be extended.
            let initialMax = initialSize - 1    //This is always a power of 2 by design of this class.
            
            var size = initialMax   //Find the new required size of the array.
            while size < index {
                size <<= 1
            }
            arr.extend([Int](count: size - initialMax, repeatedValue: 0))
            
            let newSize = arr.count     //Updates the extended section accordingly.
            for var i = initialMax << 1; i<newSize; i <<= 1 {
                arr[i] += arr[initialMax]
            }
        }
        println("Ok")
        
        var idx = index     //The actual value update.
        while idx < arr.count {
            arr[idx] += change
            idx += LSOne(idx)
        }
    }
    
    private func LSOne(num: Int) -> Int {
        return num&(-num)
    }
}
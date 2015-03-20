//
//  Set.swift
//  Memento
//
//  Represents the balanced Binary Search Tree data structure.
//
//  Functional Specifications
//  Insert element
//  Remove element
//  Find an element
//  Get smallest element
//  Get largest element
//
//  Non-functional Specifications
//  O(log n) time complexity for functional operations.
//  No duplicate elements.
//
//  Created by Qua Zi Xian on 20/3/15.
//  Copyright (c) 2015 NUS CS3217. All rights reserved.
//

import Foundation

class Set<T: Comparable> {
    private var _root: SetNode<T>?
    private var _size: Int
    
    //Properties
    var size: Int {
        return _size
    }
    var isEmpty: Bool {
        return size == 0
    }
    var smallestElement: T? {
        if _root == nil {
            return nil
        }
        var cur = _root!
        while cur.hasLeftChild {
            cur = cur.leftChild!
        }
        return cur.value
    }
    var largestElement: T? {
        if _root == nil {
            return nil
        }
        var cur = _root!
        while cur.hasRightChild {
            cur = cur.rightChild!
        }
        return cur.value
    }
    
    init() {
        _root = nil
        _size = 0
    }
    
    //Inserts a new element into the set.
    //Does nothing if element already exists.
    func insert(elem: T) {
        if _root == nil {
            _root = SetNode<T>(value: elem, parent: nil)
        } else {
            insert(elem, curNode: _root!)
        }
        _size++
    }
    
    //The recursive insertion function
    private func insert(elem: T, curNode: SetNode<T>) {
        //Catch duplicate
        if elem == curNode.value {
            return
        }
        
        //Recursive insertion
        if elem < curNode.value {
            if curNode.hasLeftChild {
                insert(elem, curNode: curNode.leftChild!)
            } else {
                curNode.leftChild = SetNode<T>(value: elem, parent: curNode)
            }
        } else {
            if curNode.hasRightChild {
                insert(elem, curNode: curNode.rightChild!)
            } else {
                curNode.rightChild = SetNode<T>(value: elem, parent: curNode)
            }
        }
        
        //Balancing
        if curNode.balanceFactor == -2 {
            if curNode.rightChild!.balanceFactor == 1 {
                rotateRight(curNode.rightChild!)
            }
            rotateLeft(curNode)
            if curNode === _root {
                _root = curNode.parent
            }
        } else if curNode.balanceFactor == 2 {
            if curNode.leftChild!.balanceFactor == -1 {
                rotateLeft(curNode.leftChild!)
            }
            rotateRight(curNode)
            if curNode === _root {
                _root = curNode.parent
            }
        }
    }
    
    //Required: node.hasRightChild returns true
    private func rotateLeft(node: SetNode<T>) {
        assert(node.hasRightChild)
        
        let r = node.rightChild!
        
        //Link right child to parent
        if let p = node.parent {
            if node === p.leftChild {
                p.leftChild = r
            } else {
                p.rightChild = r
            }
        }
        r.parent = node.parent
        
        //Make right child the parent
        node.parent = r
        
        //Make left child of r as right child of node
        if let rl = r.leftChild {
            rl.parent = node
        }
        node.rightChild = r.leftChild
        
        //Set node as r's left child
        r.leftChild = node
    }
    
    //Required: node.hasLeftChild returns true
    private func rotateRight(node: SetNode<T>) {
        assert(node.hasLeftChild)
        
        let l = node.leftChild!
        
        //Link left child to parent
        if let p = node.parent {
            if node === p.leftChild {
                p.leftChild = l
            } else {
                p.rightChild = l
            }
        }
        l.parent = node.parent
        
        //Make left child as the parent
        node.parent = l
        
        //Make right child of l as left child of node
        if let lr = l.rightChild {
            lr.parent = node
        }
        node.leftChild = l.rightChild
        
        //Set node as l's right child
        l.rightChild = node
    }
    
    //Checks if the set contains the specified element
    func contains(elem: T) -> Bool {
        if _root == nil {
            return false
        }
        return contains(elem, curNode: _root!)
    }
    
    //The recursive binary search function
    private func contains(elem: T, curNode: SetNode<T>) -> Bool {
        if elem == curNode.value {
            return true
        }
        
        if elem < curNode.value {
            return curNode.hasLeftChild ? contains(elem, curNode: curNode.leftChild!): false
        } else {
            return curNode.hasRightChild ? contains(elem, curNode: curNode.rightChild!): false
        }
    }
    
    func erase(elem: T) {
        //To be implemented
        _size--
    }
}

class SetNode<T> {
    let value: T
    private var _leftChild: SetNode<T>?
    private var _rightChild: SetNode<T>?
    private var _leftHeight: Int
    private var _rightHeight: Int
    private var _parent: SetNode<T>?
    
    //Properties
    var hasLeftChild: Bool {
        return _leftChild != nil
    }
    var hasRightChild: Bool {
        return _rightChild != nil
    }
    var leftChild: SetNode<T>? {
        get {
            return _leftChild
        }
        set {
            _leftChild = newValue
            _leftHeight = (_leftChild == nil) ? -1: _leftChild!.height
        }
    }
    var rightChild: SetNode<T>? {
        get {
            return _rightChild
        }
        set {
            _rightChild = newValue
            _rightHeight = (_rightChild == nil) ? -1: _rightChild!.height
        }
    }
    var parent: SetNode<T>? {
        get {
            return _parent
        }
        set {
            _parent = newValue
        }
    }
    var height: Int {
        return max(_leftHeight, _rightHeight) + 1
    }
    var balanceFactor: Int {
        return _leftHeight - _rightHeight
    }
    
    init(value: T, parent: SetNode<T>?){
        self.value = value
        self._parent = parent
        _leftChild = nil
        _rightChild = nil
        _leftHeight = -1
        _rightHeight = -1
    }
}

//
//  Map.swift
//  Memento
//
//  Defines an ordered collection of mapping of keys to values using balanced Binary Search Tree.
//
//  Created by Qua Zi Xian on 5/4/15.
//  Copyright (c) 2015 NUS CS3217. All rights reserved.
//

import Foundation

class Map<K: Comparable, V> {
    private var _root: MapNode<K, V>?
    private var _size: Int
    
    //Properties
    var size: Int {
        return _size
    }
    var isEmpty: Bool {
        return size == 0
    }
    var smallestKey: K? {
        return isEmpty ? nil: minElement(_root!).key
    }
    var valueForSmallestKey: V? {
        return isEmpty ? nil: minElement(_root!).value
    }
    var largestKey: K? {
        return isEmpty ? nil: maxElement(_root!).key
    }
    var valueForLargestKey: V? {
        return isEmpty ? nil: maxElement(_root!).value
    }
    subscript(key: K) -> V? {
        get {
            return valueForKey(key)
        }
        set(newValue) {
            if newValue == nil {
                eraseValueForKey(key)
            } else {
                insertValueForKey(key, value: newValue!)
            }
        }
    }
    
    init() {
        _root = nil
        _size = 0
    }
    
    //Inserts a new element into the set.
    //Does nothing if element already exists.
    func insertValueForKey(key: K, value: V) {
        if isEmpty {
            _root = MapNode<K, V>(key: key, value: value, parent: nil)
            _size++
        } else {
            insert(MapNode<K, V>(key: key, value: value, parent: nil), curNode: _root!)
        }
    }
    
    //The recursive insertion function
    private func insert(newNode: MapNode<K, V>, curNode: MapNode<K, V>) {
        //Catch duplicate
        if newNode.key == curNode.key {
            newNode.parent = curNode.parent
            newNode.leftChild = curNode.leftChild
            newNode.rightChild = curNode.rightChild
            curNode.leftChild?.parent = newNode
            curNode.rightChild?.parent = newNode
            if curNode === _root {
                _root = newNode
            } else if let p = curNode.parent {
                if curNode === p.leftChild {
                    p.leftChild = newNode
                } else {
                    p.rightChild = newNode
                }
            }
            return
        }
        
        //Recursive insertion
        if newNode.key < curNode.key {
            if curNode.hasLeftChild {
                insert(newNode, curNode: curNode.leftChild!)
                curNode.updateHeight()
            } else {
                curNode.leftChild = newNode
                newNode.parent = curNode
                _size++
            }
        } else {
            if curNode.hasRightChild {
                insert(newNode, curNode: curNode.rightChild!)
                curNode.updateHeight()
            } else {
                curNode.rightChild = newNode
                newNode.parent = curNode
                _size++
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
    private func rotateLeft(node: MapNode<K, V>) {
        assert(node.hasRightChild)
        
        let r = node.rightChild!
        
        //Make left child of r as right child of node
        if let rl = r.leftChild {
            rl.parent = node
        }
        node.rightChild = r.leftChild
        
        //Set node as r's left child
        r.leftChild = node
        
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
        
        assert(abs(node.balanceFactor) < 2)
        assert(abs(r.balanceFactor) < 2)
    }
    
    //Required: node.hasLeftChild returns true
    private func rotateRight(node: MapNode<K, V>) {
        assert(node.hasLeftChild)
        
        let l = node.leftChild!
        
        //Make right child of l as left child of node
        if let lr = l.rightChild {
            lr.parent = node
        }
        node.leftChild = l.rightChild
        
        //Set node as l's right child
        l.rightChild = node
        
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
        
        assert(abs(node.balanceFactor) < 2)
        assert(abs(l.balanceFactor) < 2)
    }
    
    //Checks if the set contains the specified element
    func containsKey(key: K) -> Bool {
        return isEmpty ? false: containsKey(key, curNode: _root!)
    }
    
    //The recursive binary search function
    private func containsKey(key: K, curNode: MapNode<K, V>) -> Bool {
        if key == curNode.key {
            return true
        }
        
        if key < curNode.key {
            return curNode.hasLeftChild ? containsKey(key, curNode: curNode.leftChild!): false
        } else {
            return curNode.hasRightChild ? containsKey(key, curNode: curNode.rightChild!): false
        }
    }
    
    //Gets the value mapped to the given key.
    //Returns nil if the key is not found.
    func valueForKey(key: K) -> V? {
        return isEmpty ? nil: valueForKey(key, curNode: _root!)
    }
    
    private func valueForKey(key: K, curNode: MapNode<K, V>) -> V? {
        if key == curNode.key {
            return curNode.value
        }
        if key < curNode.key {
            return curNode.hasLeftChild ? valueForKey(key, curNode: curNode.leftChild!): nil
        }
        return curNode.hasRightChild ? valueForKey(key, curNode: curNode.rightChild!): nil
    }
    
    //Removes all elements from this set.
    func clear() {
        _root = nil
        _size = 0
    }
    
    //Removes the specified element from the set.
    //Does nothing if the element cannot be found.
    func eraseValueForKey(key: K) {
        if isEmpty {
            return
        }
        erase(key, curNode: _root!)
    }
    
    private func erase(key: K, curNode: MapNode<K, V>) {
        var node: MapNode<K, V>
        if key < curNode.key {
            if !curNode.hasLeftChild {
                return
            }
            erase(key, curNode: curNode.leftChild!)
            curNode.updateHeight()
            node = curNode
        } else if key > curNode.key {
            if !curNode.hasRightChild {
                return
            }
            erase(key, curNode: curNode.rightChild!)
            curNode.updateHeight()
            node = curNode
        } else {
            if !curNode.hasLeftChild && !curNode.hasRightChild {
                if let p = curNode.parent {
                    if curNode === p.leftChild {
                        p.leftChild = nil
                    } else {
                        p.rightChild = nil
                    }
                } else {
                    _root = nil
                }
                _size--
                return
            } else if curNode.hasLeftChild ^ curNode.hasRightChild {
                let c = curNode.hasLeftChild ? curNode.leftChild!: curNode.rightChild!
                c.parent = curNode.parent
                if let p = curNode.parent {
                    if curNode === p.leftChild {
                        p.leftChild = c
                    } else {
                        p.rightChild = c
                    }
                } else {
                    _root = c
                }
                node = c
            } else {
                let s = minElement(curNode.rightChild!)
                let sp = s.parent!
                s.parent = curNode.parent
                s.leftChild = curNode.leftChild
                curNode.leftChild?.parent = s
                if let p = curNode.parent {
                    if curNode === p.leftChild {
                        p.leftChild = s
                    } else {
                        p.rightChild = s
                    }
                } else {
                    _root = s
                }
                if sp !== curNode { //Removing from successor's original parent
                    sp.leftChild = s.rightChild
                    if let sr = s.rightChild {
                        sr.parent = sp
                    }
                    s.rightChild = curNode.rightChild
                    curNode.rightChild?.parent = s
                    if sp.balanceFactor == -2 { //Balancing sp after removing s as child
                        if sp.rightChild!.balanceFactor == 1 {
                            rotateRight(sp.rightChild!)
                        }
                        rotateLeft(sp)
                    }
                }
                node = s
            }
            _size--
        }
        
        //Balancing
        if node.balanceFactor == -2 {
            if node.rightChild!.balanceFactor == 1 {
                rotateRight(node.rightChild!)
            }
            rotateLeft(node)
            if curNode === _root {
                _root = node.parent
            }
        } else if node.balanceFactor == 2 {
            if node.leftChild!.balanceFactor == -1 {
                rotateLeft(node.leftChild!)
            }
            rotateRight(node)
            if node === _root {
                _root = node.parent
            }
        }
    }
    
    //Gets the array of elements stored in this set.
    func inOrderTraversal() -> [(K, V)] {
        if isEmpty {
            return [(K, V)]()
        }
        var arr = [(K, V)]()
        arr.reserveCapacity(size)
        inOrderTraversal(_root!, arr: &arr)
        return arr
    }
    
    private func inOrderTraversal(curNode: MapNode<K, V>, inout arr: [(K, V)]) {
        if curNode.hasLeftChild {
            inOrderTraversal(curNode.leftChild!, arr: &arr)
        }
        arr.append((curNode.key, curNode.value))
        if curNode.hasRightChild {
            inOrderTraversal(curNode.rightChild!, arr: &arr)
        }
    }
    
    //Gets the value for the successor key of the given key.
    //Returns nil if no such successor is found.
    func successorValueForCurrentKey(curKey: K) -> V? {
        if isEmpty {
            return nil
        }
        if let lowerBoundNode = lowerBoundNodeForKey(curKey, curNode: _root!) {
            return lowerBoundNode.key == curKey ? successor(lowerBoundNode)?.value: lowerBoundNode.value
        }
        return nil
    }
    
    //Gets the smallest key in this map that is not less than the given key.
    //Returns nil if no such key is found in this map.
    func lowerBoundOfKey(key: K) -> K? {
        return isEmpty ? nil: lowerBoundNodeForKey(key, curNode: _root!)?.key
    }
    
    //Gets the node with key that does not compare less than the given key in the tree rooted at the given node.
    private func lowerBoundNodeForKey(key: K, curNode: MapNode<K, V>) -> MapNode<K, V>? {
        if key == curNode.key {
            return curNode
        }
        if key < curNode.key {
            return curNode.hasLeftChild ? lowerBoundNodeForKey(key, curNode: curNode.leftChild!): curNode
        }
        return curNode.hasRightChild ? lowerBoundNodeForKey(key, curNode: curNode.rightChild!): successor(curNode)
    }
    
    //Returns the node with the next smallest value or nil if no such node exists
    private func successor(node: MapNode<K, V>) -> MapNode<K, V>? {
        if node.hasRightChild {
            return minElement(node.rightChild!)
        }
        var p = node.parent
        var cur = node
        while p != nil && cur === p!.rightChild {
            cur = p!
            p = p?.parent
        }
        return p
    }
    
    private func minElement(root: MapNode<K, V>) -> MapNode<K, V> {
        var node = root
        while node.hasLeftChild {
            node = node.leftChild!
        }
        return node
    }
    
    private func maxElement(root: MapNode<K, V>) -> MapNode<K, V> {
        var node = root
        while node.hasRightChild {
            node = node.rightChild!
        }
        return node
    }
}

class MapNode<K: Comparable, V> {
    let key: K
    let value: V
    private var _leftChild: MapNode<K, V>?
    private var _rightChild: MapNode<K, V>?
    private var _leftHeight: Int
    private var _rightHeight: Int
    private var _parent: MapNode<K, V>?
    
    //Properties
    var hasLeftChild: Bool {
        return _leftChild != nil
    }
    var hasRightChild: Bool {
        return _rightChild != nil
    }
    var leftChild: MapNode<K, V>? {
        get {
            return _leftChild
        }
        set {
            _leftChild = newValue
            _leftHeight = (_leftChild == nil) ? -1: _leftChild!.height
        }
    }
    var rightChild: MapNode<K, V>? {
        get {
            return _rightChild
        }
        set {
            _rightChild = newValue
            _rightHeight = (_rightChild == nil) ? -1: _rightChild!.height
        }
    }
    var parent: MapNode<K, V>? {
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
    
    init(key: K, value: V, parent: MapNode<K, V>?){
        self.key = key
        self.value = value
        self._parent = parent
        _leftChild = nil
        _rightChild = nil
        _leftHeight = -1
        _rightHeight = -1
    }
    
    func updateHeight() {
        _leftHeight = hasLeftChild ? _leftChild!.height: -1
        _rightHeight = hasRightChild ? _rightChild!.height: -1
    }
}

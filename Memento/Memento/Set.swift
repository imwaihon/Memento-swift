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
        return isEmpty ? nil: minElement(_root!).value
    }
    var largestElement: T? {
        return isEmpty ? nil: maxElement(_root!).value
    }
    
    init() {
        _root = nil
        _size = 0
    }
    
    //Inserts a new element into the set.
    //Does nothing if element already exists.
    func insert(elem: T) {
        if isEmpty {
            _root = SetNode<T>(value: elem, parent: nil)
            _size++
        } else {
            insert(elem, curNode: _root!)
        }
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
                curNode.updateHeight()
            } else {
                curNode.leftChild = SetNode<T>(value: elem, parent: curNode)
                _size++
            }
        } else {
            if curNode.hasRightChild {
                insert(elem, curNode: curNode.rightChild!)
                curNode.updateHeight()
            } else {
                curNode.rightChild = SetNode<T>(value: elem, parent: curNode)
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
    private func rotateLeft(node: SetNode<T>) {
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
    private func rotateRight(node: SetNode<T>) {
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
    func contains(elem: T) -> Bool {
        if isEmpty {
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
    
    //Removes all elements from this set.
    func clear() {
        removeSubtreeOf(_root)
        _size = 0
    }
    
    //Removes the specified element from the set.
    //Does nothing if the element cannot be found.
    func erase(elem: T) {
        if isEmpty {
            return
        }
        erase(elem, curNode: _root!)
    }
    
    private func erase(elem: T, curNode: SetNode<T>) {
        var node: SetNode<T>
        if elem < curNode.value {
            if !curNode.hasLeftChild {
                return
            }
            erase(elem, curNode: curNode.leftChild!)
            curNode.updateHeight()
            node = curNode
        } else if elem > curNode.value {
            if !curNode.hasRightChild {
                return
            }
            erase(elem, curNode: curNode.rightChild!)
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
    func inOrderTraversal() -> [T] {
        if isEmpty {
            return [T]()
        }
        var arr = [T]()
        arr.reserveCapacity(size)
        inOrderTraversal(_root!, arr: &arr)
        return arr
    }
    
    private func inOrderTraversal(curNode: SetNode<T>, inout arr: [T]) {
        if curNode.hasLeftChild {
            inOrderTraversal(curNode.leftChild!, arr: &arr)
        }
        arr.append(curNode.value)
        if curNode.hasRightChild {
            inOrderTraversal(curNode.rightChild!, arr: &arr)
        }
    }
    
    //Returns the node with the next smallest value or nil if no such node exists
    private func successor(node: SetNode<T>) -> SetNode<T>? {
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
    
    private func minElement(root: SetNode<T>) -> SetNode<T> {
        var node = root
        while node.hasLeftChild {
            node = node.leftChild!
        }
        return node
    }
    
    private func maxElement(root: SetNode<T>) -> SetNode<T> {
        var node = root
        while node.hasRightChild {
            node = node.rightChild!
        }
        return node
    }
    
    //Remcursively removes child nodes
    private func removeSubtreeOf(node: SetNode<T>?) {
        if node == nil {
            return
        }
        removeSubtreeOf(node?.leftChild)
        removeSubtreeOf(node?.rightChild)
        node?.leftChild = nil
        node?.rightChild = nil
    }
    
    deinit {
        removeSubtreeOf(_root)
        _root = nil
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
    
    func updateHeight() {
        _leftHeight = hasLeftChild ? _leftChild!.height: -1
        _rightHeight = hasRightChild ? _rightChild!.height: -1
    }
}

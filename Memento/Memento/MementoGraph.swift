//
//  MementoGraph.swift
//  Memento
//
//  Represents a graph object in the application.
//
//  Specifications:
//  Able to represent multigraphs.
//  Easily identify and access to all nodes in the graph.
//  Identifying/Enumerating distinct neighbours of any node.
//  Insert/Remove nodes and edges without having to relabel nodes.
//  Generate a level graph using Breadth-First Search.
//
//  Non-functional requirements:
//  Acceptably low latency for all methods.
//  Compact node labelling range.
//
//  Representation Invariant(s)
//  Graph should have at least 1 node.
//  There should be at most 1 edge between any pair of nodes.
//
//  Created by Qua Zi Xian on 19/3/15.
//  Copyright (c) 2015 NUS CS3217. All rights reserved.
//

import Foundation

class MementoGraph {
    let name: String
    private var adjList: [[Int]]
    private var nodes: [MementoNode?]
    private let nodeLabelGenerator: Set<Int>
    
    //Properties
    var rootIcon: MementoNodeIcon {
        return nodes[0]!.icon
    }
    
    init(name: String, root: MementoNode) {
        self.name = name
        adjList = [[Int]]()
        nodes = [MementoNode?]()
        //associations = [Association]()
        //links = [Link]()
        
        nodeLabelGenerator = Set<Int>() //Initialise a small set of available labels
        for idx in 0...10 {
            nodeLabelGenerator.insert(idx)
        }
        
        insertNode(root)
    }
    
    private func insertNode(node: MementoNode){
        node.label = nodeLabelGenerator.smallestElement!
        nodeLabelGenerator.erase(node.label)
        
        //node.label is guaranteed to be < nodes.count at all times.
        if node.label >= nodes.count {
            nodes.append(node)
            adjList.append([Int]())
        } else {
            nodes[node.label] = node
            adjList[node.label].removeAll(keepCapacity: false)
        }
        
        //Replenish the label generator's labels
        if nodeLabelGenerator.size < 3 {
            let base = nodeLabelGenerator.largestElement!+1
            for i in 0...9 {
                nodeLabelGenerator.insert(base+i)
            }
        }
    }
    
    private func insertEdge(source: MementoNode, destination: MementoNode){
        let sLabel = source.label
        let dLabel = destination.label
        assert(sLabel>=0 && sLabel<nodes.count && nodes[sLabel] != nil)
        assert(dLabel>=0 && dLabel<nodes.count && nodes[dLabel] != nil)
        if !contains(adjList[sLabel], dLabel) {
            adjList[sLabel].append(dLabel)
        }
        if !contains(adjList[dLabel], sLabel) {
            adjList[dLabel].append(sLabel)
        }
    }
    
    //Gets the node with the given label.
    //Returns nil if the node does not exist or the label is invalid.
    func getNode(label: Int) -> MementoNode? {
        if label < 0 || label >= nodes.count {
            return nil
        }
        return nodes[label]
    }
    
    //Gets the neighbours of the given node
    //Returns an empty list if the given node does not exist or is invalid.
    func getNeighbourIcons(node: MementoNodeIcon) -> [MementoNodeIcon] {
        let sLabel = node.label
        let set = Set<Int>()
        var res = [MementoNodeIcon]()
        
        if sLabel < 0 || sLabel >= nodes.count || nodes[sLabel] == nil {
            return res
        }
        
        let size = adjList[sLabel].count
        for i in 0..<size {
            let dLabel = adjList[sLabel][i]
            if !set.contains(dLabel) {
                assert(nodes[dLabel] != nil)
                res.append(nodes[dLabel]!.icon)
            }
        }
        return res
    }
}

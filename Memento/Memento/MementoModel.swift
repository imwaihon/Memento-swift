//
//  MementoModel.swift
//  Memento
//
//  The app model that stores teh runtime representations of the graphs and nodes.
//
//  Specifications:
//  Add graphs
//  Remove graphs
//
//  Non-Functional Specifications:
//  Able to save the graphs
//  Deal with graph name collisions
//
//  Created by Qua Zi Xian on 25/3/15.
//  Copyright (c) 2015 NUS CS3217. All rights reserved.
//

import Foundation

class MementoModel {
    private var graphs: [MementoGraph]
    private var names: NSMutableSet
    private var graphMap: [String: Int]
    
    //Properties
    var numPalaces: Int {
      return graphs.count
    }
    var palaceIcons: [MemoryPalaceIcon] {
        var arr = [MemoryPalaceIcon]()
        for i in 0..<numPalaces {
            arr.append(graphs[i].icon)
        }
        return arr
    }
    
    init(){
        graphs = [MementoGraph]()
        names = NSMutableSet()
        graphMap = [String: Int]()
    }
    
    //Adds the new graph to the collection.
    func addPalace(palace: MementoGraph){
        
        var name = palace.name
        if graphMap[name] != nil { //Check for collision
            for var i=1; ; i++ {
                if graphMap[name+"(\(i))"] == nil {   //Assume NSMutableSet is hash set, this is O(NM)
                    palace.name = name+"(\(i))"
                    break
                }
            }
        }
        graphMap[palace.name] = graphs.count
        graphs.append(palace)
        
        //Save changes?
    }
    
    //Gets the specified memory palace.
    //Returns nil if palaceNumber<0 or palaceNumber>=numPalaces.
    func getPalace(palaceName: String) -> MementoGraph? {
        if let index = graphMap[palaceName] {
            return graphs[index]
        }
        return nil
    }
    
    //Removes the specified memory palace.
    //Does nothing if palaceNumber<0 or palaceNumber>=numPalaces.
    func removePalace(palaceName: String){
        if let index = graphMap[palaceName] {
            for i in (index+1)..<graphs.count {
                graphMap[graphs[i].name]?--
            }
            graphMap[graphs[index].name] = nil
            graphs.removeAtIndex(index)
        } else {
            return
        }
        
        //Save changes?
    }
    
    private func isValidPalaceNumber(palaceNumber: Int) -> Bool {
        return palaceNumber >= 0 && palaceNumber < graphs.count
    }
}
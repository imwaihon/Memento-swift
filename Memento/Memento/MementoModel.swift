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
    
    //Properties
    var numPalaces: Int {
      return graphs.count
    }
    
    init(){
        graphs = [MementoGraph]()
        names = NSMutableSet()
    }
    
    //Adds the new graph to the collection.
    func addPalace(palace: MementoGraph){
        graphs.append(palace)
        
        var name = palace.name
        if names.containsObject(name) { //Check for collision
            for var i=1; ; i++ {
                if !names.containsObject(name+"(\(i))") {   //Assume NSMutableSet is hash set, this is O(NM)
                    palace.name = name+"(\(i))"
                    break
                }
            }
        }
        names.addObject(palace.name)
        
        //Save changes?
    }
    
    //Gets the specified memory palace.
    //Returns nil if palaceNumber<0 or palaceNumber>=numPalaces.
    func getPalace(palaceNumber: Int) -> MementoGraph? {
        if !isValidPalaceNumber(palaceNumber) {
            return nil
        }
        return graphs[palaceNumber]
    }
    
    //Removes the specified memory palace.
    //Does nothing if palaceNumber<0 or palaceNumber>=numPalaces.
    func removePalace(palaceNumber: Int){
        if !isValidPalaceNumber(palaceNumber) {
            return
        }
        let palace = graphs[palaceNumber]
        graphs.removeAtIndex(palaceNumber)
        names.removeObject(palace.name)
        
        //Save changes?
    }
    
    private func isValidPalaceNumber(palaceNumber: Int) -> Bool {
        return palaceNumber >= 0 && palaceNumber < graphs.count
    }
}
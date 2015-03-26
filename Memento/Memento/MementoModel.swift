//
//  MementoModel.swift
//  Memento
//
//  The app model that stores teh runtime representations of the graphs and nodes.
//
//  Created by Qua Zi Xian on 25/3/15.
//  Copyright (c) 2015 NUS CS3217. All rights reserved.
//

import Foundation

class MementoModel {
    private var graphs: [MementoGraph]
    
    //Properties
    var numPalaces: Int {
      return graphs.count
    }
    
    init(){
        graphs = [MementoGraph]()
    }
    
    //Adds the new graph to the collection.
    func addPalace(palace: MementoGraph){
        graphs.append(palace)
        
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
        graphs.removeAtIndex(palaceNumber)
        
        //Save changes?
    }
    
    private func isValidPalaceNumber(palaceNumber: Int) -> Bool {
        return palaceNumber >= 0 && palaceNumber < graphs.count
    }
}
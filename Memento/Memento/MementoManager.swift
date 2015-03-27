//
//  AppManager.swift
//  Memento
//
//  The facade class that receives ALL requests from the controller.
//  This class hides all the complexity of native backend operations.
//
//  Created by Qua Zi Xian on 24/3/15.
//  Copyright (c) 2015 NUS CS3217. All rights reserved.
//

import Foundation

class MementoManager: MemoryPalaceManager {
    private var selectedPalace: MementoGraph?
    private var selectedRoom: MementoNode?
    private let model: MementoModel
    private let graphFactory: MementoGraphFactory
    private let nodeFactory: MementoNodeFactory

    //Properties
    var numberOfMemoryPalace: Int {
        return model.numPalaces
    }
    
    init(){
        selectedPalace = nil
        selectedRoom = nil
        model = MementoModel()
        graphFactory = MementoGraphFactory()
        nodeFactory = MementoNodeFactory()
    }
    
    //Adds a new memory palace
    func addMemoryPalace(named name: String, imageFile: String){
        let newGraph = graphFactory.makeGraph(named: name, imageFile: imageFile)
        model.addPalace(newGraph)
    }
    
    //Gets the specified memory palace
    //Returns nil if the specified memory palce does not exist.
    func getMemoryPalace(palaceNumber: Int) -> MemoryPalace? {
        return model.getPalace(palaceNumber)
    }
    
    //Removes the specified memory palace
    //Does nothing if no memory palace is represented by the given palaceNumber
    func removeMemoryPalace(palaceNumber: Int){
        //Perform integrity checks
        
        model.removePalace(palaceNumber)
    }
    
    //Adds a new room to the current memory palace.
    //Does nothing if no memory palace is selected.
    func addMemoryPalaceRoom(){
        if selectedPalace == nil {
            return
        }
    }
}
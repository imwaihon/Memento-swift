//
//  MementoModel.swift
//  Memento
//
//  The app model that stores teh runtime representations of the graphs and nodes.
//
//  Specifications:
//  Add memory palace
//  Get memory palace
//  Remove memort palace
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
    
    // Singleton pattern
    class var sharedInstance: MementoModel {
        struct Static {
            static var instance: MementoModel?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            Static.instance = MementoModel()
        }
        
        return Static.instance!
    }
    
    private var saveLoadManager: SaveLoadManager
    private var graphs: [MementoGraph]
    private var graphMap: [String: Int]
    let saveQueue: dispatch_queue_t
    
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
        saveLoadManager = SaveLoadManager.sharedInstance
        graphs = [MementoGraph]()
        graphMap = [String: Int]()
        saveQueue = dispatch_queue_create("com.cs3217.Memento", DISPATCH_QUEUE_SERIAL)
        loadGraphs()
    }
    
    /// Checks if the memory palace with the given name exists.
    ///
    /// :param: palaceName The name of the memory palace to query.
    /// :returns: true if the memory palace exists and false otherwise.
    func containsPalace(palaceName: String) -> Bool {
        return graphMap[palaceName] != nil
    }
    
    /// Adds the new graph to the collection.
    ///
    /// :param: palace The memory palace to add.
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
        
        //Save the new palace
        dispatch_async(saveQueue, {() -> Void in
            self.savePalace(palace)
        })
    }
    
    /// Gets the specified memory palace.
    ///
    /// :param: palaceName The name of the memory palace to retrieve.
    /// :returns: The memory palace with the given name. Returns nil if no such palace is found.
    func getPalace(palaceName: String) -> MementoGraph? {
        if let index = graphMap[palaceName] {
            return graphs[index]
        }
        return nil
    }
    
    /// Removes the specified memory palace. Does nothing if no such palace is found.
    ///
    /// :param: palaceName The name of the memory palace to remove.
    func removePalace(palaceName: String){
        if let index = graphMap[palaceName] {
            for i in (index+1)..<graphs.count {
                graphMap[graphs[i].name]?--
            }
            graphMap[palaceName] = nil
            graphs.removeAtIndex(index)
        } else {
            return
        }
        
        //Save changes
        dispatch_async(saveQueue, {() -> Void in
            //Make call to delete the palace file
            self.saveLoadManager.deletePalace(palaceName)
        })
    }
    
    /// Adds the given room to the specified memory palace.
    ///
    /// :param: palaceName The name of the memory palace to add the new room to.
    /// :param: room The memory palace room to add.
    /// :returns: true if the memory palace room is added. Returns false if the memory palace does not exist.
    func addPalaceRoom(palaceName: String, room: MementoNode) -> Bool {
        if let palace = getPalace(palaceName) {
            palace.addRoom(room)
            
            //Save changes
            dispatch_async(saveQueue, {() -> Void in
                self.savePalace(palace)
            })
            return true
        }
        return false
    }
    
    /// Gets the memory palace room with the given room number from the specified memory palace.
    ///
    /// :param: palaceName The name of the memory palace to get the room from.
    /// :param: roomLabel The label of the memory palace room to retrieve.
    /// :returns: The memory palace room with the given label from the given memory palace. Returns nil if either the memory palace or the room is missing.
    func getMemoryPalaceRoom(palaceName: String, roomLabel: Int) -> MementoNode? {
        if let palace = getPalace(palaceName) {
            return palace.getRoom(roomLabel)
        }
        return nil
    }
    
    /// Removes the room from the specified memory palace. Does nothing if the memory palace does not exist.
    ///
    /// :param: palaceName The name of the memry palace to remove the room from.
    /// :param: roomLabel The label of the memory palace room to remove.
    func removeMemoryPalaceRoom(palaceName: String, roomLabel: Int) {
        if let palace = getPalace(palaceName) {
            palace.removeRoom(roomLabel)
            
            //Save changes
            dispatch_async(saveQueue, {() -> Void in
                self.savePalace(palace)
            })
        }
    }
    
    private func savePalace(palace: MementoGraph) {
        saveLoadManager.savePalaceToFile(palace)
    }
    
    /// Saves the memory palace with the given name. Does nothing if the memory palace cannot be found.
    ///
    /// :param: palaceName The name of the memory palace to save.
    func savePalace(palaceName: String) {
        //To be implmented once the SaveLoadManager is working.
        if let palace = getPalace(palaceName) {
            saveLoadManager.savePalaceToFile(palace)
        }
    }
    
    private func loadGraphs() {
        graphs = saveLoadManager.loadAllPalaces()
        let numGraphs = graphs.count
        for i in 0..<numGraphs {
            graphMap[graphs[i].name] = i
        }
    }
}
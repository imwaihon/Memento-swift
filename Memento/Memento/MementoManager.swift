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
    
    // Singleton pattern
    class var sharedInstance: MementoManager {
        struct Static {
            static var instance: MementoManager?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            Static.instance = MementoManager()
        }
        
        return Static.instance!
    }
    
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
        model = MementoModel.sharedInstance
        graphFactory = MementoGraphFactory()
        nodeFactory = MementoNodeFactory()
    }
    
    //Gets the list of con representation of existing memory palaces.
    func getMemoryPalaceIcons() -> [MemoryPalaceIcon] {
        return model.palaceIcons
    }
    
    //Adds a new memory palace
    //If there exists another memory palace with the same name, a number will be appended to the
    //new memory palace's name.
    //Returns the name of the added memory palace as a confirmation.
    func addMemoryPalace(named name: String, imageFile: String) -> String {
        let newGraph = graphFactory.makeGraph(named: name, imageFile: imageFile)
        model.addPalace(newGraph)
        return newGraph.name
    }
    
    //Gets the specified memory palace
    //Returns nil if the specified memory palce does not exist.
    func getMemoryPalace(palaceName: String) -> MemoryPalace? {
        return model.getPalace(palaceName)
    }
    
    //Returns an array of memory palace node icons
    //Returns nil if there is no memory palace of the given name
    func getPalaceOverview(palaceName: String) -> [MemoryPalaceRoomIcon]? {
        if let palace = model.getPalace(palaceName) {
            return palace.nodeIcons
        }
        return nil
    }
    
    //Removes the specified memory palace
    //Does nothing if no memory palace has the given name
    func removeMemoryPalace(palaceName: String){
        model.removePalace(palaceName)
    }
    
    //Adds a new room to the current memory palace.
    //Does nothing if no memory palace is selected.
    func addMemoryPalaceRoom(palaceName: String, roomImage: String){
        model.addPalaceRoom(palaceName, room: nodeFactory.makeNode(roomImage))
    }
    
    //Gets the memory palace room.
    //Returns nil if the memory palace or the room does not exist.
    func getMemoryPalaceRoom(palaceName: String, roomLabel: Int) -> MemoryPalaceRoom? {
        return model.getMemoryPalaceRoom(palaceName, roomLabel: roomLabel)
    }
    
    //Gets the view object representation of the memory palace room.
    //Returns nil if the memory palace or the room does not exist.
    func getMemoryPalaceRoomView(palaceName: String, roomLabel: Int) -> MemoryPalaceRoomView? {
        return (model.getMemoryPalaceRoom(palaceName, roomLabel: roomLabel)? as MementoNode).viewRepresentation
    }
    
    //Removes the specified room from the specified memory palace.
    //Does nothign if either the memory palace or the room is invalid.
    func removeMemoryPalaceRoom(palaceName: String, roomLabel: Int) {
        model.removeMemoryPalaceRoom(palaceName, roomLabel: roomLabel)
    }
    
    //Gets the name that will be used for the memory
    func generatePalaceName(baseName: String) -> String {
        return model.generatePalaceName(baseName)
    }
    
    //Saves the memory palace with the given name.
    //Does nothing if the memory palace cannot be found.
    func savePalace(palaceName: String) {
        model.savePalace(palaceName)
    }
}
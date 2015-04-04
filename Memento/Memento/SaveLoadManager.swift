//
//  SaveLoadManager.swift
//  Memento
//
//  Created by Chee Wai Hon on 31/3/15.
//  Copyright (c) 2015 NUS CS3217. All rights reserved.
//

import Foundation

class SaveLoadManager {
    
    // Singleton pattern
    class var sharedInstance: SaveLoadManager {
        struct Static {
            static var instance: SaveLoadManager?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            Static.instance = SaveLoadManager()
        }
        
        return Static.instance!
    }
    
    private let graphFactory: MementoGraphFactory
    
    init() {
        graphFactory = MementoGraphFactory()
    }
    
    func checkFolder() {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray
        let documentsDirectory = paths.objectAtIndex(0) as String
        let path = documentsDirectory.stringByAppendingPathComponent("data")
        
        let fileManager = NSFileManager.defaultManager()
        var error: NSError?
        
        if (!fileManager.fileExistsAtPath(path)) {
            // Folder does not exist, create folder
            if !fileManager.createDirectoryAtPath(path, withIntermediateDirectories: true, attributes: nil, error: &error) {
                println("Failed to create dir: \(error!.localizedDescription)")
                return
            }
        }
    }
    
    // Saves the representation of the memory palace (memento graph)
    func savePalaceToFile(palace: MementoGraph) {
        let palaceName = palace.name
        
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray
        let documentsDirectory = paths.objectAtIndex(0) as String
        let path = documentsDirectory.stringByAppendingPathComponent("data").stringByAppendingPathComponent("\(palaceName)")
        let graphPath = path.stringByAppendingPathComponent("graph.plist")
        
        let fileManager = NSFileManager.defaultManager()
        
        var graphData: NSDictionary?
        var error: NSError?
        
        if (!fileManager.fileExistsAtPath(path)) {
            // Folder does not exist, new palace
            if !fileManager.createDirectoryAtPath(path, withIntermediateDirectories: true, attributes: nil, error: &error) {
                println("Failed to create dir: \(error!.localizedDescription)")
                return
            }
            
            // Create the attribute and graph files
            graphData = NSDictionary()
            
        } else {
            // Just load the plist files
            graphData = NSDictionary(contentsOfFile: graphPath)
            
        }
        
        if graphData != nil {
            
            // Obtain graph data here
            graphData = palace.plistRepresentation
            
            graphData!.writeToFile(graphPath, atomically: true)
            NSLog(graphPath)
            
        }
    }
    
    // Saves shared resources such as images for layers/photos
    func saveSharedResource() {
        
    }


    // Deletes Palace directory
    func deletePalace(palaceName: String) {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray
        let documentsDirectory = paths.objectAtIndex(0) as String
        let path = documentsDirectory.stringByAppendingPathComponent("data").stringByAppendingPathComponent("\(palaceName)")
        
        let fileManager = NSFileManager.defaultManager()
        
        if (fileManager.fileExistsAtPath(path)) {
            fileManager.removeItemAtPath(path, error: nil)
        }
        
    }
    
    
    func loadAllPalaces() -> [MementoGraph] {
        checkFolder()
        
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray
        let documentsDirectory = paths.objectAtIndex(0) as String
        let path = documentsDirectory.stringByAppendingPathComponent("data")
        
        let fileManager = NSFileManager.defaultManager()
        let palacesFilenames = fileManager.contentsOfDirectoryAtPath(path, error: nil)! as NSArray
        
        var result = [MementoGraph]()
        
        for filename in palacesFilenames {
            result.append(loadPalace(filename as String))
        }
        
        return result
    }
    
    func loadPalace(palaceName: String) -> MementoGraph {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray
        let documentsDirectory = paths.objectAtIndex(0) as String
        let path = documentsDirectory.stringByAppendingPathComponent("data").stringByAppendingPathComponent("\(palaceName)")
        let graphPath = path.stringByAppendingPathComponent("graph.plist")
        
        var graphData = NSDictionary(contentsOfFile: graphPath)!
        
        var createdGraph = graphFactory.decodeAndMakeGraph(graphData)
        
        return createdGraph
    }
}
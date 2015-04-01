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
    
    // Saves the representation of the memory palace (memento graph)
    func savePalaceToFile(palace: MementoGraph) {
        let palaceName = palace.name
        
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray
        let documentsDirectory = paths.objectAtIndex(0) as String
        let path = documentsDirectory.stringByAppendingPathComponent("data").stringByAppendingPathComponent("\(palaceName)")
        let attributePath = path.stringByAppendingPathComponent("attribute")
        let graphPath = path.stringByAppendingPathComponent("graph")
        
        let fileManager = NSFileManager.defaultManager()
        
        var attributeData: NSMutableDictionary?
        var graphData: NSMutableArray?
        var error: NSError?
        
        if (!fileManager.fileExistsAtPath(path)) {
            // Folder does not exist, new palace
            if !fileManager.createDirectoryAtPath(path, withIntermediateDirectories: true, attributes: nil, error: &error) {
                println("Failed to create dir: \(error!.localizedDescription)")
                return
            }
            
            attributeData = NSMutableDictionary()
            graphData = NSMutableArray()
            
        } else {
            attributeData = NSMutableDictionary(contentsOfFile: attributePath)
            graphData = NSMutableArray(contentsOfFile: graphPath)
            
        }
        
        if attributeData != nil && graphData != nil {
            
            // Obtain attribute and graph data here
            
            attributeData!.writeToFile(attributePath, atomically: true)
            graphData!.writeToFile(graphPath, atomically: true)
            
        }
        
    }
    
    // Saves shared resources such as images for layers/photos
    func saveSharedResource() {
        
    }
    
    func loadPalace() {
        
    }
}
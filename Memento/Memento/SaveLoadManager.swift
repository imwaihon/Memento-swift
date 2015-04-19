//
//  SaveLoadManager.swift
//  Memento
//
//  The component that is responsible for saving and loading memory palace to/from files.
//
//  Abstraction Functions and Specifications:
//  Save memory palace:         savePalaceToFile(palace: MementoGraph)
//  Load memory palace:         loadPalace(palaceName: String) -> MementoGraph?
//  Load all memory palace:     loadAllPalace() -> [MementoGraph]
//  Remove memory palace:       deletePalace(palaceName: String)
//
//  Created by Chee Wai Hon on 31/3/15.
//  Copyright (c) 2015 NUS CS3217. All rights reserved.
//

import Foundation
import UIKit

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
    
    private let dirPath: String     //The directory where all memory palace data is stored
    private let plistExtension = "plist"
    private let graphFactory: MementoGraphFactory
    
    init() {
        graphFactory = MementoGraphFactory()
        
        //Compute the directory path to store the memory palaces.
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray
        let documentsDirectory = paths.objectAtIndex(0) as String
        dirPath = documentsDirectory.stringByAppendingPathComponent("data")
        
        checkFolder()
    }
    
    // Check folder if exist, if not, create one
    private func checkFolder() {
        let fileManager = NSFileManager.defaultManager()
        var error: NSError?
        
        //Create data folder if it does not exist.
        var isDirectory: ObjCBool = false
        let directoryExists = fileManager.fileExistsAtPath(dirPath, isDirectory: &isDirectory)
        if !directoryExists || !isDirectory {
            fileManager.createDirectoryAtPath(dirPath, withIntermediateDirectories: false, attributes: nil, error: nil)
        }
    }
    
    // Saves the representation of the memory palace (memento graph)
    func savePalaceToFile(palace: MementoGraph) {
        let palaceName = palace.name
        let path = dirPath.stringByAppendingPathComponent(palaceName).stringByAppendingPathExtension(plistExtension)!
        palace.plistRepresentation.writeToFile(path, atomically: true)
    }

    // Deletes Palace directory
    func deletePalace(palaceName: String) {
        let path = dirPath.stringByAppendingPathComponent(palaceName).stringByAppendingPathExtension(plistExtension)!
        NSFileManager.defaultManager().removeItemAtPath(path, error: nil)
    }
    
    //Gets the list of saved memory palaces.
    //Returns: A list of memory palaces constructed from their saved files.
    func loadAllPalaces() -> [MementoGraph] {
        var arr = [MementoGraph]()
        if let filenames = (NSFileManager.defaultManager().contentsOfDirectoryAtPath(dirPath, error: nil) as? [String]) {
            for filename in filenames {
                if let palace = loadPalace(filename) {
                    arr.append(palace)
                }
            }
        }
        return arr
    }
    
    //Loads the memory palace with the given name.
    //Returns: The constructed memory palace if the file corresponding to the specified memory palace is found. Returns
    //          nil otherwise.
    func loadPalace(palaceName: String) -> MementoGraph? {
        let path = dirPath.stringByAppendingPathComponent(palaceName).stringByAppendingPathExtension(plistExtension)!
        
        if let graphData = NSDictionary(contentsOfFile: path) {
            return graphFactory.decodeAndMakeGraph(graphData)
        }
        
        return nil
    }
    
    //To be deleted once the game controller changes over to loading image using UIImage constructor
    func loadOverlayImage(imageName: String) -> UIImage? {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray
        let documentsDirectory = paths.objectAtIndex(0) as String
        let path = documentsDirectory.stringByAppendingPathComponent(imgResourceDir)
        let overlayPath = path.stringByAppendingPathComponent("\(imageName)")
    
        
        let fileManager = NSFileManager.defaultManager()
        
        if (fileManager.fileExistsAtPath(overlayPath)) {
            var image = UIImage(contentsOfFile: overlayPath)
            return image
        } else {
            return nil
        }
    }
}
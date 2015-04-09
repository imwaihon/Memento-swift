//
//  ResourceManager.swift
//  Memento
//
//  The object that manages resources in the specified directory within the app's Documents directory(non-recursive).
//  This class uses manual reference counting mechanism.
//  To achieve auto-reference counting(ARC) effect, wrap this in the class that is to provide ARC.
//  The wrapper class will manually invoke the reference counting mechanism provided by this class.
//
//  Usage Notes:
//  This class treats the specified directory as an empty directory if the resource tracking file cannot be found.
//  This class resets the tracking file if the specified directory cannot be found.
//
//  Created by Qua Zi Xian on 7/4/15.
//  Copyright (c) 2015 NUS CS3217. All rights reserved.
//

import Foundation
import UIKit

class ResourceManager {
    private let _dirPath: String    //The base directory to read/write resource files.
    private let _resourceListPath: String   //The full path of the resource tracking file.
    private var _referenceCountTable: [String: UInt]    //The reference counting table
    private var saveQueue: dispatch_queue_t     //The queue used to dispatch all file save operations.
    
    //Directory is the name of the directory inside the app's Document directory.
    //Creates the directory if it does not already exists.
    init(directory: String) {
        saveQueue = dispatch_queue_create("com.cs3217.Memento.ResourceManager", DISPATCH_QUEUE_SERIAL)
        
        //Computing the path to save the resource tracking file
        let docDir = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0] as String
        let dir = docDir+"/\(directory)"
        _dirPath = docDir+"/\(directory)/"
        _resourceListPath = docDir+"/\(directory).plist"
        
        //Loads the reference counting table and creates directory if needed.
        var isDir: ObjCBool = false
        let trackingFileExists = NSFileManager.defaultManager().fileExistsAtPath(_resourceListPath)
        let directoryExists = NSFileManager.defaultManager().fileExistsAtPath(dir, isDirectory: &isDir) && isDir
        if trackingFileExists && directoryExists {
            _referenceCountTable = NSDictionary(contentsOfFile: _resourceListPath) as [String: UInt]
        } else {
            _referenceCountTable = [String: UInt]()
            NSFileManager.defaultManager().createDirectoryAtPath(dir, withIntermediateDirectories: true, attributes: nil, error: nil)
        }
    }
    
    //Gets the reference count for the given resource.
    func referenceCountForResource(resourceName: String) -> Int {
        return _referenceCountTable[resourceName] == nil ? 0: Int(_referenceCountTable[resourceName]!)
    }
    
    //Increases reference count for the resource object identified by the given name.
    //Does nothing if the resource with the given name is not found.
    func retainResource(resourceName: String) {
        if _referenceCountTable[resourceName] != nil {
            _referenceCountTable[resourceName]!++
            NSDictionary(dictionary: _referenceCountTable).writeToFile(self._resourceListPath, atomically: true)
            
            /*dispatch_async(saveQueue, {() -> Void in
            NSDictionary(dictionary: self._referenceCountTable).writeToFile(self._resourceListPath, atomically: true)
            })*/
        }
    }
    
    //Saves the text resource to the specified file.
    //If there exists a file with the same name, the existing file is overridden.
    func retainResource(resourceName: String, text: String) {
        _referenceCountTable[resourceName] = 1
        text.writeToFile(_dirPath+resourceName, atomically: true, encoding: NSUTF8StringEncoding, error: nil)
    }
    
    //Double check what resource object will be passed.
    //Saves the given image using the given name and sets reference count to 1.
    //Overrides if there exists another file with the same name in the directory.
    func retainResource(resourceName: String, image: UIImage) {
        _referenceCountTable[resourceName] = 1
        UIImageJPEGRepresentation(image, 0.9).writeToFile(_dirPath+resourceName, atomically: true)
        
        /*dispatch_async(saveQueue, {() -> Void in
        UIImageJPEGRepresentation(image, 0.9).writeToFile(self._dirPath+resourceName, atomically: true)
        })*/
    }
    
    //Reduces the reference count for the resource object identified by the given name.
    //The resource object will be removed if there is no more reference to the resource after this operation.
    //Does nothing if the resource with the given name is not found.
    func releaseResource(resourceName: String) {
        if _referenceCountTable[resourceName] != nil {
            if _referenceCountTable[resourceName] == 1 {
                _referenceCountTable[resourceName] = nil
                NSFileManager.defaultManager().removeItemAtPath(_dirPath+resourceName, error: nil)
            } else {
                _referenceCountTable[resourceName]!--
            }
            NSDictionary(dictionary: _referenceCountTable).writeToFile(_resourceListPath, atomically: true)
        }
    }
}
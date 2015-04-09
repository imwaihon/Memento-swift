//
//  ResourceManager.swift
//  Memento
//
//  The object that manages resources in the specified directory within the app's Documents directory..
//  This class uses manual reference counting mechanism.
//  To achieve auto-reference counting(ARC) effect, wrap this in the class that is to provide ARC.
//  The wrapper class will manually invoke the reference counting mechanism provided by this class.
//
//  Created by Qua Zi Xian on 7/4/15.
//  Copyright (c) 2015 NUS CS3217. All rights reserved.
//

import Foundation
import UIKit

class ResourceManager {
    private let _dirPath: String    //The base directory to read/write resource files.
    private let _resourceListPath: String   //The full path of the resource tracking file.
    private var _referenceCountTable: [String: UInt]
    private var saveQueue: dispatch_queue_t     //The queue used to dispatch all file save operations.
    
    //Directory is the name of the directory inside the app's Document directory.
    init(directory: String) {
        saveQueue = dispatch_queue_create("com.cs3217.Memento.ResourceManager", DISPATCH_QUEUE_SERIAL)
        
        //Computing the path to save the resource tracking file
        let docDir = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0] as String
        _dirPath = docDir+"/\(directory)/"
        _resourceListPath = docDir+"/\(_dirPath).plist"
        
        //Loads the reference counting table.
        if NSFileManager.defaultManager().fileExistsAtPath(_resourceListPath) {
            _referenceCountTable = NSDictionary(contentsOfFile: _resourceListPath) as [String: UInt]
        } else {
            _referenceCountTable = [String: UInt]()
        }
        //println(_resourceListPath)
    }
    
    //Increases reference count for the resource object identified by the given name.
    //Does nothing if the resource with the given name is not found.
    func retainResource(resourceName: String) {
        if _referenceCountTable[resourceName] != nil {
            _referenceCountTable[resourceName]!++
            /*dispatch_async(saveQueue, {() -> Void in
                NSDictionary(dictionary: self._referenceCountTable).writeToFile(self._resourceListPath, atomically: true)
            })*/
            NSDictionary(dictionary: _referenceCountTable).writeToFile(self._resourceListPath, atomically: true)
        }
    }
    
    //Saves the given image using the given name and sets reference count to 1.
    //Overrides if there exists another file with the same name in the directory.
    func retainResource(resourceName: String, image: UIImage) {
        _referenceCountTable[resourceName] = 1
        /*dispatch_async(saveQueue, {() -> Void in
            UIImageJPEGRepresentation(image, 0.9).writeToFile(self._dirPath+resourceName, atomically: true)
        })*/
        UIImageJPEGRepresentation(image, 0.9).writeToFile(_dirPath+resourceName, atomically: true)
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
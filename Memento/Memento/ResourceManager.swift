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

class ResourceManager {
    private let dirPath: String
    private var _referenceCountTable: [String: UInt]
    private var saveQueue: dispatch_queue_t
    
    init(directory: String) {
        _referenceCountTable = [String: UInt]()
        saveQueue = dispatch_queue_create("com.cs3217.Memento.ResourceManager", DISPATCH_QUEUE_SERIAL)
        dirPath = directory     //To be changed to the full path of the specified directory
    }
    
    //Increases reference count for the resource object identified by the given name.
    //Does nothing if the resource with the given name is not found.
    func retainResource(resourceName: String) {
        if _referenceCountTable[resourceName] != nil {
            _referenceCountTable[resourceName]!++
        }
    }
    
    //Reduces the reference count for the resource object identified by the given name.
    //The resource object will be removed if there is no more reference to the resource after this operation.
    //Does nothing if the resource with the given name is not found.
    func releaseResource(resourceName: String) {
        //To be implemented
    }
}
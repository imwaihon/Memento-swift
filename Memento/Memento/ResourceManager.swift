//
//  ResourceManager.swift
//  Memento
//
//  The object that manages resources in the specified directory within the app's Documents directory(non-recursive).
//  This class uses manual reference counting mechanism.
//  To achieve auto-reference counting(ARC) effect, wrap this in the class that is to provide ARC.
//  The wrapper class will manually invoke the reference counting mechanism provided by this class.
//
//  Abstraction functions:
//  Indicate use of resource:           retainResource(resourceName: String)
//  Add text resource:                  retainResource(resourceName: String, text: String) -> String
//  Add image resource:                 retainResource(resourceName: String, image: UIImage) -> String
//  Indicate release of resource:       releaseResource(resourceName: String)
//  Get reference count for resource:   referenceCountForResource(resourceName: String) -> Int
//  Get list of resource:               resourceOfType(type: ResourceType) -> [String]
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
    //Defines the types of resources managed by this class
    enum ResourceType {
        case Text
        case Image
        case All
    }
    //File extensions
    private let jpegExtension = "jpg"
    private let pngExtention = "png"
    private let textExtension = "txt"
    
    private let _dirPath: String    //The base directory to read/write resource files.
    private let _resourceListPath: String   //The full path of the resource tracking file.
    private var _referenceCountTable: [String: UInt]    //The reference counting table
    
    //Directory is the name of the directory inside the app's Document directory.
    //Creates the directory if it does not already exists.
    init(directory: String) {
        
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
            NSDictionary(dictionary: _referenceCountTable).writeToFile(self._resourceListPath, atomically: true)
        }
    }
    
    //Gets the list of resources of the given type in th edirectory managed by this resource manager.
    //Returns: An array of file names of resources of the specified type.
    func resourceOfType(type: ResourceType) -> [String] {
        let files = _referenceCountTable.keys.array
        
        if type == ResourceType.All {
            return files
        }
        
        //Sets the desired file extensions.
        let ext = NSMutableSet()
        if type == ResourceType.Image {
            ext.addObjectsFromArray([jpegExtension, pngExtention])
        } else {
            ext.addObject(textExtension)
        }
        
        //Filtering the resources.
        var arr = [String]()
        for file in files {
            if ext.containsObject(file.pathExtension) {
                arr.append(file)
            }
        }
        return arr
    }
    
    //Gets the reference count for the given resource.
    //Returns: The reference count for the specified resource.
    func referenceCountForResource(resourceName: String) -> Int {
        return _referenceCountTable[resourceName] == nil ? 0: Int(_referenceCountTable[resourceName]!)
    }
    
    //Increases reference count for the resource object identified by the given name.
    //Does nothing if the resource with the given name is not found.
    func retainResource(resourceName: String) {
        if _referenceCountTable[resourceName] != nil {
            _referenceCountTable[resourceName]!++
            NSDictionary(dictionary: _referenceCountTable).writeToFile(self._resourceListPath, atomically: true)
        }
    }
    
    //Saves the text resource to the specified file.
    //Returns: The actual name of the text file being saved to.
    //Requires: Resource name should have .txt extension.
    func retainResource(resourceName: String, text: String) -> String {
        var filename = resourceName
        
        //Fixes file extension
        if filename.pathExtension != textExtension {
            filename = filename.stringByDeletingPathExtension.stringByAppendingPathExtension(textExtension)!
        }
        
        //Construct new file name if file with same name exists.
        if _referenceCountTable[resourceName] != nil {
            filename = filename.stringByDeletingPathExtension
            for var i=1; ; i++ {
                if _referenceCountTable[(filename+"(\(i))").stringByAppendingPathExtension(textExtension)!] == nil {
                    filename+="(\(i))"
                    break
                }
            }
            filename = filename.stringByAppendingPathExtension(textExtension)!
        }
        
        //Write to the file.
        _referenceCountTable[filename] = 1
        text.writeToFile(_dirPath+filename, atomically: true, encoding: NSUTF8StringEncoding, error: nil)
        
        //Save the updated reference table
        NSDictionary(dictionary: _referenceCountTable).writeToFile(self._resourceListPath, atomically: true)
        return filename
    }
    
    //Saves the given image using the given name and sets reference count to 1.
    //Returns: The actual name of the image file used.
    //Requires: Resource name should have extensions .jpg or .png
    func retainResource(resourceName: String, image: UIImage) -> String {
        let ext = resourceName.pathExtension
        var filename = resourceName
        
        //Cinstruct new file name if file with same name exists.
        if _referenceCountTable[filename] != nil {
            filename = filename.stringByDeletingPathExtension
            for var i = 1; ; i++ {
                if _referenceCountTable[(filename+"(\(i))").stringByAppendingPathExtension(ext)!] == nil {
                    filename+="(\(i))"
                    break
                }
            }
            filename = filename.stringByAppendingPathExtension(ext)!
        }
        
        //Write to file.
        _referenceCountTable[filename] = 1
        if ext == jpegExtension {
            UIImageJPEGRepresentation(image, 0.9).writeToFile(_dirPath+filename, atomically: true)
        } else {
            UIImagePNGRepresentation(image).writeToFile(_dirPath+filename, atomically: true)
        }
        
        //Save the update reference table
        NSDictionary(dictionary: _referenceCountTable).writeToFile(self._resourceListPath, atomically: true)
        return filename
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
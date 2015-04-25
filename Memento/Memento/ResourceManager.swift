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
//  Add image resource:                 retainResource(resourceName: String, image: UIImage, imageType: ImageType) -> String
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
    
    //Defines the types of image supported by this class
    enum ImageType {
        case JPG
        case PNG
    }
    
    //File extensions
    private let jpegExtension = "jpg"
    private let pngExtention = "png"
    private let textExtension = "txt"
    private let plistExtension = "plist"
    
    private let _dirPath: String    //The base directory to read/write resource files.
    private let _resourceListPath: String   //The full path of the resource tracking file.
    private var _referenceCountTable: [String: UInt]    //The reference counting table
    
    /* Creates a new resource manager instance that tracks usage of files in the specified directory.
     * Creates the directory if it does not already exist.
     * Creates the tracking file if it does not already exist.
     * If directory exists but not the tracking file, a new tracking file is created and the directory is treated as
     * an empty directory.
     * @param directory The path of the directory, relative to the app's Document directory
     *                  whose contents are to be tracked.
     */
    init(directory: String) {
        
        //Computing the path to save the resource tracking file
        let docDir = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0] as String
        _dirPath = docDir.stringByAppendingPathComponent(directory)
        _resourceListPath = _dirPath.stringByAppendingPathExtension(plistExtension)!
        
        //Loads the reference counting table and creates directory if needed.
        var isDir: ObjCBool = false
        let trackingFileExists = NSFileManager.defaultManager().fileExistsAtPath(_resourceListPath)
        let directoryExists = NSFileManager.defaultManager().fileExistsAtPath(_dirPath, isDirectory: &isDir) && isDir
        if trackingFileExists && directoryExists {
            //In case an error occurs when reading from file
            if let table = NSDictionary(contentsOfFile: _resourceListPath) as? [String: UInt] {
                _referenceCountTable = table
            } else {
                _referenceCountTable = [String: UInt]()
            }
        } else {
            _referenceCountTable = [String: UInt]()
            NSFileManager.defaultManager().createDirectoryAtPath(_dirPath, withIntermediateDirectories: true, attributes: nil, error: nil)
            NSDictionary(dictionary: _referenceCountTable).writeToFile(_resourceListPath, atomically: true)
        }
    }
    
    /* Gets the list of resources of the given type in the directory managed by this resource manager.
     * @param type The type of resource to be listed.
     * @returns An array of file names of resources of the specified type.
     */
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
    
    /* Gets the reference count for the given resource.
     * @params resourceName The name of the resource to be queried.
     * @returns The reference count for the specified resource.
     */
    func referenceCountForResource(resourceName: String) -> Int {
        return _referenceCountTable[resourceName] == nil ? 0: Int(_referenceCountTable[resourceName]!)
    }
    
    /* Increases reference count for the resource object identified by the given name.
     * Does nothing if the resource with the given name is not found.
     * @param resourceName The name of the resource to be used.
     */
    func retainResource(resourceName: String) {
        if _referenceCountTable[resourceName] != nil {
            _referenceCountTable[resourceName]!++
            NSDictionary(dictionary: _referenceCountTable).writeToFile(_resourceListPath, atomically: true)
        }
    }
    
    /* Saves the text resource to the specified file.
     * @param resourceName The base name of the text file to save to.
     * @param text The text resource to be saved.
     * @returns: The actual name of the text file being saved to, with txt file extension added.
     */
    func retainResource(resourceName: String, text: String) -> String {
        var filename = resourceName
        
        //Construct new file name if file with same name exists.
        if _referenceCountTable[filename.stringByAppendingPathExtension(textExtension)!] != nil {
            for var i=1; ; i++ {
                if _referenceCountTable[(filename+"(\(i))").stringByAppendingPathExtension(textExtension)!] == nil {
                    filename+="(\(i))"
                    break
                }
            }
        }
        filename = filename.stringByAppendingPathExtension(textExtension)!
        
        //Write to the file.
        text.writeToFile(_dirPath.stringByAppendingPathComponent(filename), atomically: true, encoding: NSUTF8StringEncoding, error: nil)
        
        //Save the updated reference table
        _referenceCountTable[filename] = 1
        NSDictionary(dictionary: _referenceCountTable).writeToFile(_resourceListPath, atomically: true)
        return filename
    }
    
    /* Adds the given image resource as the given image type
     * @param resourceName The base name of the file to save as, without the file extension.
     * @param image The image to be saved.
     * @param imageType The type of image to be saved as.
     * @return The actual name of the image file used, with the file extension appended.
     */
    func retainResource(resourceName: String, image: UIImage, imageType: ImageType) -> String {
        var filename = resourceName
        let ext = imageType == ImageType.JPG ? jpegExtension: imageType == ImageType.PNG ? pngExtention: String()
        
        //Construct new file name if file with same name exists.
        if _referenceCountTable[filename.stringByAppendingPathExtension(ext)!] != nil {
            for var i = 1; ; i++ {
                if _referenceCountTable[(filename+"(\(i))").stringByAppendingPathExtension(ext)!] == nil {
                    filename+="(\(i))"
                    break
                }
            }
        }
        filename = filename.stringByAppendingPathExtension(ext)!
        
        //Save image to file
        //imageType is guaranteed to be either JPG or PNG
        switch(imageType) {
            case .JPG: UIImageJPEGRepresentation(image, 0.9).writeToFile(_dirPath.stringByAppendingPathComponent(filename), atomically: true)
                        break
            case .PNG: UIImagePNGRepresentation(image).writeToFile(_dirPath.stringByAppendingPathComponent(filename), atomically: true)
                        break
            default: break
        }
        
        //Update and save reference count table
        _referenceCountTable[filename] = 1
        NSDictionary(dictionary: _referenceCountTable).writeToFile(_resourceListPath, atomically: true)
        return filename
    }
    
    /* Reduces the reference count for the resource object identified by the given name.
     * The resource object will be removed if there is no more reference to the resource after this operation.
     * Does nothing if the resource with the given name is not found.
     * @param resourceName The name of the resource to be released.
     */
    func releaseResource(resourceName: String) {
        if _referenceCountTable[resourceName] != nil {
            if _referenceCountTable[resourceName] == 1 {    //Removing last reference to resource.
                _referenceCountTable[resourceName] = nil
                NSFileManager.defaultManager().removeItemAtPath(_dirPath.stringByAppendingPathComponent(resourceName), error: nil)
            } else {
                _referenceCountTable[resourceName]!--
            }
            NSDictionary(dictionary: _referenceCountTable).writeToFile(_resourceListPath, atomically: true)
        }
    }
}
//
//  MementoNodeFactory.swift
//  Memento
//
//  The factory object for rooms in the memory palace.
//
//  Created by Qua Zi Xian on 25/3/15.
//  Copyright (c) 2015 NUS CS3217. All rights reserved.
//

import Foundation

class MementoNodeFactory {
    
    /// Creates a memory palace room with the given background image file.
    ///
    /// :param: imageFile The filename of the background image for the room.
    /// :returns: A MementoNode instance with the given background image.
    func makeNode(imageFile: String) -> MementoNode {
        return MementoNode(imageFile: imageFile)
    }
    
    /// Creates a memory palace room from the given plist representation.
    ///
    /// :param: nodeData The plist representation of the memory palace to make.
    /// :returns The MementoNode instance represented by the given plist representation.
    func makeNode(nodeData: NSDictionary) -> MementoNode {
        let node = MementoNode(imageFile: nodeData[Constants.bgImageKey]! as String)

        let overlayArray = nodeData[Constants.overlayKey]! as NSArray
        let placeholderArray = nodeData[Constants.placeHolderKey]! as NSArray
        let valueArray = nodeData[Constants.valueKey]! as NSArray
        
        //Adds the objects contained in the room
        for overlayString in overlayArray {
            node.addOverlay(MutableOverlay.decodeFromString(overlayString as String))
        }
        for placeholderString in placeholderArray {
            node.addPlaceHolder(PlaceHolder.decodeFromString(placeholderString as String))
        }
        for index in 0..<valueArray.count {
            node.setAssociationValue(index, value: valueArray.objectAtIndex(index) as String)
        }
        
        return node
    }
}
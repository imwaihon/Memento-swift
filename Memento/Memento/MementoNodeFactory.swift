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
    
    func makeNode(imageFile: String) -> MementoNode {
        return MementoNode(imageFile: imageFile)
    }
    
    func makeNode(nodeData: NSDictionary) -> MementoNode {
        var node = MementoNode(imageFile: nodeData[bgImageKey]! as String)

        var overlayArray = nodeData[overlayKey]! as NSArray
        var placeholderArray = nodeData[placeHolderKey]! as NSArray
        var valueArray = nodeData[valueKey]! as NSArray
        
        
        for overlayString in overlayArray {
            node.addOverlay(MutableOverlay.decodeFromString(overlayString as String))
        }
        
        for placeholderString in placeholderArray {
            node.addPlaceHolder(PlaceHolder.decodeFromString(placeholderString as String))
            
        }
        
        
        for index in 0..<valueArray.count {
            node.setAssociationValue(index, value: valueArray.objectAtIndex(index) as? String)
        }
        
        return node
    }
}
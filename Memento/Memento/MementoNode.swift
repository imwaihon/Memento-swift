//
//  MementoNode.swift
//  Memento
//
//  Represents a node in the memory palace.
//  The node is represented by its own MVC.
//
//  Specifications:
//  Contains necessary information for display.
//  Changes that will affect the displayed information should update the appropriate view components.
//  Contains associations and links created by user.
//  Identify association/link selected by user.
//
//  Non-functional specifications
//  Easily identified by the graph containing it.
//
//  Created by Qua Zi Xian on 19/3/15.
//  Copyright (c) 2015 NUS CS3217. All rights reserved.
//

import Foundation
import UIKit

class MementoNode: MemoryPalaceRoom {
    private let backgroundImageFile: String
    private var placeHolders: [PlaceHolder]
    private var values: [String?]
    
    var label: Int = 0      //The node's identification label in the graph
    
    //Properties
    var icon: MemoryPalaceRoomIcon {
        return MemoryPalaceRoomIcon(label: label, filename: backgroundImageFile)
    }
    var numPlaceHolders: Int {
        return placeHolders.count
    }
    var associations: [Association] {
        var arr = [Association]()
        let numAssoc = numPlaceHolders
        for i in 0..<numAssoc {
            arr.append(Association(placeHolder: placeHolders[i], value: values[i]))
        }
        return arr
    }

    init(imageFile: String){
        backgroundImageFile = imageFile
        placeHolders = [RectanglePlaceHolder]()
        values = [String?](count: placeHolders.count, repeatedValue: nil)
    }
    
    //Adds the given placeholder to this memory palace room.
    //Does nothing if it overlaps with any of the existing placeholedrs.
    func addPlaceHolder(placeHolder: PlaceHolder) {
        var hasOverlap = false
        
        dispatch_apply(UInt(placeHolders.count), dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), {(idx: UInt) -> Void in
            hasOverlap |= PlaceHolder.hasOverlap(self.placeHolders[Int(idx)], placeHolder2: placeHolder)
        })
        
        if !hasOverlap {
            placeHolder.label = numPlaceHolders
            placeHolders.append(placeHolder)
            values.append(nil)
        }
    }
    
    //Associates the specified placeholder with the given value.
    //Does nothing ifno such placeholder exists.
    func setAssociationValue(placeHolderNumber: Int, value: String?) {
        if isValidPlaceHolderNumber(placeHolderNumber) {
            values[placeHolderNumber] = value
        }
    }
    
    private func isValidPlaceHolderNumber(num: Int) -> Bool {
        return num >= 0 && num < numPlaceHolders
    }
}
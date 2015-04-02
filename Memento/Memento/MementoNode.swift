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
    private let _backgroundImageFile: String
    private var _overlays: [MutableOverlay]
    private var _placeHolders: [PlaceHolder]
    private var _values: [String?]
    
    var label: Int = 0      //The node's identification label in the graph
    
    //Properties
    var icon: MemoryPalaceRoomIcon {
        return MemoryPalaceRoomIcon(label: label, filename: _backgroundImageFile, overlays: overlays)
    }
    var overlays: [Overlay] {
        var arr = [Overlay]()
        for i in 0..<_overlays.count {
            arr.append(_overlays[i].makeImmuatble())
        }
        return arr
    }
    var numPlaceHolders: Int {
        return _placeHolders.count
    }
    var associations: [Association] {
        var arr = [Association]()
        let numAssoc = numPlaceHolders
        for i in 0..<numAssoc {
            arr.append(Association(placeHolder: _placeHolders[i], value: _values[i]))
        }
        return arr
    }
    var viewRepresentation: MemoryPalaceRoomView {  //The object representation used to render the node in view/edit mode
        return MemoryPalaceRoomView(backgroundImage: _backgroundImageFile, overlays: overlays, associations: associations)
    }
    
    var plistRepresentation: NSDictionary { //Currently assumes no deletion of overlays, placeholders and values
        var rep = NSMutableDictionary()
        rep[bgImageKey] = NSString(string: _backgroundImageFile)
        
        //Gets array of overlays
        var overlays = NSMutableArray()
        for overlay in _overlays {
            overlays.addObject(overlay.stringEncoding)
        }
        rep[overlayKey] = overlays
        
        //Gets array of placeholders
        var pHolders = NSMutableArray()
        for placeHolder in _placeHolders {
            pHolders.addObject(placeHolder.stringEncoding)
        }
        rep[placeHolderKey] = pHolders
        
        //Gets array of values
        var val = NSMutableArray()
        for value in _values {
            val.addObject(value == nil ? "": NSString(string: value!))
        }
        rep[valueKey] = val
        return rep
    }

    init(imageFile: String){
        _backgroundImageFile = imageFile
        _overlays = [MutableOverlay]()
        _placeHolders = [RectanglePlaceHolder]()
        _values = [String?](count: _placeHolders.count, repeatedValue: nil)
    }
    
    //Adds the given placeholder to this memory palace room.
    //Does nothing if it overlaps with any of the existing placeholedrs.
    func addPlaceHolder(placeHolder: PlaceHolder) {
        var hasOverlap = false
        
        dispatch_apply(UInt(_placeHolders.count), dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), {(idx: UInt) -> Void in
            hasOverlap |= PlaceHolder.hasOverlap(self._placeHolders[Int(idx)], placeHolder2: placeHolder)
        })
        
        if !hasOverlap {
            placeHolder.label = numPlaceHolders
            _placeHolders.append(placeHolder)
            _values.append(nil)
        }
    }
    
    //Associates the specified placeholder with the given value.
    //Does nothing ifno such placeholder exists.
    func setAssociationValue(placeHolderNumber: Int, value: String?) {
        if isValidPlaceHolderNumber(placeHolderNumber) {
            _values[placeHolderNumber] = value
        }
    }
    
    //Adds the given overlay object
    func addOverlay(overlay: MutableOverlay) {
        _overlays.append(overlay)
    }
    
    private func isValidPlaceHolderNumber(num: Int) -> Bool {
        return num >= 0 && num < numPlaceHolders
    }
}
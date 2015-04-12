//
//  MementoNode.swift
//  Memento
//
//  Defines the model of a memory palace room.
//
//  Specifications:
//  Contains necessary information for display.
//  Changes that will affect the displayed information should update the appropriate view components.
//  Contains associations and links created by user.
//  Identify association/overlay selected by user.
//  Convert into representation that can be saved as a plist.
//
//  Non-functional specifications
//  Easily identified by the graph containing it.
//  Remove placeholders/overlays without changing the labels of existing overlays/placeholders.
//  Retrieve the correct placeholder/overlay using the same label even after removing some other overlay/placeholder.
//
//  Implementation Explanation for deletion:
//  Can easily use removeAtIndex on the array, but retrieving the correct object requires O(N) scan as labels no longer
//  reflect the index.
//  We want to know the index that stores the object with the given label.
//  By using cumulative counting, we can know how many items with labels in the range [0, given label] were removed.
//  Using this, we can identify the index that the object is most likely in.
//  If the object woth given label does not exist, the object at the index will have a different label.
//  Cumulative table can be done efficiently in O(log N) time using Binary-Indexed Tree.
//  Hence, the Binary-Indexed Tree is used in computing the index of the specified object.
//  Fenwick Tree solution is scraped as it leads to occupying even more memory and does not improve deletion time complexity.
//  Current implementation is using balanced Binary Search Tree to map label to object.
//
//  Created by Qua Zi Xian on 19/3/15.
//  Copyright (c) 2015 NUS CS3217. All rights reserved.
//

import Foundation
import UIKit

class MementoNode: MemoryPalaceRoom {
    private let _overlays: Map<Int, MutableOverlay>
    private let _placeHolders: Map<Int, PlaceHolder>
    private let _values: Map<Int, String>
    
    let _backgroundImageFile: String
    var label: Int = 0      //The node's identification label in the graph
    var graphName: String = "sampleGraph"
    
    //Properties
    var icon: MemoryPalaceRoomIcon {
        return MemoryPalaceRoomIcon(graphName: graphName, label: label, filename: _backgroundImageFile, overlays: overlays)
    }
    var overlays: [Overlay] {
        var tempArr = _overlays.inOrderTraversal()
        var arr = [Overlay]()
        arr.reserveCapacity(numOverlays)
        for elem in tempArr {
            arr.append(elem.1.makeImmuatble())
        }
        return arr
    }
    var numOverlays: Int {
        return _overlays.size
    }
    var numPlaceHolders: Int {
        return _placeHolders.size
    }
    var associations: [Association] {
        var arr = [Association]()
        var tempArr1 = _placeHolders.inOrderTraversal()
        var tempArr2 = _values.inOrderTraversal()
        arr.reserveCapacity(numPlaceHolders)
        for i in 0..<numPlaceHolders {
            arr.append(Association(placeHolder: tempArr1[i].1, value: tempArr2[i].1))
        }
        return arr
    }
    var viewRepresentation: MemoryPalaceRoomView {  //The object representation used to render the node in view/edit mode
        return MemoryPalaceRoomView(graphName: graphName, label: label, backgroundImage: _backgroundImageFile, overlays: overlays, associations: associations)
    }
    
    var plistRepresentation: NSDictionary { //Currently assumes no deletion of overlays, placeholders and values
        var rep = NSMutableDictionary()
        rep[bgImageKey] = NSString(string: _backgroundImageFile)
        
        //Gets array of overlays
        let overlayArr = overlays
        var overlayStrArr = [String]()
        overlayStrArr.reserveCapacity(overlayArr.count)
        for overlay in overlayArr {
            overlayStrArr.append(overlay.stringEncoding)
        }
        rep[overlayKey] = NSArray(array: overlayStrArr)
        
        //Gets arrays of placeholders and values
        let assoc = associations
        var pHolderStrArr = [String]()
        var val = [String]()
        pHolderStrArr.reserveCapacity(assoc.count)
        val.reserveCapacity(assoc.count)
        
        for elem in assoc {
            pHolderStrArr.append(elem.placeHolder.stringEncoding)
            val.append(elem.value)
        }
        
        rep[placeHolderKey] = NSArray(array: pHolderStrArr)
        rep[valueKey] = NSArray(array: val)
        
        return rep
    }

    init(imageFile: String){
        _backgroundImageFile = imageFile
        _overlays = Map<Int, MutableOverlay>()
        _placeHolders = Map<Int, PlaceHolder>()
        _values = Map<Int, String>()
    }
    
    //Adds the given placeholder to this memory palace room.
    //Returns false if the placeholder cannot be added because it overlaps with an existing placeholder.
    func addPlaceHolder(placeHolder: PlaceHolder) -> Bool {
        
        //Checks for overlap
        let pHolders = _placeHolders.inOrderTraversal()
        var hasOverlap = false
        dispatch_apply(UInt(pHolders.count), dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), {(idx: UInt) -> Void in
            hasOverlap |= PlaceHolder.hasOverlap(placeHolder, placeHolder2: pHolders[Int(idx)].1)
        })
        if hasOverlap {
            return false
        }
        
        //Else add the placeholder.
        let label = _placeHolders.isEmpty ? 0: _placeHolders.largestKey! + 1
        placeHolder.label = label
        _placeHolders[label] = placeHolder
        _values[label] = String()
        return true
    }
    
    //Gets the placeholder identified by the given label.
    //Returns nil if no such placeholder is found.
    func getPlaceHolder(placeHolderLabel: Int) -> PlaceHolder? {
        return _placeHolders[placeHolderLabel]
    }
    
    //Gets the association identified by the placeholder's label.
    //Returns nil if no such association is found.
    func getAssociation(placeHolderLabel: Int) -> Association? {
        return _placeHolders[placeHolderLabel] != nil && _values[placeHolderLabel] != nil ? Association(placeHolder: _placeHolders[placeHolderLabel]!, value: _values[placeHolderLabel]!): nil
    }
    
    //Sets the new frame for the placeholder identified by the given label.
    func setPlaceHolderFrame(label: Int, newFrame: CGRect) {
        if let pHolder = _placeHolders[label] {
            let newPlaceholder = RectanglePlaceHolder(highlightArea: newFrame)
            newPlaceholder.label = pHolder.label
            _placeHolders[label] = newPlaceholder
        }
    }
    
    //Swaps the 2 placeholders.
    //Returns false if no swapping takes place due to absence of 1 of the specified placeholders.
    func swapPlaceHolders(pHolder1Label: Int, pHolder2Label: Int) -> Bool {
        if let pHolder1 = _placeHolders[pHolder1Label] {
            if let pHolder2 = _placeHolders[pHolder2Label] {
                let value1 = _values[pHolder1Label]
                let value2 = _values[pHolder2Label]
                pHolder1.label = pHolder2Label
                pHolder2.label = pHolder1Label
                _placeHolders[pHolder1Label] = pHolder2
                _placeHolders[pHolder2Label] = pHolder1
                _values[pHolder1Label] = value2
                _values[pHolder2Label] = value1
                return true
            }
        }
        return false
    }

    //Removes the placeholder identified by the label, and its corresponding associated value.
    //Does nothing if the placeholder cannot be found.
    func removePlaceHolder(placeHolderLabel: Int) {
        _placeHolders.eraseValueForKey(placeHolderLabel)
        _values.eraseValueForKey(placeHolderLabel)
    }
    
    //Associates the specified placeholder with the given value.
    //Does nothing ifno such placeholder exists.
    func setAssociationValue(placeHolderLabel: Int, value: String) {
        if _placeHolders[placeHolderLabel] != nil {
            _values[placeHolderLabel] = value
        }
    }
    
    //Adds the given overlay object
    //Returns the identifier assigned to the added overlay
    func addOverlay(overlay: MutableOverlay) -> Int {
        let label = _overlays.isEmpty ? 0: _overlays.largestKey! + 1
        _overlays[label] = overlay
        _overlays[label]?.label = label
        return label
    }
    
    //Gets the overlay object with the given label.
    //Returns nil if no such overlay object can be found.
    func getOverlay(overlayLabel: Int) -> Overlay? {
        return _overlays[overlayLabel]?.makeImmuatble()
    }

    //Changes the frame of the overlay object.
    //Does nothing if the overlay object cannot be found.
    func setOverlayFrame(overlayLabel: Int, newFrame: CGRect) {
        if _overlays[overlayLabel] != nil {
            _overlays[overlayLabel]?.frame = newFrame
        }
    }
    
    //Removes the overlay identified by the given label.
    //Does nothing if no such overlay is found.
    func removeOverlay(overlayLabel: Int) {
        _overlays.eraseValueForKey(overlayLabel)
    }
}
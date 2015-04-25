//
//  MementoNode.swift
//  Memento
//
//  Defines the model of a memory palace room(mutable).
//
//  Fields:
//  label: Int                      The label assigned to thsi room
//  backgroundImageFile: String     The name of this room's background image file
//  graphName: String               The name of the memory palace this room is in
//  overlays: [Overlay]             The list of overlays in this room
//  associations: [Association]     The list of associations in this room
//
//  Abstraction Functions and Specifications:
//  Add association placeholder:                            addPlaceHolder(placeHolder: PlaceHolder) -> Bool
//  Get association:                                        getAssociation(placeHolderLabel: Int) -> Association?
//  Set association value:                                  setAssociationValue(placeHolderLabel: Int, value: String)
//  Swap association ordering:                              swapPlaceHolders(pHolder1Label: Int, pHolder2Label: Int) -> Bool
//  Remove association:                                     removePlaceHolder(placeHolderLabel: Int)
//  Add overlay:                                            addOverlay(overlay: MutableOverlay) -> Int
//  Get overlay:                                            getOverlay(overlayLabel: Int) -> Overlay?
//  Shift/Resize overlay:                                   setOverlayFrame(overlayLabel: Int, newFrame: CGRect)
//  Remove overlay:                                         removeOverlay(overlayLabel: Int)
//  Convert into plist representation for saving:           plistRepresentation: NSDictionary
//
//  Non-functional specifications
//  Easily identified by the graph containing it.
//  Remove placeholders/overlays without changing the labels of existing overlays/placeholders.
//  Retrieve the correct placeholder/overlay using the same label even after removing some other overlay/placeholder.
//
//  Created by Qua Zi Xian on 19/3/15.
//  Copyright (c) 2015 NUS CS3217. All rights reserved.
//

import Foundation
import UIKit

class MementoNode {
    private let _overlays: Map<Int, MutableOverlay>
    private let _placeHolders: Map<Int, PlaceHolder>
    private let _values: Map<Int, String>
    
    var backgroundImageFile: String
    var label: Int = 0      //The node's identification label in the graph
    var graphName: String!
    
    //Properties
    var icon: MemoryPalaceRoomIcon {
        return MemoryPalaceRoomIcon(graphName: graphName, label: label, filename: backgroundImageFile, overlays: overlays)
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
        return MemoryPalaceRoomView(graphName: graphName, label: label, backgroundImage: backgroundImageFile, overlays: overlays, associations: associations)
    }
    
    var plistRepresentation: NSDictionary {
        var rep = NSMutableDictionary()
        rep[Constants.bgImageKey] = NSString(string: backgroundImageFile)
        
        //Gets array of overlays
        let overlayArr = overlays
        var overlayStrArr = [String]()
        overlayStrArr.reserveCapacity(overlayArr.count)
        for overlay in overlayArr {
            overlayStrArr.append(overlay.stringEncoding)
        }
        rep[Constants.overlayKey] = NSArray(array: overlayStrArr)
        
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
        
        rep[Constants.placeHolderKey] = NSArray(array: pHolderStrArr)
        rep[Constants.valueKey] = NSArray(array: val)
        
        return rep
    }

    init(imageFile: String){
        graphName = Constants.defaultPalaceName
        backgroundImageFile = imageFile
        _overlays = Map<Int, MutableOverlay>()
        _placeHolders = Map<Int, PlaceHolder>()
        _values = Map<Int, String>()
    }
    
    /// Adds the given placeholder to this memory palace room.
    /// This operation fails if the given placeholder overlaps with any existing placeholders.
    ///
    /// :param: placeHolder The placeholder object to be added.
    /// :returns: true if the placeholder is successfully added. Returns false otherwise..
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
    
    /// Gets the placeholder identified by the given label.
    ///
    /// :param: placeHolderLabel The label of the placeholder to retrieve.
    /// :returns: The placeholder object with the given label. Returns nil if no such placeholder is found.
    func getPlaceHolder(placeHolderLabel: Int) -> PlaceHolder? {
        return _placeHolders[placeHolderLabel]
    }
    
    /// Gets the association identified by the placeholder's label.
    ///
    /// :param: placeHolderLabel The label of the placeholder in the association.
    /// :returns: The association object wth the given label. Returns nil if no such association is found.
    func getAssociation(placeHolderLabel: Int) -> Association? {
        return _placeHolders[placeHolderLabel] != nil && _values[placeHolderLabel] != nil ? Association(placeHolder: _placeHolders[placeHolderLabel]!, value: _values[placeHolderLabel]!): nil
    }
    
    /// Sets the new color for the placeholder. Does nothing if the placeholder is not found.
    ///
    /// :param: placeHolderLabel The label of the placeholder to edit.
    /// :param: color The new color of the placeholder.
    func setPlaceHolderColor(placeHolderLabel: Int, color: String) {
        _placeHolders[placeHolderLabel]?.color = color
    }
    
    /// Swaps the 2 placeholders. Swapping occurs if both placeholders are found.
    ///
    /// :param: pHolder1Label The label of the 1st placeholder to swap.
    /// :param: pHolder2Label The label of the 2nd placeholder to swap.
    /// :returns: true if swapping takes place. Returns false otherwise.
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

    /// Removes the placeholder identified by the label, and its corresponding associated value.
    /// Does nothing if the placeholder cannot be found.
    ///
    /// :param: placeHolderLabel The label of the placeholder to be removed.
    func removePlaceHolder(placeHolderLabel: Int) {
        _placeHolders.eraseValueForKey(placeHolderLabel)
        _values.eraseValueForKey(placeHolderLabel)
    }
    
    /// Associates the specified placeholder with the given value. Does nothing if no such placeholder exists.
    ///
    /// :param: placeHolderLabel The label of the placeholder associated with the association.
    /// :param: value The value to be set to the association.
    func setAssociationValue(placeHolderLabel: Int, value: String) {
        if _placeHolders[placeHolderLabel] != nil {
            _values[placeHolderLabel] = value
        }
    }
    
    /// Adds the given overlay object.
    ///
    /// :param: overlay The overlay object to be added.
    /// :returns: The identifier assigned to the added overlay.
    func addOverlay(overlay: MutableOverlay) -> Int {
        let label = _overlays.isEmpty ? 0: _overlays.largestKey! + 1
        _overlays[label] = overlay
        _overlays[label]?.label = label
        return label
    }
    
    /// Gets the overlay object with the given label.
    ///
    /// :param: overlayLabel The label of the overlay object to retrieve.
    /// :returns: The overlay object with the given label, Returns nil if no such overlay object can be found.
    func getOverlay(overlayLabel: Int) -> Overlay? {
        return _overlays[overlayLabel]?.makeImmuatble()
    }

    /// Changes the frame of the overlay object. Does nothing if the overlay object cannot be found.
    ///
    /// :param: overlayLabel The label of the overlay object to edit.
    /// :param: newFrame The new frame for the overlay object.
    func setOverlayFrame(overlayLabel: Int, newFrame: CGRect) {
        if _overlays[overlayLabel] != nil {
            _overlays[overlayLabel]?.frame = newFrame
        }
    }
    
    /// Removes the overlay identified by the given label. Does nothing if no such overlay is found.
    ///
    /// :param: overlayLabel The label of the overlay object to remove.
    func removeOverlay(overlayLabel: Int) {
        _overlays.eraseValueForKey(overlayLabel)
    }
}
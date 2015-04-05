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
//
//  Created by Qua Zi Xian on 19/3/15.
//  Copyright (c) 2015 NUS CS3217. All rights reserved.
//

import Foundation
import UIKit

class MementoNode: MemoryPalaceRoom {
    private let _backgroundImageFile: String
    //private var _overlayFT: FenwickTree
    //private var _placeHolderFT: FenwickTree
    //private var _overlays: [MutableOverlay]
    //private var _placeHolders: [PlaceHolder]
    //private var _values: [String?]
    private let _overlays: Map<Int, MutableOverlay>
    private let _placeHolders: Map<Int, PlaceHolder>
    private let _values: Map<Int, String>
    
    var label: Int = 0      //The node's identification label in the graph
    var graphName: String = "sampleGraph"
    
    //Properties
    var icon: MemoryPalaceRoomIcon {
        return MemoryPalaceRoomIcon(graphName: graphName, label: label, filename: _backgroundImageFile, overlays: overlays)
    }
    var overlays: [Overlay] {
        /*var arr = [Overlay]()
        for i in 0..<_overlays.count {
            arr.append(_overlays[i].makeImmuatble())
        }*/
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
        /*let numAssoc = numPlaceHolders
        for i in 0..<numAssoc {
            arr.append(Association(placeHolder: _placeHolders[i], value: _values[i]))
        }*/
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
        /*var overlays = NSMutableArray()
        for overlay in _overlays {
            overlays.addObject(overlay.stringEncoding)
        }
        rep[overlayKey] = overlays*/
        let overlayArr = overlays
        var overlayStrArr = [String]()
        overlayStrArr.reserveCapacity(overlayArr.count)
        for overlay in overlayArr {
            overlayStrArr.append(overlay.stringEncoding)
        }
        rep[overlayKey] = NSArray(array: overlayStrArr)
        
        //Gets array of placeholders
        /*var pHolders = NSMutableArray()
        for placeHolder in _placeHolders {
            pHolders.addObject(placeHolder.stringEncoding)
        }
        rep[placeHolderKey] = pHolders*/
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
        
        //Gets array of values
        /*var val = NSMutableArray()
        for value in values {
            val.addObject(value == nil ? "": NSString(string: value!))
        }
        rep[valueKey] = val*/
        return rep
    }

    init(imageFile: String){
        _backgroundImageFile = imageFile
        //_overlays = [MutableOverlay]()
        //_overlayFT = FenwickTree()
        //_placeHolders = [RectanglePlaceHolder]()
        //_placeHolderFT = FenwickTree()
        //_values = [String?](count: _placeHolders.count, repeatedValue: nil)
        _overlays = Map<Int, MutableOverlay>()
        _placeHolders = Map<Int, PlaceHolder>()
        _values = Map<Int, String>()
    }
    
    //Adds the given placeholder to this memory palace room.
    //Does nothing if it overlaps with any of the existing placeholedrs.
    func addPlaceHolder(placeHolder: PlaceHolder) {
        var hasOverlap = false
        
        /*dispatch_apply(UInt(_placeHolders.count), dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), {(idx: UInt) -> Void in
            hasOverlap |= PlaceHolder.hasOverlap(self._placeHolders[Int(idx)], placeHolder2: placeHolder)
        })
        
        if !hasOverlap {
            placeHolder.label = _placeHolders.isEmpty ? 0: _placeHolders[_placeHolders.count - 1].label + 1
            _placeHolders.append(placeHolder)
            _values.append(nil)
        }*/
        let label = _placeHolders.isEmpty ? 0: _placeHolders.largestKey! + 1
        placeHolder.label = label
        _placeHolders[label] = placeHolder
        _values[label] = String()
    }
    
    //Gets the placeholder identified by the given label.
    //Returns nil if no such placeholder is found.
    func getPlaceHolder(placeHolderLabel: Int) -> PlaceHolder? {
        /*if label < 0 || _placeHolders.isEmpty {
            return nil
        }
        let offset = _placeHolderFT.query(label + 1)
        let idx = label - offset
        if idx >= 0 && idx < _placeHolders.count && _placeHolders[idx].label == label {
            return _placeHolders[idx]
        }
        return nil*/
        return _placeHolders[placeHolderLabel]
    }
    
    //Gets the association identified by the placeholder's label.
    //Returns nil if no such association is found.
    func getAssociation(placeHolderLabel: Int) -> Association? {
        /*if label < 0 || _placeHolders.isEmpty {
            return nil
        }
        let offset = _placeHolderFT.query(placeHolderLabel + 1)
        let idx = placeHolderLabel - offset
        if idx >= 0 && idx < _placeHolders.count && _placeHolders[idx].label == placeHolderLabel {
            return Association(placeHolder: _placeHolders[idx], value: _values[idx])
        }
        return nil*/
        return _placeHolders[placeHolderLabel] != nil && _values[placeHolderLabel] != nil ? Association(placeHolder: _placeHolders[placeHolderLabel]!, value: _values[placeHolderLabel]!): nil
    }
    
    //Sets the new frame for the placeholder identified by the given label.
    func setPlaceHolderFrame(label: Int, newFrame: CGRect) {
        /*if label < 0 || _placeHolders.isEmpty {
            return
        }
        let offset = _placeHolderFT.query(label + 1)
        let idx = label - offset
        if idx >= 0 && idx < _placeHolders.count && _placeHolders[idx].label == label {
            _placeHolders[idx] = RectanglePlaceHolder(highlightArea: newFrame)
            _placeHolders[idx].label = label
        }*/
        if let pHolder = _placeHolders[label] {
            let newPlaceholder = RectanglePlaceHolder(highlightArea: newFrame)
            newPlaceholder.label = pHolder.label
            _placeHolders[label] = newPlaceholder
        }
    }

    //Removes the placeholder identified by the label, and its corresponding associated value.
    //Does nothing if the placeholder cannot be found.
    func removePlaceHolder(placeHolderLabel: Int) {
        /*if label < 0 || _placeHolders.isEmpty {
            return
        }
        if _placeHolders.count == 1 {   //Special case: Only 1 placeholder exists
            if _placeHolders[0].label == label {
                _placeHolders.removeAtIndex(0)
                _values.removeAtIndex(0)
                _placeHolderFT = FenwickTree()
            }
            return
        }
        let offset = _placeHolderFT.query(label + 1)
        let idx = label - offset
        if idx >= 0 && idx < _placeHolders.count && _placeHolders[idx].label == label {
            _placeHolderFT.update(label + 1, change: 1)
            if idx == _placeHolders.count - 1 { //Special case: Removing the last placeholder
                let prevLabel = _placeHolders[idx - 1].label
                _placeHolderFT.clearFromIndex(prevLabel + 1)
            }
            _placeHolders.removeAtIndex(idx)
            _values.removeAtIndex(idx)
        }*/
        _placeHolders.eraseValueForKey(placeHolderLabel)
        _values.eraseValueForKey(placeHolderLabel)
    }
    
    //Associates the specified placeholder with the given value.
    //Does nothing ifno such placeholder exists.
    func setAssociationValue(placeHolderLabel: Int, value: String) {
        /*if placeHolderLabel < 0 || _placeHolders.isEmpty {
            return
        }
        let offset = _placeHolderFT.query(placeHolderLabel + 1)
        let idx = placeHolderLabel - offset
        if idx >= 0 && idx < _placeHolders.count && _placeHolders[idx].label == placeHolderLabel {
            _values[idx] = value
        }*/
        if _placeHolders[placeHolderLabel] != nil {
            _values[placeHolderLabel] = value
        }
    }
    
    //Adds the given overlay object
    //Returns the identifier assigned to the added overlay
    func addOverlay(overlay: MutableOverlay) -> Int {
        /*let label = _overlays.isEmpty ? 0: _overlays[_overlays.count - 1].label + 1
        _overlays.append(overlay)
        _overlays[_overlays.count - 1].label = label
        return label*/
        let label = _overlays.isEmpty ? 0: _overlays.largestKey! + 1
        _overlays[label] = overlay
        _overlays[label]?.label = label
        return label
    }
    
    //Gets the overlay object with the given label.
    //Returns nil if no such overlay object can be found.
    func getOverlay(overlayLabel: Int) -> Overlay? {
        /*if label < 0 || _overlays.count == 0 {
            return nil
        }
        let offset = _overlayFT.query(label + 1)
        let idx = label - offset
        if idx < 0 || idx >= _overlays.count || _overlays[idx].label != label {
            return nil
        }
        return _overlays[idx].makeImmuatble()*/
        return _overlays[overlayLabel]?.makeImmuatble()
    }

    //Changes the frame of the overlay object.
    //Does nothing if the overlay object cannot be found.
    func setOverlayFrame(overlayLabel: Int, newFrame: CGRect) {
        /*if _overlays.isEmpty {
            return
        }
        let offset = _overlayFT.query(label + 1)
        let idx = label - offset
        if idx >= 0 && idx < _overlays.count && _overlays[idx].label == label {
            _overlays[idx].frame = newFrame
        }*/
        if _overlays[overlayLabel] != nil {
            _overlays[overlayLabel]?.frame = newFrame
        }
    }
    
    //Removes the overlay identified by the given label.
    //Does nothing if no such overlay is found.
    func removeOverlay(overlayLabel: Int) {
        /*if label < 0 || _overlays.isEmpty {     //Error cases
            return
        }
        if _overlays.count == 1 {       //Special case: there is only 1 overlay.
            if _overlays[0].label == label {    //If the overlay is found.
                _overlays.removeAtIndex(0)
                _overlayFT = FenwickTree()
            }
            return
        }
        let offset = _overlayFT.query(label + 1)
        let idx = label - offset
        if idx >= 0 && idx < _overlays.count && _overlays[idx].label == label {  //If the overlay is found
            _overlayFT.update(label + 1, change: 1)
            if idx == _overlays.count - 1 { //Special case: Deleting last element.
                let prevLabel = _overlays[idx - 1].label
                _overlayFT.clearFromIndex(prevLabel + 1)
            }
            _overlays.removeAtIndex(idx)
        }*/
        _overlays.eraseValueForKey(overlayLabel)
    }
}
//
//  MementoNodeTests.swift
//  Memento
//
//  Unit tests for memory palace room
//
//  Created by Qua Zi Xian on 28/3/15.
//  Copyright (c) 2015 NUS CS3217. All rights reserved.
//

import Foundation
import UIKit
import XCTest

class MementoNodeTests: XCTestCase {
    func testInit(){
        let node = MementoNode(imageFile: "A.png")
        XCTAssertEqual(node.icon, MemoryPalaceRoomIcon(graphName: "sampleGraph", label: 0, filename: "A.png", overlays: []))
        XCTAssertEqual(node.numPlaceHolders, 0)
    }
    
    func testAddPlaceHolder() {
        let node = MementoNode(imageFile: "A.png")
        let placeHolder1 = RectanglePlaceHolder(highlightArea: CGRectMake(0, 0, 30, 20))
        let placeHolder2 = RectanglePlaceHolder(highlightArea: CGRectMake(40, 50, 30, 20))
        let placeHolder3 = RectanglePlaceHolder(highlightArea: CGRectMake(69, 69, 20, 20))
        let assoc1 = Association(placeHolder: placeHolder1, value: "")
        let assoc2 = Association(placeHolder: placeHolder2, value: "")
        let assoc3 = Association(placeHolder: placeHolder3, value: "")
        
        node.addPlaceHolder(placeHolder1)
        XCTAssertEqual(node.numPlaceHolders, 1)
        XCTAssertEqual(placeHolder1.label, 0)
        XCTAssertEqual(node.associations, [assoc1])
        
        node.addPlaceHolder(placeHolder2)
        XCTAssertEqual(node.numPlaceHolders, 2)
        XCTAssertEqual(placeHolder2.label, 1)
        XCTAssertEqual(node.associations, [assoc1, assoc2])
        
        node.addPlaceHolder(placeHolder3)
        XCTAssertEqual(node.numPlaceHolders, 3)
        XCTAssertEqual(placeHolder3.label, 2)
        XCTAssertEqual(node.associations, [assoc1, assoc2, assoc3])
    }
    
    func testRemovePlaceHolder() {
        let frame1 = CGRectMake(0, 0, 10, 20)
        let frame2 = CGRectMake(10, 0, 10, 20)
        let frame3 = CGRectMake(20, 0, 10, 20)
        let frame4 = CGRectMake(30, 0, 10, 20)
        let frame5 = CGRectMake(40, 0, 10, 20)
        let placeHolder1 = RectanglePlaceHolder(highlightArea: frame1)
        let placeHolder2 = RectanglePlaceHolder(highlightArea: frame2)
        let placeHolder3 = RectanglePlaceHolder(highlightArea: frame3)
        let placeHolder4 = RectanglePlaceHolder(highlightArea: frame4)
        let placeHolder5 = RectanglePlaceHolder(highlightArea: frame5)
        let node = MementoNode(imageFile: "A.png")
        
        node.addPlaceHolder(placeHolder1)
        node.addPlaceHolder(placeHolder2)
        node.addPlaceHolder(placeHolder3)
        
        //Tests removal from the middle
        node.removePlaceHolder(placeHolder2.label)
        XCTAssertTrue(node.getPlaceHolder(placeHolder2.label) == nil)
        XCTAssertFalse(node.getPlaceHolder(placeHolder1.label) == nil)
        XCTAssertFalse(node.getPlaceHolder(placeHolder3.label) == nil)
        XCTAssertEqual(placeHolder3.label, 2)
        
        //Tests removal of non-existent placeholder
        node.removePlaceHolder(placeHolder2.label)
        XCTAssertFalse(node.getPlaceHolder(placeHolder3.label) == nil)
        
        node.addPlaceHolder(placeHolder4)
        node.addPlaceHolder(placeHolder5)
        XCTAssertFalse(node.getPlaceHolder(placeHolder4.label) == nil)
        XCTAssertFalse(node.getPlaceHolder(placeHolder5.label) == nil)
        
        //Removal of back elements
        node.removePlaceHolder(placeHolder4.label)
        node.removePlaceHolder(placeHolder5.label)
        XCTAssertTrue(node.getPlaceHolder(placeHolder4.label) == nil)
        XCTAssertTrue(node.getPlaceHolder(placeHolder5.label) == nil)
        
        //Tests placeholder labelling scheme after removal of back elements
        node.addPlaceHolder(placeHolder2)
        XCTAssertFalse(node.getPlaceHolder(placeHolder2.label) == nil)
        XCTAssertEqual(placeHolder2.label, 3)
    }
    
    func testSetAssociationValue() {
        let node = MementoNode(imageFile: "A.png")
        let placeHolder1 = RectanglePlaceHolder(highlightArea: CGRectMake(0, 0, 30, 20))
        let placeHolder2 = RectanglePlaceHolder(highlightArea: CGRectMake(40, 50, 30, 20))
        let placeHolder3 = RectanglePlaceHolder(highlightArea: CGRectMake(70, 70, 20, 20))
        var assoc1 = Association(placeHolder: placeHolder1, value: "")
        var assoc2 = Association(placeHolder: placeHolder2, value: "")
        var assoc3 = Association(placeHolder: placeHolder3, value: "")
        
        node.addPlaceHolder(placeHolder1)
        node.addPlaceHolder(placeHolder2)
        node.addPlaceHolder(placeHolder3)
        XCTAssertEqual(node.numPlaceHolders, 3)
        XCTAssertEqual(node.associations, [assoc1, assoc2, assoc3])
        
        node.setAssociationValue(0, value: "3")
        assoc1 = Association(placeHolder: placeHolder1, value: "3")
        XCTAssertEqual(node.associations, [assoc1, assoc2, assoc3])
        
        node.setAssociationValue(2, value: "4")
        assoc3 = Association(placeHolder: placeHolder3, value: "4")
        XCTAssertEqual(node.associations, [assoc1, assoc2, assoc3])
        
        node.setAssociationValue(0, value: "")
        assoc1 = Association(placeHolder: placeHolder1, value: "")
        XCTAssertEqual(node.associations, [assoc1, assoc2, assoc3])
        
        node.removePlaceHolder(0)
        XCTAssertEqual(node.getAssociation(2)!, assoc3)
    }
    
    func testPlistEncoding() {
        let node = MementoNode(imageFile: "A.png")
        let overlay1 = MutableOverlay(frame: CGRectMake(30, 30, 30, 30), imageFile: "B.png")
        let overlay2 = MutableOverlay(frame: CGRectMake(45, 0, 100, 77), imageFile: "C.png")
        let placeHolder1 = RectanglePlaceHolder(highlightArea: CGRectMake(30, 30, 30, 30))
        let placeHolder2 = RectanglePlaceHolder(highlightArea: CGRectMake(100, 200, 300, 400))
        
        //Tests initial state representation
        var rep = node.plistRepresentation
        XCTAssertEqual(rep[bgImageKey] as NSString, "A.png")
        XCTAssertEqual((rep.objectForKey(overlayKey) as NSArray).count, 0)
        XCTAssertEqual((rep.objectForKey(placeHolderKey) as NSArray).count, 0)
        XCTAssertEqual((rep.objectForKey(valueKey) as NSArray).count, 0)
        
        node.addOverlay(overlay1)
        node.addOverlay(overlay2)
        node.addPlaceHolder(placeHolder1)
        node.addPlaceHolder(placeHolder2)
        rep = node.plistRepresentation
        XCTAssertEqual(rep[bgImageKey] as NSString, "A.png")
        
        //Checking the overlay objects' conversion.
        //This is a way to decode the overlay from the node's plist representation.
        XCTAssertEqual((rep.objectForKey(overlayKey) as NSArray).count, 2)
        XCTAssertEqual(MutableOverlay.decodeFromString((rep.objectForKey(overlayKey) as NSArray).objectAtIndex(0) as String), overlay1)
        XCTAssertEqual(MutableOverlay.decodeFromString((rep.objectForKey(overlayKey) as NSArray).objectAtIndex(1) as String), overlay2)
        
        //Checking the placeholders' conversion.
        //This is a way to decode the placehodler from the node's plist representation.
        XCTAssertEqual((rep.objectForKey(placeHolderKey) as NSArray).count, 2)
        XCTAssertEqual(PlaceHolder.decodeFromString((rep.objectForKey(placeHolderKey) as NSArray).objectAtIndex(0) as String), placeHolder1)
        XCTAssertEqual(PlaceHolder.decodeFromString((rep.objectForKey(placeHolderKey) as NSArray).objectAtIndex(1) as String), placeHolder2)
        
        //Checking that null values are added corresponding to each placeholder.
        XCTAssertEqual((rep.objectForKey(valueKey) as NSArray).count, 2)
        XCTAssertEqual((rep.objectForKey(valueKey) as NSArray).objectAtIndex(0) as String, "")
        XCTAssertEqual((rep.objectForKey(valueKey) as NSArray).objectAtIndex(1) as String, "")
        
        node.setAssociationValue(1, value: "Hello")
        rep = node.plistRepresentation
        
        //Repeating the previous assertions to check that the other attribute states are unaffected.
        XCTAssertEqual(rep[bgImageKey] as NSString, "A.png")
        
        XCTAssertEqual((rep.objectForKey(overlayKey) as NSArray).count, 2)
        XCTAssertEqual(MutableOverlay.decodeFromString((rep.objectForKey(overlayKey) as NSArray).objectAtIndex(0) as String), overlay1)
        XCTAssertEqual(MutableOverlay.decodeFromString((rep.objectForKey(overlayKey) as NSArray).objectAtIndex(1) as String), overlay2)
        
        XCTAssertEqual((rep.objectForKey(placeHolderKey) as NSArray).count, 2)
        XCTAssertEqual(PlaceHolder.decodeFromString((rep.objectForKey(placeHolderKey) as NSArray).objectAtIndex(0) as String), placeHolder1)
        XCTAssertEqual(PlaceHolder.decodeFromString((rep.objectForKey(placeHolderKey) as NSArray).objectAtIndex(1) as String), placeHolder2)
        
        //Checking that null values are added corresponding to each placeholder.
        XCTAssertEqual((rep.objectForKey(valueKey) as NSArray).count, 2)
        XCTAssertEqual((rep.objectForKey(valueKey) as NSArray).objectAtIndex(0) as String, "")
        XCTAssertEqual((rep.objectForKey(valueKey) as NSArray).objectAtIndex(1) as String, "Hello")
    }
    
    func testAddOverlay() {
        let frame = CGRectMake(10, 20, 30, 40)
        var overlay1 = MutableOverlay(frame: frame, imageFile: "A.png")
        var overlay2 = MutableOverlay(frame: frame, imageFile: "B.png")
        let node = MementoNode(imageFile: "A.png")
        
        overlay1.label = node.addOverlay(overlay1)
        overlay2.label = node.addOverlay(overlay2)
        XCTAssertFalse(node.getOverlay(overlay1.label) == nil)
        XCTAssertFalse(node.getOverlay(overlay2.label) == nil)
        XCTAssertEqual(node.getOverlay(overlay1.label)!, overlay1.makeImmuatble())
        XCTAssertEqual(node.getOverlay(overlay2.label)!, overlay2.makeImmuatble())
    }
    
    func testRemoveOverlay() {
        let frame = CGRectMake(10, 20, 30, 40)
        var overlay1 = MutableOverlay(frame: frame, imageFile: "A.png")
        var overlay2 = MutableOverlay(frame: frame, imageFile: "B.png")
        var overlay3 = MutableOverlay(frame: frame, imageFile: "C.png")
        var overlay4 = MutableOverlay(frame: frame, imageFile: "D.png")
        var overlay5 = MutableOverlay(frame: frame, imageFile: "E.png")
        let node =  MementoNode(imageFile: "A.png")
        
        //Tests removeing overlay from an empty list.
        //Make sure it does not crash.
        node.removeOverlay(3)
        
        //Loads the overlays
        //Oder should be [overlay1, overlay2, overlay3]
        overlay1.label = node.addOverlay(overlay1)
        overlay2.label = node.addOverlay(overlay2)
        overlay3.label = node.addOverlay(overlay3)
        XCTAssertEqual(node.getOverlay(overlay1.label)!, overlay1.makeImmuatble())
        XCTAssertEqual(node.getOverlay(overlay2.label)!, overlay2.makeImmuatble())
        XCTAssertEqual(node.getOverlay(overlay3.label)!, overlay3.makeImmuatble())
        XCTAssertEqual(node.overlays, [overlay1.makeImmuatble(), overlay2.makeImmuatble(), overlay3.makeImmuatble()])
        
        //Tests deletion in the middle
        //Order should become: [overlay1, overlay3, overlay4] at the end of this block.
        node.removeOverlay(overlay2.label)
        XCTAssertTrue(node.getOverlay(overlay2.label) == nil)
        overlay4.label = node.addOverlay(overlay4)
        XCTAssertEqual(overlay4.label, overlay3.label + 1)
        XCTAssertEqual(node.overlays, [overlay1.makeImmuatble(), overlay3.makeImmuatble(), overlay4.makeImmuatble()])
        
        //Tests deletion of 1st element
        //Order should become [overlay3, overlay4]
        XCTAssertEqual(overlay1.label, 0)
        node.removeOverlay(overlay1.label)
        XCTAssertTrue(node.getOverlay(overlay1.label) == nil)
        XCTAssertEqual(node.overlays, [overlay3.makeImmuatble(), overlay4.makeImmuatble()])
        XCTAssertFalse(node.getOverlay(overlay3.label) == nil)
        XCTAssertFalse(node.getOverlay(overlay4.label) == nil)
        XCTAssertEqual(node.getOverlay(overlay3.label)!, overlay3.makeImmuatble())
        XCTAssertEqual(node.getOverlay(overlay4.label)!, overlay4.makeImmuatble())
        
        //Make number of overlays 3
        //Overlay list becomes [overlay3, overlay4, overlay5]
        overlay5.label = node.addOverlay(overlay5)
        XCTAssertFalse(node.getOverlay(overlay5.label) == nil)
        XCTAssertEqual(overlay4.label + 1, overlay5.label)
        
        //Tests deletion of the last elements
        node.removeOverlay(overlay5.label)
        node.removeOverlay(overlay4.label)
        XCTAssertTrue(node.getOverlay(overlay4.label) == nil)
        XCTAssertTrue(node.getOverlay(overlay5.label) == nil)
        overlay1.label = node.addOverlay(overlay1)
        XCTAssertFalse(node.getOverlay(overlay1.label) == nil)
        XCTAssertEqual(overlay3.label + 1, overlay1.label)
        
        //Currently, list of overlays is [overlay3, overlay1]
        //Removes non-existent overlays
        node.removeOverlay(0)
        node.removeOverlay(1)
        node.removeOverlay(5)
        XCTAssertFalse(node.getOverlay(overlay3.label) == nil)
        XCTAssertFalse(node.getOverlay(overlay1.label) == nil)
        XCTAssertEqual(node.getOverlay(overlay3.label)!, overlay3.makeImmuatble())
        XCTAssertEqual(node.getOverlay(overlay1.label)!, overlay1.makeImmuatble())
        
        //Tests removing the last remaining overlay.
        //This happens after removing one of the current 2 overlays.
        node.removeOverlay(overlay3.label)
        node.removeOverlay(overlay1.label)
        XCTAssertTrue(node.getOverlay(overlay3.label) == nil)
        XCTAssertTrue(node.getOverlay(overlay1.label) == nil)
        
        //Test to ensure that Fenwick Tree is cleared properly when overlays array becomes empty.
        overlay1.label = node.addOverlay(overlay1)
        XCTAssertFalse(node.getOverlay(0) == nil)
        XCTAssertEqual(node.getOverlay(0)!, overlay1.makeImmuatble())
    }
    
    func testSetOverlayFrame() {
        let frame1 = CGRectMake(10, 20, 30, 40)
        let frame2 = CGRectMake(20, 30, 40, 50)
        var overlay1 = MutableOverlay(frame: frame1, imageFile: "A.png")
        var overlay2 = MutableOverlay(frame: frame1, imageFile: "B.png")
        let node = MementoNode(imageFile: "A.png")
        
        //Normal case without prior deletion
        overlay1.label = node.addOverlay(overlay1)
        overlay2.label = node.addOverlay(overlay2)
        node.setOverlayFrame(overlay2.label, newFrame: frame2)
        XCTAssertEqual(node.getOverlay(overlay2.label)!.frame, frame2)
        
        node.removeOverlay(overlay1.label)
        node.setOverlayFrame(overlay2.label, newFrame: frame1)
        XCTAssertEqual(node.getOverlay(overlay2.label)!.frame, frame1)
    }
}
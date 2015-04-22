//
//  MementoManagerTests.swift
//  Memento
//
//  High level black-box unit testing for data managerment component.
//  Do not change the namges of the unit tests.
//  Tests are execute by alphabetical order of their names and manager holds a singleton instance of the model.
//  So changes made to the model through the manager is propagated to othe rtest cases.
//
//  Created by Qua Zi Xian on 28/3/15.
//  Copyright (c) 2015 NUS CS3217. All rights reserved.
//

import Foundation
import UIKit
import XCTest

class MementoManagerTests: XCTestCase {
    func test() {
        let bundle = NSBundle.mainBundle()
        println(bundle.pathForResource("linuxpenguin", ofType: "jpg"))
    }
    
    func testAddAndRemoveMemoryPalace() {
        let manager = MementoManager.sharedInstance
        let model = MementoModel.sharedInstance
        let image = UIImage(contentsOfFile: NSBundle.mainBundle().pathForResource("linuxpenguin", ofType: "jpg")!)!
        var initialNumPalace = manager.numberOfMemoryPalace
        
        //Tests adding palace with resource as JPG
        let res = manager.addMemoryPalace(named: "graph1", image: image, imageType: Constants.ImageType.JPG)
        XCTAssertEqual(res.0, "graph1")
        XCTAssertEqual(res.1.pathExtension, "jpg")
        XCTAssertEqual(manager.numberOfMemoryPalace, initialNumPalace+1)
        XCTAssertTrue(fileExists("sharedResource".stringByAppendingPathComponent(res.1)))
        XCTAssertFalse(manager.getMemoryPalace("graph1") == nil)
        XCTAssertEqual(manager.getMemoryPalace("graph1")!.icon, MemoryPalaceIcon(graphName: "graph1", imageFile: res.1))
        
        //Add memory palace with duplicate name
        XCTAssertEqual(manager.addMemoryPalace(named: "graph1", imageFile: res.1), "graph1(1)")
        XCTAssertFalse(manager.getMemoryPalace("graph1(1)") == nil)
        XCTAssertEqual(manager.getMemoryPalace("graph1(1)")!.icon, MemoryPalaceIcon(graphName: "graph1(1)", imageFile: res.1))
        XCTAssertEqual(manager.numberOfMemoryPalace, initialNumPalace+2)
        
        //Adds another palace using the same image as graph1 but as PNG
        let res2 = manager.addMemoryPalace(named: "graph2", image: image, imageType: Constants.ImageType.PNG)
        XCTAssertEqual(res2.0, "graph2")
        XCTAssertEqual(res2.1.pathExtension, "png")
        XCTAssertTrue(fileExists("sharedResource".stringByAppendingPathComponent(res2.1)))
        XCTAssertEqual(manager.numberOfMemoryPalace, initialNumPalace+3)
        XCTAssertFalse(manager.getMemoryPalace("graph2") == nil)
        XCTAssertEqual(manager.getMemoryPalace("graph2")!.icon, MemoryPalaceIcon(graphName: "graph2", imageFile: res2.1))
        
        //Deletes 1 of the memory palace using the existing image
        manager.removeMemoryPalace("graph1")
        XCTAssertEqual(manager.numberOfMemoryPalace, initialNumPalace+2)
        XCTAssertTrue(manager.getMemoryPalace("graph1") == nil)
        XCTAssertTrue(fileExists("sharedResource".stringByAppendingPathComponent(res.1)))    //Check for existing reference.
        
        //Remove last reference to the actual image.
        manager.removeMemoryPalace("graph1(1)")
        XCTAssertEqual(manager.numberOfMemoryPalace, initialNumPalace+1)
        XCTAssertTrue(manager.getMemoryPalace("graph1(1)") == nil)
        XCTAssertFalse(fileExists("sharedResource".stringByAppendingPathComponent(res.1)))
        
        //Clean up the remaining test graph
        manager.removeMemoryPalace("graph2")
        XCTAssertEqual(manager.numberOfMemoryPalace, initialNumPalace)
        XCTAssertTrue(manager.getMemoryPalace("graph2") == nil)
        XCTAssertFalse(fileExists("sharedResource".stringByAppendingPathComponent(res2.1)))

        dispatch_sync(model.saveQueue, {() -> Void in
            //Wait for all asynchronous cleanup operations to be done.
        })
    }
    
    func testInsertAndRemoveMemoryPalaceRoom() {
        let manager = MementoManager.sharedInstance
        let model = MementoModel.sharedInstance
        let image = UIImage(contentsOfFile: NSBundle.mainBundle().pathForResource("linuxpenguin", ofType: "jpg")!)!
        let palaceName = manager.addMemoryPalace(named: "graph1", image: image, imageType: Constants.ImageType.JPG).0
        let room1Image = manager.getMemoryPalaceRoomView(palaceName, roomLabel: 0)!.backgroundImage
        
        //Tests initial state
        XCTAssertTrue(fileExists("sharedResource".stringByAppendingPathComponent(room1Image)))
        XCTAssertFalse(manager.getPalaceOverview(palaceName) == nil)
        
        //Adds room2 using new resource as PNG
        let res = manager.addMemoryPalaceRoom(palaceName, image: image, imageType: Constants.ImageType.PNG)
        XCTAssertFalse(res == nil)
        XCTAssertEqual(res!.0, 1)
        XCTAssertEqual(res!.1.pathExtension, "png")
        XCTAssertEqual(manager.getMemoryPalaceRoomView(palaceName, roomLabel: 1)!.backgroundImage, res!.1)
        //XCTAssertEqual(manager.getPalaceOverview(palaceName)!, [room1, room2])
        XCTAssertTrue(fileExists("sharedResource".stringByAppendingPathComponent(res!.1)))
        
        //Adds room3 using existing resource
        if let res2 = manager.addMemoryPalaceRoom(palaceName, roomImage: room1Image) {
            XCTAssertEqual(res2, 2)
            XCTAssertEqual(manager.getMemoryPalaceRoomView(palaceName, roomLabel: 2)!.backgroundImage, room1Image)
        }
        
        //Tests adding room using new image as JPG
        let res3 = manager.addMemoryPalaceRoom(palaceName, image: image, imageType: Constants.ImageType.JPG)
        XCTAssertFalse(res3 == nil)
        XCTAssertEqual(res3!.0, 3)
        XCTAssertEqual(res3!.1.pathExtension, "jpg")
        XCTAssertTrue(fileExists("sharedResource".stringByAppendingPathComponent(res3!.1)))
        
        //Tests adding room to non-existent memory palace
        XCTAssertTrue(manager.addMemoryPalaceRoom("somePalace", roomImage: "B.png") == nil)
        XCTAssertTrue(manager.addMemoryPalaceRoom("somePalace", image: image, imageType: Constants.ImageType.JPG) == nil)
        
        //Removes room2
        manager.removeMemoryPalaceRoom(palaceName, roomLabel: 1)
        XCTAssertTrue(manager.getMemoryPalaceRoom(palaceName, roomLabel: 1) == nil)
        XCTAssertFalse(fileExists("sharedResource".stringByAppendingPathComponent(res!.1)))
        
        //Removes room3
        manager.removeMemoryPalaceRoom(palaceName, roomLabel: 2)
        XCTAssertTrue(manager.getMemoryPalaceRoom(palaceName, roomLabel: 2) == nil)
        XCTAssertTrue(fileExists("sharedResource".stringByAppendingPathComponent(room1Image)))
        
        //Removes till 1 room remaining
        manager.removeMemoryPalaceRoom(palaceName, roomLabel: 0)
        XCTAssertTrue(manager.getMemoryPalaceRoom(palaceName, roomLabel: 0) == nil)
        XCTAssertFalse(fileExists("sharedResource".stringByAppendingPathComponent(room1Image)))
        
        //Attempts to remove last remaining room
        manager.removeMemoryPalaceRoom(palaceName, roomLabel: 3)
        XCTAssertFalse(manager.getMemoryPalaceRoom(palaceName, roomLabel: 3) == nil)
        
        //Clean up directory
        manager.removeMemoryPalace(palaceName)
        
        dispatch_sync(model.saveQueue, {() -> Void in
            //Do nothing. Wait for deletion to complete.
        })
    }
    
    func testSetBackgroundImage() {
        let manager = MementoManager.sharedInstance
        let model = MementoModel.sharedInstance
        let palaceName = manager.addMemoryPalace(named: "graph1", imageFile: "A.png")
        let room = model.getMemoryPalaceRoom(palaceName, roomLabel: 0)
        let image = UIImage(named: NSBundle.mainBundle().pathForResource("linuxpenguin", ofType: ".jpg")!)!
        
        XCTAssertEqual(room!.backgroundImageFile, "A.png")
        
        //Tests normal operation using JPG resource
        let imageName = manager.setBackgroundImageForRoom(palaceName, roomLabel: 0, newImage: image, imageType: Constants.ImageType.JPG)
        if imageName != nil {
            XCTAssertEqual(imageName!.pathExtension, "jpg")
            XCTAssertEqual(room!.backgroundImageFile, imageName!)
            XCTAssertTrue(fileExists("sharedResource".stringByAppendingPathComponent(imageName!)))
            
            //Attempts to change to same background image
            //The image file should not be dropped.
            manager.setBackgroundImageForRoom(palaceName, roomLabel: 0, newImageFile: imageName!)
            XCTAssertTrue(fileExists("sharedResource".stringByAppendingPathComponent(imageName!)))
            
            //Changes back the background image
            manager.setBackgroundImageForRoom(palaceName, roomLabel: 0, newImageFile: "A.png")
            XCTAssertEqual(room!.backgroundImageFile, "A.png")
            XCTAssertFalse(fileExists("sharedResource".stringByAppendingPathComponent(imageName!)))
        }
        
        //Tests normal operation using PNG resource
        let imageName2 = manager.setBackgroundImageForRoom(palaceName, roomLabel: 0, newImage: image, imageType: Constants.ImageType.PNG)
        if imageName2 != nil {
            XCTAssertEqual(imageName2!.pathExtension, "png")
            XCTAssertEqual(room!.backgroundImageFile, imageName2!)
            XCTAssertTrue(fileExists("sharedResource".stringByAppendingPathComponent(imageName2!)))
            
            //Change back the background image
            manager.setBackgroundImageForRoom(palaceName, roomLabel: 0, newImageFile: "A.png")
            XCTAssertEqual(room!.backgroundImageFile, "A.png")
            XCTAssertFalse(fileExists("sharedResource".stringByAppendingPathComponent(imageName2!)))
        }
        
        //Attempts to set background image on non-existent room
        XCTAssertTrue(manager.setBackgroundImageForRoom(palaceName, roomLabel: 1, newImage: image, imageType: Constants.ImageType.JPG) == nil)
        
        //Clean up directory
        manager.removeMemoryPalace(palaceName)
        
        dispatch_sync(model.saveQueue, {() -> Void in
            //Do nothing. Wait for deletion to complete.
        })
    }
    
    func testPlaceHolderOperations() {
        let manager = MementoManager.sharedInstance
        let model = MementoModel.sharedInstance
        let palaceName = manager.addMemoryPalace(named: "graph1", imageFile: "A.png")
        let placeHolder1 = RectanglePlaceHolder(highlightArea: CGRectMake(10, 20, 30, 40))
        let frame2 = CGRectMake(100, 100, 100, 100)
        let room = model.getMemoryPalaceRoom(palaceName, roomLabel: 0)
        XCTAssertFalse(room == nil)
        XCTAssertEqual(room!.numPlaceHolders, 0)
        placeHolder1.label = 1  //To test if the label gets updated when added to room
        
        //Adds the placeholder
        //Note: This part is prone to runtime error.
        //Last error recived was 'cannot index empty buffer'.
        //Cause to be investigated.
        XCTAssertTrue(manager.addPlaceHolder(palaceName, roomLabel: 0, placeHolder: placeHolder1))
        XCTAssertEqual(room!.numPlaceHolders, 1)
        XCTAssertEqual(placeHolder1.label, 0)
        XCTAssertEqual(room!.getPlaceHolder(0)!, placeHolder1)
        
        //Tries to add same placeholder again. Simulate overlapping placeholder
        XCTAssertFalse(manager.addPlaceHolder(palaceName, roomLabel: 0, placeHolder: placeHolder1))
        XCTAssertEqual(room!.numPlaceHolders, 1)
        
        //Adds placeholder to non-existent room
        XCTAssertFalse(manager.addPlaceHolder(palaceName, roomLabel: 1, placeHolder: placeHolder1))
        
        //Change frame of current placeholder
        manager.setPlaceHolderFrame(palaceName, roomLabel: 0, placeHolderLabel: 0, newFrame: frame2)
        XCTAssertEqual((room!.getPlaceHolder(0) as RectanglePlaceHolder).highlightArea, frame2)
        
        //Sets association value
        XCTAssertEqual(room!.getAssociation(0)!.value, "")
        manager.setAssociationValue(palaceName, roomLabel: 0, placeHolderLabel: 0, value: "Hello")
        XCTAssertEqual(room!.getAssociation(0)!.value, "Hello")
        
        //Removes placeholder
        manager.removePlaceHolder(palaceName, roomLabel: 0, placeHolderLabel: 0)
        XCTAssertEqual(room!.numPlaceHolders, 0)
        XCTAssertTrue(room!.getPlaceHolder(0) == nil)
        XCTAssertTrue(room!.getAssociation(0) == nil)
        
        //Cleanup
        manager.removeMemoryPalace(palaceName)
        dispatch_sync(model.saveQueue, {() -> Void in
            //Do nothing. Wait for cleanup to finish.
        })
    }
    
    func testSwapPlaceHolders() {
        let manager = MementoManager.sharedInstance
        let model = MementoModel.sharedInstance
        let graph = MementoGraph(name: "graph1", rootNode: MementoNode(imageFile: "A.png"))
        let pHolder1 = RectanglePlaceHolder(highlightArea: CGRectMake(0, 0, 10, 20))
        let pHolder2 = RectanglePlaceHolder(highlightArea: CGRectMake(10, 0, 20, 20))
        
        //Memory palace not present.
        XCTAssertFalse(manager.swapPlaceHolders(graph.name, roomLabel: 0, pHolder1Label: 0, pHolder2Label: 1))
        
        model.addPalace(graph)
        
        //Both placeholers are not present
        XCTAssertFalse(manager.swapPlaceHolders(graph.name, roomLabel: 0, pHolder1Label: 0, pHolder2Label: 1))
        
        XCTAssertTrue(manager.addPlaceHolder(graph.name, roomLabel: 0, placeHolder: pHolder1))
        XCTAssertTrue(manager.addPlaceHolder(graph.name, roomLabel: 0, placeHolder: pHolder2))
        XCTAssertEqual(pHolder1.label, 0)
        XCTAssertEqual(pHolder2.label, 1)
        
        //Room not present.
        XCTAssertFalse(manager.swapPlaceHolders(graph.name, roomLabel: 1, pHolder1Label: 0, pHolder2Label: 1))
        
        //Swap actually takes place.
        XCTAssertTrue(manager.swapPlaceHolders(graph.name, roomLabel: 0, pHolder1Label: 0, pHolder2Label: 1))
        XCTAssertEqual(pHolder1.label, 1)
        XCTAssertEqual(pHolder2.label, 0)
        
        //Both placeholders do not exist.
        XCTAssertFalse(manager.swapPlaceHolders(graph.name, roomLabel: 0, pHolder1Label: 2, pHolder2Label: 8))
        
        //1 of the placeholders does not exist.
        manager.removePlaceHolder(graph.name, roomLabel: 0, placeHolderLabel: 0)
        XCTAssertFalse(manager.swapPlaceHolders(graph.name, roomLabel: 0, pHolder1Label: 1, pHolder2Label: 0))
        
        //Clean up directory
        model.removePalace(graph.name)
        
        dispatch_sync(model.saveQueue, {() -> Void in
            //Do nothing. Wait for cleanup to finish.
        })
    }
    
    func testOverlayOperations() {
        let manager = MementoManager.sharedInstance
        let model = MementoModel.sharedInstance
        let palaceName = manager.addMemoryPalace(named: "graph1", imageFile: "A.png")
        let room = model.getMemoryPalaceRoom(palaceName, roomLabel: 0)
        let image = UIImage(named: NSBundle.mainBundle().pathForResource("linuxpenguin", ofType: ".jpg")!)!
        let frame1  = CGRectMake(0, 0, 10, 10)
        let frame2 = CGRectMake(50, 50, 10, 10)
        XCTAssertFalse(room == nil)
        XCTAssertEqual(room!.numOverlays, 0)
        
        //Add overlay with new image resource as JPG
        let overlay1 = manager.addOverlay(palaceName, roomLabel: 0, frame: frame1, image: image, imageType: Constants.ImageType.JPG)
        if overlay1 != nil {
            XCTAssertEqual(overlay1!.imageFile.pathExtension, "jpg")
            XCTAssertEqual(room!.numOverlays, 1)
            XCTAssertEqual(room!.getOverlay(0)!, overlay1!)
            XCTAssertEqual(overlay1!.label, 0)
            XCTAssertEqual(overlay1!.frame, frame1)
            XCTAssertTrue(fileExists("sharedResource".stringByAppendingPathComponent(overlay1!.imageFile)))
        } else {
            XCTFail("Overlay 1 not added")
        }
        
        //Add overlay using existing image resource
        var overlay2 = MutableOverlay(frame: frame2, imageFile: overlay1!.imageFile)
        if let label = manager.addOverlay(palaceName, roomLabel: 0, overlay: overlay2) {
            overlay2.label = label
            XCTAssertEqual(room!.numOverlays, 2)
            XCTAssertEqual(label, 1)
            XCTAssertEqual(room!.getOverlay(1)!, overlay2.makeImmuatble())
        } else {
            XCTFail("Overlay 2 not added")
        }
        
        //Add overlay using new image resource as PNG
        var overlay3 = manager.addOverlay(palaceName, roomLabel: 0, frame: frame1, image: image, imageType: Constants.ImageType.PNG)
        if overlay3 != nil {
            XCTAssertEqual(overlay3!.imageFile.pathExtension, "png")
            XCTAssertEqual(room!.numOverlays, 3)
            XCTAssertEqual(overlay3!.label, 2)
            XCTAssertEqual(overlay3!.frame, frame1)
            XCTAssertTrue(fileExists("sharedResource".stringByAppendingPathComponent(overlay3!.imageFile)))
        }
        
        //Failed attempts to add overlay
        XCTAssertTrue(manager.addOverlay(palaceName, roomLabel: 1, frame: frame1, image: image, imageType: Constants.ImageType.JPG) == nil)
        XCTAssertTrue(manager.addOverlay(palaceName, roomLabel: 1, overlay: overlay2) == nil)
        
        //Change overlay frames
        let newFrame1 = CGRectMake(30, 40, 50, 60)
        manager.setOverlayFrame(palaceName, roomLabel: 0, overlayLabel: 0, newFrame: newFrame1)
        XCTAssertNotEqual(room!.getOverlay(0)!, overlay1!)
        XCTAssertEqual(room!.getOverlay(0)!.frame, newFrame1)
        XCTAssertEqual(room!.getOverlay(0)!.imageFile, overlay1!.imageFile)
        
        //Change overlay for non-existent room/overlay
        manager.setOverlayFrame(palaceName, roomLabel: 1, overlayLabel: 1, newFrame: newFrame1)
        XCTAssertEqual(room!.getOverlay(1)!, overlay2.makeImmuatble())
        
        //Remove overlays
        manager.removeOverlay(palaceName, roomLabel: 0, overlayLabel: 0)
        XCTAssertEqual(room!.numOverlays, 2)
        XCTAssertTrue(room!.getOverlay(0) == nil)
        XCTAssertTrue(fileExists("sharedResource".stringByAppendingPathComponent(overlay1!.imageFile)))
        
        //Removing these overlays cause the image resources to be deleted
        manager.removeOverlay(palaceName, roomLabel: 0, overlayLabel: 1)
        XCTAssertEqual(room!.numOverlays, 1)
        XCTAssertTrue(room!.getOverlay(1) == nil)
        XCTAssertFalse(fileExists("sharedResource".stringByAppendingPathComponent(overlay1!.imageFile)))
        
        manager.removeOverlay(palaceName, roomLabel: 0, overlayLabel: 2)
        XCTAssertEqual(room!.numOverlays, 0)
        XCTAssertTrue(room!.getOverlay(2) == nil)
        XCTAssertFalse(fileExists("sharedResource".stringByAppendingPathComponent(overlay3!.imageFile)))
        
        //Cleanup
        manager.removeMemoryPalace(palaceName)
        dispatch_sync(model.saveQueue, {() -> Void in
            //Do nothing. Wait for cleanup to finish.
        })
    }
    
    func testGetNextNodeView() {
        let manager = MementoManager.sharedInstance
        let model = MementoModel.sharedInstance
        let graph = MementoGraph(name: "graph1", rootNode: MementoNode(imageFile: "A.png"))
        let room2 = MementoNode(imageFile: "B.png")
        let room3 = MementoNode(imageFile: "C.png")
        
        model.addPalace(graph)
        model.addPalaceRoom(graph.name, room: room2)
        model.addPalaceRoom(graph.name, room: room3)
        XCTAssertEqual(room2.label, 1)
        XCTAssertEqual(room3.label, 2)
        
        XCTAssertEqual(manager.getNextNode(graph.name, roomLabel: 0)!.label, 1)
        XCTAssertEqual(manager.getNextNode(graph.name, roomLabel: 1)!.label, 2)
        XCTAssertTrue(manager.getNextNode(graph.name, roomLabel: 2) == nil)
        
        manager.removeMemoryPalaceRoom(graph.name, roomLabel: 1)
        XCTAssertEqual(manager.getNextNode(graph.name, roomLabel: 0)!.label, 2)
        XCTAssertEqual(manager.getNextNode(graph.name, roomLabel: 1)!.label, 2)
        XCTAssertTrue(manager.getNextNode(graph.name, roomLabel: 2) == nil)
        
        //Clean up directory
        model.removePalace(graph.name)
        
        dispatch_sync(model.saveQueue, {() -> Void in
            //Do nothing. Wait for cleanup to complete.
        })
    }
    
    private func fileExists(filename: String) -> Bool {
        let dir = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0] as String
        return NSFileManager.defaultManager().fileExistsAtPath(dir+"/\(filename)")
    }
    
    /*func testCleanup() {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray
        let documentsDirectory = paths.objectAtIndex(0) as String
        let path = documentsDirectory.stringByAppendingPathComponent("data")
        
        let fileManager = NSFileManager.defaultManager()
        let palacesFilenames = fileManager.subpathsOfDirectoryAtPath(path, error: nil)! as [String]
        
        for filename in palacesFilenames {
            println(filename)
        }
        
        fileManager.removeItemAtPath(path.stringByAppendingPathComponent("graph2(1)"), error: nil)
        fileManager.removeItemAtPath(path.stringByAppendingPathComponent("graph1(5)"), error: nil)
        fileManager.removeItemAtPath(path.stringByAppendingPathComponent("graph2(2)"), error: nil)
        fileManager.removeItemAtPath(path.stringByAppendingPathComponent("graph1(2)"), error: nil)
        fileManager.removeItemAtPath(path.stringByAppendingPathComponent("graph1(3)"), error: nil)
        fileManager.removeItemAtPath(path.stringByAppendingPathComponent("graph1"), error: nil)
    }*/
}
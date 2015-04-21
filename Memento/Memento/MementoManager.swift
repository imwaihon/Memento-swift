//
//  AppManager.swift
//  Memento
//
//  The facade class that receives ALL requests from the controller.
//  This class hides all the complexity of native backend operations.
//
//  Abstraction Functions:
//  Add memory palace:                                  addMemoryPalace(named: String, imageFile: String) -> String
//  Add memory palace with new resource:                addMemoryPalace(named: String, imageFile: String, image: UIImage) -> (String, String)
//  Get palace overview:                                getPalaceOverview(palaceName: String) -> [Memory]
//  Remove palace:                                      removeMemoryPalace(palaceName: String)
//  Add room to memory palace:                          addMemoryPalaceRoom(palaceName: String, roomImage: String) -> Int?
//  Add room to memory palace with new resource:        addMemoryPalaceRoom(palaceName: String, roomImage: String, image: UIImage) -> (Int, String)?
//  Get view representation for room:                   getMemoryPalaceRoomView(palaceName: String, roomLabel: Int) -> MemoryPalaceRoomView?
//  Set background image for room:                      setBackgroundImageForRoom(palaceName: String, roomLabel: Int, newImageFile: String)
//  Set background image for room with new resource:    setBackgroundImageForRoom(palaceName: String, roomLabel: Int, newImage: UIImage) -> String?
//  Remove memory palace room:                          removeMemoryPalaceRoom(palaceName: String, roomLabel: Int)
//  Add overlay:                                        addOverlay(palaceName: String, roomLabel: Int, overlay: MutableOverlay) -> Int?
//  Add overlay with new resource:                      addOverlay(palaceName: String, roomLabel: Int, frame: CGRect, image: UIImage) -> Overlay?
//  Shift/Resize overlay:                               setOverlayFrame(palaceName: String, roomLabel: Int, overlayLabel: Int, newFrame: CGRect)
//  Remove overlay:                                     removeOverlay(palaceName: String, roomLabel: Int, overlayLabel: Int)
//  Add placeholder:                                    addPlaceHolder(palaceName: String, roomLabel: Int, placeHolder: PlaceHolder) -> Bool
//  Shift/Resize placeholder:                           setPlaceHolderFrame(palaceName: String, roomLabel: Int, placeHolderLabel: Int, newFrame: CGRect)
//  Set association value:                              setAssociationValue(palaceName: String, roomLabel: Int, placeHolderLabel: Int, value: String)
//  Swap placeholder order:                             swapPlaceHolders(palaceName: String, roomLabel: Int, pHolder1Label: Int, pHolder2Label: Int) -> Bool
//  Remove placeholder:                                 removePlaceHolder(palaceName: String, roomLabel: Int, placeHolderLabel: Int)
//  Get view for next room:                             getNextNode(palaceName: String, roomLabel: Int) -> MemoryPalaceRoomView?
//  List image resources:                               getImageResource() -> [String]
//
//  Non-functional Specifications:
//  Save every change made to memory palace/room
//
//  Created by Qua Zi Xian on 24/3/15.
//  Copyright (c) 2015 NUS CS3217. All rights reserved.
//

import Foundation
import UIKit

class MementoManager {
    
    // Singleton pattern
    class var sharedInstance: MementoManager {
        struct Static {
            static var instance: MementoManager?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            Static.instance = MementoManager()
        }
        
        return Static.instance!
    }
    
    private var selectedPalace: MementoGraph?
    private var selectedRoom: MementoNode?
    private let model: MementoModel
    private let resourceManager: ResourceManager
    private let graphFactory: MementoGraphFactory
    private let nodeFactory: MementoNodeFactory

    //Properties
    var numberOfMemoryPalace: Int {
        return model.numPalaces
    }
    
    init(){
        selectedPalace = nil
        selectedRoom = nil
        model = MementoModel.sharedInstance
        resourceManager = ResourceManager(directory: Constants.imgResourceDir)
        graphFactory = MementoGraphFactory()
        nodeFactory = MementoNodeFactory()
    }
    
    //Gets the list of con representation of existing memory palaces.
    func getMemoryPalaceIcons() -> [MemoryPalaceIcon] {
        return model.palaceIcons
    }
    
    //Adds a new memory palace using an existing image in resources folder as the image of the 1st room.
    //If there exists another memory palace with the same name, a number will be appended to the
    //new memory palace's name.
    //Returns the name of the added memory palace as a confirmation.
    func addMemoryPalace(named name: String, imageFile: String) -> String {
        //assert(resourceManager.referenceCountForResource(imageFile) > 0)
        resourceManager.retainResource(imageFile)
        let newGraph = graphFactory.makeGraph(named: name, imageFile: imageFile)
        model.addPalace(newGraph)
        return newGraph.name
    }
    
    //Adds memory palace with given name using the image provided as the 1st room's background image.
    //It is recommended to use this method if the image does not exist in the resources folder yet.
    //Returns a tuple (graph name, image name) representing names assigned to the grah and the given image.
    func addMemoryPalace(named name: String, imageFile: String, image: UIImage) -> (String, String) {
        let imgFile = resourceManager.retainResource(imageFile, image: image)
        let newGraph = graphFactory.makeGraph(named: name, imageFile: imgFile)
        model.addPalace(newGraph)
        return (newGraph.name, imgFile)
    }
    
    /* Adds memory palace using new image resource as background for 1st room.
     * @param named Teh memory palace name.
     * @param imageFile The base name of the image file to be saved as.
     * @param image The image resource to be saved.
     * @param imageType The type of image to be saved as.
     * @return A tuple (finalised palace name, finalised resource name)
     */
    func addMemoryPalace(named name: String, imageFile: String, image: UIImage, imageType: Constants.ImageType) -> (String, String) {
        let imgFile = resourceManager.retainResource(imageFile, image: image, imageType: imageType == Constants.ImageType.JPG ? ResourceManager.ImageType.JPG: ResourceManager.ImageType.PNG)
        let newGraph = graphFactory.makeGraph(named: name, imageFile: imgFile)
        model.addPalace(newGraph)
        return (newGraph.name, imgFile)
    }
    
    //Gets the specified memory palace
    //Returns nil if the specified memory palce does not exist.
    func getMemoryPalace(palaceName: String) -> MementoGraph? {
        return model.getPalace(palaceName)
    }
    
    //Returns an array of memory palace node icons
    //Returns nil if there is no memory palace of the given name
    func getPalaceOverview(palaceName: String) -> [MemoryPalaceRoomIcon]? {
        if let palace = model.getPalace(palaceName) {
            return palace.nodeIcons
        }
        return nil
    }
    
    //Removes the specified memory palace
    //Does nothing if no memory palace has the given name
    func removeMemoryPalace(palaceName: String){
        if let roomIcons = model.getPalace(palaceName)?.nodeIcons {
            //Release all image resources
            for icon in roomIcons {
                for overlay in icon.overlays {
                    resourceManager.releaseResource(overlay.imageFile)
                }
                resourceManager.releaseResource(icon.filename)
            }
            //Remove the palace from the model
            model.removePalace(palaceName)
        }
    }
    
    //Adds a new room to the current memory palace.
    //Does nothing if the memory palace is not found.
    //Returns the room label for the newly-added room or nil if the operation fails.
    func addMemoryPalaceRoom(palaceName: String, roomImage: String) -> Int? {
        if model.containsPalace(palaceName) {
            resourceManager.retainResource(roomImage)
            let newRoom = nodeFactory.makeNode(roomImage)
            model.addPalaceRoom(palaceName, room: newRoom)
            return newRoom.label
        }
        return nil
    }
    
    //Adds a new memory palace room with the given image.
    //Recommended to use this for images that does not currently exist in shared resources folder.
    //Returns the room label and the file name assigned to the image upon success.
    //Returns nil if the memory palace does not exist.
    func addMemoryPalaceRoom(palaceName: String, roomImage: String, image: UIImage) -> (Int, String)? {
        if model.containsPalace(palaceName) {
            //Add the image resource and get assigned file name
            let imgFile = resourceManager.retainResource(roomImage, image: image)
            let newRoom = nodeFactory.makeNode(imgFile)
            model.addPalaceRoom(palaceName, room: newRoom)
            return (newRoom.label, imgFile)
        }
        return nil
    }
    
    //Gets the memory palace room.
    //Returns nil if the memory palace or the room does not exist.
    func getMemoryPalaceRoom(palaceName: String, roomLabel: Int) -> MementoNode? {
        return model.getMemoryPalaceRoom(palaceName, roomLabel: roomLabel)
    }
    
    //Gets the view object representation of the memory palace room.
    //Returns nil if the memory palace or the room does not exist.
    func getMemoryPalaceRoomView(palaceName: String, roomLabel: Int) -> MemoryPalaceRoomView? {
        return model.getMemoryPalaceRoom(palaceName, roomLabel: roomLabel)?.viewRepresentation
    }
    
    //Sets the background image of the room to another existing image resource
    func setBackgroundImageForRoom(palaceName: String, roomLabel: Int, newImageFile: String) {
        if let room = model.getMemoryPalaceRoom(palaceName, roomLabel: roomLabel) {
            resourceManager.releaseResource(room.backgroundImageFile)
            resourceManager.retainResource(newImageFile)
            room.backgroundImageFile = newImageFile
            model.savePalace(palaceName)
        }
    }
    
    //Sets the background image of the specified memory palace room with the given image as a new resource.
    //Recommended to use this if the image does not yet exist in the shared resource folder.
    //Returns the name assigned to the given image on success.
    //Retuens nil if the memory palace room cannot be found.
    func setBackgroundImageForRoom(palaceName: String, roomLabel: Int, newImage: UIImage) -> String? {
        if let room = model.getMemoryPalaceRoom(palaceName, roomLabel: roomLabel) {
            let imageName = resourceManager.retainResource(generateImageName(), image: newImage)
            resourceManager.releaseResource(room.backgroundImageFile)
            room.backgroundImageFile = imageName
            model.savePalace(palaceName)
            return imageName
        }
        return nil
    }
    
    //Removes the specified room from the specified memory palace.
    //Does nothign if either the memory palace or the room is invalid.
    func removeMemoryPalaceRoom(palaceName: String, roomLabel: Int) {
        if let palace = model.getPalace(palaceName) {
            if palace.numRooms == 1 {
                return
            }
            if let room = palace.getRoom(roomLabel) {
                for overlay in room.overlays {
                    resourceManager.releaseResource(overlay.imageFile)
                }
                resourceManager.releaseResource(room.backgroundImageFile)
                model.removeMemoryPalaceRoom(palaceName, roomLabel: roomLabel)
            }
        }
    }
    
    //Gets the name that will be used for the memory
    func generatePalaceName(baseName: String) -> String {
        return model.generatePalaceName(baseName)
    }
    
    //Adds the given overlay object to the speicified memory palace room, using an existing image.
    //Does nothing if the memory palace room is not found.
    func addOverlay(palaceName: String, roomLabel: Int, overlay: MutableOverlay) -> Int? {
        if let room = model.getMemoryPalaceRoom(palaceName, roomLabel: roomLabel) {
            resourceManager.retainResource(overlay.imageFile)
            let overlayLabel = room.addOverlay(overlay)
            model.savePalace(palaceName)
            return overlayLabel
        }
        return nil
    }
    
    //Adds a new overlay object using a new image resource to be save to sharedResource folder.
    //Returns the added overlay object on success and nil if the palace or room is not found.
    //This is the recommended method to use if the image does not currently exist in the shared resource folder.
    func addOverlay(palaceName: String, roomLabel: Int, frame: CGRect, image: UIImage) -> Overlay? {
        
        //If room exists
        if let room = model.getMemoryPalaceRoom(palaceName, roomLabel: roomLabel) {
            
            //Add the given image as a resource
            let imgName = resourceManager.retainResource(generateImageName(), image: image)
            
            //Make and add the overlay
            var overlay = MutableOverlay(frame: frame, imageFile: imgName)
            overlay.label = room.addOverlay(overlay)
            model.savePalace(palaceName)
            return overlay.makeImmuatble()
        }
        return nil
    }

    //Sets the overlay's frame.
    //Does nothing if the overlay object is not found.
    func setOverlayFrame(palaceName: String, roomLabel: Int, overlayLabel: Int, newFrame: CGRect) {
        if let room = model.getMemoryPalaceRoom(palaceName, roomLabel: roomLabel) {
            room.setOverlayFrame(overlayLabel, newFrame: newFrame)
            model.savePalace(palaceName)
        }
    }
    
    //Removes the overlay from the memory palace room.
    //Does nothing if the memory palace room or the overlay cannot be found.
    func removeOverlay(palaceName: String, roomLabel: Int, overlayLabel: Int) {
        
        //If overlay exists
        if let room = model.getMemoryPalaceRoom(palaceName, roomLabel: roomLabel) {
            if let overlay = room.getOverlay(overlayLabel) {
                
                //Release reference to overlay image and remove overlay
                resourceManager.releaseResource(overlay.imageFile)
                room.removeOverlay(overlayLabel)
                model.savePalace(palaceName)
            }
        }
    }
    
    //Adds the given palceholder to the specified memory palace room.
    //Returns false if the room is not found or the placeholder cannot be added due to overlap with an
    //existin placeholder.
    func addPlaceHolder(palaceName: String, roomLabel: Int, placeHolder: PlaceHolder) -> Bool {
        if let room = model.getMemoryPalaceRoom(palaceName, roomLabel: roomLabel) {
            let res = room.addPlaceHolder(placeHolder)
            if res {
                model.savePalace(palaceName)
            }
            return res
        }
        return false
    }
    
    //Sets the palceholder's frame.
    //Does nothing if the placehodler is not found.
    func setPlaceHolderFrame(palaceName: String, roomLabel: Int, placeHolderLabel: Int, newFrame: CGRect) {
        if let room = model.getMemoryPalaceRoom(palaceName, roomLabel: roomLabel) {
            room.setPlaceHolderFrame(placeHolderLabel, newFrame: newFrame)
            model.savePalace(palaceName)
        }
    }
    
    //Returns true if the swap is successful.
    //Returns false if swap is unsuccessful due to absence of 1 or both of the placeholders.
    func swapPlaceHolders(palaceName: String, roomLabel: Int, pHolder1Label: Int, pHolder2Label: Int) -> Bool {
        if let room = model.getMemoryPalaceRoom(palaceName, roomLabel: roomLabel) {
            let res = room.swapPlaceHolders(pHolder1Label, pHolder2Label: pHolder2Label)
            if res {
                model.savePalace(palaceName)
            }
            return res
        }
        return false
    }
    
    //Sets the value of the specified placeholder in the given memory palace room.
    //Does nothing if the placeholder is not found.
    func setAssociationValue(palaceName: String, roomLabel: Int, placeHolderLabel: Int, value: String) {
        if let room = model.getMemoryPalaceRoom(palaceName, roomLabel: roomLabel) {
            room.setAssociationValue(placeHolderLabel, value: value)
            model.savePalace(palaceName)
        }
    }
    
    //Removes the specified placeholder.
    //Does nothing if the placeholder is not found.
    func removePlaceHolder(palaceName: String, roomLabel: Int, placeHolderLabel: Int) {
        if let room = model.getMemoryPalaceRoom(palaceName, roomLabel: roomLabel) {
            room.removePlaceHolder(placeHolderLabel)
            model.savePalace(palaceName)
        }
    }
    
    //Gets the memory palace room that comes after the specified memory palace room.
    //Returns nil if the palace is not found or if there is no room to be returned.
    func getNextNode(palaceName: String, roomLabel: Int) -> MemoryPalaceRoomView? {
        return model.getPalace(palaceName)?.getNextRoomViewForRoom(roomLabel)
    }
    
    //Saves the memory palace with the given name.
    //Does nothing if the memory palace cannot be found.
    func savePalace(palaceName: String) {
        model.savePalace(palaceName)
    }
    
    //Gets the list of image resources in sharedResource folder
    func getImageResource() -> [String] {
        return resourceManager.resourceOfType(ResourceManager.ResourceType.Image)
    }
    
    private func generateImageName() -> String {
        let flags: NSCalendarUnit = .YearCalendarUnit | .MonthCalendarUnit | .DayCalendarUnit | .HourCalendarUnit | .MinuteCalendarUnit | .SecondCalendarUnit
        let components = NSCalendar.currentCalendar().components(flags, fromDate: NSDate())
        return "\(components.year)\(components.month)\(components.day)\(components.hour)\(components.minute).jpg"
    }
}
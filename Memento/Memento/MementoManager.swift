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
//  Add overlay:                                        addOverlay(palaceName: String, roomLabel: Int, frame: CGRect, imageFile: String) -> Int?
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
    
    private let model: MementoModel
    private let resourceManager: ResourceManager
    private let graphFactory: MementoGraphFactory
    private let nodeFactory: MementoNodeFactory

    //Properties
    var numberOfMemoryPalace: Int {
        return model.numPalaces
    }
    
    init(){
        model = MementoModel.sharedInstance
        resourceManager = ResourceManager(directory: Constants.imgResourceDir)
        graphFactory = MementoGraphFactory()
        nodeFactory = MementoNodeFactory()
    }
    
    /* Gets the list of con representation of existing memory palaces.
     * @return The list of icons representing the existing memory palaces.
     */
    func getMemoryPalaceIcons() -> [MemoryPalaceIcon] {
        return model.palaceIcons
    }
    
    /* Adds a new memory palace using an existing image in resources folder as the image of the 1st room.
     * @param named The base name of the memory palace to add.
     * @param imageFile The name of the existing image to use as 1st room's background.
     * @return The assigned name of the added memory palace.
     */
    func addMemoryPalace(named name: String, imageFile: String) -> String {
        resourceManager.retainResource(imageFile)
        let newGraph = graphFactory.makeGraph(named: name, imageFile: imageFile)
        model.addPalace(newGraph)
        return newGraph.name
    }
        
    /* Adds memory palace using new image resource as background for 1st room.
     * @param named Teh memory palace name.
     * @param imageFile The base name of the image file to be saved as, without fie extension.
     * @param image The image resource to be saved.
     * @param imageType The type of image to be saved as.
     * @return A tuple (finalised palace name, finalised resource name)
     */
    func addMemoryPalace(named name: String, image: UIImage, imageType: Constants.ImageType) -> (String, String) {
        let imgFile = resourceManager.retainResource(generateImageName(), image: image, imageType: imageType)
        let newGraph = graphFactory.makeGraph(named: name, imageFile: imgFile)
        model.addPalace(newGraph)
        return (newGraph.name, imgFile)
    }
    
    /* Gets the specified memory palace.
     * @return The specified memory palace or  nil if the specified memory palace is not found.
     */
    func getMemoryPalace(palaceName: String) -> MementoGraph? {
        return model.getPalace(palaceName)
    }
    
    /* Gets the overview of rooms in the specified memory palace.
     * @param palaceName The name of the memory palace.
     * @return A list of icons of rooms in the memory palace or nil if the memory palace is not found.
     */
    func getPalaceOverview(palaceName: String) -> [MemoryPalaceRoomIcon]? {
        if let palace = model.getPalace(palaceName) {
            return palace.nodeIcons
        }
        return nil
    }
    
    /* Removes the specified memory palace. Does nothing if the memory palace is not found.
     * @param palaceName The name of the memory palace to remove.
     */
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
    
    /* Adds a new room to the current memory palace using existing resource. Does nothing if the memory palace is not found.
     * @param palaceName The name of the memory palace to add the new room to.
     * @param roomImage The name of the image file to use as the room's background.
     * @return The room label for the newly-added room or nil if the memory palace is not found.
     */
    func addMemoryPalaceRoom(palaceName: String, roomImage: String) -> Int? {
        if model.containsPalace(palaceName) {
            resourceManager.retainResource(roomImage)
            let newRoom = nodeFactory.makeNode(roomImage)
            model.addPalaceRoom(palaceName, room: newRoom)
            return newRoom.label
        }
        return nil
    }
    
    /* Adds room to memory palace with new resource as background.
     * @param palaceName The name of the memory palace to add room to.
     * @param roomImage The base name for the image resource to be saved as.
     * @param image The image resoure to be saved.
     * @param imageType The type ofimage to save as.
     * @return
     */
    func addMemoryPalaceRoom(palaceName: String, image: UIImage, imageType: Constants.ImageType) -> (Int, String)? {
        if model.containsPalace(palaceName) {
            //Add the image resource and get assigned file name
            let imgFile = resourceManager.retainResource(generateImageName(), image: image, imageType: imageType)
            let newRoom = nodeFactory.makeNode(imgFile)
            model.addPalaceRoom(palaceName, room: newRoom)
            return (newRoom.label, imgFile)
        }
        return nil
    }
    
    /* Gets the memory palace room.
     * @param palaceName The name of the memory palace the room is in.
     * @param roomLabel the label of the target room.
     * @return The memory palace room or nil if the memory palace or the room does not exist.
     */
    func getMemoryPalaceRoom(palaceName: String, roomLabel: Int) -> MementoNode? {
        return model.getMemoryPalaceRoom(palaceName, roomLabel: roomLabel)
    }
    
    /* Gets the view object representation of the memory palace room.
     * @param palaceName The name of the memory palace the room is in.
     * @param roomLabel The label of the target room.
     * @return The view representation of the room or nil if the memory palace room is not found.
     */
    func getMemoryPalaceRoomView(palaceName: String, roomLabel: Int) -> MemoryPalaceRoomView? {
        return model.getMemoryPalaceRoom(palaceName, roomLabel: roomLabel)?.viewRepresentation
    }
    
    /* Sets the background image of the room to another existing image resource
     * @param palaceName The name of the memory palace the room is in.
     * @param roomLabel The label of the target room.
     * @param newImageFile The name of the new image file to set as background.
     */
    func setBackgroundImageForRoom(palaceName: String, roomLabel: Int, newImageFile: String) {
        if let room = model.getMemoryPalaceRoom(palaceName, roomLabel: roomLabel) {
            resourceManager.retainResource(newImageFile)
            resourceManager.releaseResource(room.backgroundImageFile)
            room.backgroundImageFile = newImageFile
            model.savePalace(palaceName)
        }
    }
    
    /* Sets the background image for the target memory palace room.
     * @param palaceName The name of the memory palace the room is in.
     * @param roomLabel The label of the target room.
     * @param newImage The new image resource to use as background.
     * @param imageType The type of image to save the resource as.
     * @return The file name used to save the new image resource or nil if the memory palace room is not found.
     */
    func setBackgroundImageForRoom(palaceName: String, roomLabel: Int, newImage: UIImage, imageType: Constants.ImageType) -> String? {
        if let room = model.getMemoryPalaceRoom(palaceName, roomLabel: roomLabel) {
            let imageName = resourceManager.retainResource(generateImageName(), image: newImage, imageType: imageType)
            resourceManager.releaseResource(room.backgroundImageFile)
            room.backgroundImageFile = imageName
            model.savePalace(palaceName)
            return imageName
        }
        return nil
    }
    
    /* Removes the specified room from the specified memory palace.
     * Does nothing if either the memory palace or the room is invalid.
     * @param palaceName The name of the memory palace the room is in.
     * @param roomLabel The label of the room to remove.
     */
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
    
    /* Adds the given overlay object to the speicified memory palace room, using an existing image.
     * Does nothing if the memory palace room is not found.
     * @param palaceName The name of the memory palace the room is in.
     * @param roomLabel The label of the room to add the overlay to.
     * @param frame The frame of the overlay.
     * @param imageFile The filename of the voerlay image.
     * @return The label assigned to the new overlay.
     */
    func addOverlay(palaceName: String, roomLabel: Int, frame: CGRect, imageFile: String) -> Int? {
        if let room = model.getMemoryPalaceRoom(palaceName, roomLabel: roomLabel) {
            resourceManager.retainResource(imageFile)
            let overlayLabel = room.addOverlay(MutableOverlay(frame: frame, imageFile: imageFile))
            model.savePalace(palaceName)
            return overlayLabel
        }
        return nil
    }
    
    /* Adds new overlay to the specified memory palace room.
     * @param palaceName The name of the memory palace the room is in.
     * @param roomLabel The label of the target room.
     * @param frame The frame of the overlay.
     * @param image The image resource to use for the overlay.
     * @param imageType The type of image to save the image resource as.
     * @return The added overlay object or nil if the memory palace room is not found.
     */
    func addOverlay(palaceName: String, roomLabel: Int, frame: CGRect, image: UIImage, imageType: Constants.ImageType) -> Overlay? {
        if let room = model.getMemoryPalaceRoom(palaceName, roomLabel: roomLabel) {
            
            //Add the given image as a resource
            let imgName = resourceManager.retainResource(generateImageName(), image: image, imageType: imageType)
            
            //Make and add the overlay
            var overlay = MutableOverlay(frame: frame, imageFile: imgName)
            overlay.label = room.addOverlay(overlay)
            model.savePalace(palaceName)
            return overlay.makeImmuatble()
        }
        return nil
    }

    /* Sets the overlay's frame. Does nothing if the overlay object is not found.
     * @param palaceName The name of the memory palace the room is in.
     * @param roomLabel The label of the room the overlay is in.
     * @param overlayLabel The label of the target overlay.
     * @param newFrame The new frame of the overlay.
     */
    func setOverlayFrame(palaceName: String, roomLabel: Int, overlayLabel: Int, newFrame: CGRect) {
        if let room = model.getMemoryPalaceRoom(palaceName, roomLabel: roomLabel) {
            room.setOverlayFrame(overlayLabel, newFrame: newFrame)
            model.savePalace(palaceName)
        }
    }
    
    /* Removes the overlay from the memory palace room. Does nothing if the overlay cannot be found.
     * @param palaceName The name of the memory palace the room is in.
     * @param roomLabel The label of the room the overlay is in.
     * @param overlayLabel The label of the overlay to be removed.
     */
    func removeOverlay(palaceName: String, roomLabel: Int, overlayLabel: Int) {
        if let room = model.getMemoryPalaceRoom(palaceName, roomLabel: roomLabel) {
            if let overlay = room.getOverlay(overlayLabel) {
                resourceManager.releaseResource(overlay.imageFile)
                room.removeOverlay(overlayLabel)
                model.savePalace(palaceName)
            }
        }
    }
    
    /* Adds the given palceholder to the specified memory palace room.
     * @param palaceName The name of the memory palace the room is in.
     * @param roomLabel The label of the room the placeholder is t be added.
     * @param palceHolder The placeholder to be added.
     * @return True if the palceholder is successfully added and false otherwise.
     * Note: This method fails it room is not found or the placeholder overlaps with an existing placeholder.
     */
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
    
    /* Sets the color of the association placeholder.
     * @param palaceName The name of the memory palace the room is in.
     * @param roomLabel The label of the room the association is in.
     * @param placeHolderLabel The label of the target placeholder.
     * @param color The new color of the placeholder.
     */
    func setPlaceHolderColor(palaceName: String, roomLabel: Int, placeHolderLabel: Int, color: String) {
        if let room = model.getMemoryPalaceRoom(palaceName, roomLabel: roomLabel) {
            room.setPlaceHolderColor(placeHolderLabel, color: color)
            model.savePalace(palaceName)
        }
    }
    
    /* Sets the association's frame. Does nothing if the association is not found.
     * @param palaceName The name of the memory palace the room is in.
     * @param roomLabel The label of the room the association is in.
     * @param placeHolderLabel The label of the target association.
     */
    func setPlaceHolderFrame(palaceName: String, roomLabel: Int, placeHolderLabel: Int, newFrame: CGRect) {
        if let room = model.getMemoryPalaceRoom(palaceName, roomLabel: roomLabel) {
            room.setPlaceHolderFrame(placeHolderLabel, newFrame: newFrame)
            model.savePalace(palaceName)
        }
    }
    
    /* Swaps the 2 associations.
     * @param palaceName The name of the memory palace the room is in.
     * @param roomLabel The label of the room the placeholders are in.
     * @param pHolder1Label The label of 1 of the associations to be swapped.
     * @param pHolder2Label The label of the other association to be swapped.
     * @return True if the operation is successful and false if one or both associations do not exist.
     */
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
    
    /* Sets the value for the specified association. Does nothing if the placeholder is not found.
     * @param palaceName The name of the memory palace the room is in.
     * @param roomLabel The label of the target room.
     * @param placeHolderLabel The label of the association to set the value for.
     * @param value The value to be set.
     */
    func setAssociationValue(palaceName: String, roomLabel: Int, placeHolderLabel: Int, value: String) {
        if let room = model.getMemoryPalaceRoom(palaceName, roomLabel: roomLabel) {
            room.setAssociationValue(placeHolderLabel, value: value)
            model.savePalace(palaceName)
        }
    }
    
    /* Removes the specified placeholder. Does nothing if the placeholder is not found.
     * @param palaceName The name of the memory palace the room is in.
     * @param roomLabel The label of the target room.
     * @param placeHolderLabel The label of the placeholder to remove.
     */
    func removePlaceHolder(palaceName: String, roomLabel: Int, placeHolderLabel: Int) {
        if let room = model.getMemoryPalaceRoom(palaceName, roomLabel: roomLabel) {
            room.removePlaceHolder(placeHolderLabel)
            model.savePalace(palaceName)
        }
    }
    
    /* Gets the memory palace room that comes after the specified memory palace room.
     * @param palaceName The name of the memory palace the specified room is in.
     * @param roomLabel The label of the target room whose successor is to be obtained.
     * @return The memory palace room that comes immediately after the one specified or nil if there is no such room.
     */
    func getNextNode(palaceName: String, roomLabel: Int) -> MemoryPalaceRoomView? {
        return model.getPalace(palaceName)?.getNextRoomViewForRoom(roomLabel)
    }
    
    /* Saves the memory palace with the given name. Does nothing if the memory palace cannot be found.
     */
    func savePalace(palaceName: String) {
        model.savePalace(palaceName)
    }
    
    /* Gets the list of image resources in sharedResource folder
     * @return A list of existing image resource filenames
     */
    func getImageResource() -> [String] {
        return resourceManager.resourceOfType(ResourceManager.ResourceType.Image)
    }
    
    //Generates a file name based on the current timestamp.
    private func generateImageName() -> String {
        let flags: NSCalendarUnit = .YearCalendarUnit | .MonthCalendarUnit | .DayCalendarUnit | .HourCalendarUnit | .MinuteCalendarUnit | .SecondCalendarUnit
        let components = NSCalendar.currentCalendar().components(flags, fromDate: NSDate())
        return "\(components.year)\(components.month)\(components.day)\(components.hour)\(components.minute)\(components.second)"
    }
}
//
//  NodeViewController.swift
//  Memento
//
//  Created by Lim Jing Rong on 23/3/15.
//  Copyright (c) 2015 NUS CS3217. All rights reserved.
//


//  TODO: Record ordering of nodes using model.

import UIKit
import MobileCoreServices

class NodeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // ImageView = whole screen
    
    @IBOutlet weak var menuBarView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var editModeButton: UIButton!
    @IBOutlet weak var deleteModeButton: UIButton!
    private var newMedia: Bool?
    
    var mementoManager = MementoManager.sharedInstance
    
    private var isMainView: Bool = true
    private var newImage: DraggableImageView!
    private var lastRotation = CGFloat()
    private let panRec = UIPanGestureRecognizer()
    private var startPoint = CGPoint()
    private var allCGRects = [CGRect]()
    
    var roomLabel = Int()
    var graphName = String()
    private var overlayList = [Overlay]()
    private var associationList = [Association]()
    
    private var rotationToggler: Bool = true
    private var editToggler: Bool = true
    var deleteToggler: Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageView.userInteractionEnabled = true
        self.view.userInteractionEnabled = true
        
        //setUpGestures()
        panRec.addTarget(self, action: "handlePan:")
        self.view.addGestureRecognizer(panRec)
        
        // Get view representation of room
        var roomRep = mementoManager.getMemoryPalaceRoomView(graphName, roomLabel: roomLabel)!
        
        // Get image from graphical view
        imageView.image = Utilities.getImageNamed(roomRep.backgroundImage)
        
        // Load
        overlayList = roomRep.overlays
        associationList = roomRep.associations
        loadLayouts()
        
    }
    
    // Function to load layouts
    private func loadLayouts() {
        // Load draggable image views/layers
        var draggableImageViewsToAdd = [DraggableImageView]()
        for eachOverlay in overlayList {
            var newFrame = eachOverlay.frame
            var newImageFile = eachOverlay.imageFile
            var newImage = Utilities.getImageNamed(newImageFile)
            NSLog(newImageFile)
            var newDraggableImageView = DraggableImageView(image: newImage!)
            newDraggableImageView.graphName = self.graphName
            newDraggableImageView.roomLabel = self.roomLabel
            newDraggableImageView.labelIdentifier = eachOverlay.label
            newDraggableImageView.frame = newFrame
            newDraggableImageView.parentViewController = self
            self.imageView.addSubview(newDraggableImageView)
        }
        
        // Load association list
        for eachAssociation in associationList {
            var newFrame = eachAssociation.placeHolder.view.frame
            var newLabel = eachAssociation.placeHolder.label
            allCGRects.append(newFrame)
            
            var newAnnotatableView = AnnotatableUIView(frame: newFrame, parentController: self, tagNumber: newLabel, background: imageView, graphName: graphName, roomLabel:roomLabel)
            newAnnotatableView.backgroundColor = .whiteColor()
            newAnnotatableView.alpha = 0.25
            newAnnotatableView.annotation = eachAssociation.value
            imageView.addSubview(newAnnotatableView)
        }
        
    }
    
    // Toggles on edit mode
    @IBAction func toggleEditMode(sender: AnyObject) {
        
        if self.editToggler == false {
            self.editToggler = true
            self.imageView.userInteractionEnabled = true
            // Enable editing -> Show menu bar
            UIView.animateWithDuration(NSTimeInterval(0.3), animations: {
                var moveFrameUp = CGRectMake(0, self.view.frame.height - self.menuBarView.frame.height, self.menuBarView.frame.width, self.menuBarView.frame.height)
                self.menuBarView.frame = moveFrameUp
            })
            
        } else {
            self.editToggler = false
            self.imageView.userInteractionEnabled = false
            // Disable editing -> Hide menu bar
            UIView.animateWithDuration(NSTimeInterval(0.3), animations: {
                var moveFrameDown = CGRectMake(0, self.view.frame.height, self.menuBarView.frame.width, self.menuBarView.frame.height)
                self.menuBarView.frame = moveFrameDown
            })
        }
        
    }
    
    // Adds an overlaying image from camera roll ( possibly in-app sprites next time?)
    @IBAction func addOverlayImage(sender: AnyObject){
        if (editToggler == false) {
            return
        }
        isMainView = false
        getImageFromPhotoLibrary(sender)
        
    }
    
    // Helper functions for main photo pickers
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
        let mediaType = info[UIImagePickerControllerMediaType] as NSString
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
        if mediaType.isEqualToString(kUTTypeImage as NSString) {
            var image = info[UIImagePickerControllerOriginalImage]
                as UIImage
            
            // Adjustments to show UIImageView in proper rotation according to input types
            if picker.sourceType == UIImagePickerControllerSourceType.Camera{
                image = UIImage(CGImage: image.CGImage, scale:1, orientation: UIImageOrientation.Down)!
            } else {
                image = UIImage(CGImage: image.CGImage, scale:1, orientation: UIImageOrientation.Up)!
            }

            if isMainView == true {
                imageView.image = image
            }
            else {
                // Adding draggable images
                // Scaling factor for inserted images is default at height 150
                var scalingFactor = image.size.height/150.0
                var newWidth = image.size.width / scalingFactor
                newImage = DraggableImageView(image: image)
                newImage.graphName = self.graphName
                newImage.roomLabel = self.roomLabel
                newImage.frame = CGRect(x: imageView.center.x, y: imageView.center.y, width: newWidth, height: 150.0)
                newImage.parentViewController = self
                //newImage.frame = CGRect(x: imageView.center.x, y: imageView.center.y, width: image.size.width/10.0, height: image.size.width/10.0)
                imageView.addSubview(newImage)
                
                // Get paths for saving
                var newOverlay = mementoManager.addOverlay(graphName, roomLabel: roomLabel, frame: newImage.frame, image: Utilities.convertToThumbnail(newImage.image!))!
                newImage.labelIdentifier = newOverlay.label
                
            }
            
            if (newMedia == true) {
                // Option to save to camera roll/ Photo album
                //UIImageWriteToSavedPhotosAlbum(image, self, "image:didFinishSavingWithError:contextInfo:", nil)
            } else if mediaType.isEqualToString(kUTTypeMovie as NSString) {
                // Code to support video here
            }
            
        }
    }
    
    func image(image: UIImage, didFinishSavingWithError error: NSErrorPointer, contextInfo:UnsafePointer<Void>) {
        
        if error != nil {
            let alert = UIAlertController(title: "Save Failed",
                message: "Failed to save image",
                preferredStyle: UIAlertControllerStyle.Alert)
            
            let cancelAction = UIAlertAction(title: "OK",
                style: .Cancel, handler: nil)
            
            alert.addAction(cancelAction)
            self.presentViewController(alert, animated: true,
                completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func dismissView(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    private func getImageFromPhotoLibrary(sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(
            UIImagePickerControllerSourceType.SavedPhotosAlbum) {
                var imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType =
                    UIImagePickerControllerSourceType.PhotoLibrary
                imagePicker.mediaTypes = [kUTTypeImage as NSString]
                imagePicker.allowsEditing = false
                
                var popover = UIPopoverController(contentViewController: imagePicker) as UIPopoverController
                var frame = CGRectMake(315, 260, 386, 386);
                
                popover.presentPopoverFromRect(frame, inView: self.view, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: true)
                
                newMedia = false
        }
    }
    
    // Method to draw rectangles for annotation
    // In the form of CGRect, UIView with alpha to display to user
    func handlePan(sender: AnyObject) {
        if (editToggler == false) {
            return
        }
        
        // Method to draw a rectangle
        if (sender.state == UIGestureRecognizerState.Began) {
            startPoint = sender.locationInView(imageView)
        }
        if (sender.state == UIGestureRecognizerState.Ended) {
            var endPoint = sender.locationInView(imageView)
            if (startPoint.x > 0.0 && startPoint.y > 0.0) {
                drawNewRect(startPoint, endPoint: endPoint)
            }
        }
    }

    private func drawNewRect(startPoint: CGPoint, endPoint: CGPoint) {
        var newRectDoesNotIntersect = true
        // Make rectangle
        var newRect = CGRect(x: min(startPoint.x, endPoint.x), y: min(startPoint.y, endPoint.y), width: abs(startPoint.x - endPoint.x), height: abs(startPoint.y - endPoint.y))
        
        for eachRect in allCGRects{
            if (CGRectIntersectsRect(eachRect, newRect)) {
                newRectDoesNotIntersect = false
            }
        }
        
        let minHeight = 100.0 as CGFloat
        let minWidth = 100.0 as CGFloat
        if (newRectDoesNotIntersect && newRect.height>minHeight && newRect.width>minWidth) {
            // Add the rectangle into main view
            allCGRects.append(newRect)
            var newRectPlaceHolder = RectanglePlaceHolder(highlightArea: newRect)
            mementoManager.addPlaceHolder(graphName, roomLabel: roomLabel, placeHolder: newRectPlaceHolder)
            var newViewToTest = AnnotatableUIView(frame: newRect, parentController: self, tagNumber: newRectPlaceHolder.label, background: imageView, graphName: graphName, roomLabel:roomLabel)
            newViewToTest.backgroundColor = .whiteColor()
            newViewToTest.alpha = 0.25
            imageView.addSubview(newViewToTest)
        }
    }
    
    func deleteView(view: UIView) {
        if let indexToRect = find(allCGRects, view.frame) {
            allCGRects.removeAtIndex(indexToRect)
        }
        view.removeFromSuperview()
        
        var roomRep = mementoManager.getMemoryPalaceRoomView(graphName, roomLabel: roomLabel)!
        
        overlayList = roomRep.overlays
        associationList = roomRep.associations
    }
    
    /************************************** Menu buttons **************************************/
    
    // Delete Mode Activated
    @IBAction func deleteButtonPressed(sender: UIButton) {
        if deleteToggler {
            deleteToggler = false
            deleteModeButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        } else {
            deleteToggler = true
            deleteModeButton.setTitleColor(UIColor.yellowColor(), forState: UIControlState.Normal)
        }
    }
    
    // Next Node button
    @IBAction func nextNodePressed(sender: UIButton) {
        // If node does not exist
        if ( mementoManager.getNextNode(self.graphName, roomLabel: self.roomLabel) == nil ) {
            performSegueWithIdentifier("CreateNewNodeSegue", sender: self)
        } else {
            // Node Exists. Reload view controller with appropriate data.
            loadNextNode()
        }
        
    }
    
    // Back button pressed
    @IBAction func backButtonPressed(sender: AnyObject) {
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // Change background image
    @IBAction func changeImageView(sender: AnyObject) {
        performSegueWithIdentifier("ReplaceNodeSegue", sender: self)
    }
    
    // TODO: Edit background image with CLImageEditor
    @IBAction func editImageView(sender: AnyObject) {
        
    }
    
    // Reload viewcontroller with next node's data
    private func loadNextNode() {
        if let nextNode = mementoManager.getNextNode(self.graphName, roomLabel: self.roomLabel) {
            self.roomLabel = nextNode.label
        }
        
        // Get view representation of next room
        var newRoomRep = mementoManager.getMemoryPalaceRoomView(graphName, roomLabel: roomLabel)!
        
        // Get image from graphical view
        var oldImage = UIImageView(image: imageView.image)
        oldImage.frame = imageView.frame
        imageView.image = Utilities.getImageNamed(newRoomRep.backgroundImage)
        
        // Remove all current overlays/placeholder
        for eachSubview in self.imageView.subviews {
            eachSubview.removeFromSuperview()
        }
        
        // Load
        overlayList = newRoomRep.overlays
        associationList = newRoomRep.associations
        loadLayouts()
        allCGRects = [CGRect]()
        
        self.view.addSubview(oldImage)
        
        UIView.animateWithDuration(NSTimeInterval(1.0), animations: {
            oldImage.frame.origin = CGPoint(x: -1024.0, y: 768.0)
            }, completion: { finished in
            oldImage.removeFromSuperview()
        })
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "CreateNewNodeSegue") {
            let nextNodeViewController = segue.destinationViewController as BlurCreateNodePopoverController
            nextNodeViewController.graphName = self.graphName
            nextNodeViewController.isNextNode = true
        } else if (segue.identifier == "ReplaceNodeSegue") {
            let nextNodeViewController = segue.destinationViewController as BlurCreateNodePopoverController
            nextNodeViewController.graphName = self.graphName
            nextNodeViewController.isNextNode = false
            nextNodeViewController.nextRoomLabel = self.roomLabel
            nextNodeViewController.parentVC = self
        }
    }
    

}
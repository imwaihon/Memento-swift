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
import QuartzCore

class NodeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLImageEditorDelegate {
    
    @IBOutlet weak var swapButton: UIButton!
    @IBOutlet weak var annotateWordButton: UIButton!
    @IBOutlet weak var downloadButton: UIButton!
    @IBOutlet weak var menuBarView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var editModeButton: UIButton!
    @IBOutlet weak var deleteModeButton: UIButton!
    private var newMedia: Bool?
    
    var mementoManager = MementoManager.sharedInstance
    
    private var newImage: DraggableImageView!
    private let panRec = UIPanGestureRecognizer()
    private var startPoint = CGPoint()
    private var allCGRects = [CGRect]()
    private var allButtons = [UIButton]()
    private var allAnnotatableViews = [AnnotatableUIView]()
    
    var roomLabel = Int()
    var graphName = String()
    private var overlayList = [Overlay]()
    private var associationList = [Association]()
    
    private var editToggler: Bool = true
    var deleteToggler: Bool = false
    private var annotateWordToggler: Bool = false
    private var swappingToggler: Bool = false
    private var previouslySelectedLabel :String = "_"
    private var previouslySelectedIndex : Int?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageView.userInteractionEnabled = true
        self.view.userInteractionEnabled = true
        
        panRec.addTarget(self, action: "handlePan:")
        
        // Get view representation of room
        var roomRep = mementoManager.getMemoryPalaceRoomView(graphName, roomLabel: roomLabel)!
        
        // Get image from graphical view
        imageView.image = Utilities.getImageNamed(roomRep.backgroundImage)
        
        // Button border settings
        downloadButton.setImage(UIImage(named: "capturingImage"), forState: UIControlState.Selected)
        downloadButton.setImage(UIImage(named: "capturingImage"), forState: UIControlState.Highlighted)
        
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
            allAnnotatableViews.append(newAnnotatableView)
            imageView.addSubview(newAnnotatableView)
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
        
        let minHeight = 75.0 as CGFloat
        let minWidth = 75.0 as CGFloat
        if (newRectDoesNotIntersect && newRect.height>minHeight && newRect.width>minWidth) {
            // Add the rectangle into main view
            allCGRects.append(newRect)
            var newRectPlaceHolder = RectanglePlaceHolder(highlightArea: newRect)
            mementoManager.addPlaceHolder(graphName, roomLabel: roomLabel, placeHolder: newRectPlaceHolder)
            var newView = AnnotatableUIView(frame: newRect, parentController: self, tagNumber: newRectPlaceHolder.label, background: imageView, graphName: graphName, roomLabel:roomLabel)
            newView.backgroundColor = .whiteColor()
            newView.alpha = 0.25
            allAnnotatableViews.append(newView)
            imageView.addSubview(newView)
        }
    }
    
    /************************************** Menu buttons **************************************/
    
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
    
    // Delete Mode Activated
    @IBAction func deleteButtonPressed(sender: UIButton) {
        if deleteToggler {
            // Deactivate
            deleteToggler = false
            deleteModeButton.setImage(UIImage(named: "Eraser Filled-100.png"), forState: UIControlState.Normal)
        } else {
            // Activate
            if(annotateWordToggler == true){
                self.wordAnnotationButtonPressed(annotateWordButton)
            }
            if(swappingToggler == true){
                self.swapAnnotationLabels(swapButton)
            }
            deleteToggler = true
            deleteModeButton.setImage(UIImage(named: "eraserSelected.png"), forState: UIControlState.Normal)
        }
    }

    // Helper function to delete views
    func deleteView(view: UIView) {
        if let indexToRect = find(allCGRects, view.frame) {
            allCGRects.removeAtIndex(indexToRect)
            allAnnotatableViews.removeAtIndex(indexToRect)
        }
        view.removeFromSuperview()
        
        var roomRep = mementoManager.getMemoryPalaceRoomView(graphName, roomLabel: roomLabel)!
        
        overlayList = roomRep.overlays
        associationList = roomRep.associations
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
    
    // Edit imageview with CLImageEditor
    @IBAction func editImageView(sender: AnyObject) {
        var editor = CLImageEditor(image: self.imageView.image)
        editor.delegate = self
        self.presentViewController(editor, animated: true, completion: nil)
    }
    
    // Save imageView to camera roll
    @IBAction func captureView(sender: AnyObject) {
        UIImageWriteToSavedPhotosAlbum(getImageView(), nil, nil, nil);
        
    }
    
    // Returns imageView's image + all annotations
    private func getImageView() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.imageView.bounds.size, view.opaque, 0.0)
        self.imageView.layer.renderInContext(UIGraphicsGetCurrentContext())
        var imageCaptured = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return imageCaptured
    }
    
    // Toggle mode for annotation words
    @IBAction func wordAnnotationButtonPressed(sender: AnyObject) {
        if annotateWordToggler {
            // Deactivate
            annotateWordToggler = false
            annotateWordButton.setImage(UIImage(named: "annotationModeImage.png"), forState: UIControlState.Normal)
            self.view.removeGestureRecognizer(panRec)
            self.imageView.alpha = 1.0
        } else {
            if(deleteToggler == true){
                self.deleteButtonPressed(deleteModeButton)
            }
            if(swappingToggler == true){
                self.swapAnnotationLabels(swapButton)
            }
            // Activate
            annotateWordToggler = true
            annotateWordButton.setImage(UIImage(named: "annotationModeActiveImage.png"), forState: UIControlState.Normal)
            self.view.removeGestureRecognizer(panRec)
            self.view.addGestureRecognizer(panRec)
            self.imageView.alpha = 0.75
        }
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
        
        // Remove views and empty datasets
        for eachSubview in self.imageView.subviews {
            eachSubview.removeFromSuperview()
        }
        removeAllLabels()
        allCGRects.removeAll(keepCapacity: false)
        allAnnotatableViews.removeAll(keepCapacity: false)
        allButtons.removeAll(keepCapacity: false)
        
        // Off all toggleables
        if(annotateWordToggler == true){
            self.wordAnnotationButtonPressed(annotateWordButton)
        }
        if(swappingToggler == true){
            self.swapAnnotationLabels(swapButton)
        }
        if(deleteToggler == true){
            self.deleteButtonPressed(deleteModeButton)
        }
        
        // Load
        overlayList = newRoomRep.overlays
        associationList = newRoomRep.associations
        loadLayouts()
        self.view.addSubview(oldImage)
        
        // Animation
        UIView.animateWithDuration(NSTimeInterval(1.0), animations: {
            oldImage.frame.origin = CGPoint(x: -1024.0, y: 0)
            }, completion: { finished in
            oldImage.removeFromSuperview()
        })
    }
    
    // Adds an overlaying image from camera roll
    @IBAction func addOverlayImage(sender: AnyObject){
        if (editToggler == false) {
            return
        }
        getImageFromPhotoLibrary(sender)
        
    }
    
    // Show/Hide all labels on annotations
    @IBAction func swapAnnotationLabels(sender: AnyObject) {
        if swappingToggler {
            removeAllLabels()
            swappingToggler = false
            swapButton.setImage(UIImage(named: "orderingModeImage.png"), forState: UIControlState.Normal)
        } else {
            if(deleteToggler==true){
                self.deleteButtonPressed(deleteModeButton)
            }
            if(annotateWordToggler == true){
                self.wordAnnotationButtonPressed(annotateWordButton)
            }
            showAllLabels()
            swappingToggler = true
            swapButton.setImage(UIImage(named: "orderingModeActiveImage.png"), forState: UIControlState.Normal)
        }
    }
    
    private func removeAllLabels() {
        for eachButton in allButtons {
            eachButton.removeFromSuperview()
        }
        previouslySelectedLabel = "_"
    }
    
    private func showAllLabels() {
        allButtons.removeAll(keepCapacity: false)
        // Update association list
        var roomRepresentation = mementoManager.getMemoryPalaceRoomView(graphName, roomLabel: roomLabel)!
        associationList = roomRepresentation.associations
        
        // Load association list
        for eachAssociation in associationList {
            // Make button
            let newButton = UIButton()
            newButton.frame = eachAssociation.placeHolder.view.frame
            if let labelNumber = find(allCGRects, newButton.frame) {
                newButton.setTitle(String(labelNumber + 1), forState: UIControlState.Normal)
            }

            newButton.tag = eachAssociation.placeHolder.label
            newButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            newButton.titleLabel?.font = UIFont(name: "Helvetica", size: 50)
            newButton.titleLabel?.textAlignment = NSTextAlignment.Center
            newButton.addTarget(self, action: "labelButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
            self.view.addSubview(newButton)
            allButtons.append(newButton)
        }
    }
    
    func labelButtonTapped(sender: UIButton!) {
        if let labelSelected = sender?.tag {
            // Set current selection
            if (previouslySelectedLabel == "_") {
                previouslySelectedLabel = String(labelSelected)
                previouslySelectedIndex = (sender?.titleLabel?.text?.toInt())! - 1
                sender.backgroundColor = UIColor.grayColor()
            } else {
                // Swap the labels
                mementoManager.swapPlaceHolders(self.graphName, roomLabel: self.roomLabel, pHolder1Label: previouslySelectedLabel.toInt()!, pHolder2Label: labelSelected)
                
                
                if let indexToSwap = sender?.titleLabel?.text?.toInt() {
                    // Update viewtags of annotatable views for deletion
                    var tempTag = allAnnotatableViews[indexToSwap - 1].viewTag
                    allAnnotatableViews[indexToSwap - 1].viewTag = allAnnotatableViews[previouslySelectedIndex!].viewTag
                    allAnnotatableViews[previouslySelectedIndex!].viewTag = tempTag
                    
                    // Swap content in array as well
                    var tempRect = allCGRects[previouslySelectedIndex!]
                    allCGRects[previouslySelectedIndex!] = allCGRects[indexToSwap - 1]
                    allCGRects[indexToSwap - 1] = tempRect
                    
                    var tempAnnotatableView = allAnnotatableViews[previouslySelectedIndex!]
                    allAnnotatableViews[previouslySelectedIndex!] = allAnnotatableViews[indexToSwap - 1]
                    allAnnotatableViews[indexToSwap - 1] = tempAnnotatableView
                }

                // Refresh view
                removeAllLabels()
                showAllLabels()
            }
        }
    }
    
    
    // Helper functions for main photo pickers
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
            
            // Adding draggable images
            // Scaling factor for inserted images is default at height 150
            var scalingFactor = image.size.height/150.0
            var newWidth = image.size.width / scalingFactor
            newImage = DraggableImageView(image: image)
            newImage.graphName = self.graphName
            newImage.roomLabel = self.roomLabel
            newImage.frame = CGRect(x: imageView.center.x, y: imageView.center.y, width: newWidth, height: 150.0)
            newImage.parentViewController = self
            imageView.addSubview(newImage)
            
            // Get paths for saving
            var newOverlay = mementoManager.addOverlay(graphName, roomLabel: roomLabel, frame: newImage.frame, image: (newImage.image!))!
            newImage.labelIdentifier = newOverlay.label
            
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
    
    /******************************************************************************************/
    
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
    
    //CLEditor functions
    func imageEditor(editor: CLImageEditor!, didFinishEdittingWithImage image: UIImage!) {
            self.imageView.image = image
            mementoManager.setBackgroundImageForRoom(self.graphName, roomLabel: self.roomLabel, newImage: Utilities.convertToScreenSize(image))
            self.dismissViewControllerAnimated(true, completion: nil)
    }

}
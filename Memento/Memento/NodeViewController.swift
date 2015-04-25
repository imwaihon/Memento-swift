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

class NodeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLImageEditorDelegate, UIPopoverPresentationControllerDelegate, AddLayerDelegate {
    
    @IBOutlet weak var menuBarView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var swapButton: UIButton!
    @IBOutlet weak var annotateWordButton: UIButton!
    @IBOutlet weak var downloadButton: UIButton!
    @IBOutlet weak var editModeButton: UIButton!
    @IBOutlet weak var deleteModeButton: UIButton!
    @IBOutlet weak var changeImageButton: UIButton!
    
    var mementoManager = MementoManager.sharedInstance
    var roomLabel = Int()
    var graphName = String()
    
    private let panRec = UIPanGestureRecognizer()
    private var startPoint = CGPoint()
    
    private var overlayList = [Overlay]()
    private var associationList = [Association]()
    private var allCGRects = [CGRect]()
    private var allButtons = [UIButton]()
    private var allAnnotatableViews = [AnnotatableUIView]()

    var deleteToggler: Bool = false
    private var editToggler: Bool = true
    private var annotateWordToggler: Bool = false
    private var swappingToggler: Bool = false
    
    private var previouslySelectedLabel :String = "_"
    private var previouslySelectedIndex : Int?
    private var darkViewLayer = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageView.userInteractionEnabled = true
        self.view.userInteractionEnabled = true
        
        // Set up gestures
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
    
    
    /* Gestures Selector */
    
    // Method to draw rectangles for annotation
    // Drawings are saved the form of CGRect, presented using UIView
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
    
    /* Menu Buttons */
    
    /* Buttons for toggling */
    
    // Toggles on/off edit mode
    @IBAction func toggleEditMode(sender: AnyObject) {
        
        if self.editToggler == false {
            self.editToggler = true
            //self.imageView.userInteractionEnabled = true
            // Enable editing -> Show menu bar
            UIView.animateWithDuration(NSTimeInterval(0.3), animations: {
                var moveFrameUp = CGRectMake(0, self.view.frame.height - self.menuBarView.frame.height, self.menuBarView.frame.width, self.menuBarView.frame.height)
                self.menuBarView.frame = moveFrameUp
            })
            
        } else {
            self.editToggler = false
            //self.imageView.userInteractionEnabled = false
            // Disable editing -> Hide menu bar
            UIView.animateWithDuration(NSTimeInterval(0.3), animations: {
                var moveFrameDown = CGRectMake(0, self.view.frame.height, self.menuBarView.frame.width, self.menuBarView.frame.height)
                self.menuBarView.frame = moveFrameDown
            })
        }
        
    }
    
    // Toggles on/off delete mode
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
            // Interaction for all AnnotatableUIViews to be enabled
            for eachView in allAnnotatableViews {
                eachView.userInteractionEnabled = true
            }
            deleteToggler = true
            deleteModeButton.setImage(UIImage(named: "eraserSelected.png"), forState: UIControlState.Normal)
        }
    }
    
    // Toggle on/off for allowing users to insert/edit annotations
    @IBAction func wordAnnotationButtonPressed(sender: AnyObject) {
        if annotateWordToggler {
            // Deactivate
            annotateWordToggler = false
            annotateWordButton.setImage(UIImage(named: "annotationModeImage.png"), forState: UIControlState.Normal)
            self.view.removeGestureRecognizer(panRec)
            darkViewLayer.removeFromSuperview()
            
            // Send all AnnotatableUIViews to the back
            for eachView in allAnnotatableViews {
                self.imageView.sendSubviewToBack(eachView)
                eachView.userInteractionEnabled = false
            }
            
            // Allow touch for draggable images
            for eachView in self.imageView.subviews {
                if eachView.isMemberOfClass(DraggableImageView) {
                    (eachView as DraggableImageView).userInteractionEnabled = true
                }
            }
            
            
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
            self.imageView.addSubview(darkViewLayer)
            self.imageView.sendSubviewToBack(darkViewLayer)
            
            // Send all AnnotatableUIViews to the front
            for eachView in allAnnotatableViews {
                self.imageView.bringSubviewToFront(eachView)
                eachView.userInteractionEnabled = true
            }
            
            // Disllow touch for draggable images
            for eachView in self.imageView.subviews {
                if eachView.isMemberOfClass(DraggableImageView) {
                    (eachView as DraggableImageView).userInteractionEnabled = false
                }
            }
        }
    }
    
    // Toggle on/off to show placeholder labels, and to allow swapping of these labels
    // In this mode, users are allowed to swap the label ordering by tapping on one placeholder(AnnotatableUIView) to swap with another.
    @IBAction func swapAnnotationLabels(sender: AnyObject) {
        if swappingToggler {
            removeAllLabels()
            swappingToggler = false
            swapButton.setImage(UIImage(named: "orderingModeImage.png"), forState: UIControlState.Normal)
            
            // Send all AnnotatableUIViews to the back
            for eachView in allAnnotatableViews {
                self.imageView.sendSubviewToBack(eachView)
                eachView.userInteractionEnabled = false
            }
            
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
            
            // Send all AnnotatableUIViews to the front
            for eachView in allAnnotatableViews {
                self.imageView.bringSubviewToFront(eachView)
                eachView.userInteractionEnabled = true
            }
        }
    }
    
    
    // Next Node button pressed
    // If there is an existing next node, go to that next node
    // If there is not next node, create new node via BlurCreateNodePopoverController
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
    // Segues back to OverviewViewController
    @IBAction func backButtonPressed(sender: AnyObject) {
        // Empty array of views to prevent retain cycle
        allAnnotatableViews.removeAll()
        allCGRects.removeAll()
        allButtons.removeAll()

        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // Edit image button pressed
    // Edit the background picture with CLImageEditor
    @IBAction func editImageView(sender: AnyObject) {
        var imageSheet = UIAlertController(title: "Background Image", message: nil, preferredStyle: .ActionSheet)
        
        imageSheet.addAction(UIAlertAction(title: "Edit", style: .Default, handler: { (action: UIAlertAction!) in
            self.editBackgroundImage()
        }))
        
        imageSheet.addAction(UIAlertAction(title: "Replace", style: .Default, handler: { (action: UIAlertAction!) in
            self.replaceBackgroundImage()
        }))
        
        imageSheet.modalPresentationStyle = .Popover
        
        imageSheet.popoverPresentationController?.sourceView = self.view
        imageSheet.popoverPresentationController?.sourceRect = CGRectMake(changeImageButton.frame.origin.x, 703.0, 50, 50)
        
        presentViewController(imageSheet, animated: true, completion: nil)
        
    }
    
    // Capture background picture button pressed
    // Prompts the user for them to save or discard the captured image to camera roll
    @IBAction func captureView(sender: AnyObject) {
        var ssAlert = UIAlertController(title: "Screenshot taken", message: "Save to Camera Roll?", preferredStyle: UIAlertControllerStyle.Alert)
        
        ssAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
            UIImageWriteToSavedPhotosAlbum(self.getImageView(), nil, nil, nil)
        }))
        
        ssAlert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action: UIAlertAction!) in
            // Do nothing if cancel.
        }))
        
        presentViewController(ssAlert, animated: true, completion: nil)
    }
    
    // Adds an overlaying image from Photo Library or Existing Layers
    @IBAction func addOverlayImage(sender: AnyObject){
        if (editToggler == false) {
            return
        }
        
        var imageSheet = UIAlertController(title: "Image Layer Options", message: nil, preferredStyle: .ActionSheet)
        
        imageSheet.addAction(UIAlertAction(title: "Photo Library", style: .Default, handler: { (action: UIAlertAction!) in
            self.getImageFromPhotoLibrary()
        }))
        
        imageSheet.addAction(UIAlertAction(title: "Existing Layers", style: .Default, handler: { (action: UIAlertAction!) in
            self.presentSharedResourcePopover()
        }))
        
        imageSheet.modalPresentationStyle = .Popover
        imageSheet.popoverPresentationController?.sourceView = self.view
        imageSheet.popoverPresentationController?.sourceRect = CGRectMake((sender as UIButton).center.x - 25.0, 703.0, 50.0, 50.0)
        
        presentViewController(imageSheet, animated: true, completion: nil)
    }
    
    /* Helper functions */
    
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
    
    // Helper function for capturing background picture.
    // Returns the background image + all placeholders and overlays
    private func getImageView() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.imageView.bounds.size, view.opaque, 0.0)
        self.imageView.layer.renderInContext(UIGraphicsGetCurrentContext())
        var imageCaptured = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return imageCaptured
    }
    
    // Helper function to create and add draggable images from Photo Library or Existing Layers.
    // Takes in the image and name of the image, then add this image to the view
    // Scaling factor for inserted images is default at height 150.
    func addLayer(image: UIImage, imageName: String?) {
        var scalingFactor = image.size.height/150.0
        var newWidth = image.size.width / scalingFactor
        var newFrame = CGRect(x: imageView.center.x, y: imageView.center.y, width: newWidth, height: 150.0)
        var newImage: DraggableImageView
        
        // Add the overlay to the model
        
        // First time this image is used
        if imageName != nil {
            newImage = DraggableImageView(image: Utilities.getImageNamed(imageName!))
            newImage.labelIdentifier = mementoManager.addOverlay(graphName, roomLabel: roomLabel, frame: newFrame, imageFile: imageName!)!
            
        } else {
            // Existing image
            var newOverlay = mementoManager.addOverlay(graphName, roomLabel: roomLabel, frame: newFrame, image: Utilities.convertToThumbnail(image), imageType: Constants.ImageType.PNG)!
            newImage = DraggableImageView(image: Utilities.getImageNamed(newOverlay.imageFile))
            newImage.labelIdentifier = newOverlay.label
        }
        
        // Setting values for newImage before adding into imageView
        newImage.frame = newFrame
        newImage.graphName = self.graphName
        newImage.roomLabel = self.roomLabel
        newImage.parentViewController = self
        imageView.addSubview(newImage)
    }
    
    // Helper function to create a new placeholder (AnnottableUIView)
    // Dimensions are determined by user's pan gesture start and end point
    // These placeholders have a minimum size of (75*75)
    private func drawNewRect(startPoint: CGPoint, endPoint: CGPoint) {
        var newRectDoesNotIntersect = true
        // Make rectangle
        var newRect = CGRect(x: min(startPoint.x, endPoint.x), y: min(startPoint.y, endPoint.y), width: abs(startPoint.x - endPoint.x), height: abs(startPoint.y - endPoint.y))
        
        // Check if this rectangle does not intersect with existing rectangles
        for eachRect in allCGRects{
            if (CGRectIntersectsRect(eachRect, newRect)) {
                newRectDoesNotIntersect = false
            }
        }
        
        let minHeight = 75.0 as CGFloat
        let minWidth = 75.0 as CGFloat
        if (newRectDoesNotIntersect && newRect.height>minHeight && newRect.width>minWidth) {
            // Update model
            var newRectPlaceHolder = RectanglePlaceHolder(highlightArea: newRect)
            mementoManager.addPlaceHolder(graphName, roomLabel: roomLabel, placeHolder: newRectPlaceHolder)
            // Adding to view
            var newView = AnnotatableUIView(frame: newRect, parentController: self, tagNumber: newRectPlaceHolder.label, graphName: graphName, roomLabel:roomLabel)
            newView.backgroundColor = .whiteColor()
            newView.alpha = 0.25
            allCGRects.append(newRect)
            allAnnotatableViews.append(newView)
            imageView.addSubview(newView)
        }
    }
    
    // Helper functions for main photo pickers
    private func getImageFromPhotoLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(
            UIImagePickerControllerSourceType.SavedPhotosAlbum) {
                var imagePicker: UIImagePickerController? = UIImagePickerController()
                imagePicker?.delegate = self
                imagePicker?.sourceType =
                    UIImagePickerControllerSourceType.PhotoLibrary
                imagePicker?.mediaTypes = [kUTTypeImage as NSString]
                imagePicker?.allowsEditing = false
                
                var popover = UIPopoverController(contentViewController: imagePicker!) as UIPopoverController?
                var frame = CGRectMake(315, 260, 386, 386);
                
                popover?.presentPopoverFromRect(frame, inView: self.view, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: true)
                
                imagePicker = nil
                popover = nil
        }
    }
    
    // Helper function to reload viewcontroller with next node's data
    // Updates roomLabel, roomRep, background image, toggles, overlays and placeholders
    func loadNextNode() {
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
        if (withAnimation) {
            println("animated")
            UIView.animateWithDuration(NSTimeInterval(1.0), animations: {
                oldImage.frame.origin = CGPoint(x: -1024.0, y: 0)
                }, completion: { finished in
                    oldImage.removeFromSuperview()
            })
        }

        
    }
    
    // Helper function to display the numeric value of each placeholder(AnnotatableUIView) label number
    // Number shown is + 1 so as to display from [1..n+1] instead of [0..n]
    // UIButtons are created on top of each placeholder to allow for swapping of labels
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
            // Button's title reflect it's position in the array.
            // The numbers displayed would be strictly consecutive.
            if let labelNumber = find(allCGRects, newButton.frame) {
                newButton.setTitle(String(labelNumber + 1), forState: UIControlState.Normal)
            }
            // Setting button attributes
            // Button tag contains model's label to allow for updates in the model
            newButton.tag = eachAssociation.placeHolder.label
            newButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            newButton.titleLabel?.font = UIFont(name: "Helvetica", size: 50)
            newButton.titleLabel?.textAlignment = NSTextAlignment.Center
            newButton.addTarget(self, action: "labelButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
            self.view.addSubview(newButton)
            allButtons.append(newButton)
        }
    }
    
    // Helper function for handling the swapping of labels
    // If it's only 1 selection, the placeholder will get highlighted with a yellow border
    // If there's 2 consecutive selection, the labels of these 2 placeholders(AnnotatableUIView) will get swapped
    func labelButtonTapped(sender: UIButton!) {
        if let labelSelected = sender?.tag {
            if (previouslySelectedLabel == "_") {
                // Set current selection as there are no previously selected labels.
                previouslySelectedLabel = String(labelSelected)
                previouslySelectedIndex = (sender?.titleLabel?.text?.toInt())! - 1
                
                // Draw border
                sender.layer.borderWidth = 2.0
                sender.layer.borderColor = UIColor.yellowColor().CGColor
            } else {
                // Swap the labels
                mementoManager.swapPlaceHolders(self.graphName, roomLabel: self.roomLabel, pHolder1Label: previouslySelectedLabel.toInt()!, pHolder2Label: labelSelected)
                
                if let indexToSwap = sender?.titleLabel?.text?.toInt() {
                    // Update viewtags of annotatable views for deletion
                    var tempTag = allAnnotatableViews[indexToSwap - 1].viewTag
                    allAnnotatableViews[indexToSwap - 1].viewTag = allAnnotatableViews[previouslySelectedIndex!].viewTag
                    allAnnotatableViews[previouslySelectedIndex!].viewTag = tempTag
                    
                    // Swap contents in array as well
                    var tempRect = allCGRects[previouslySelectedIndex!]
                    allCGRects[previouslySelectedIndex!] = allCGRects[indexToSwap - 1]
                    allCGRects[indexToSwap - 1] = tempRect
                    var tempAnnotatableView = allAnnotatableViews[previouslySelectedIndex!]
                    allAnnotatableViews[previouslySelectedIndex!] = allAnnotatableViews[indexToSwap - 1]
                    allAnnotatableViews[indexToSwap - 1] = tempAnnotatableView
                }
                
                // Refresh the view
                removeAllLabels()
                showAllLabels()
            }
        }
    }
    
    // Helper function for handling the removal of all the numeric value of each placeholder(AnnotatableUIView) label number
    // Removes all the UIButtons previously created on top of the placeholders, and resets the previously selected label value
    private func removeAllLabels() {
        for eachButton in allButtons {
            eachButton.removeFromSuperview()
        }
        // Set previous selection back to dummy, non-integer value
        previouslySelectedLabel = "_"
    }
    

    
    /* Image Picker */
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
            
            // Call addLayer function
            addLayer(Utilities.convertToScreenSize(image), imageName: nil)
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
    

    /* CLEditor */
    func imageEditor(editor: CLImageEditor!, didFinishEdittingWithImage image: UIImage!) {
        self.imageView.image = image
        mementoManager.setBackgroundImageForRoom(self.graphName, roomLabel: self.roomLabel, newImage: Utilities.convertToScreenSize(image), imageType: Constants.ImageType.JPG)
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    /* Action Sheets helper functions */
    
    func editBackgroundImage() {
        var editor = CLImageEditor(image: self.imageView.image)
        editor.delegate = self
        self.presentViewController(editor, animated: true, completion: nil)
    }
    
    func replaceBackgroundImage() {
        performSegueWithIdentifier("ReplaceNodeSegue", sender: self)
    }
    
    func presentSharedResourcePopover() {
        var sharedResourceController = self.storyboard?.instantiateViewControllerWithIdentifier("SharedResourceViewController") as SharedResourceViewController?
        sharedResourceController?.delegate = self
        var popover = UIPopoverController(contentViewController: sharedResourceController!) as UIPopoverController?
        var frame = CGRectMake(315, 260, 386, 386);

        popover?.presentPopoverFromRect(frame, inView: self.view, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: true)
        
        sharedResourceController = nil
        popover = nil
        
    }
    
    
    /* Segue */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "CreateNewNodeSegue") {
            let nextNodeViewController = segue.destinationViewController as BlurCreateNodePopoverController
            nextNodeViewController.graphName = self.graphName
            nextNodeViewController.isNextNode = true
            nextNodeViewController.parentVC = self
        } else if (segue.identifier == "ReplaceNodeSegue") {
            let nextNodeViewController = segue.destinationViewController as BlurCreateNodePopoverController
            nextNodeViewController.graphName = self.graphName
            nextNodeViewController.isNextNode = false
            nextNodeViewController.nextRoomLabel = self.roomLabel
            nextNodeViewController.parentVC = self
        }
    }
    
    /* Private Functions */
    
    // Function to load layouts
    private func loadLayouts() {
        // Load draggable image views/layers
        var draggableImageViewsToAdd = [DraggableImageView]()
        for eachOverlay in overlayList {
            var newFrame = eachOverlay.frame
            var newImageFile = eachOverlay.imageFile
            var newImage = Utilities.getImageNamed(newImageFile)
            // TODO: remove NSlog
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
            
            var newAnnotatableView = AnnotatableUIView(frame: newFrame, parentController: self, tagNumber: newLabel, graphName: graphName, roomLabel:roomLabel)
            newAnnotatableView.backgroundColorHexCode = eachAssociation.placeHolder.color
            newAnnotatableView.alpha = 0.25
            newAnnotatableView.annotation = eachAssociation.value
            newAnnotatableView.userInteractionEnabled = false
            allAnnotatableViews.append(newAnnotatableView)
            imageView.addSubview(newAnnotatableView)
            imageView.sendSubviewToBack(newAnnotatableView)
            newAnnotatableView.updateBackgroundColor()
        }
        
        
        // Pre-load dark layer
        darkViewLayer.frame = CGRect(x: 0, y: 0, width: self.imageView.frame.width, height: self.imageView.frame.height)
        darkViewLayer.backgroundColor = UIColor.blackColor()
        darkViewLayer.alpha = 0.3
        
    }

}
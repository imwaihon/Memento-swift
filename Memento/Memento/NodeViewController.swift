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
    
    @IBOutlet weak var imageView: UIImageView!
    private var newMedia: Bool?
    
    var mementoManager = MementoManager.sharedInstance
    var saveLoadManager = SaveLoadManager.sharedInstance
    
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
        imageView.image = getImageNamed(roomRep.backgroundImage)
        
        // Load
        overlayList = roomRep.overlays
        associationList = roomRep.associations
        loadLayouts()
        
    }
    
    // Function to load layouts
    private func loadLayouts() {
        // Load draggable image views/layers
        var draggableImageViewsToAdd = [DraggableImageView]()
        var counter = 0
        for eachOverlay in overlayList {
            var newFrame = eachOverlay.frame
            var newImageFile = eachOverlay.imageFile
            var newImage = saveLoadManager.loadOverlayImage(newImageFile)
            
            var newDraggableImageView = DraggableImageView(image: newImage!)
            newDraggableImageView.graphName = self.graphName
            newDraggableImageView.roomLabel = self.roomLabel
            newDraggableImageView.labelIdentifier = counter
            counter += 1
            newDraggableImageView.frame = newFrame
            self.imageView.addSubview(newDraggableImageView)
        }
        
        // Load association list
        for eachAssociation in associationList {
            var newFrame = eachAssociation.placeHolder.view.frame
            var newLabel = eachAssociation.placeHolder.label
            
            var newAnnotatableView = AnnotatableUIView(frame: newFrame, parentController: self, tagNumber: newLabel, background: imageView, graphName: graphName, roomLabel:roomLabel)
            newAnnotatableView.backgroundColor = .whiteColor()
            newAnnotatableView.alpha = 0.25
            newAnnotatableView.label.text = eachAssociation.value
            imageView.addSubview(newAnnotatableView)
        }
        
    }
    
    // Camera button
    @IBAction func useCamera(sender: AnyObject) {
        
        if UIImagePickerController.isSourceTypeAvailable(
            UIImagePickerControllerSourceType.Camera) {
                
                let imagePicker = UIImagePickerController()
                
                imagePicker.delegate = self
                imagePicker.sourceType =
                    UIImagePickerControllerSourceType.Camera
                imagePicker.mediaTypes = [kUTTypeImage as NSString]
                self.presentViewController(imagePicker, animated: true, 
                    completion: nil)
                newMedia = true
                
                // For main view
                isMainView = true
        }
    }
    
    // Camera roll button
    @IBAction func useCameraRoll(sender: AnyObject) {
        isMainView = true
        getImageFromPhotoLibrary(sender)
    }
    
    
    // Adds an overlaying image from camera roll ( possibly in-app sprites next time?)
    // Possible future portability for cropping images.
    @IBAction func addOverlayImage(sender: AnyObject){
        isMainView = false
        getImageFromPhotoLibrary(sender)
        
    }
    
    @IBAction func rotateImage(sender: AnyObject) {
        if rotationToggler == true {
            UIView.animateWithDuration(1.0, animations: {
                self.imageView.transform = CGAffineTransformMakeRotation((180.0 * CGFloat(M_PI)) / 180.0)
            })
            rotationToggler = false
        } else {
            UIView.animateWithDuration(1.0, animations: {
                self.imageView.transform = CGAffineTransformMakeRotation(0)
            })
            rotationToggler = true
        }
        
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
                imageView.addSubview(newImage)
                
                // Get paths for saving
                saveLoadManager.saveOverlayImage("test", imageToSave: image)
                var newMutableOverlay = MutableOverlay(frame: newImage.frame, imageFile: "test")
                newImage.labelIdentifier = mementoManager.addOverlay(graphName, roomLabel: roomLabel, overlay: newMutableOverlay)
                
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
        
        if (newRectDoesNotIntersect) {
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
    
    private func getImageNamed(fileName : String) -> UIImage{
        let nsDocumentDirectory = NSSearchPathDirectory.DocumentDirectory
        let nsUserDomainMask = NSSearchPathDomainMask.UserDomainMask
        if let paths = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
        {
            if paths.count > 0
            {
                if let dirPath = paths[0] as? String
                {
                    let readPath = dirPath.stringByAppendingPathComponent(fileName)
                    let image    = UIImage(contentsOfFile: readPath)
                    // Do whatever you want with the image
                    return image!
                }
            }
        }
        return UIImage()
    }

}
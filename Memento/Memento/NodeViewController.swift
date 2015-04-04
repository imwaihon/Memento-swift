//
//  NodeViewController.swift
//  Memento
//
//  Created by Lim Jing Rong on 23/3/15.
//  Copyright (c) 2015 NUS CS3217. All rights reserved.
//


import UIKit
import MobileCoreServices

class NodeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // ImageView = whole screen
    
    @IBOutlet weak var imageView: UIImageView!
    var newMedia: Bool?
    
    var mementoManager = MementoManager.sharedInstance
    var isMainView: Bool = true
    var newImage: DraggableImageView!
    var lastRotation = CGFloat()
    let panRec = UIPanGestureRecognizer()
    var startPoint = CGPoint()
    var annotationCount: Int = 100
    
    var roomLabel = Int()
    var graphName = String()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setUpGestures()
        panRec.addTarget(self, action: "handlePan:")
        self.view.addGestureRecognizer(panRec)
        self.view.userInteractionEnabled = true
        
        // Get view representation of room
        var roomRep = mementoManager.getMemoryPalaceRoomView(graphName, roomLabel: roomLabel)!
        
        // Get image from graphical view
        imageView.image = getImageNamed(roomRep.backgroundImage)
        
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
                newImage.frame = CGRect(x: imageView.center.x, y: imageView.center.y, width: newWidth, height: 150.0)
                imageView.userInteractionEnabled = true
                imageView.addSubview(newImage)
                
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
        // Make rectangle
        var toDrawRect = CGRect(x: min(startPoint.x, endPoint.x), y: min(startPoint.y, endPoint.y), width: abs(startPoint.x - endPoint.x), height: abs(startPoint.y - endPoint.y))

        // Add the rectangle into main view
        var newViewToTest = AnnotatableUIView(frame: toDrawRect, parentController: self, tagNumber: annotationCount)
        annotationCount += 1
        newViewToTest.backgroundColor = .whiteColor()
        newViewToTest.alpha = 0.1
        imageView.userInteractionEnabled = true
        imageView.addSubview(newViewToTest)
        //self.view.addSubview(newViewToTest)
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
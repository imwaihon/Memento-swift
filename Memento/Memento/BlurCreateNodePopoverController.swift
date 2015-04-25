//
//  BlurCreateNodePopoverController.swift
//  Memento
//
//  Created by Jingrong (: on 6/4/15.
//  Copyright (c) 2015 NUS CS3217. All rights reserved.
//

import Foundation
import UIKit
import MobileCoreServices
import QuartzCore

class BlurCreateNodePopoverController: UIViewController, UIGestureRecognizerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, CLImageEditorDelegate {
    
    
    var newMedia: Bool?
    var mementoManager = MementoManager.sharedInstance
    var graphName: String = ""
    var nextRoomLabel = Int()
    var isNextNode: Bool = true
    var parentVC: NodeViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .clearColor()
        
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .Dark))
        visualEffectView.frame = self.view.bounds
        visualEffectView.autoresizingMask = .FlexibleWidth | .FlexibleHeight
        visualEffectView.setTranslatesAutoresizingMaskIntoConstraints(true)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: "handleTap:")
        tapGesture.numberOfTapsRequired = 1
        visualEffectView.addGestureRecognizer(tapGesture)
        
        self.view.addSubview(visualEffectView)
        self.view.sendSubviewToBack(visualEffectView)
        self.setNeedsStatusBarAppearanceUpdate()

    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return true
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    func handleTap(sender: UITapGestureRecognizer){
        let previousViewController = self.presentingViewController as NodeViewController
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.BlackOpaque
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
        }
    }
        
    // Camera roll button
    @IBAction func useCameraRoll(sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(
            UIImagePickerControllerSourceType.SavedPhotosAlbum) {
                var imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType =
                    UIImagePickerControllerSourceType.SavedPhotosAlbum
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
        if mediaType.isEqualToString(kUTTypeImage as NSString) {
            var image = info[UIImagePickerControllerOriginalImage]
                as UIImage
            
            if (picker.sourceType == UIImagePickerControllerSourceType.Camera) {
                var editor = CLImageEditor(image: image)
                editor.delegate = self
                picker.pushViewController(editor, animated: true)
            } else {
                if (isNextNode == true){
                    var resourceRep = mementoManager.addMemoryPalaceRoom(self.graphName, image: Utilities.convertToScreenSize(image), imageType: Constants.ImageType.JPG)
                    if resourceRep != nil {
                        nextRoomLabel = resourceRep!.0
                    }
                } else {
                    self.parentVC?.imageView.image = image
                    mementoManager.setBackgroundImageForRoom(self.graphName, roomLabel: nextRoomLabel, newImage: Utilities.convertToScreenSize(image), imageType: Constants.ImageType.JPG)
                }
                self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }
    
    func imageEditor(editor: CLImageEditor!, didFinishEdittingWithImage image: UIImage!) {
        if (isNextNode == true){
            var resourceRep = mementoManager.addMemoryPalaceRoom(self.graphName, image: Utilities.convertToScreenSize(image), imageType: Constants.ImageType.JPG)
            if resourceRep != nil {
                nextRoomLabel = resourceRep!.0
            }
        } else {
            self.parentVC?.imageView.image = image
            mementoManager.setBackgroundImageForRoom(self.graphName, roomLabel: nextRoomLabel, newImage: Utilities.convertToScreenSize(image), imageType: Constants.ImageType.JPG)
        }


        self.dismissViewControllerAnimated(true, completion: {finished in
            self.dismissViewControllerAnimated(true, completion: nil)
        })
    }
    
    func imageEditorDidCancel(editor: CLImageEditor!) {
        self.dismissViewControllerAnimated(true, completion: {finished in
            self.dismissViewControllerAnimated(true, completion: nil)
        })
    }
    
}
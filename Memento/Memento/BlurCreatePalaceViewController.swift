//
//  BlurCreatePalaceViewController.swift
//  Memento
//
//  Created by Abdulla Contractor on 29/3/15.
//  Copyright (c) 2015 NUS CS3217. All rights reserved.
//


import Foundation
import UIKit
import MobileCoreServices
import QuartzCore

/// This view brings up a full screen modal view with a blur effect on it. The view is used to create a new memory palace by taking an image and a palace name as user inputs
class BlurCreatePalaceViewController: UIViewController, UIGestureRecognizerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, CLImageEditorDelegate {
    
    // Instance Variables
    var newMedia: Bool?
    var model = MementoManager.sharedInstance
    var parent: ModelChangeUpdateDelegate!
    // Storyboard connected variables
    @IBOutlet weak var nameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .clearColor()
        
        // Set up blur effect for the view
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
        nameTextField.backgroundColor = UIColor.clearColor()
        nameTextField.layer.borderColor = UIColor.whiteColor().CGColor
        nameTextField.layer.borderWidth = 1.5
        nameTextField.layer.cornerRadius = 5
        nameTextField.delegate = self
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.BlackOpaque
    }
    
    // UITEXTFIELDDELEGATEPROTOCOL FUNCTIONS
    func textFieldShouldReturn(textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return true
    }
    
    /// This function triggers whenever the user starts entering anything into the text field. It provides functionality towards blocking a user from selecting an image before entering a name for the new palace.
    @IBAction func startedEnteringName(sender: AnyObject) {
        nameTextField.layer.borderColor = UIColor.whiteColor().CGColor
    }
    
    /// Navigates to the camera to allow the user to click a photo
    @IBAction func useCamera(sender: AnyObject) {
        
        if(!nameTextField.text.isEmpty){
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
        } else{
            nameTextField.layer.borderColor = UIColor.redColor().CGColor
        }
    }
    
    // Camera roll button
    @IBAction func useCameraRoll(sender: AnyObject) {
        if(!nameTextField.text.isEmpty){
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
                    
                    // Needs to allow potrait
                    //self.presentViewController(popover, animated: true, completion: nil)
                    
                    newMedia = false
            }
        } else{
            nameTextField.layer.borderColor = UIColor.redColor().CGColor
        }
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        let mediaType = info[UIImagePickerControllerMediaType] as NSString
        if mediaType.isEqualToString(kUTTypeImage as NSString) {
            var image = info[UIImagePickerControllerOriginalImage]
                as UIImage
            if(picker.sourceType == UIImagePickerControllerSourceType.Camera){
                var editor = CLImageEditor(image: image)
                editor.delegate = self
                picker.pushViewController(editor, animated: true)
            } else{
                model.addMemoryPalace(named: nameTextField.text, /*imageFile: "\(nameTextField.text)0",*/image: Utilities.convertToScreenSize(image), imageType: Constants.ImageType.JPG)
                parent.dataModelHasBeenChanged()
                self.dismissViewControllerAnimated(true, completion: {finished in
                self.dismissViewControllerAnimated(true, completion: nil)
                })
            }
        }
    }
    
    func imageEditor(editor: CLImageEditor!, didFinishEdittingWithImage image: UIImage!) {
        model.addMemoryPalace(named: nameTextField.text, /*imageFile: "\(nameTextField.text)0",*/image: Utilities.convertToScreenSize(image), imageType: Constants.ImageType.JPG)
        parent.dataModelHasBeenChanged()
        self.dismissViewControllerAnimated(true, completion: {finished in
            self.dismissViewControllerAnimated(true, completion: nil)
        })
    }
    
    func imageEditorDidCancel(editor: CLImageEditor!) {
        parent.dataModelHasBeenChanged()
        self.dismissViewControllerAnimated(true, completion: {finished in
            self.dismissViewControllerAnimated(true, completion: nil)
        })
    }
    
    
    func handleTap(sender: UITapGestureRecognizer){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
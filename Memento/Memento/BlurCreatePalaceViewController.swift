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

class BlurCreatePalaceViewController: UIViewController, UIGestureRecognizerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    
    var newMedia: Bool?
    var model = MementoManager()
    var parent: ModelChangeUpdateDelegate!
    
    @IBOutlet weak var nameTextField: UITextField!
    
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
        nameTextField.backgroundColor = UIColor.clearColor()
        nameTextField.layer.borderColor = UIColor.whiteColor().CGColor
        nameTextField.layer.borderWidth = 1.5
        nameTextField.layer.cornerRadius = 5
        nameTextField.delegate = self
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
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func startedEnteringName(sender: AnyObject) {
        nameTextField.layer.borderColor = UIColor.whiteColor().CGColor
    }
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.BlackOpaque
    }
    
    // Camera button
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
            
            /*
            // Adjustments to show UIImageView in proper rotation according to input types
            if picker.sourceType == UIImagePickerControllerSourceType.Camera{
                image = UIImage(CGImage: image.CGImage, scale:1, orientation: UIImageOrientation.Down)!
            } else {
                image = UIImage(CGImage: image.CGImage, scale:1, orientation: UIImageOrientation.Up)!
            }
            let nsDocumentDirectory = NSSearchPathDirectory.DocumentDirectory
            let nsUserDomainMask = NSSearchPathDomainMask.UserDomainMask
            if let paths = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true) {
                if paths.count > 0 {
                    if let dirPath = paths[0] as? String {
                        let writePath = dirPath.stringByAppendingPathComponent("\(nameTextField.text)0.png")
                        UIImagePNGRepresentation(image).writeToFile(writePath, atomically: true)
                    }
                }
            }
            model.addMemoryPalace(named: nameTextField.text, imageFile: "\(nameTextField.text)0.png")*/
            model.addMemoryPalace(named: nameTextField.text, imageFile: "\(nameTextField.text)0.jpg", image:Utilities.convertToThumbnail(image))
        }
        parent.dataModelHasBeenChanged()
        self.dismissViewControllerAnimated(true, completion: {finished in
            self.dismissViewControllerAnimated(true, completion: nil)
        })
    }
    
}
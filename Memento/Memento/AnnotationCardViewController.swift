//
//  AnnotationCardViewController.swift
//  Memento
//
//  Created by Abdulla Contractor on 16/4/15.
//  Copyright (c) 2015 NUS CS3217. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore

class AnnotationCardViewController : UIViewController, UITextViewDelegate {

    @IBOutlet weak var textViewAnno: UITextView!
    var previousText = ""
    weak var parent : AnnotatableUIView!
    var edittingEnabled: Bool!
    var mementoManager = MementoManager.sharedInstance
    
    // Color Buttons
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!
    @IBOutlet weak var button5: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textViewAnno.text = previousText
        textViewAnno.layer.borderColor = UIColor.lightGrayColor().CGColor
        textViewAnno.layer.borderWidth = 1.5
        textViewAnno.layer.cornerRadius = 5
        textViewAnno.delegate = self
        if edittingEnabled == true {
            textViewAnno.userInteractionEnabled = true
        } else {
            textViewAnno.userInteractionEnabled = false
        }
        
        loadButtons()
        
        
        
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    override func viewDidDisappear(animated: Bool) {
        if edittingEnabled == true{
            parent.annotation = textViewAnno.text
            parent.persistAnnotation()
        }
        super.viewDidDisappear(animated)
    }
    
    /* UITextField Delegate */

    // Prevents going over textfield size
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        // Combine the new text with the old
        let combinedText = (textView.text as NSString).stringByReplacingCharactersInRange(range, withString: text)
        
        // Create attributed version of the text
        let attributedText = NSMutableAttributedString(string: combinedText)
        attributedText.addAttribute(NSFontAttributeName, value: textView.font, range: NSMakeRange(0, attributedText.length))
        
        // Get the padding of the text container
        let padding = textView.textContainer.lineFragmentPadding
        
        // Create a bounding rect size by subtracting the padding
        // from both sides and allowing for unlimited length
        let boundingSize = CGSizeMake(textView.frame.size.width - padding * 2, CGFloat.max)
        
        // Get the bounding rect of the attributed text in the
        // given frame
        let boundingRect = attributedText.boundingRectWithSize(boundingSize, options: NSStringDrawingOptions.UsesLineFragmentOrigin, context: nil)
        
        // Compare the boundingRect plus the top and bottom padding
        // to the text view height; if the new bounding height would be
        // less than or equal to the text view height, append the text
        if (boundingRect.size.height + padding * 2 <= textView.frame.size.height){
            return true
        }
        else {
            return false
        }
    }
    
    /* Color Buttons */
    
    @IBAction func button1Pressed(sender: AnyObject) {
        parent.backgroundColorHexCode = Constants.color1
        parent.updateBackgroundColor()
        mementoManager.setPlaceHolderColor(parent.graphName, roomLabel: parent.roomLabel, placeHolderLabel: parent.viewTag, color: parent.backgroundColorHexCode)
        setAllButtonsToFade()
        button1.alpha = 1.0
    }
    
    @IBAction func button2Pressed(sender: AnyObject) {
        //parent.backgroundColor = button2.backgroundColor!
        parent.backgroundColorHexCode = Constants.color2
        parent.updateBackgroundColor()
        mementoManager.setPlaceHolderColor(parent.graphName, roomLabel: parent.roomLabel, placeHolderLabel: parent.viewTag, color: parent.backgroundColorHexCode)
        setAllButtonsToFade()
        button2.alpha = 1.0
    }
    
    @IBAction func button3Pressed(sender: AnyObject) {
        parent.backgroundColorHexCode = Constants.color3
        parent.updateBackgroundColor()
        mementoManager.setPlaceHolderColor(parent.graphName, roomLabel: parent.roomLabel, placeHolderLabel: parent.viewTag, color: parent.backgroundColorHexCode)
        setAllButtonsToFade()
        button3.alpha = 1.0
    }
    
    @IBAction func button4Pressed(sender: AnyObject) {
        parent.backgroundColorHexCode = Constants.color4
        parent.updateBackgroundColor()
        mementoManager.setPlaceHolderColor(parent.graphName, roomLabel: parent.roomLabel, placeHolderLabel: parent.viewTag, color: parent.backgroundColorHexCode)
        setAllButtonsToFade()
        button4.alpha = 1.0
    }
    
    @IBAction func button5Pressed(sender: AnyObject) {
        parent.backgroundColorHexCode = Constants.color5
        parent.updateBackgroundColor()        
        mementoManager.setPlaceHolderColor(parent.graphName, roomLabel: parent.roomLabel, placeHolderLabel: parent.viewTag, color: parent.backgroundColorHexCode)
        setAllButtonsToFade()
        button5.alpha = 1.0
    }
    
    private func loadButtons() {
        for eachButton in self.view.subviews {
            if eachButton.isMemberOfClass(UIButton) {
                (eachButton as UIButton).layer.cornerRadius = (eachButton as UIButton).bounds.size.width/2
                (eachButton as UIButton).layer.borderWidth = 2.0
                (eachButton as UIButton).layer.borderColor = UIColor.blackColor().CGColor
            }
        }
        button1.backgroundColor = hexStringToUIColor(Constants.color1)
        button2.backgroundColor = hexStringToUIColor(Constants.color2)
        button3.backgroundColor = hexStringToUIColor(Constants.color3)
        button4.backgroundColor = hexStringToUIColor(Constants.color4)
        button5.backgroundColor = hexStringToUIColor(Constants.color5)
        setAllButtonsToFade()
    }
    
    // Set all buttons to fade
    private func setAllButtonsToFade() {
        for eachButton in self.view.subviews {
            if eachButton.isMemberOfClass(UIButton) {
                (eachButton as UIButton).alpha = 0.5
            }
        }
    }
    
    // Helper function to convert hexstring color to UIColor
    private func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet() as NSCharacterSet).uppercaseString
        
        if (cString.hasPrefix("#")) {
            cString = cString.substringFromIndex(advance(cString.startIndex, 1))
        }
        
        var rgbValue:UInt32 = 0
        NSScanner(string: cString).scanHexInt(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    
}
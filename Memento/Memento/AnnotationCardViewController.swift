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

class AnnotationCardViewController : UIViewController{
    @IBOutlet weak var textView: UITextView!
    var previousText = ""
    var parent : AnnotatableUIView!
    var edittingEnabled: Bool!
    
    // Color Buttons
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!
    @IBOutlet weak var button5: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.text = previousText
        textView.layer.borderColor = UIColor.lightGrayColor().CGColor
        textView.layer.borderWidth = 1.5
        textView.layer.cornerRadius = 5
        if edittingEnabled == true{
            textView.userInteractionEnabled = true
        } else{
            textView.userInteractionEnabled = false
        }
        
        loadButtons()
        
        
        
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    override func viewDidDisappear(animated: Bool) {
        if edittingEnabled == true{
            parent.annotation = textView.text
            parent.persistAnnotation()
        }
        super.viewDidDisappear(animated)
    }
    
    @IBAction func button1Pressed(sender: AnyObject) {
        parent.backgroundColor = button1.backgroundColor!
        parent.backgroundColorHexCode = Constants.color1
        setAllButtonsToFade()
        button1.alpha = 1.0
    }
    
    @IBAction func button2Pressed(sender: AnyObject) {
        parent.backgroundColor = button2.backgroundColor!
        parent.backgroundColorHexCode = Constants.color2
        setAllButtonsToFade()
        button2.alpha = 1.0
    }
    
    @IBAction func button3Pressed(sender: AnyObject) {
        parent.backgroundColor = button3.backgroundColor!
        parent.backgroundColorHexCode = Constants.color3
        setAllButtonsToFade()
        button3.alpha = 1.0
    }
    
    @IBAction func button4Pressed(sender: AnyObject) {
        parent.backgroundColor = button4.backgroundColor!
        parent.backgroundColorHexCode = Constants.color4
        setAllButtonsToFade()
        button4.alpha = 1.0
    }
    
    @IBAction func button5Pressed(sender: AnyObject) {
        parent.backgroundColor = button5.backgroundColor!
        parent.backgroundColorHexCode = Constants.color5
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
//
//  AnnotationCardViewController.swift
//  Memento
//
//  Created by Abdulla Contractor on 16/4/15.
//  Copyright (c) 2015 NUS CS3217. All rights reserved.
//

import Foundation
import UIKit

class AnnotationCardViewController : UIViewController{
    @IBOutlet weak var textView: UITextView!
    var previousText = ""
    var parent : AnnotatableUIView!
    var edittingEnabled: Bool!
    
    @IBOutlet weak var editButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        editButton.hidden = !edittingEnabled
        textView.text = previousText
        textView.layer.borderColor = UIColor.lightGrayColor().CGColor
        textView.layer.borderWidth = 1.5
        textView.layer.cornerRadius = 5
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
    }
    @IBAction func saveButtonPressed(sender: AnyObject) {
        parent.annotation = textView.text
        parent.persistAnnotation()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
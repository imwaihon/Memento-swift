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
}
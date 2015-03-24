//
//  CreateNewPalaceViewController.swift
//  Memento
//
//  Created by Chee Wai Hon on 23/3/15.
//  Copyright (c) 2015 NUS CS3217. All rights reserved.
//

import UIKit

class CreateNewPalaceViewController: UIViewController {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func createNewPressed(sender: UIButton) {
    }

    @IBAction func backPressed(sender: UIButton) {
        
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
}

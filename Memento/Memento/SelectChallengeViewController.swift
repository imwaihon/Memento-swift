//
//  SelectChallengeViewController.swift
//  Memento
//
//  Created by Chee Wai Hon on 31/3/15.
//  Copyright (c) 2015 NUS CS3217. All rights reserved.
//

import Foundation
import UIKit

class SelectChallengeViewController: UIViewController {
    
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "LoadCustomChallengeSegue"){
        } else if(segue.identifier == "LoadPresetChallengeSegue"){
        }
    }
    
    @IBAction func backButtonPress(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}

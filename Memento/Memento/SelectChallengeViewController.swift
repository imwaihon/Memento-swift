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
    
    enum gameModes : String {
        case orderMode = "Order"
        case findMode = "Find"
    }
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var modeTitleLabel: UILabel!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        modeTitleLabel.text = gameModes.orderMode.rawValue
        playButton.layer.borderColor = UIColor.darkGrayColor().CGColor
        playButton.layer.borderWidth = 1.5
        playButton.layer.cornerRadius = 5
        leftButton.hidden = true
        rightButton.hidden = false
        
    }
    
    @IBAction func leftButtonClicked(sender: AnyObject) {
        leftButton.hidden = true
        rightButton.hidden = false
        modeTitleLabel.text = gameModes.orderMode.rawValue
    }
    @IBAction func rightButtonClicked(sender: AnyObject) {
        leftButton.hidden = false
        rightButton.hidden = true
        modeTitleLabel.text = gameModes.findMode.rawValue
    }
    @IBAction func playButtonPressed(sender: AnyObject) {
        self.performSegueWithIdentifier("LoadCustomChallengeSegue", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "LoadCustomChallengeSegue") {
            let dvc = segue.destinationViewController as LoadCustomChallengeViewController
            dvc.gameMode = self.modeTitleLabel.text!
            
        }
    }
    
    @IBAction func backButtonPress(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}

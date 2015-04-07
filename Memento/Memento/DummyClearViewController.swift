//
//  DummyClearViewController.swift
//  Memento
//
//  Created by Jingrong (: on 7/4/15.
//  Copyright (c) 2015 NUS CS3217. All rights reserved.
//
//  Created to assist in letting nodeviewcontroller transit to itself , or an image picker

import Foundation
import UIKit

class DummyClearViewController: UIViewController {
    var nodeAlreadyExist: Bool = false
    var graphName: String = ""
    var nextRoomLabel = Int()
    
    override func viewDidLoad() {
        // Delay to wait for modal animation to finish loading
        delay(0.01){
            if self.nodeAlreadyExist == true {
                self.performSegueWithIdentifier("goToExistingNextNode", sender: self)
            } else {
                // Allow user to input image
                self.performSegueWithIdentifier("goToSelectPicture", sender: self)
            }
        }

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "goToExistingNextNode"){
            // Go to previously created next node
            let nextNodeViewController = segue.destinationViewController as NodeViewController
            nextNodeViewController.graphName = self.graphName
            nextNodeViewController.roomLabel = nextRoomLabel
        }
        if (segue.identifier == "goToSelectPicture") {
            let nextNodeViewController = segue.destinationViewController as BlurCreateNodePopoverController
            nextNodeViewController.graphName = self.graphName
        }
    }
    
    private func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
}

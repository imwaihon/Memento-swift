//
//  GameMenuViewController.swift
//  Memento
//
//  Created by Chee Wai Hon on 10/4/15.
//  Copyright (c) 2015 NUS CS3217. All rights reserved.
//

import Foundation
import UIKit

class GameMenuViewController: UIViewController {
    
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .clearColor()
        
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .Dark))
        visualEffectView.frame = self.view.bounds
        visualEffectView.autoresizingMask = .FlexibleWidth | .FlexibleHeight
        visualEffectView.setTranslatesAutoresizingMaskIntoConstraints(true)
    
        self.view.addSubview(visualEffectView)
        self.view.sendSubviewToBack(visualEffectView)
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    

    @IBAction func backButtonPress(sender: AnyObject) {
        let controller = self.presentingViewController as? GameChallengeViewController
        controller?.resumeGame()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func backToMenuButtonPress(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
}
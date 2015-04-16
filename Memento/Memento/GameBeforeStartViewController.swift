//
//  GameBeforeStartViewController.swift
//  Memento
//
//  Created by Chee Wai Hon on 16/4/15.
//  Copyright (c) 2015 NUS CS3217. All rights reserved.
//

import Foundation
import UIKit
import MobileCoreServices
import QuartzCore

class GameBeforeStartViewController: UIViewController, UIGestureRecognizerDelegate, UINavigationControllerDelegate {
    
    weak var delegate: GamePauseDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .clearColor()
        
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .Dark))
        visualEffectView.frame = self.view.bounds
        visualEffectView.autoresizingMask = .FlexibleWidth | .FlexibleHeight
        visualEffectView.setTranslatesAutoresizingMaskIntoConstraints(true)
        
        self.view.addSubview(visualEffectView)
        self.view.sendSubviewToBack(visualEffectView)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.BlackOpaque
    }
    

    @IBAction func startGame(sender: AnyObject) {
        print("lol")
        self.delegate?.startGame()
    }
    
    @IBAction func backToMenuButtonPress(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
}
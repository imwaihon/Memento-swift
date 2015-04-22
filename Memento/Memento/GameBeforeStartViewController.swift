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
    
    var palaceName = String()
    var gameMode = String()
    var guideSwitch = true
    var showLayerSwitch = true

    @IBOutlet weak var guideAnnotationSwitch: UISwitch!
    
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
    
    @IBAction func guideSwitchChanged(sender: UISwitch) {
        if sender.on {
            guideSwitch = true
        } else {
            guideSwitch = false
        }
    }
    
    @IBAction func showLayerSwitchChanged(sender: UISwitch) {
        if sender.on {
            showLayerSwitch = true
        } else {
            showLayerSwitch = false
        }
    }

    @IBAction func startGame(sender: AnyObject) {
        self.performSegueWithIdentifier("StartGameSegue", sender: self)
    }
    
    @IBAction func backToMenuButtonPress(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "StartGameSegue"){
            let dvc = segue.destinationViewController as GameChallengeViewController
            dvc.palaceName = self.palaceName
            dvc.gameMode = self.gameMode
            dvc.showAnnotation = self.guideSwitch
            dvc.showLayer = self.showLayerSwitch
        }
    }
}
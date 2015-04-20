//
//  EndGameChallengeViewController.swift
//  Memento
//
//  Created by Chee Wai Hon on 31/3/15.
//  Copyright (c) 2015 NUS CS3217. All rights reserved.
//

import Foundation
import UIKit
import MobileCoreServices
import QuartzCore

class EndGameChallengeViewController: UIViewController, UIGestureRecognizerDelegate, UINavigationControllerDelegate {
    
    var timeValue = 0
    var mistakeValue = 0
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var mistakeCountLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .clearColor()
        
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .Dark))
        visualEffectView.frame = self.view.bounds
        visualEffectView.autoresizingMask = .FlexibleWidth | .FlexibleHeight
        visualEffectView.setTranslatesAutoresizingMaskIntoConstraints(true)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: "handleTap:")
        tapGesture.numberOfTapsRequired = 1
        visualEffectView.addGestureRecognizer(tapGesture)
        
        self.view.addSubview(visualEffectView)
        self.view.sendSubviewToBack(visualEffectView)
        
        updateResult(timeValue, mistakes: mistakeValue)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    func handleTap(sender: UITapGestureRecognizer) {
        self.dismissViewControllerAnimated(true, completion: nil)
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    private func updateResult(time: Int, mistakes: Int) {
        timeLabel.text = "Time taken: \(String(time)) seconds"
        mistakeCountLabel.text = "Mistakes made: \(String(mistakes))"
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.BlackOpaque
    }
    
}

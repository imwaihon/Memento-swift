//
//  LoadCustomChallengeViewController.swift
//  Memento
//
//  Created by Chee Wai Hon on 31/3/15.
//  Copyright (c) 2015 NUS CS3217. All rights reserved.
//

// Collectionview to load a custom challenge

import Foundation
import UIKit

class LoadCustomChallengeViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UIGestureRecognizerDelegate, ModelChangeUpdateDelegate {
    
    @IBOutlet var palaceTiles: UICollectionView!
    var mementoManager = MementoManager.sharedInstance
    var palaces : [MemoryPalaceIcon]!
    var nextPalace = ""
    var selectedPalace = ""
    var gameMode = ""
    var imagesCache : [String:UIImage]!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        palaceTiles.backgroundColor = UIColor.clearColor()
        self.setNeedsStatusBarAppearanceUpdate()
        imagesCache = [String:UIImage]()
        self.palaces = mementoManager.getMemoryPalaceIcons()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        palaceTiles.reloadData()
    }
    
    
    /* Collection View */
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return palaces.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell = palaceTiles.dequeueReusableCellWithReuseIdentifier("SelectPalaceCollectionViewCell", forIndexPath: indexPath) as SelectPalaceCollectionViewCell
        cell.parent = self

        let currentIcon : MemoryPalaceIcon = palaces[indexPath.item]
        if(imagesCache[currentIcon.imageFile] == nil || imagesCache[currentIcon.imageFile] == UIImage()) {
            imagesCache[currentIcon.imageFile] = Utilities.getImageNamed(currentIcon.imageFile)
        }
        cell.imageView.image = imagesCache[currentIcon.imageFile]
        cell.nameLabel.text = currentIcon.graphName
        cell.nameLabel.hidden = false
        cell.opacityBackground.hidden = false
    
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cellClicked = collectionView.cellForItemAtIndexPath(indexPath) as SelectPalaceCollectionViewCell
        self.nextPalace = cellClicked.nameLabel.text!
        self.performSegueWithIdentifier("ShowBeforeStartSegue", sender: self)
    }
    
    func dataModelHasBeenChanged() {
        self.palaces = mementoManager.getMemoryPalaceIcons()
        self.palaceTiles.reloadData()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.BlackOpaque
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "ShowBeforeStartSegue"){
            self.selectedPalace = ""
            let dvc = segue.destinationViewController as GameBeforeStartViewController
            dvc.palaceName = self.nextPalace
            dvc.gameMode = self.gameMode
        }
    }
    
    @IBAction func backButtonPress(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}

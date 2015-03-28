//
//  SelectPalaceViewController.swift
//  Memento
//
//  Created by Chee Wai Hon on 23/3/15.
//  Copyright (c) 2015 NUS CS3217. All rights reserved.
//

import UIKit

class SelectPalaceViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UIGestureRecognizerDelegate {
    
    @IBOutlet var palaceTiles: UICollectionView!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        palaceTiles.backgroundColor = UIColor.clearColor()
        
        setUpGestures()
        
    }
    
    // GESTURES
    
    // Set up gestures
    func setUpGestures() {
        // Tap Gesture
        let tapGesture = UITapGestureRecognizer(target: self, action: "handleTap:")
        tapGesture.numberOfTapsRequired = 1
        
        palaceTiles.addGestureRecognizer(tapGesture)
    }
    
    func handleTap(sender: UITapGestureRecognizer) {
        if sender.state == UIGestureRecognizerState.Ended {
            var point = sender.locationInView(palaceTiles)
            
            var indexPath = palaceTiles.indexPathForItemAtPoint(point)
            
            // If first cell is selected
            if indexPath?.item == 0 {
                self.performSegueWithIdentifier("CreateNewPalaceSegue", sender: self)
            }
            
        }
    }
    

    
    
    // COLLECTION VIEW

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    // Number of tiles
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = palaceTiles.dequeueReusableCellWithReuseIdentifier("SelectPalaceCollectionViewCell", forIndexPath: indexPath) as SelectPalaceCollectionViewCell
        cell.addShadows()
        // First cell is reserved for the add button
        if indexPath.item == 0 {
            cell.backgroundColor = UIColor.blackColor()
            
        } else {
            cell.backgroundColor = UIColor.clearColor()
            cell.imageView.image = UIImage(named: "landscape1")
            
        }
        
        return cell
    }
    
}

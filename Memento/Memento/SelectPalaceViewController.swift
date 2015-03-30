//
//  SelectPalaceViewController.swift
//  Memento
//
//  Created by Chee Wai Hon on 23/3/15.
//  Copyright (c) 2015 NUS CS3217. All rights reserved.
//

import UIKit

class SelectPalaceViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UIGestureRecognizerDelegate, ModelChangeUpdateDelegate {
    
    @IBOutlet var palaceTiles: UICollectionView!
    var model = MementoManager()
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        palaceTiles.backgroundColor = UIColor.clearColor()
        self.setNeedsStatusBarAppearanceUpdate()
        //setUpGestures()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
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
        return model.numberOfMemoryPalace + 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = palaceTiles.dequeueReusableCellWithReuseIdentifier("SelectPalaceCollectionViewCell", forIndexPath: indexPath) as SelectPalaceCollectionViewCell
        cell.addShadows()
        // First cell is reserved for the add button
        if indexPath.item == 0 {
            cell.backgroundColor = UIColor.clearColor()
            cell.imageView.image = UIImage(named: "addPalaceImage")
            cell.nameLabel.hidden = true
            cell.opacityBackground.hidden = true
            
        } else {
            let currentIcon : MemoryPalaceIcon = model.getMemoryPalaceIcons()[indexPath.item-1]
            cell.imageView.image = getImageNamed(currentIcon.imageFile)
            cell.nameLabel.text = currentIcon.graphName
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if indexPath.item == 0 {
            self.performSegueWithIdentifier("CreateNewPalaceSegue", sender: self)
        } else{
            self.performSegueWithIdentifier("GoToPalaceSegue", sender: self)
        }
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.BlackOpaque
    }
    
    func DataModelHasBeenChanged() {
        self.palaceTiles.reloadData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "CreateNewPalaceSegue"){
            let dvc = segue.destinationViewController as BlurCreatePalaceViewController
            dvc.parent = self
            dvc.model = self.model
        }
    }
    
    func getImageNamed(fileName : String) -> UIImage{
        let nsDocumentDirectory = NSSearchPathDirectory.DocumentDirectory
        let nsUserDomainMask = NSSearchPathDomainMask.UserDomainMask
        if let paths = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
        {
            if paths.count > 0
            {
                if let dirPath = paths[0] as? String
                {
                    let readPath = dirPath.stringByAppendingPathComponent(fileName)
                    let image    = UIImage(contentsOfFile: readPath)
                    // Do whatever you want with the image
                    return image!
                }
            }
        }
        return UIImage()
    }
    
}

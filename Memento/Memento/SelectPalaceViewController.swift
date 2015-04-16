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
    var model = MementoManager.sharedInstance
    var palaces : [MemoryPalaceIcon]!
    var nextPalace = ""
    var selectedPalace = ""
    var imagesCache : [String:UIImage]!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        palaceTiles.backgroundColor = UIColor.clearColor()
        self.setNeedsStatusBarAppearanceUpdate()
        
        self.setUpGestures()
        imagesCache = [String:UIImage]()
        self.palaces = model.getMemoryPalaceIcons()
        
    }
    
    func setUpGestures(){
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: "longPressHandler:")
        longPressGesture.minimumPressDuration = 0.5
        self.view.addGestureRecognizer(longPressGesture)
    }
    
    func longPressHandler(gesture: UIGestureRecognizer){
        var pointOfTheTouch = gesture.locationInView(self.palaceTiles)
        var indexPath = palaceTiles.indexPathForItemAtPoint(pointOfTheTouch)
        
        if(indexPath != nil && indexPath!.item != 0){
            let selectedCell = palaceTiles.cellForItemAtIndexPath(indexPath!) as SelectPalaceCollectionViewCell?
            if(selectedCell != nil){
                selectedPalace = selectedCell!.nameLabel.text!
                palaceTiles.reloadData()
            }
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        palaceTiles.reloadData()
    }
    
    
    // COLLECTION VIEW
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return palaces.count + 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell = palaceTiles.dequeueReusableCellWithReuseIdentifier("SelectPalaceCollectionViewCell", forIndexPath: indexPath) as SelectPalaceCollectionViewCell
        cell.parent = self
        //cell.addShadows()
        // First cell is reserved for the add button
        if indexPath.item == 0 {
            cell.backgroundColor = UIColor.clearColor()
            cell.imageView.image = UIImage(named: "addPalaceImage")
            cell.nameLabel.hidden = true
            cell.opacityBackground.hidden = true
            cell.deleteButton.hidden = true
            
        } else {
            let currentIcon : MemoryPalaceIcon = palaces[indexPath.item-1]
            if(imagesCache[currentIcon.imageFile] == nil || imagesCache[currentIcon.imageFile] == UIImage()){
                imagesCache[currentIcon.imageFile] = Utilities.getImageNamed(currentIcon.imageFile)
            }
            cell.imageView.image = imagesCache[currentIcon.imageFile]
            cell.nameLabel.text = currentIcon.graphName
            cell.nameLabel.hidden = false
            cell.opacityBackground.hidden = false
            if(cell.nameLabel.text == selectedPalace){
                cell.deleteButton.hidden = false
            } else{
                cell.deleteButton.hidden = true
            }
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if indexPath.item == 0 {
            self.performSegueWithIdentifier("CreateNewPalaceSegue", sender: self)
        } else{
            let cellClicked = collectionView.cellForItemAtIndexPath(indexPath) as SelectPalaceCollectionViewCell
            self.nextPalace = cellClicked.nameLabel.text!
            self.performSegueWithIdentifier("GoToPalaceSegue", sender: self)
        }
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.BlackOpaque
    }
    
    func dataModelHasBeenChanged() {
        self.palaces = model.getMemoryPalaceIcons()
        self.palaceTiles.reloadData()
    }
    
    func deletePalace(named : String){
        model.removeMemoryPalace(named)
        self.dataModelHasBeenChanged()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "CreateNewPalaceSegue"){
            self.selectedPalace = ""
            let dvc = segue.destinationViewController as BlurCreatePalaceViewController
            dvc.parent = self
        } else if(segue.identifier == "GoToPalaceSegue"){
            self.selectedPalace = ""
            let dvc = segue.destinationViewController as OverviewViewController
            dvc.palaceName = self.nextPalace
            dvc.parentVC = self
        }
    }
    
    @IBAction func backButtonPress(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}

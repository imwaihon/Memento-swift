//
//  OverviewViewController.swift
//  tester
//
//  Created by Abdulla Contractor on 26/3/15.
//  Copyright (c) 2015 Abdulla Contractor. All rights reserved.
//

import Foundation
import UIKit

class OverviewViewController : UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
    
    @IBOutlet weak var scrollableOverviewCollectionView: UICollectionView!
    var palaceName: String!
    var model = MementoManager.sharedInstance
    var rooms: [MemoryPalaceRoomIcon]!
    var parentVC: SelectPalaceViewController!
    
    var selectedCellLabel: Int!
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollableOverviewCollectionView.delegate = self
        scrollableOverviewCollectionView.dataSource = self
        scrollableOverviewCollectionView.backgroundColor = UIColor.clearColor()
        self.setNeedsStatusBarAppearanceUpdate()
        rooms = model.getPalaceOverview(palaceName)!
        
        setUpGestures()
        
    }
    override func viewWillAppear(animated: Bool) {
        // Referesh before everytime collection view is shown
        super.viewWillAppear(animated)
        rooms = model.getPalaceOverview(palaceName)!
        scrollableOverviewCollectionView.reloadData()
        
    }
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    func setUpGestures(){
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: "longPressHandler:")
        longPressGesture.minimumPressDuration = 1.0
        self.view.addGestureRecognizer(longPressGesture)
    }
    
    func longPressHandler(gesture: UIGestureRecognizer){
        var pointOfTheTouch = gesture.locationInView(self.scrollableOverviewCollectionView)
        var indexPath = scrollableOverviewCollectionView.indexPathForItemAtPoint(pointOfTheTouch)
        
        if(indexPath != nil && indexPath!.item != 0){
            let selectedCell = scrollableOverviewCollectionView.cellForItemAtIndexPath(indexPath!) as OverviewImageCollectionViewCell?
            if(selectedCell != nil){
                selectedCell?.graphName = self.palaceName
                // PROBLEM IS HERE!
                //selectedCell?.roomLabel = indexPath!.item - 1
                selectedCell?.roomLabel = rooms[indexPath!.item - 1].label
                println(indexPath!.item - 1)
                selectedCell?.deleteButtonView.alpha = 1.0
                selectedCell?.parent = self
            }
        }
    }
    
    func deleteRoom(graphName: String, roomLabel: Int) {
        model.removeMemoryPalaceRoom(graphName, roomLabel: roomLabel)
        self.dataModelHasBeenChanged()
    }
    
    func dataModelHasBeenChanged() {
        self.rooms = model.getPalaceOverview(palaceName)
        self.scrollableOverviewCollectionView.reloadData()
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return rooms.count + 1;
    }
    
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if(indexPath.row == 0){
            var cell = collectionView.dequeueReusableCellWithReuseIdentifier("SpaceCell", forIndexPath: indexPath) as UICollectionViewCell
            return cell
        } else{
            var cell = collectionView.dequeueReusableCellWithReuseIdentifier("OverviewImageCell", forIndexPath: indexPath) as OverviewImageCollectionViewCell
            let currentIcon = rooms[indexPath.row - 1]
            cell.roomLabel = currentIcon.label
            cell.image.image = Utilities.getImageNamed(currentIcon.filename)
            //cell.image.image = UIImage(named: "landscape\(indexPath.row)")
            return cell
        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if let selectedCell = collectionView.cellForItemAtIndexPath(indexPath) as? OverviewImageCollectionViewCell {
            self.selectedCellLabel = selectedCell.roomLabel
            self.performSegueWithIdentifier("goToNode", sender: self)
        }

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "goToNode"){
            let dvc = segue.destinationViewController as NodeViewController
            //dvc.roomLabel = selectedCellLabel
            dvc.roomLabel = selectedCellLabel
            dvc.graphName = palaceName
        }
    }
    
    func collectionView(collectionView : UICollectionView,layout collectionViewLayout:UICollectionViewLayout,sizeForItemAtIndexPath indexPath:NSIndexPath) -> CGSize
    {
        if(indexPath.row == 0){
            return CGSizeMake(251, 404)
        } else{
            return CGSizeMake(522, 404)
        }
    }
    
    @IBAction func backButtonPress(sender: AnyObject) {
        parentVC.dataModelHasBeenChanged()
        model.savePalace(palaceName)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.BlackOpaque
    }
    
    
}
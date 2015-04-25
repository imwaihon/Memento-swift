//
//  OverviewViewController.swift
//  tester
//
//  Created by Abdulla Contractor on 26/3/15.
//  Copyright (c) 2015 Abdulla Contractor. All rights reserved.
//

import Foundation
import UIKit

/// This view is an infinite horizontal scroll representation of the rooms contained within a memory palace.
class OverviewViewController : UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
    
    // Storyboard connected variables
    @IBOutlet weak var scrollableOverviewCollectionView: UICollectionView!
    // Instance variables
    var palaceName: String!
    var model = MementoManager.sharedInstance
    var rooms: [MemoryPalaceRoomIcon]!
    var parentVC: SelectPalaceViewController!
    var selectedCellLabel: Int!
    var cellToDelete: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Sets up the collection view that will contain the room representations.
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
    
    /// Sets up the gesture recognisers for the delete function.
    func setUpGestures(){
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: "longPressHandler:")
        longPressGesture.minimumPressDuration = 1.0
        self.view.addGestureRecognizer(longPressGesture)
    }
    
    /// The function called when a long press is detected. Long press triggers the delete palace functionality
    func longPressHandler(gesture: UIGestureRecognizer){
        var pointOfTheTouch = gesture.locationInView(self.scrollableOverviewCollectionView)
        var indexPath = scrollableOverviewCollectionView.indexPathForItemAtPoint(pointOfTheTouch)
        
        if(indexPath != nil && indexPath!.item != 0){
            cellToDelete = indexPath!.item
            scrollableOverviewCollectionView.reloadData()
        }
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.BlackOpaque
    }
    
    /// Calls the data model to remove a particular room from the memory palace and updates the current view to reflect the changes
    ///
    /// :param: graphName The name of the memory palace that contains the room to be deleted
    /// :param: roomLabel The room to be deleted in a specific memory palace
    func deleteRoom(graphName: String, roomLabel: Int) {
        model.removeMemoryPalaceRoom(graphName, roomLabel: roomLabel)
        self.rooms = model.getPalaceOverview(palaceName)
        cellToDelete = nil
        self.scrollableOverviewCollectionView.reloadData()
    }
    
    
    // COLLECTION VIEW FUNCTIONS
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
            if(cellToDelete == indexPath.item){
                cell.showDeleteButton()
            } else{
                cell.hideDeleteButton()
            }
            let currentIcon = rooms[indexPath.row - 1]
            cell.roomLabel = currentIcon.label
            cell.image.image = Utilities.getImageNamed(currentIcon.filename)
            cell.parent = self
            cell.graphName = self.palaceName
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
    
    func collectionView(collectionView : UICollectionView,layout collectionViewLayout:UICollectionViewLayout,sizeForItemAtIndexPath indexPath:NSIndexPath) -> CGSize
    {
        if(indexPath.row == 0){
            return CGSizeMake(251, 404)
        } else{
            return CGSizeMake(522, 404)
        }
    }
    
    // NAVIGATION FUNCTIONS
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "goToNode"){
            cellToDelete = nil
            let dvc = segue.destinationViewController as NodeViewController
            //dvc.roomLabel = selectedCellLabel
            dvc.roomLabel = selectedCellLabel
            dvc.graphName = palaceName
        }
    }
    
    @IBAction func backButtonPress(sender: AnyObject) {
        parentVC.dataModelHasBeenChanged()
        model.savePalace(palaceName)
        parentVC = nil
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
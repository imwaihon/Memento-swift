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
    var model: MementoManager!
    var rooms: [MemoryPalaceRoomIcon]!
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollableOverviewCollectionView.delegate = self
        scrollableOverviewCollectionView.dataSource = self
        scrollableOverviewCollectionView.backgroundColor = UIColor.clearColor()
        self.setNeedsStatusBarAppearanceUpdate()
        rooms = model.getPalaceOverview(palaceName)!
        
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
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
            cell.image.image = self.getImageNamed(currentIcon.filename)
            //cell.image.image = UIImage(named: "landscape\(indexPath.row)")
            return cell
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
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.BlackOpaque
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
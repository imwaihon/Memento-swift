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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollableOverviewCollectionView.delegate = self
        scrollableOverviewCollectionView.dataSource = self
        scrollableOverviewCollectionView.backgroundColor = UIColor.clearColor()
        
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6;
    }
    
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if(indexPath.row == 0){
            var cell = collectionView.dequeueReusableCellWithReuseIdentifier("SpaceCell", forIndexPath: indexPath) as UICollectionViewCell
            return cell
        } else{
            var cell = collectionView.dequeueReusableCellWithReuseIdentifier("OverviewImageCell", forIndexPath: indexPath) as OverviewImageCollectionViewCell
            cell.image.image = UIImage(named: "landscape\(indexPath.row)")
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
    
}
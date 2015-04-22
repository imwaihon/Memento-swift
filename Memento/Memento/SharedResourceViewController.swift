//
//  SharedResourceViewController.swift
//  Memento
//
//  Created by Chee Wai Hon on 22/4/15.
//  Copyright (c) 2015 NUS CS3217. All rights reserved.
//

import Foundation
import UIKit


// Stashed

//class SharedResourceViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
//    
//    var mementoManager = MementoManager.sharedInstance
//    
//    required init(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        
//    }
//
//    
////    // COLLECTION VIEW
////    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
////        return palaces.count
////    }
////    
////    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
////        var cell = palaceTiles.dequeueReusableCellWithReuseIdentifier("SelectPalaceCollectionViewCell", forIndexPath: indexPath) as SelectPalaceCollectionViewCell
////        cell.parent = self
////        
////        let currentIcon : MemoryPalaceIcon = palaces[indexPath.item]
////        if(imagesCache[currentIcon.imageFile] == nil || imagesCache[currentIcon.imageFile] == UIImage()) {
////            imagesCache[currentIcon.imageFile] = Utilities.getImageNamed(currentIcon.imageFile)
////        }
////        cell.imageView.image = imagesCache[currentIcon.imageFile]
////        cell.nameLabel.text = currentIcon.graphName
////        cell.nameLabel.hidden = false
////        cell.opacityBackground.hidden = false
////        
////        return cell
////    }
////    
////    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
////        let cellClicked = collectionView.cellForItemAtIndexPath(indexPath) as SelectPalaceCollectionViewCell
////        self.nextPalace = cellClicked.nameLabel.text!
////        self.performSegueWithIdentifier("ShowBeforeStartSegue", sender: self)
////    }
////    
//    
//}

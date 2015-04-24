//
//  SharedResourceViewController.swift
//  Memento
//
//  Created by Chee Wai Hon on 22/4/15.
//  Copyright (c) 2015 NUS CS3217. All rights reserved.
//

import Foundation
import UIKit


class SharedResourceViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    var mementoManager = MementoManager.sharedInstance
    var resourceList = [String]()
    weak var delegate: AddLayerDelegate?
    
    @IBOutlet weak var resourceView: UICollectionView!

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resourceList = mementoManager.getImageResource()
        
    }

    
    // COLLECTION VIEW
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return resourceList.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell = resourceView.dequeueReusableCellWithReuseIdentifier("SharedResourceCollectionViewCell", forIndexPath: indexPath) as SharedResourceCollectionViewCell
        cell.imageView.image = Utilities.convertToThumbnail(Utilities.getImageNamed(resourceList[indexPath.item]))
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cellClicked = collectionView.cellForItemAtIndexPath(indexPath) as SharedResourceCollectionViewCell
        delegate?.addLayer(Utilities.getImageNamed(resourceList[indexPath.item]), imageName: resourceList[indexPath.item])
    }
    
    
}

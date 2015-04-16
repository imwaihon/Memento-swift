//
//  OverviewImageCollectionViewCell.swift
//  tester
//
//  Created by Abdulla Contractor on 26/3/15.
//  Copyright (c) 2015 Abdulla Contractor. All rights reserved.
//

import Foundation
import UIKit

class OverviewImageCollectionViewCell : UICollectionViewCell {
    
    @IBOutlet weak var image: UIImageView!
    var mementoManager = MementoManager.sharedInstance
    var graphName: String!
    var roomLabel: Int!
    var parent: OverviewViewController!
    
    @IBOutlet weak var deleteButtonView: UIButton!
    
    @IBAction func deleteButtonPressed(sender: AnyObject) {
        deleteButtonView.alpha = 0.0
        parent.deleteRoom(graphName, roomLabel: roomLabel)
    }

    
}
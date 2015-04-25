//
//  OverviewImageCollectionViewCell.swift
//  tester
//
//  Created by Abdulla Contractor on 26/3/15.
//  Copyright (c) 2015 Abdulla Contractor. All rights reserved.
//

import Foundation
import UIKit

/// Collection view cell that represents a room in a particular memory palace.
class OverviewImageCollectionViewCell : UICollectionViewCell {
    
    // Storyboard connected variables
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var deleteButtonView: UIButton!
    
    // Instance variables
    var mementoManager = MementoManager.sharedInstance
    var graphName: String!
    var roomLabel: Int!
    var parent: OverviewViewController!
    
    @IBAction func deleteButtonPressed(sender: AnyObject) {
        self.hideDeleteButton()
        parent.deleteRoom(graphName, roomLabel: roomLabel)
    }
    
    func showDeleteButton(){
        deleteButtonView.alpha = 1.0
    }
    func hideDeleteButton(){
        deleteButtonView.alpha = 0.0
    }

    
}
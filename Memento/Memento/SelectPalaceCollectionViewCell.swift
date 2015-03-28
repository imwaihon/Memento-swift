//
//  SelectPalaceCollectionViewCell.swift
//  Memento
//
//  Created by Chee Wai Hon on 23/3/15.
//  Copyright (c) 2015 NUS CS3217. All rights reserved.
//

import UIKit

class SelectPalaceCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var imageView: UIImageView!
    
    func addShadows(){
        imageView.layer.shadowColor = UIColor.blackColor().CGColor
        imageView.layer.shadowOffset = CGSizeMake(2, 2);
        imageView.layer.shadowOpacity = 0.4;
        imageView.layer.shadowRadius = 1.0;
        imageView.clipsToBounds = false;
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        
        
    }
    
}

//
//  MoveImageDelegate.swift
//  tester
//
//  Created by Abdulla Contractor on 23/3/15.
//  Copyright (c) 2015 Abdulla Contractor. All rights reserved.
//

import Foundation
import UIKit

protocol MoveImageDelegate{
    func updateImagePosition(name : String, toPosition : CGPoint)
}
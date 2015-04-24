//
//  AddLayerDelegate.swift
//  Memento
//
//  Created by Chee Wai Hon on 24/4/15.
//  Copyright (c) 2015 NUS CS3217. All rights reserved.
//

import Foundation

protocol AddLayerDelegate: class {
    func addLayer(image: UIImage, imageName: String?)
}
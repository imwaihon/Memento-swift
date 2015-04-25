//
//  ModelChangeUpdateDelegate.swift
//  Memento
//
//  Created by Abdulla Contractor on 30/3/15.
//  Copyright (c) 2015 NUS CS3217. All rights reserved.
//

import Foundation

protocol ModelChangeUpdateDelegate : class{
    /** 
        This function can be used to indicate that the data model has been changed.
        The implementation of this function should include code that responds appropriately 
        to the changes in the model.
    */
    func dataModelHasBeenChanged()
}
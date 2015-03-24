//
//  AppManager.swift
//  Memento
//
//  The facade class that receives ALL requests from the controller.
//  This class hides all the complexity of native backend operations.
//
//  Created by Qua Zi Xian on 24/3/15.
//  Copyright (c) 2015 NUS CS3217. All rights reserved.
//

import Foundation

class MementoManager{
    private var selectedPalace: MementoGraph?
    
    init(){
        selectedPalace = nil
    }
    
    //Adds a new memory palace
    func addMemoryPalace(imageFile: String){
        
    }
    
    //Removes the specified memory palace
    //Does nothign if no memory palace is represented by the given palaceNumber
    func removeMemoryPalace(palaceNumber: Int){
        
    }
    
    //Gets the number of memory palaces in existence
    //Returns an integer of at least 0
    func getNumberofMemoryPalace() -> Int{
        return 0
    }
}
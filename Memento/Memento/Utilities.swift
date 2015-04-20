//
//  Utilities.swift
//  Memento
//
//  The class that provides miscellaneous functions used by the app.
//
//  Created by Abdulla Contractor on 12/4/15.
//  Copyright (c) 2015 NUS CS3217. All rights reserved.
//

import Foundation
import UIKit

class Utilities {
    
    //Scales the image such that it fits the full screen size.
    //Returns: A scaled-up version of the given image that fills the scrren size.
    class func convertToScreenSize(image : UIImage) -> UIImage {
        UIGraphicsBeginImageContext(Constants.fullScreenImageFrame.size);
        image.drawInRect(Constants.fullScreenImageFrame)
        let newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return newImage
    }
    
    //Converts the given image to thumbnail size.
    //Returns: The thumbnail-size version of the given UIImage.
    class func convertToThumbnail(image : UIImage) -> UIImage {
        let destinationSize = CGSize(width: image.size.width/3, height: image.size.height/3)
        UIGraphicsBeginImageContext(destinationSize);
        image.drawInRect(CGRectMake(0,0,destinationSize.width,destinationSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return newImage
    }
    
    //Gets the image with the given name from the sharedResource folder.
    //Returns: A UIImage instants with contents of the specified image resource file or an empty UIImage instance if
    //the resource file is not found.
    class func getImageNamed(name : String) -> UIImage! {
        if let image = UIImage(contentsOfFile: Constants.docDir.stringByAppendingPathComponent(Constants.imgResourceDir).stringByAppendingPathComponent(name)) {
            return image
        }
        return UIImage()
    }
    
    //Randomly shuffles the order of the elements in the given array.
    //Returns: An array with its elements shuffled.
    class func shuffleArray<T>(var array: [T]) -> [T] {
        for index in reverse(0..<array.count) {
            let randomIndex = Int(arc4random_uniform(UInt32(index)))
            (array[index], array[randomIndex]) = (array[randomIndex], array[index])
        }
        return array
    }

}
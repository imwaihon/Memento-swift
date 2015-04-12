//
//  Utilities.swift
//  Memento
//
//  Created by Abdulla Contractor on 12/4/15.
//  Copyright (c) 2015 NUS CS3217. All rights reserved.
//

import Foundation
import UIKit

class Utilities{
    class func convertToThumbnail(image : UIImage) -> UIImage{
        let destinationSize = CGSize(width: image.size.width/3, height: image.size.height/3)
        UIGraphicsBeginImageContext(destinationSize);
        image.drawInRect(CGRectMake(0,0,destinationSize.width,destinationSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return newImage
    }
    
    class func getImageNamed(name : String) -> UIImage!{
        let fileName = imgResourceDir.stringByAppendingPathComponent(name)
        let nsDocumentDirectory = NSSearchPathDirectory.DocumentDirectory
        let nsUserDomainMask = NSSearchPathDomainMask.UserDomainMask
        if let paths = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
        {
            if paths.count > 0
            {
                if let dirPath = paths[0] as? String
                {
                    let readPath = dirPath.stringByAppendingPathComponent(fileName)
                    let image    = UIImage(contentsOfFile: readPath)
                    // Do whatever you want with the image
                    if(image == nil){
                        return UIImage()
                    } else{
                        return image!
                    }
                }
            }
        }
        return UIImage()
    }

}
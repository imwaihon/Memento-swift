//
//  LineDrawer.swift
//  tester
//
//  Created by Abdulla Contractor on 18/3/15.
//  Copyright (c) 2015 Abdulla Contractor. All rights reserved.
//

import Foundation
import UIKit

class LineDrawer: UIView {
    
    var lines : [[CGPoint]]
    
    init(frame: CGRect, lines : [[CGPoint]]) {
        self.lines = lines
        super.init(frame: frame)
    }

    required init(coder aDecoder: NSCoder) {
        self.lines = [[]]
        super.init(coder: aDecoder)
    }
    
    func setLines(lines : [[CGPoint]]){
        self.lines = lines
    }
    
    override func drawRect(rect: CGRect) {
        var context:CGContextRef = UIGraphicsGetCurrentContext();
        
        /*// move to your first point
        CGContextMoveToPoint(context, 100.0, 100.0);
        
        // add a line to your second point
        CGContextAddLineToPoint(context, 200.0, 600.0);
        // set the stroke color and width
        CGContextSetRGBStrokeColor(context, 0.0, 0.0, 0.0, 1.0);
        
        
        CGContextSetLineWidth(context, 2.0);
        // tell the context to draw the stroked line
        CGContextStrokePath(context);*/
        
        for pair in lines{
            // move to your first point
            CGContextMoveToPoint(context, pair[0].x, pair[0].y);
            
            // add a line to your second point
            CGContextAddLineToPoint(context, pair[1].x, pair[1].y);
            // set the stroke color and width
            CGContextSetRGBStrokeColor(context, 0.0, 0.0, 0.0, 1.0);
            
            
            CGContextSetLineWidth(context, 2.0);
            // tell the context to draw the stroked line
            CGContextStrokePath(context);
        }
    }
}
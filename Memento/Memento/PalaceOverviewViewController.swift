//
//  PalaceOverviewViewController.swift
//  tester
//
//  Created by Abdulla Contractor on 18/3/15.
//  Copyright (c) 2015 Abdulla Contractor. All rights reserved.
//

import UIKit
import CoreGraphics

class PalaceOverviewViewController: UIViewController, UIScrollViewDelegate, MoveImageDelegate {
    
    /*private var imagesWithLocation : [String : CGPoint] = [ "landscape1" : CGPoint(x: 50, y: 288),
        "landscape2" : CGPoint(x: 350, y: 484),
        "landscape3" : CGPoint(x: 350, y: 92),
        "landscape4" : CGPoint(x: 650, y: 288),
        "landscape5" : CGPoint(x: 950, y: 288)]*/
    
    private var imagesWithLocation : [String : CGPoint] = [ "landscape1" : CGPoint(x: 150, y: 384),
        "landscape2" : CGPoint(x: 450, y: 534),
        "landscape3" : CGPoint(x: 450, y: 234),
        "landscape4" : CGPoint(x: 750, y: 384),
        "landscape5" : CGPoint(x: 1050, y: 384)]
    
    private var linesFromAndTo : [[CGPoint]] = [
    [CGPoint(x: 150, y: 384), CGPoint(x: 450, y: 534)],
    [CGPoint(x: 450, y: 534), CGPoint(x: 750, y: 384)]]
    
    private var lines : [[String]] = [
        ["landscape1", "landscape2"],
        ["landscape1", "landscape3"],
        ["landscape2", "landscape3"]]

    @IBOutlet weak var scrollView: UIScrollView!
    
    private var drawingView: LineDrawer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        scrollView.delegate = self
        
        self.populateImages()
        
        // 2
        scrollView.contentSize = CGSize(width: 1256, height: self.view.frame.height)
        scrollView.canCancelContentTouches = false
        
        //var drawingView = UIView(frame: scrollView.frame)
        /*var newLines : [[CGPoint]]! = []
        for pair in lines{
            let pairOfPoints : [CGPoint] = [imagesWithLocation[pair[0]]!, imagesWithLocation[pair[1]]!]
            newLines.append(pairOfPoints)
        }*/
        drawingView = LineDrawer(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: scrollView.contentSize), lines: getLines())
        drawingView.backgroundColor = UIColor.clearColor()
        scrollView.addSubview(drawingView)
        scrollView.sendSubviewToBack(drawingView)
        
        // 4
        let scrollViewFrame = scrollView.frame
        let scaleWidth = scrollViewFrame.size.width / scrollView.contentSize.width
        let scaleHeight = scrollViewFrame.size.height / scrollView.contentSize.height
        let minScale = min(scaleWidth, scaleHeight);
        scrollView.minimumZoomScale = minScale;
        
        // 5
        scrollView.maximumZoomScale = 1.0
        scrollView.zoomScale = minScale;
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        // get the current context
        
    }
    
    func populateImages(){
        var images = imagesWithLocation.keys.array
        for imageName in images{
            let image = UIImage(named: imageName)!
            var imageView = DraggableImageView(image: image, name: imageName, parent: self)
            imageView.frame = CGRect(origin: imagesWithLocation[imageName]!, size:CGSize(width: 256.0, height: 192.0))
            imageView.center = imagesWithLocation[imageName]!
            scrollView.addSubview(imageView)
        }
    }
    
    func getLines() -> [[CGPoint]]{
        var newLines : [[CGPoint]]! = []
        for pair in lines{
            let pairOfPoints : [CGPoint] = [imagesWithLocation[pair[0]]!, imagesWithLocation[pair[1]]!]
            newLines.append(pairOfPoints)
        }
        return newLines
    }
    
    func updateImagePosition(name : String, toPosition : CGPoint){
        imagesWithLocation[name] = toPosition
        for view in scrollView.subviews{
            if(view is LineDrawer){
                if(toPosition.x > scrollView.contentSize.width){
                    let lineDrawView = view as LineDrawer
                    scrollView.contentSize = CGSize(width: toPosition.x + 200, height: self.view.frame.height)
                    lineDrawView.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: scrollView.contentSize)
                }
               let drawer = view as LineDrawer
                drawer.setLines(self.getLines())
                drawer.setNeedsDisplay()
            }
        }
    }
}


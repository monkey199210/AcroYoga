//
//  FriendViewController.swift
//  TurnUP
//
//  Created by SCAR on 3/24/16.
//  Copyright © 2016 ku. All rights reserved.
//

import UIKit
class FriendViewController: UIViewController, ZLSwipeableViewDelegate, ZLSwipeableViewDataSource{
    
    var colorIndex:NSInteger = 0
    var colors:NSArray = []
    @IBOutlet weak var swipeableView: ZLSwipeableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.clipsToBounds = true
        self.view.backgroundColor = UIColor.whiteColor()
        
        self.colorIndex = 0;
        self.colors = [
                    UIImage(named:"p3.jpeg")!,
                    UIImage(named:"p4.jpeg")!,
                    UIImage(named:"p5.jpeg")!,
                    UIImage(named:"p6.jpeg")!
        ];
        
        let swipeableView = ZLSwipeableView.init(frame: self.swipeableView.frame)
        swipeableView.numberOfActiveViews = 3
        self.swipeableView = swipeableView
        self.view .addSubview(self.swipeableView)
        
        self.swipeableView.dataSource = self
        self.swipeableView.delegate = self
        self.swipeableView.translatesAutoresizingMaskIntoConstraints = false
        self.swipeableView.loadViewsIfNeeded()
        
    }
    
    override func viewDidLayoutSubviews() {
        
    }
    
    
   func swipeableView(swipeableView: ZLSwipeableView!, didCancelSwipe view: UIView!) {
        
    }
    
    func swipeableView(swipeableView: ZLSwipeableView!, didEndSwipingView view: UIView!, atLocation location: CGPoint) {
        
    }
    
    func swipeableView(swipeableView: ZLSwipeableView!, didStartSwipingView view: UIView!, atLocation location: CGPoint) {
        
    }
    
    func swipeableView(swipeableView: ZLSwipeableView!, didSwipeView view: UIView!, inDirection direction: ZLSwipeableViewDirection) {
        
    }
    
    func swipeableView(swipeableView: ZLSwipeableView!, swipingView view: UIView!, atLocation location: CGPoint, translation: CGPoint) {
        
    }
    
    func nextViewForSwipeableView(swipeableView:ZLSwipeableView)->UIView
    {
        if(self.colorIndex >= self.colors.count)
        {
        self.colorIndex = 0
        }
        
        let view:UIView = UIView.init(frame: swipeableView.bounds)
        let image:UIImageView = UIImageView.init(image:self.colors.objectAtIndex(self.colorIndex) as? UIImage)
        image.frame = view.bounds
        image.layer.shadowColor = UIColor.blackColor().CGColor
        image.layer.shadowOpacity = 0.33
        image.layer.shadowOffset = CGSizeMake(0, 1.5)
        image.layer.shadowRadius = 8.0
        image.layer.shouldRasterize = true
        view.addSubview(image)
        
        
        self.colorIndex += 1
        
        return view
    }

//    func colorForName(name:NSString)->UIColor
//    {
////        let sanitizedName = name.stringByReplacingOccurrencesOfString(" ", withString: "")
////        let selectorString = "flat" + sanitizedName + "Color"
//////        let colorClass =
////        return colorClass.performSelector(NSSelectorFromString(selectorString))
//    }
    

}

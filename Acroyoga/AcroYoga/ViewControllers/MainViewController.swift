//
//  MainViewController.swift
//  TurnUP
//
//  Created by SCAR on 3/21/16.
//  Copyright © 2016 ku. All rights reserved.
//

import UIKit
import Koloda
private var numberOfCards: UInt = 3
class MainViewController: UIViewController{


    
    @IBOutlet weak var flipView: KolodaView!
    @IBOutlet weak var centerAvatar: UIImageView!
    //pulse
    let pulsator = Pulsator()
    var user: AYUser?
    
    //    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var photoView: UIView!
    @IBOutlet weak var pageControl: UIPageControl!
    

    
    var totalPages = 0
 
    private var dataSource: Array<UIImage> = {
        var array: Array<UIImage> = []
        for index in 0..<numberOfCards {
            array.append(UIImage(named: "splash\(index + 1)")!)
        }
        
        return array
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
       
        initView()
         user = UserProfile.currentUser()
         self.updateMainImage()
        FBEvent.onMainPictChanged().listen(self) { [unowned self] (_) -> Void in
            self.updateMainImage()
        }
        
        flipView.dataSource = self
        flipView.delegate = self
        
        self.modalTransitionStyle = UIModalTransitionStyle.FlipHorizontal

    }
    //MARK: IBActions
    @IBAction func leftButtonTapped() {
        flipView?.swipe(SwipeResultDirection.Left)
    }
    
    @IBAction func rightButtonTapped() {
        flipView?.swipe(SwipeResultDirection.Right)
    }
    
    @IBAction func undoButtonTapped() {
        flipView?.revertAction()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        centerAvatar.layer.layoutIfNeeded()
        pulsator.position = centerAvatar.layer.position
    }
    override func viewWillAppear(animated: Bool) {
//        pulsator.start()
    }
    func initView()
    {
        centerAvatar.layer.borderWidth = 2.0
        centerAvatar.layer.masksToBounds = false
        centerAvatar.layer.borderColor = UIColor.whiteColor().CGColor
        centerAvatar.layer.cornerRadius = centerAvatar.frame.size.width/2.0
        centerAvatar.clipsToBounds = true
    }
    @IBAction func likeAction(sender: UIButton) {
        // 11: dislikeAction 12: likeAction
        if sender.tag == 11
        {
             flipView?.swipe(SwipeResultDirection.Left)
        } else if sender.tag == 12
        {
             flipView?.swipe(SwipeResultDirection.Right)
        }
        sender.transform = CGAffineTransformMakeScale(0.6, 0.6)
        UIView.animateWithDuration(1.0,
                                   delay: 0,
                                   usingSpringWithDamping: 0.3,
                                   initialSpringVelocity: 6.0,
                                   options: UIViewAnimationOptions.AllowUserInteraction,
                                   animations: {
                                    sender.transform = CGAffineTransformIdentity
            }, completion: nil)

        
    }
    @IBAction func pulseAction(sender: UIButton) {

        centerAvatar.transform = CGAffineTransformMakeScale(0.8, 0.8)
        UIView.animateWithDuration(1.0,
                                   delay: 0,
                                   usingSpringWithDamping: 0.3,
                                   initialSpringVelocity: 6.0,
                                   options: UIViewAnimationOptions.AllowUserInteraction,
                                   animations: {
                                    self.centerAvatar.transform = CGAffineTransformIdentity
            }, completion: nil)
//        pulsator.start()
    }
    private func updateMainImage() {
        UserProfile.getMainPict({ (image) -> Void in
            UserProfile.getCircledMainImage({ (image) -> Void in
                self.centerAvatar.image = image
                UIView.animateWithDuration(1.0,
                    delay: 0,
                    usingSpringWithDamping: 0.3,
                    initialSpringVelocity: 6.0,
                    options: UIViewAnimationOptions.AllowUserInteraction,
                    animations: {
                        self.centerAvatar.transform = CGAffineTransformIdentity
                    }, completion: nil)
            })
        })
    }
    func startPulse()
    {
    //palse
    centerAvatar.layer.superlayer?.insertSublayer(pulsator, below: centerAvatar.layer)
    pulsator.numPulse = 5
    pulsator.radius = (UIScreen.mainScreen().bounds.width) / 2 + 30
    pulsator.animationDuration = 5
    pulsator.backgroundColor = centerAvatar.backgroundColor?.CGColor
    pulsator.start()
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        startPulse()
//        FB.getFacebookFriends()

    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
}
//MARK: KolodaViewDelegate
extension MainViewController: KolodaViewDelegate {
    
    func kolodaDidRunOutOfCards(koloda: KolodaView) {
//        dataSource.insert(UIImage(named: "Card_like_6")!, atIndex: flipView.currentCardIndex - 1)
//        let position = flipView.currentCardIndex
        flipView.hidden = true
    }
    
    func koloda(koloda: KolodaView, didSelectCardAtIndex index: UInt) {
//        UIApplication.sharedApplication().openURL(NSURL(string: "http://yalantis.com/")!)
    }
}

//MARK: KolodaViewDataSource
extension MainViewController: KolodaViewDataSource {
    
    func kolodaNumberOfCards(koloda:KolodaView) -> UInt {
        return UInt(dataSource.count)
    }
    
    func koloda(koloda: KolodaView, viewForCardAtIndex index: UInt) -> UIView {
        return UIImageView(image: dataSource[Int(index)])
    }
    
    func koloda(koloda: KolodaView, viewForCardOverlayAtIndex index: UInt) -> OverlayView? {
        return NSBundle.mainBundle().loadNibNamed("OverView",
                                                  owner: self, options: nil)[0] as? OverlayView
    }
}

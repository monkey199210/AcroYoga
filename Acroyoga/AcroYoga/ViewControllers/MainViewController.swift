//
//  MainViewController.swift
//  AcroYoga
//
//  Created by SCAR on 3/21/16.
//  Copyright © 2016 ku. All rights reserved.
//

import UIKit
import Koloda
import CoreLocation
import CoreData
private var numberOfCards: UInt = 3
class MainViewController: UIViewController, CLLocationManagerDelegate, UITextFieldDelegate{
    
    
    
    @IBOutlet weak var zipCodeTextField: UITextField!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var dislikeButton: UIButton!
    @IBOutlet weak var refreshButton: UIButton!
    
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var flipView: KolodaView!
    @IBOutlet weak var centerAvatar: UIImageView!
    //Change “names” to “people” and [String] to [NSManagedObject]
    
    //pulse
    let pulsator = Pulsator()
    var user: AYUser?
    
    //location
    var locationManager: CLLocationManager = CLLocationManager()
    var startLocation: CLLocation!
    var latitude = ""
    var longitude = ""
    
    var zipLat = ""
    var zipLong = ""
    
    var userList: [AYUser] = []
    var newUserList: [AYUser] = []
    
    //    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var photoView: UIView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    
    
    var totalPages = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        user = UserProfile.currentUser()
        self.updateMainImage()
        FBEvent.onMainPictChanged().listen(self) { [unowned self] (_) -> Void in
            self.updateMainImage()
            self.searchUsers()
            self.savePeople(UserProfile.userProfile.user!)
        }
        
        flipView.dataSource = self
        flipView.delegate = self
        
        self.modalTransitionStyle = UIModalTransitionStyle.FlipHorizontal
        
        //location
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        startLocation = nil
        
        //retrive coredata
        FBEvent.onSettingInfoChanged().listen(self) { [unowned self] (isReceived) -> Void in
            if isReceived
            {
                self.searchUsers()
            }
        }
        
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
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(MainViewController.handleTap))
        self.view.addGestureRecognizer(tapGesture);
        centerAvatar.layer.borderWidth = 2.0
        centerAvatar.layer.masksToBounds = false
        centerAvatar.layer.borderColor = UIColor.whiteColor().CGColor
        centerAvatar.layer.cornerRadius = centerAvatar.frame.size.width/2.0
        centerAvatar.clipsToBounds = true
        
        flipView.layer.cornerRadius = 8
        flipView.clipsToBounds = true
    }
    func closeKeyboard(){
        self.view.endEditing(true)
    }
    func searchUsers()
    {
        var reqLong = ""
        var reqLat = ""
        if (zipCodeTextField.text != "")
        {
            reqLat = zipLat
            reqLong = zipLong
        }else
        {
            if self.latitude == ""
            {
                return
            }
            reqLat = latitude
            reqLong = longitude
        }
        let defaults = NSUserDefaults.standardUserDefaults()
        var distance = String(defaults.integerForKey(AYNet.KEY_DISTANCE))
        if (defaults.integerForKey(AYNet.KEY_DISTANCE) == 0)
        {
            distance = "100"
        }
        let fly = defaults.boolForKey(AYNet.KEY_FLY) ? "1" : "0"
        let base = defaults.boolForKey(AYNet.KEY_BASE) ? "1" : "0"
        let lbase = defaults.boolForKey(AYNet.KEY_LBASING) ? "1" : "0"
        let both = defaults.boolForKey(AYNet.KEY_BOTH) ? "1" : "0"
        let whip = defaults.boolForKey(AYNet.KEY_WHIP) ? "1" : "0"
        let pop = defaults.boolForKey(AYNet.KEY_POP) ? "1" : "0"
        let hand = defaults.boolForKey(AYNet.KEY_HAND) ? "1" : "0"
        let acrotype = "100"
        let experience = String(defaults.integerForKey(AYNet.KEY_RATE))
        if let user = UserProfile.currentUser()
        {
            self.isBlocked = true
            let params = [ AYNet.USERFACEBOOKID: user.facebookid as! AnyObject,
                           AYNet.KEY_LONGITUDE: reqLat as AnyObject,
                           AYNet.KEY_LATITUDE: reqLong as AnyObject,
                           AYNet.KEY_SEARCH_DISTANCE: distance as AnyObject,
                           AYNet.KEY_SEARCH_FLY: fly as AnyObject,
                           AYNet.KEY_SEARCH_BASE: base as AnyObject,
                           AYNet.KEY_SEARCH_LBASING: lbase as AnyObject,
                           AYNet.KEY_SEARCH_BOTH: both as AnyObject,
                           AYNet.KEY_SEARCH_WHIP: whip as AnyObject,
                           AYNet.KEY_SEARCH_POP: pop as AnyObject,
                           AYNet.KEY_SEARCH_HAND: hand as AnyObject,
                           AYNet.KEY_SEARCH_ACROTYPE: acrotype as AnyObject,
                           AYNet.KEY_SEARCH_EXPERIENCE: experience as AnyObject]
            Net.searchUsers(params).onSuccess(callback: {(list) -> Void in
                self.userList = list
                self.configureFlipView()
                
                self.isBlocked = false
            })
        }
    }
    @IBAction func likeAction(sender: UIButton) {
        // 11: dislikeAction 12: likeAction
        if sender.tag == 11
        {
            flipView?.swipe(SwipeResultDirection.Left)
        } else if sender.tag == 12
        {
            flipView?.swipe(SwipeResultDirection.Right)
        }else if sender.tag == 13
        {
            flipView?.revertAction()
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
    private var isBlocked = false
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
        if isBlocked
        {
            return
        }
        if zipCodeTextField.text == ""
        {
            searchUsers()
        }else {
            
        }
        //        pulsator.start()
    }
    func likeButtonEnabled(flag: Bool)
    {
        if flag
        {
            likeButton.hidden = false
            dislikeButton.hidden = false
            
        }else{
            likeButton.hidden = true
            dislikeButton.hidden = true
        }
    }
    func configureFlipView()
    {
        newUserList = []
        for i in 0 ..< userList.count
        {
            if userList[i].username == "0"
            {
                return
            }
            
            if DBManager.checkUser(userList[i].facebookid!)
            {
                continue
            }
            newUserList.append(userList[i])
        }
        if newUserList.count > 0{
            
            self.likeButtonEnabled(true)
            flipView.dataSource = self
            flipView.hidden = false
            flipView.reloadData()
        }else{
            self.likeButtonEnabled(false)
        }
        
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
        pulsator.numPulse = 3
        pulsator.radius = (UIScreen.mainScreen().bounds.width) / 2 + 30
        pulsator.animationDuration = 5
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
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let latestLocation: AnyObject = locations[locations.count - 1]
        
        latitude = String(latestLocation.coordinate.latitude)
        longitude = String(latestLocation.coordinate.longitude)
        manager.stopUpdatingLocation()
        searchUsers()
    }
    
    func getLatLngForZip(zipCode: String) {
        let url = NSURL(string: "\(AYNet.baseUrl)address=\(zipCode)")
        let data = NSData(contentsOfURL: url!)
        if(data != nil)
        {
            let json = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as! NSDictionary
            if let result = json["results"] as? NSArray {
                if(result.count > 0)
                {
                    if let geometry = result[0]["geometry"] as? NSDictionary {
                        if let location = geometry["location"] as? NSDictionary {
                            let latitude = location["lat"] as! Float
                            let longitude = location["lng"] as! Float
                            zipLat = String(latitude)
                            zipLong = String(longitude)
                            searchUsers()
                            print("\n\(latitude), \(longitude)")
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func zipCodeSearchAction(sender: AnyObject) {
        closeKeyboard()
        let zipCode = zipCodeTextField.text
        if zipCode == ""
        {
            return
        }
        getLatLngForZip(zipCode!)
    }
    func handleTap()
    {
        self.view.endEditing(true)
    }
    //core data: register chatting user
    func savePeople(user: AYUser) {
        let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        //2
        let fetchRequest = NSFetchRequest(entityName: "User")
        
        //3
        var firstUser: User!
        do {
            let results =
                try managedContext.executeFetchRequest(fetchRequest)
            if results.count > 0
            {
                firstUser = results.first as? User
            }
        } catch _ as NSError {
            return
        }
        if firstUser == nil
        {
            let entity =  NSEntityDescription.entityForName("User",
                                                            inManagedObjectContext:managedContext)
            
            let person = NSManagedObject(entity: entity!,
                                         insertIntoManagedObjectContext: managedContext) as? User
            
            //3
            let messages:NSMutableDictionary = NSMutableDictionary()
            person?.avatar = user.profileMainImage
            person?.username = user.username
            person?.userid = user.facebookid
            person?.messages = messages
            person?.messagedate = ""
            
            //4
            do {
                try managedContext.save()
                
            } catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
            }
        }else {
            firstUser.username = user.username
            firstUser.userid = user.facebookid
            firstUser.avatar = user.profileMainImage
            do {
                try managedContext.save()
                
            } catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
            }
            
        }
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        closeKeyboard()
        return false
    }
}

//MARK: KolodaViewDelegate
extension MainViewController: KolodaViewDelegate {
    
    func kolodaDidRunOutOfCards(koloda: KolodaView) {
        flipView.hidden = true
        likeButtonEnabled(false)
        self.newUserList = []
        self.flipView.reloadData()
    }
    
    func koloda(koloda: KolodaView, didSelectCardAtIndex index: UInt) {
        //        UIApplication.sharedApplication().openURL(NSURL(string: "http://yalantis.com/")!)
        let profileDetailVC = self.storyboard!.instantiateViewControllerWithIdentifier("ProfileDetailViewController") as! ProfileDetailViewController
        profileDetailVC.userID = newUserList[Int(index)].facebookid
        self.presentViewController(profileDetailVC, animated: true, completion: nil)    }
    func koloda(koloda: KolodaView, didSwipeCardAtIndex index: UInt, inDirection direction: SwipeResultDirection) {
        print(index)
        if direction == SwipeResultDirection.Right
        {
            var people: User?
            let appDelegate =
                UIApplication.sharedApplication().delegate as! AppDelegate
            
            let managedContext = appDelegate.managedObjectContext
            
            //2
            let fetchRequest = NSFetchRequest(entityName: "User")
            
            //3
            do {
                let results =
                    try managedContext.executeFetchRequest(fetchRequest)
                people = results.first as? User
            } catch _ as NSError {
                return
            }
            let msgList = [ChatMessage]()
            var dic:[String : AnyObject] = (people?.messages)! as! [String: AnyObject]
            let messages = NSKeyedArchiver.archivedDataWithRootObject(msgList)
            var dictionary: [String : AnyObject] = Dictionary()
            dictionary["messages"] = messages
            dictionary["username"] = newUserList[Int(index)].username
            dictionary["avatar"] = newUserList[Int(index)].profileMainImage
            dic[newUserList[Int(index)].facebookid!] = dictionary
            people?.messages = dic
            do {
                try managedContext.save()
                let messageViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("MessageViewController") as? MessageViewController
                messageViewController?.messageInfo()
            } catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
            }
        }
    }
}

extension MainViewController: KolodaViewDataSource {
    
    func kolodaNumberOfCards(koloda: KolodaView) -> UInt {
        return UInt(newUserList.count)
    }
    func koloda(koloda: KolodaView, viewForCardAtIndex index: UInt) -> UIView {
        let dataView = NSBundle.mainBundle().loadNibNamed("CustomOverlayView",
                                                          owner: self, options: nil)[0] as? CustomOverlayView
        let user = newUserList[Int(index)]
        dataView?.label1.text = user.username
        // Retrive picture from parse
        
        UserProfile.getImage(user.profileMainImage!, completition:{ (image) -> Void in
            dataView?.myImage.image = image
        })
        
        
        return dataView!
    }
    func kolodaViewForCardOverlayAtIndex(koloda: KolodaView, index: UInt) -> OverlayView? {
        return NSBundle.mainBundle().loadNibNamed("OverView",
                                                  owner: self, options: nil)[0] as? OverlayView
    }
}

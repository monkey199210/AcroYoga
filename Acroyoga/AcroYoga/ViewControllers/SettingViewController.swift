//
//  SettingViewController.swift
//  TurnUP
//
//  Created by SCAR on 3/21/16.
//  Copyright © 2016 ku. All rights reserved.
//



import UIKit

class SettingViewController: UIViewController {
    
    @IBOutlet weak var distanceLabel: UILabel!
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    //checkbox
    @IBOutlet weak var flycheckBox: VKCheckbox!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var weightTextView: UITextField!
    
    @IBOutlet weak var baseCheck: VKCheckbox!
    @IBOutlet weak var lbaseCheck: VKCheckbox!
    @IBOutlet weak var handCheck: VKCheckbox!
    @IBOutlet weak var whipCheck: VKCheckbox!
    @IBOutlet weak var popCheck: VKCheckbox!
    @IBOutlet weak var bothCheck: VKCheckbox!
    @IBOutlet weak var ratingView: HCSStarRatingView!
    
    @IBOutlet weak var notificationSwitch: UISwitch!
    @IBOutlet weak var notificationSoundSwitch: UISwitch!
    @IBOutlet weak var readySwitch: UISwitch!
    
    @IBOutlet weak var distanceSlider: UISlider!
    @IBOutlet weak var hideSwitch: UISwitch!
    @IBOutlet weak var btn_Unit: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        configureScrollView()
        initView()
        
    }
    
    @IBAction func sliderValueChanged(sender: UISlider) {
        let selectedValue = Int(sender.value)
        distanceLabel.text = "\(selectedValue)Km"
    }
    func configureScrollView()
    {
        let screenRect = UIScreen.mainScreen().bounds
        let screenWidth = screenRect.size.width
        
        //Setting the right content size - only height is being calculated depenging on content.
        let height = self.hideSwitch.frame.maxY + 15
        let contentSize = CGSizeMake(screenWidth, height);
        self.scrollView.contentSize = contentSize;
    }
    @IBAction func unitAction(sender: AnyObject) {
        
        let title = btn_Unit.titleLabel?.text == "Kg" ? "LBS": "Kg"
        btn_Unit.setTitle(title, forState: UIControlState.Normal)
    }
    @IBAction func saveAction(sender: AnyObject) {
        let defaults = NSUserDefaults.standardUserDefaults()
        let rate = Int(ratingView.value)
        let distance = Int(distanceSlider.value)
        defaults.setBool( flycheckBox.isOn(), forKey: AYNet.KEY_FLY)
        defaults.setBool( baseCheck.isOn(), forKey: AYNet.KEY_BASE)
        defaults.setBool( lbaseCheck.isOn(), forKey: AYNet.KEY_LBASING)
        defaults.setBool( handCheck.isOn(), forKey: AYNet.KEY_HAND)
        defaults.setBool( whipCheck.isOn(), forKey: AYNet.KEY_WHIP)
        defaults.setBool( popCheck.isOn(), forKey: AYNet.KEY_POP)
        defaults.setBool( bothCheck.isOn(), forKey: AYNet.KEY_BOTH)
        defaults.setInteger(distance, forKey: AYNet.KEY_DISTANCE)
        defaults.setInteger(rate, forKey: AYNet.KEY_RATE)
        defaults.synchronize()
        let readyFlag = readySwitch.on ? "1" : "0"
        let hideFlag = hideSwitch.on ? "1" : "0"
        let params = [ AYNet.USERFACEBOOKID: UserProfile.userProfile.user?.facebookid as! AnyObject,
                       AYNet.KEY_HIDE: hideFlag as AnyObject,
                       AYNet.KEY_READY: readyFlag as AnyObject]
        Net.requestServer(AYNet.UPLOADSETTING_URL, params:params).onSuccess(callback: { (enabled) -> Void in
            Net.me().onSuccess(callback: {(user) -> Void in
                defaults.setBool( self.readySwitch.on, forKey: AYNet.KEY_READY)
                defaults.setBool(self.hideSwitch.on, forKey: AYNet.KEY_HIDE)
                defaults.synchronize()
            })
            
            self.dismissViewControllerAnimated(true, completion: nil)
        }).onFailure { (error) -> Void in
            self.dismissViewControllerAnimated(true, completion: nil)
        }

        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    func initView()
    {
        let defaults = NSUserDefaults.standardUserDefaults()
        distanceSlider.value = Float(defaults.integerForKey(AYNet.KEY_DISTANCE))
        distanceLabel.text = "\(defaults.integerForKey(AYNet.KEY_DISTANCE))Km"
        flycheckBox.setOn(defaults.boolForKey(AYNet.KEY_FLY))
        baseCheck.setOn(defaults.boolForKey(AYNet.KEY_BASE))
        lbaseCheck.setOn(defaults.boolForKey(AYNet.KEY_LBASING))
        bothCheck.setOn(defaults.boolForKey(AYNet.KEY_BOTH))
        whipCheck.setOn(defaults.boolForKey(AYNet.KEY_WHIP))
        popCheck.setOn(defaults.boolForKey(AYNet.KEY_POP))
        handCheck.setOn(defaults.boolForKey(AYNet.KEY_HAND))
        readySwitch.setOn(defaults.boolForKey(AYNet.KEY_READY), animated: false)
        hideSwitch.setOn(defaults.boolForKey(AYNet.KEY_HIDE), animated: false)
        ratingView.value = CGFloat(defaults.integerForKey(AYNet.KEY_RATE))
    }
}


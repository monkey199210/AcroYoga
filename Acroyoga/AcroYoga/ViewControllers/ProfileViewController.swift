//
//  ProfileViewController.swift
//  AcroYoga
//
//  Created by Rui Caneira on 9/5/16.
//  Copyright © 2016 ku. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var profileImg: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        self.updateMainImage()
        FBEvent.onMainPictChanged().listen(self) { [unowned self] (_) -> Void in
            self.updateMainImage()
        }

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func initView()
    {
        profileImg.layer.masksToBounds = false
        profileImg.layer.cornerRadius = profileImg.frame.size.width/2.0
        profileImg.clipsToBounds = true
    }

    @IBAction func editProfileAction(sender: AnyObject) {
        let profileDetailVC = self.storyboard!.instantiateViewControllerWithIdentifier("ProfileDetailViewController") as! ProfileDetailViewController
        
        self.showViewController(profileDetailVC, sender: sender)
    }
    @IBAction func settingAction(sender: AnyObject) {
        let settingVC = self.storyboard!.instantiateViewControllerWithIdentifier("SettingViewController") as! SettingViewController
        
        self.showViewController(settingVC, sender: sender)
    }
    private func updateMainImage() {
        UserProfile.getMainPict({ (image) -> Void in
            UserProfile.getCircledMainImage({ (image) -> Void in
                self.profileImg.image = image
            })
        })
    }

}

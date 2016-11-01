//
//  ProfileDetailViewController.swift
//  AcroYoga
//
//  Created by Rui Caneira on 9/5/16.
//  Copyright © 2016 ku. All rights reserved.
//

import UIKit

class ProfileDetailViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var skillView: UIView!
     var images = ["image1", "image2"]
     @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var ratingView: HCSStarRatingView!
    @IBOutlet weak var descriptionTextField: UITextView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var user: AYUser?
    override func viewDidLoad() {
        super.viewDidLoad()
        pageControl.numberOfPages = 0
        let screenRect = UIScreen.mainScreen().bounds
        let screenWidth = screenRect.size.width
        
        //Setting the right content size - only height is being calculated depenging on content.
        let height = self.skillView.frame.maxY + 15
        let contentSize = CGSizeMake(screenWidth, height);
        self.scrollView.contentSize = contentSize;
        configure()
        activityIndicator.startAnimating()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

   func configure()
   {
    if let user = UserProfile.currentUser() {
        configureWithUser(user)
    }
    FBEvent.onProfileReceived().listen(self, callback: { [unowned self] (user) -> Void in
        self.configureWithUser(user)
//        FBEvent.onProfileReceived().removeListener(self)
        })
    }
    @IBAction func backAction(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func editProfileAction(sender: AnyObject) {
        
    }
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    func configureWithUser(pUser: AYUser)
    {
        userNameLabel.text = pUser.username
        phoneNumberLabel.text = "Phone: " + pUser.phoneNumber
        ratingView.value = CGFloat((pUser.rate as NSString).floatValue)
        if pUser.description != ""
        {
            descriptionTextField.text = pUser.description
        }
        images = []
        if let img1 = pUser.profileMainImage {
            images.append(img1)
        }
        if let img2 = pUser.imgpath1 {
            images.append(img2)
        }
        if let img3 = pUser.imgpath2 {
            images.append(img3)
        }
        if let img4 = pUser.imgpath3 {
            images.append(img4)
        }
        pageControl.numberOfPages = images.count
        collectionView.reloadData()
    }
}
extension ProfileDetailViewController
{
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let collectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("collectionViewCell", forIndexPath: indexPath)
        if let cell = collectionViewCell as? DetailCollectionViewCell
        {
            UserProfile.getImage(images[indexPath.row], completition:{ (image) -> Void in
                cell.imageView.image = image
                self.activityIndicator.stopAnimating()
                self.activityIndicator.hidden = true
                })
            return cell
        }

        return collectionViewCell
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        if scrollView == self.collectionView {
            var page: Int = Int(scrollView.contentOffset.x / UIScreen.mainScreen().bounds.width)
            page = min(page, self.images.count - 1)
            page = max(page, 0)
            self.pageControl.currentPage = page
        }
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        // Set cell width to 100%
        let collectionViewWidth = self.collectionView.bounds.size.width
        return CGSize(width: collectionViewWidth, height: collectionViewWidth)
    }

}

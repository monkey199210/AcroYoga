//
//  LoginViewController.swift
//  AcroYoga
//
//  Created by SCAR on 3/18/16.
//  Copyright © 2016 ku. All rights reserved.
//

import UIKit
import MRProgress
import FBSDKLoginKit
class LoginViewController: UIViewController ,UIScrollViewDelegate{

//    @IBOutlet weak var scrollView: UIScrollView!
//    
//    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var pageControl: UIPageControl!
   
    @IBOutlet weak var scroll: UIScrollView!
    @IBOutlet weak var contentView: UIStackView!

    
    let sampleBG: [UIImage] = [
        UIImage(named:"splash1")!,
        UIImage(named:"splash2")!,
         UIImage(named:"splash3")!
    ]
    
    var totalPages = 0
    override func viewWillAppear(animated: Bool) {
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        let userInfo = defaults.objectForKey("username")
        if(userInfo != nil)
        {
            self.success()
        }else
        {
            
        }

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loaddata()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        loginFaceBook()
        // Do any additional setup after loading the view, typically from a nib.
        totalPages = sampleBG.count
    }
    
    func loaddata()
    {
      
    }
    
   func loginFaceBook()
    {
       
//        if(FB.hasActiveSession()){
//            print("FACEBOOK ACTIVE SESSION");
//            self.success()
//        }else{
//            print("FACEBOOK DOES NOT HAVE ACTIVE SESSION");
//        }
        
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        configureScrollView()
        configurePageControl()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: Custom method implementation
    
    func configureScrollView() {
        // Enable paging.
//        var screenRect = scroll.frame
//        screenRect.size.height = 700;
//        self.scroll.contentSize = screenRect.size
        
        scrollView.pagingEnabled = true
        
        // Set the following flag values.
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        
        
        // Set the scrollview content size.
        scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * CGFloat(totalPages), scrollView.frame.size.height)
        
        // Set self as the delegate of the scrollview.
        
        // Load the TestView view from the TestView.xib file and configure it properly.
        for i in 0 ..< totalPages {
            // Load the TestView view.
            let testView = NSBundle.mainBundle().loadNibNamed("TestView", owner: self, options: nil)[0] as! UIView
            
            // Set its frame and the background color.
            testView.frame = CGRectMake(CGFloat(i) * scrollView.frame.size.width, scrollView.frame.origin.y, scrollView.frame.size.width, scrollView.frame.size.height)

            let image = testView.viewWithTag(1) as! UIImageView
            image.image = sampleBG[i]
            
            // Add the test view as a subview to the scrollview.
            scrollView.addSubview(testView)
        }
    }
    
    
    func configurePageControl() {
        // Set the total pages to the page control.
        
        pageControl.numberOfPages = totalPages
        
        // Set the initial page.
        pageControl.currentPage = 0
        
    }
    
    
    // MARK: UIScrollViewDelegate method implementation
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        // Calculate the new page index depending on the content offset.
        let currentPage = floor(scrollView.contentOffset.x / scrollView.frame.size.width);
        // Set the new page index to the page control.
        pageControl.currentPage = Int(currentPage)
    }
    
    
    // MARK: IBAction method implementation
    
    @IBAction func changePage(sender: AnyObject) {
        // Calculate the frame that should scroll to based on the page control current page.
        var newFrame = scrollView.frame
        newFrame.origin.x = newFrame.size.width * CGFloat(pageControl.currentPage)
        scrollView.scrollRectToVisible(newFrame, animated: true)
        
    }
    
    @IBAction func facebookLogin(){
        
        let login = FBSDKLoginManager()
        let defaults = NSUserDefaults.standardUserDefaults()

        //                defaults.setObject(name , forKey: "username")
        //                defaults.setObject(facebookProfileUrl, forKey: "userImage")
        //                defaults.synchronize()
        login.logInWithReadPermissions(["user_about_me", "user_friends"], fromViewController: self) { [unowned self] (result, error) -> Void in
            if result != nil && error == nil {
//                Webservice.showBlocking(true)
                let requestMe = FBSDKGraphRequest.init(graphPath: "me", parameters: ["fields": "id, name"])
                let connection = FBSDKGraphRequestConnection()
                connection.addRequest(requestMe, completionHandler: { (connection, result, error) -> Void in
                    if let accessToken = FBSDKAccessToken.currentAccessToken() where result != nil && error == nil {
//                        self.facebookAccessToken = accessToken.tokenString
                        print(accessToken)
                        if let uID = result["id"] as? String {
                            defaults.setObject( uID, forKey: "userid")
                            if let name = result["name"] as? String {
                                defaults.setObject(name , forKey: "username")
                            }
                            defaults.synchronize()
                        }
                        let height = Int(FBoxHelper.getScreenSize().height)
                        let width = Int(FBoxHelper.getScreenSize().width)
                        let request = FBSDKGraphRequest(graphPath: "/me/picture", parameters: ["height":"\(height)", "redirect":"0", "width":"\(width)"])
                        request.startWithCompletionHandler({ (connection, result, error) -> Void in
                            if result != nil && error == nil {
                                if let data = result["data"] as? NSDictionary {
                                    if let url = data["url"] as? String {
                                        defaults.setObject(url, forKey: "userImage")
                                        defaults.synchronize()
                                        self.success()
                                    }
                                }
                            }else if error != nil {
                                print(error)
                                
                            }
                        })
                    }else if error != nil {
                        print(error)
//                        Webservice.closeBlocking(true)
                    }
                })
                connection.start()
            }else if error != nil {
                print(error)
            }
        }

//        self.success()
    }
    
    func handleLogin(){
        print("SUCCESS");
//        FB.getInfo(self.success)
    }
    
    func success()
    {
         Webservice.showBlocking(true)
        Net.requestUser().onSuccess(callback: { (enabled) -> Void in
            MRProgressOverlayView.dismissOverlayForView(FBoxHelper.getWindow(), animated: true)
            
            ////
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setObject("1", forKey: "login")
            defaults.synchronize()
            
            ////
            let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate
            
            appDelegate!.loadPageController(false)
        }).onFailure(callback: { (_) -> Void in
            print("failed")
            Webservice.closeBlocking(true)
        })
    }


}

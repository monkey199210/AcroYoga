//
//  LoginViewController.swift
//  TurnUP
//
//  Created by SCAR on 3/18/16.
//  Copyright © 2016 ku. All rights reserved.
//

import UIKit
class LoginViewController: UIViewController ,UIScrollViewDelegate,FBLoginViewDelegate{

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
       
        if(FB.hasActiveSession()){
            print("FACEBOOK ACTIVE SESSION");
            self.success()
        }else{
            print("FACEBOOK DOES NOT HAVE ACTIVE SESSION");
        }
        
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
        for var i=0; i<totalPages; ++i {
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
        
        FB.login(self.handleLogin);
//        self.success()
    }
    
    func handleLogin(){
        print("SUCCESS");
        FB.getInfo(self.success)
        

    }
    
    func success()
    {
        Net.requestUser().onSuccess(callback: { (enabled) -> Void in
            let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate
            
            appDelegate!.loadPageController()
        })
    }


}

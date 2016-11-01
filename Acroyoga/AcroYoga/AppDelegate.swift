import UIKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        var vc = UIViewController()
//        let storyboard =UIStoryboard.storyboardWithName:@"Main" bundle:[NSBundle mainBundle;
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        if(!self.getStatus())
        {
            vc = storyboard.instantiateViewControllerWithIdentifier("LoginViewController")
            
            self.setRootViewController(vc)
        }
        else
        {
             self.loadPageController()
        }
        return true
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        return FBAppCall.handleOpenURL(url, sourceApplication: sourceApplication, fallbackHandler: nil);
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        FB.handleDidBecomeActive();
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
        FB.logout();
        
    }
    
    func getStatus()->Bool
    {
        let defaults = NSUserDefaults.standardUserDefaults()
        
        let userInfo = defaults.objectForKey("username")
        if(userInfo != nil)
        {
            return true
        }
        return false

    }
    
    func setRootViewController(vc:UIViewController)
    {
        let navigationController = UINavigationController(rootViewController: vc)
        self.window!.rootViewController = navigationController
        vc.navigationController?.navigationBar.barStyle = UIBarStyle.Black
        self.window!.makeKeyAndVisible()
    }
    
    func loadPageController()
    {
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let v1 = storyboard.instantiateViewControllerWithIdentifier("ProfileViewController")
        let v2 = storyboard.instantiateViewControllerWithIdentifier("MainViewController")
        let v3 = storyboard.instantiateViewControllerWithIdentifier("ShareViewController")
        
        //Default
        // var controller = AHPagingMenuViewController(controllers: [v1,v2,v3,v4,v5], icons: ["Page 1", "Page 2", "Page 3", "Page 4", "Page 5"], position:2)
        
        //Like Tinder s2
        let controller = AHPagingMenuViewController(controllers: [v1,v2,v3], icons: NSArray(array: [UIImage(named:"profile")!, UIImage(named:"acroyoga")!, UIImage(named:"message")! ]), position:1)
        controller.setShowArrow(false)
        controller.setTransformScale(true)
        controller.setDissectColor(UIColor(white: 0.756, alpha: 1.0));
        controller.setSelectColor(UIColor(red: 0.963, green: 0.266, blue: 0.176, alpha: 1.000))
        
        //Nav - Icons e Strings
        //var controller = AHPagingMenuViewController(controllers: [v1,v2,v3,v4,v5], icons: NSArray(array: [UIImage(named:"photo")!,"Love", UIImage(named:"conf")!, UIImage(named:"message")!, "Map"]), position:2)
        
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window!.rootViewController = controller
        self.window!.makeKeyAndVisible()

    }
    
    
}


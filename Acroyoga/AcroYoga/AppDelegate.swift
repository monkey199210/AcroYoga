import UIKit
import CoreData
import FBSDKCoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var deviceToken: String!
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        
        // Override point for customization after application launch.
        registerForPushNotifications(application)
        application.applicationIconBadgeNumber = 0
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        var vc = UIViewController()
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        if let notification = launchOptions?[UIApplicationLaunchOptionsRemoteNotificationKey] as? [String: AnyObject] {
            // 2
            let aps = notification["aps"] as! [String: AnyObject]
            let userId = aps["uid"] as! String
//            let newmsg = aps["alert"] as! String
//            let date = aps["date"] as! String
            //if user alreay exist?
            if !DBManager.checkUser(userId)
            {
                Net.getUserInfoById(userId).onSuccess(callback:  {(user) -> Void in
                    DBManager.saveUser(user, text: nil, date: nil)
                    self.loadPageController(true)
                })
            }else {
                self.loadPageController(true)
            }

            // 3
        }else {
        
        
            if(!self.getStatus())
            {
                vc = storyboard.instantiateViewControllerWithIdentifier("LoginViewController")
            
                self.setRootViewController(vc)
            }
            else
            {
                self.loadPageController(false)
            }
        }
        return true
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
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
        
//        FB.handleDidBecomeActive();
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
//        FB.logout();
        self.saveContext()

        
    }
    func registerForPushNotifications(application: UIApplication) {
        let notificationSettings = UIUserNotificationSettings(
            forTypes: [.Badge, .Sound, .Alert], categories: nil)
        application.registerUserNotificationSettings(notificationSettings)
    }
    func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
        if notificationSettings.types != .None {
            application.registerForRemoteNotifications()
        }
    }
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let tokenChars = UnsafePointer<CChar>(deviceToken.bytes)
        var tokenString = ""
        
        for i in 0..<deviceToken.length {
            tokenString += String(format: "%02.2hhx", arguments: [tokenChars[i]])
        }
        
        print("Device Token:", tokenString)
        self.deviceToken = tokenString
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        print("Failed to register:", error)
    }
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
//        let aps = userInfo["aps"] as! [String: AnyObject]
//        let userId = aps["uid"] as! String
//        let newmsg = aps["alert"] as! String
//        let date = aps["date"] as! String
//        //if user alreay exist?
//        if !DBManager.checkUser(userId)
//        {
//            Net.getUserInfoById(userId).onSuccess(callback:  {(user) -> Void in
//               DBManager.saveUser(user, text: newmsg, date: date)
//                self.loadPageController(true)
//            })
//        }
        UIApplication.sharedApplication().applicationIconBadgeNumber = 0
        
    }
    
    func getStatus()->Bool
    {
        let defaults = NSUserDefaults.standardUserDefaults()
        
        let userInfo = defaults.objectForKey("login") as? String
        if(userInfo == "1")
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
    
    func loadPageController(notificationFlag: Bool)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let v1 = storyboard.instantiateViewControllerWithIdentifier("ProfileViewController")
        let v2 = storyboard.instantiateViewControllerWithIdentifier("MainViewController")
        let v3 = storyboard.instantiateViewControllerWithIdentifier("MessageViewController")
        
        //Default
        // var controller = AHPagingMenuViewController(controllers: [v1,v2,v3,v4,v5], icons: ["Page 1", "Page 2", "Page 3", "Page 4", "Page 5"], position:2)
        
        //Like Tinder s2
        let controller = AHPagingMenuViewController(controllers: [v1,v2,v3], icons: NSArray(array: [UIImage(named:"profile")!, UIImage(named:"acroyoga")!, UIImage(named:"message")! ]), position:1)
        controller.setShowArrow(false)
        controller.setTransformScale(true)
        controller.setDissectColor(UIColor(white: 0.756, alpha: 1.0));
        controller.setSelectColor(UIColor(red: 0.963, green: 0.266, blue: 0.176, alpha: 1.000))
        if notificationFlag
        {
            controller.currentPage = 3
        }
        //Nav - Icons e Strings
        //var controller = AHPagingMenuViewController(controllers: [v1,v2,v3,v4,v5], icons: NSArray(array: [UIImage(named:"photo")!,"Love", UIImage(named:"conf")!, UIImage(named:"message")!, "Map"]), position:2)
        
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window!.rootViewController = controller
        self.window!.makeKeyAndVisible()

    }
    // MARK: - Core Data stack
    
    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.alamond.aaa" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("AcroYoga", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("AcroYogaCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }

    
    
}


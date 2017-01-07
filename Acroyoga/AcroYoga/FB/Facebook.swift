//
import Foundation
import Genome
import BrightFutures
import Async
import FBSDKLoginKit
let FB = Facebook();
//
class Facebook {
//
//    var fbSession:FBSession?;
//    
//    init(){
//        self.fbSession = FBSession.activeSession();
//    }
//    
//    func hasActiveSession() -> Bool{
//        let defaults = NSUserDefaults.standardUserDefaults()
//        if let session = defaults.objectForKey("fbsession")
//        {
//            self.fbSession = session as? FBSession
//            return true
//        }
//        let fbsessionState = FBSession.activeSession().state;
//        if ( fbsessionState == FBSessionState.Open
//            || fbsessionState == FBSessionState.OpenTokenExtended ){
//                self.fbSession = FBSession.activeSession();
//                return true;
//        }
//        return false;
//    }
//    
//    func login(callback: () -> Void){
//        
//        let permission = ["basic_info", "email", "user_work_history", "user_education_history", "user_location"];
//        
//        let activeSession = FBSession.activeSession();
//        let fbsessionState = activeSession.state;
//        var showLoginUI = true;
//        
//        if(fbsessionState == FBSessionState.CreatedTokenLoaded){
//            showLoginUI = false;
//        }
//        
//        if(fbsessionState != FBSessionState.Open
//            && fbsessionState != FBSessionState.OpenTokenExtended){
//                FBSession.openActiveSessionWithReadPermissions(
//                    permission,
//                    allowLoginUI: showLoginUI,
//                    completionHandler: { (session:FBSession!, state:FBSessionState, error:NSError!) in
//
//                        if(error != nil){
//                            print("Session Error: \(error)");
//                        }
//                        
//                        self.fbSession = session;
//                        
//                        //save session
////                        let defaults = NSUserDefaults.standardUserDefaults()
////                        defaults.setObject( session, forKey: "fbsession")
////                        defaults.synchronize()
//                        
//                        callback();
//                        
//                    }
//                );
//                return;
//        }
//        
//        callback();
//        
//    }
//    class func loginFB()
//    {
//        let permission = ["basic_info", "email", "user_work_history", "user_education_history", "user_location"];
//        let login = FBSDKLoginManager()
//        login.logInWithReadPermissions(["user_about_me"], fromViewController: self) { [unowned self] (result, error) -> Void in
//            if result != nil && error == nil {
//                Webservice.showBlocking(true)
//                let requestMe = FBSDKGraphRequest.init(graphPath: "me", parameters: ["fields": "first_name"])
//                let connection = FBSDKGraphRequestConnection()
//                connection.addRequest(requestMe, completionHandler: { (connection, result, error) -> Void in
//                    if let accessToken = FBSDKAccessToken.currentAccessToken() where result != nil && error == nil {
//                        self.facebookAccessToken = accessToken.tokenString
//                        if let name = result["first_name"] as? String {
//                            
//                        }
//                        
//                    }else if error != nil {
//                        print(error)
//                        Webservice.closeBlocking(true)
//                    }
//                })
//                connection.start()
//            }else if error != nil {
//                print(error)
//            }
//        }
//
//
//    }
//    
//    func logout(){
//        self.fbSession?.closeAndClearTokenInformation();
//        self.fbSession?.close();
//    }
//    
//    func getInfo(callback: () -> Void){
//        FBRequest.requestForMe()?.startWithCompletionHandler({(connection:FBRequestConnection!, result:AnyObject!, error:NSError!) in
//            
//            if(error != nil){
//                print("Error Getting ME: \(error)");
//            }
//            else{
//                UIApplication.sharedApplication()
//                print("\(result)");
//                self.parseResult(result)
//               
//                callback()
//            }
//        });
//    }
//    
//    func handleDidBecomeActive(){
//        FBAppCall.handleDidBecomeActive();
//    }
//    
//    func parseResult(result:AnyObject)
//    {
//        var name=""
//        var id=""
//        do {
//            let jsonDict = try result as? NSDictionary
//            if let jsonDict = jsonDict {
//                // work with dictionary here
//                if let idvalue = jsonDict["id"] as? String {
//                    id = idvalue
//                }
//                if let username = jsonDict["name"] as? String {
//                    name = username
//                }
//                let facebookProfileUrl = "http://graph.facebook.com/\(id)/picture?type=large"
//                let defaults = NSUserDefaults.standardUserDefaults()
//                defaults.setObject( id, forKey: "userid")
//                defaults.setObject(name , forKey: "username")
//                defaults.setObject(facebookProfileUrl, forKey: "userImage")
//                defaults.synchronize()
//
//            } else {
//                // more error handling
//            }
//        } catch let error as NSException {
//            // error handling
//        }
//    }
//    func getFacebookFriends()
//    {
//        var friendList:[FacebookFriend] = []
//        let friendsRequest : FBRequest = FBRequest.requestForMyFriends()
//        friendsRequest.startWithCompletionHandler{(connection:FBRequestConnection!, result:AnyObject!, error:NSError!) -> Void in
//            let resultdict = result as! NSDictionary
//            print("Result Dict: \(resultdict)")
//            let data : NSArray = resultdict.objectForKey("data") as! NSArray
//            
//            for i in 0 ..< data.count {
//                let friend = FacebookFriend()
//                let valueDict : NSDictionary = data[i] as! NSDictionary
//                let id = valueDict.objectForKey("id") as! String
//                let name = valueDict.objectForKey("name") as! String
//                friend.id = id
//                friend.name = name
//                friend.avatar = "http://graph.facebook.com/\(id)/picture?type=large"
//                friendList.append(friend)
//                
//            }
//            
//             FBEvent.facebookFriendReceived(friendList)
//        }
//    }
////
    }
class FacebookFriend
{
    var name: String = ""
    var id: String = ""
    var avatar: String = ""
    func initFriend(uid: String, uname: String)
    {
        name = uname
        id = uid
    }
}

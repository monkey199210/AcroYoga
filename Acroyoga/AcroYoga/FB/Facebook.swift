
import Foundation

let FB = Facebook();

class Facebook {
    
    var fbSession:FBSession?;
    
    init(){
        self.fbSession = FBSession.activeSession();
    }
    
    func hasActiveSession() -> Bool{
        let fbsessionState = FBSession.activeSession().state;
        if ( fbsessionState == FBSessionState.Open
            || fbsessionState == FBSessionState.OpenTokenExtended ){
                self.fbSession = FBSession.activeSession();
                return true;
        }
        return false;
    }
    
    func login(callback: () -> Void){
        
        let permission = ["basic_info", "email", "user_work_history", "user_education_history", "user_location"];
        
        let activeSession = FBSession.activeSession();
        let fbsessionState = activeSession.state;
        var showLoginUI = true;
        
        if(fbsessionState == FBSessionState.CreatedTokenLoaded){
            showLoginUI = false;
        }
        
        if(fbsessionState != FBSessionState.Open
            && fbsessionState != FBSessionState.OpenTokenExtended){
                FBSession.openActiveSessionWithReadPermissions(
                    permission,
                    allowLoginUI: showLoginUI,
                    completionHandler: { (session:FBSession!, state:FBSessionState, error:NSError!) in

                        if(error != nil){
                            print("Session Error: \(error)");
                        }
                        
                        self.fbSession = session;
                        
                        callback();
                        
                    }
                );
                return;
        }
        
        callback();
        
    }
    
    func logout(){
        self.fbSession?.closeAndClearTokenInformation();
        self.fbSession?.close();
    }
    
    func getInfo(callback: () -> Void){
        FBRequest.requestForMe()?.startWithCompletionHandler({(connection:FBRequestConnection!, result:AnyObject!, error:NSError!) in
            
            if(error != nil){
                print("Error Getting ME: \(error)");
            }
            else{
                UIApplication.sharedApplication()
                print("\(result)");
                self.parseResult(result)
               
                callback()
            }
        });
    }
    
    func handleDidBecomeActive(){
        FBAppCall.handleDidBecomeActive();
    }
    
    func parseResult(result:AnyObject)
    {
        var name=""
        var id=""
        do {
            let jsonDict = try result as? NSDictionary
            if let jsonDict = jsonDict {
                // work with dictionary here
                if let idvalue = jsonDict["id"] as? String {
                    id = idvalue
                }
                if let username = jsonDict["name"] as? String {
                    name = username
                }
                let facebookProfileUrl = "http://graph.facebook.com/\(id)/picture?type=large"
                let defaults = NSUserDefaults.standardUserDefaults()
                defaults.setObject( id, forKey: "userid")
                defaults.setObject(name , forKey: "username")
                defaults.setObject(facebookProfileUrl, forKey: "userImage")
                defaults.synchronize()

            } else {
                // more error handling
            }
        } catch let error as NSException {
            // error handling
        }
    }
    func getFacebookFriends()
    {
        let friendsRequest : FBRequest = FBRequest.requestForMyFriends()
        friendsRequest.startWithCompletionHandler{(connection:FBRequestConnection!, result:AnyObject!, error:NSError!) -> Void in
            let resultdict = result as! NSDictionary
            print("Result Dict: \(resultdict)")
            let data : NSArray = resultdict.objectForKey("data") as! NSArray
            
            for i in 0 ..< data.count {
                let valueDict : NSDictionary = data[i] as! NSDictionary
                let id = valueDict.objectForKey("id") as! String
                print("the id value is \(id)")
            }
            
            let friends = resultdict.objectForKey("data") as! NSArray
            print("Found \(friends.count) friends")
        }
    }
    
    }

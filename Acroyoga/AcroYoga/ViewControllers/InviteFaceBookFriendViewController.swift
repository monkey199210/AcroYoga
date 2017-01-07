//
//  InviteFaceBookFriendViewController.swift
//  AcroYoga
//
//  Created by Rui Caneira on 9/24/16.
//  Copyright © 2016 ku. All rights reserved.
//

import UIKit
import FBSDKCoreKit

class InviteFaceBookFriendViewController: UIViewController {

    var friendList:[FacebookFriend] = []
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.friendList = []
        let fbRequest = FBSDKGraphRequest(graphPath:"/me/friends", parameters:nil);
        Webservice.showBlocking(true)
        fbRequest.startWithCompletionHandler { (connection : FBSDKGraphRequestConnection!, result : AnyObject!, error : NSError!) -> Void in
            
            if error == nil {
                
                print("Friends are : \(result)")
                let resultdict = result as! NSDictionary
                print("Result Dict: \(resultdict)")
                let data : NSArray = resultdict.objectForKey("data") as! NSArray
                
                for i in 0 ..< data.count {
                    let friend = FacebookFriend()
                    let valueDict : NSDictionary = data[i] as! NSDictionary
                    let id = valueDict.objectForKey("id") as! String
                    let name = valueDict.objectForKey("name") as! String
                    friend.id = id
                    friend.name = name
                    friend.avatar = "http://graph.facebook.com/\(id)/picture?type=large"
                    self.friendList.append(friend)
                    
                }
                self.tableView.reloadData()
                Webservice.closeBlocking(true)
                
            } else {
                
                print("Error Getting Friends \(error)");
               Webservice.closeBlocking(true)
                
            }
        }
        
    }
    func refreshTableView()
    {
//        if(FB.hasActiveSession()){
//            FB.getFacebookFriends()
//            FBEvent.onFacebookFriend().listen(self, callback: { [unowned self] (friends) -> Void in
//                self.friendList = friends
//                self.tableView.reloadData()
//                })
//        }else{
//            print("FACEBOOK DOES NOT HAVE ACTIVE SESSION");
//        }

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backAction(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    func showAlert(message: String)
    {
        let alertView = UIAlertController(title: "Alert", message: message, preferredStyle: .Alert)
        alertView.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
        self.presentViewController(alertView, animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
extension InviteFaceBookFriendViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("fbCell") as! FBCell
                    cell.avatar.layer.borderWidth = 0.0
            cell.avatar.layer.masksToBounds = false
            cell.avatar.layer.borderColor = UIColor.clearColor().CGColor
            //            cell.avatar.layer.cornerRadius = cell.avatar.frame.size.width/2.0
            cell.bind(friendList[indexPath.row])

        return cell
    }
}
//MARK: - Table View Delegate
//extension InviteFaceBookFriendViewController: UITableViewDelegate {
//
//    
//}
class FBCell: UITableViewCell
{
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var name: UILabel!
    var index: String = ""
    @IBAction func addAction(sender: UIButton) {
        print(self.index)
        Net.getUserInfoById(self.index).onSuccess(callback:  {(senduser) -> Void in
            DBManager.saveUser(senduser, text: nil, date: nil)
            sender.backgroundColor = UIColor.grayColor()
            sender.enabled = false
            FBEvent.alertMessageReceived(self.name.text! + " is added")
        }).onFailure(callback: {(_) -> Void in
            FBEvent.alertMessageReceived(self.name.text! + " is not member of AcroYoga")
            
        })
        
    }
    func bind(friend: FacebookFriend)
    {
        let name = friend.name
        let avatar = friend.avatar
        self.name.text = name
        if let url = NSURL(string: avatar) {
            self.avatar.nk_cancelLoading()
            self.avatar.nk_setImageWith(url)
        }
        index = friend.id
        let flag = DBManager.checkUser(friend.id)
        if flag
        {
            self.addButton.backgroundColor = UIColor.grayColor()
        }
        self.addButton.enabled = !flag
        self.addButton.layer.borderColor = UIColor.grayColor().CGColor
        self.addButton.layer.borderWidth = 1
        self.addButton.layer.cornerRadius = 4
        self.avatar.layer.cornerRadius = self.avatar.frame.height / 2
        self.addButton.addTarget(self, action: #selector(FBCell.addAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
    }
}

//
//  ShareViewController.swift
//  AcroYoga
//
//  Created by SCAR on 3/21/16.
//  Copyright © 2016 ku. All rights reserved.
//
import UIKit
import CoreData

class MessageViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var messageList: [String: AnyObject]!
    var keys:Array<String> = Array<String>()
    var newkeys:Array<String> = Array<String>()
    var timer: NSTimer!
    var timerPause = true
    override func viewDidLoad() {
        super.viewDidLoad()
        messageInfo()
        
    }
    override func viewWillAppear(animated: Bool) {
        if timerPause
        {
            timer = NSTimer.scheduledTimerWithTimeInterval(20, target: self, selector: #selector(MessageViewController.loadMessages), userInfo: nil, repeats: true)
            timerPause = false
        }
    }
    func messageInfo()
    {
        var user: User?
        let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        //2
        let fetchRequest = NSFetchRequest(entityName: "User")
        
        //3
        do {
            let results =
                try managedContext.executeFetchRequest(fetchRequest)
            user = results.first as? User
        } catch _ as NSError {
            return
        }
        
        if user != nil
        {
            
            let message: [String: AnyObject] = (user?.messages)! as! [String : AnyObject]
            //            self.messages = userIDsArray.allValues
            messageList = message
            let lazyMapCollection = message.keys
            let userKeys = Array(lazyMapCollection)
            keys = userKeys
            print(keys)
            
            
        }
        if tableView != nil
        {
            tableView.reloadData()
        }
    }
    func loadMessages()
    {
        if let user = UserProfile.currentUser()
        {
            
            Net.NewMessage(["receiver": user.facebookid!]).onSuccess(callback: {(list) -> Void in
                for i in 0 ..< list.count
                {
                    var checkdoubleaNewKey = false
                    if list[i].uid == ""
                    {
                        return
                    }
                    for j in 0 ..< self.newkeys.count
                    {
                        if list[i].uid == self.newkeys[j]
                        {
                            checkdoubleaNewKey = true
                            break
                        }
                    }
                    if !DBManager.checkUser(list[i].uid)
                    {
                        if !checkdoubleaNewKey
                        {
                            self.newkeys.append(list[i].uid)
                            Net.getUserInfoById(list[i].uid).onSuccess(callback:  {(senduser) -> Void in
                                DBManager.saveUser(senduser, text: list[i].text, date: list[i].date)
                                self.messageInfo()
                            })
                        }
                    }else{
                        DBManager.saveInputMessage(list[i].uid, text: list[i].text, date: list[i].date)
                    }
                    
                    
                }
            })
            self.messageInfo()
        }

    }
    
}
extension MessageViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return keys.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("chatCell") as! ChatCell
        if let chatInfo = messageList[keys[indexPath.row] ] as? [String: AnyObject]
        {
            //sign new person
            var flag = true
            for i in 0 ..< newkeys.count
            {
                if keys[indexPath.row] == newkeys[i]
                {
                    flag = false
                }
            }
            cell.newIcon.hidden = flag
            cell.nameLabel.text = chatInfo["username"] as? String
            cell.messageLabel.text = "I am ready for you. Do you..."
            let avatar = chatInfo["avatar"] as! String
            let messages = chatInfo["messages"]
            //set lastmessage
            if let chatMessages = NSKeyedUnarchiver.unarchiveObjectWithData((messages as? NSData)!)         {
                let messageList = chatMessages as! [ChatMessage]
                if messageList.count > 0
                {
                    cell.messageLabel.text = messageList[messageList.count-1].text
                    cell.timeLabel.text  = messageList[messageList.count-1].time
                }
            }
            cell.avatar.layer.borderWidth = 0.0
            cell.avatar.layer.masksToBounds = false
            cell.avatar.layer.borderColor = UIColor.clearColor().CGColor
            cell.selectionStyle = .None
//            cell.avatar.layer.cornerRadius = cell.avatar.frame.size.width/2.0
            UserProfile.getImage(avatar, completition:{ (image) -> Void in
                cell.avatar.image = image
            })
        }
        
        return cell
    }
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool
    {
        return true
    }
}
//MARK: - Table View Delegate
extension MessageViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("Row \(indexPath.row) was selected")
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! ChatCell
        cell.newIcon.hidden = true
        
        for i in 0 ..< newkeys.count
        {
            if newkeys[i] == keys[indexPath.row]
            {
                newkeys.removeAtIndex(i)
                break
            }
        }
        if !timerPause
        {
            self.timer.invalidate()
            timerPause = true
        }
        let chatViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ChatViewController") as? ChatViewController
        chatViewController!.cdKey = keys[indexPath.row]
        
        self.presentViewController(chatViewController!, animated: true, completion: nil)
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        switch editingStyle {
        case .Delete:
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            keys.removeAtIndex(indexPath.row)
        case .Insert:
            tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        case .None:
            
            return
        }
    }
    
}
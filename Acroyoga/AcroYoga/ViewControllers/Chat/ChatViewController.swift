//
//  ChatViewController.swift
//  Flirtbox
//
//  Created by Azamat Valitov on 10.11.15.
//  Copyright © 2015 flirtbox. All rights reserved.
//

import UIKit
import CoreData
class ChatMessage: NSObject, NSCoding {
    var text: String!
    var time: String!
    var avatar: String?
    var isMy: Bool
    init(text: String, time: String, isMy: Bool, avatar: String) {
        self.text = text
        self.time = time
        self.avatar = avatar
        self.isMy = isMy
    }
    required convenience init?(coder decoder: NSCoder) {
        guard let text = decoder.decodeObjectForKey("text") as? String,
            let time = decoder.decodeObjectForKey("time") as? String,
            let avatar = decoder.decodeObjectForKey("avatar") as? String
            else { return nil }
        
        self.init(
            text: text,
            time: time,
            isMy: decoder.decodeBoolForKey("isMy"),
            avatar: avatar
        )
    }
    
    func encodeWithCoder(coder: NSCoder) {
        coder.encodeObject(self.text, forKey: "text")
        coder.encodeObject(self.time, forKey: "time")
        coder.encodeObject(self.avatar, forKey: "avatar")
        coder.encodeBool(self.isMy, forKey: "isMy")
    }
}
class ChatUser{
    var name: String!
    var facebookId: String!
    var avatar: String
    var date: String!
    var message: AnyObject!
    init(name: String, facebookId: String, avatar: String, date: String, message: AnyObject?) {
        self.name = name
        self.facebookId = facebookId
        self.avatar = avatar
        self.date = date
        self.message = message
    }
}
protocol ChatDelegate{
	func archiveConversation (conversation : AYMessage, completionHandler: (result: Bool)->());
	func deleteConversation (conversation : AYMessage, completionHandler: (result: Bool)->());
}
class ChatViewController: UIViewController, UITextViewDelegate, ChatTableViewCellDelegate {

    var cdKey: String?
    var user: ChatUser?
	var converser : AYUser?
    var message: AYMessage?
    private var chatMessages:[ChatMessage] = []
	var chatDelegate : ChatDelegate?;
    var timer: NSTimer!
    var timerFlag = false
    // MARK: - Lifecycle
	
//	var type: eConversationType = .Indefinite;
	
	
    override func viewDidLoad() {
		super.viewDidLoad();
//		if(self.type != .Inbox){
//			self.archiveButton.hidden = true;
//		}
		initUser()
//		self.archiveButton.addTarget(self, action: #selector(ChatViewController.archiveTapped(_:)), forControlEvents: .TouchUpInside)
//		self.deleteButton.addTarget(self, action:#selector(ChatViewController.deleteTapped(_:)), forControlEvents: .TouchUpInside);
        self.userNameWithAge.text = " "
//        self.searchLabel.text = " "
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 50
        let bgView = UIView(frame: self.view.bounds)
        bgView.backgroundColor = UIColor(red: 235.0/255.0, green: 235.0/255.0, blue: 235.0/255.0, alpha: 1.0)
        let closeBtn = UIButton(type: .Custom)
        closeBtn.frame = self.view.bounds
        closeBtn.addTarget(self, action: #selector(ChatViewController.closeKeyboard), forControlEvents: .TouchUpInside)
        bgView.addSubview(closeBtn)
        tableView.backgroundView = bgView
        
        userAvatar.layer.borderWidth = 0.0
        userAvatar.layer.masksToBounds = false
        userAvatar.layer.borderColor = UIColor.clearColor().CGColor
        userAvatar.layer.cornerRadius = userAvatar.frame.size.width/2.0
        userAvatar.clipsToBounds = true
		userAvatar.userInteractionEnabled = true;
		
        if let sendUser = UserProfile.currentUser() {
            self.converser = sendUser
            configureWithUser(sendUser)
//            loadNewMessage()
            if !timerFlag
            {
                timer = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: #selector(ChatViewController.loadNewMessage), userInfo: nil, repeats: true)
                timerFlag = true
            }
        }
    }
	
	func archiveTapped(sender : UIButton){
		self.chatDelegate?.archiveConversation(self.message!){ result in
			self.navigationController?.popViewControllerAnimated(true);
		};
	}
	func deleteTapped(sender : UIButton){
		self.chatDelegate?.deleteConversation(self.message!){ result in
			self.navigationController?.popViewControllerAnimated(true);
		};
	}
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        messageTextView.becomeFirstResponder()
    }
    private var myUserName: String!
    private func configureWithUser(usr: AYUser) {
        myUserName = usr.username
        if let user = self.user {
            if let url = NSURL(string: user.avatar) {
                userAvatar.nk_cancelLoading()
                userAvatar.nk_setImageWith(url)
            }
//            self.locationImage.hidden = false
            self.userNameWithAge.text = user.name
//			if let country = user.country{
//				if country.length > 0 && user.town.length > 0 {
//					self.userLocation.text = country + ", " + user.town
//				}else if country.length == 0 && user.town.length > 0 {
//					self.userLocation.text = user.town
//				}else if country.length > 0 && user.town.length == 0 {
//					self.userLocation.text = user.country
//				}else{
//					self.userLocation.text = " "
//					self.locationImage.hidden = true
//				}
//			}
            
            if let messages = NSKeyedUnarchiver.unarchiveObjectWithData((user.message as? NSData)!)         {
                self.chatMessages = messages as! [ChatMessage]
            }
            self.tableView.reloadData()
        }
   
        

    }
    func loadNewMessage()
    {
//        let params = [String: AnyObject]()
        if let user = UserProfile.currentUser()
        {
            
            Net.NewMessage(["receiver": user.facebookid!]).onSuccess(callback: {(list) -> Void in
                for i in 0 ..< list.count
                {
                    if list[i].uid == ""
                    {
                        return
                    }
                    if list[i].uid == self.cdKey
                    {
                        let item = ChatMessage(text: list[i].text, time: list[i].date, isMy: false, avatar: self.user!.avatar)
                        self.chatMessages.append(item)
                         self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: self.chatMessages.count - 1, inSection: 0)], withRowAnimation: .Bottom)
                        FBoxHelper.delay(0.5, closure: { () -> () in
                        self.scrollToBottom()
                        })
                    }
                }
            })
        }
        
    }
    
    //get chating user information and old messages from core data
    func initUser()
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
            if let key = self.cdKey
            {
                if let messageDetail = message[key]
                {
                    let name = messageDetail["username"] as! String
                    let avatar = messageDetail["avatar"] as! String
                    let chatMessages = messageDetail["messages"]
                    let chatUser = ChatUser(name: name, facebookId: key, avatar: avatar, date: "", message: chatMessages)
                        self.user = chatUser
                    
                }
                
            }
            
        }

    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ChatViewController.keyboardWillChangeFrame(_:)), name: UIKeyboardWillChangeFrameNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ChatViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        saveMessages()
        NSNotificationCenter.defaultCenter().removeObserver(self)
        if timerFlag
        {
            timer.invalidate()
        }
    
    }
    
    func keyboardWillChangeFrame(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue() {
            bottomConstraint.constant = keyboardSize.height
            UIView.animateWithDuration(FBoxConstants.kAnimationDuration, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: .CurveEaseInOut, animations: { () -> Void in
                self.view.layoutIfNeeded()
                }, completion:{(_) -> Void in
            })
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        bottomConstraint.constant = 0.0
        UIView.animateWithDuration(FBoxConstants.kAnimationDuration, delay: 0.0, usingSpringWithDamping: FBoxConstants.kAnimationDamping, initialSpringVelocity: FBoxConstants.kAnimationInitialVelocity, options: .CurveEaseInOut, animations: { () -> Void in
            self.view.layoutIfNeeded()
            }, completion:{(_) -> Void in
                
        })
    }
    
    // MARK: - Outlets
    @IBOutlet weak var archiveButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
//    @IBOutlet weak var locationImage: UIImageView!
//    @IBOutlet weak var searchLabel: UILabel!
    @IBOutlet weak var userNameWithAge: UILabel!
    @IBOutlet weak var userAvatar: UIImageView!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var emptyLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageHeight: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!

    // MARK: - Actions
//	@IBAction func openProfileAction(sender: AnyObject) {
//		if self.user == nil && self.message != nil {
//			Net.userData(self.message!.username, animated: true).onSuccess(callback: { (user) -> Void in
//				if let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ProfileViewController") as? ProfileViewController {
//					controller.userDetailed = user
//					self.navigationController?.pushViewController(controller, animated: true)
//				}
//			})
//		}
//	}

	@IBAction func backAction(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func sendAction(sender: AnyObject) {
        var userName: String? = nil
        if let user = self.user {
            userName = user.name
        }
        if let _ = userName where (messageTextView.text as NSString).length > 0 {
            let msgText = messageTextView.text
            let now = NSDate().dateBySubtractingSeconds(NSTimeZone.localTimeZone().secondsFromGMT)
            if converser != nil
            {
            let params = [AYNet.KEY_MESSAGE_SENDERID: converser!.facebookid, AYNet.KEY_MESSAGE_RECEIVERID: self.user?.facebookId, AYNet.KEY_MESSAGE_TEXT: messageTextView.text, AYNet.KEY_MESSAGE_DATE: now.toString(format: .Custom("yyyy-MM-dd HH:mm"))]
            
            Net.requestServer(AYNet.Insert_chatmessage_URL, params: params).onSuccess(callback: { (_) -> Void in
//                let now = NSDate().dateBySubtractingSeconds(NSTimeZone.localTimeZone().secondsFromGMT)
                self.chatMessages.append(ChatMessage(text: msgText, time: now.toString(format: .Custom("yyyy-MM-dd HH:mm")), isMy:true, avatar: ""))
                self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: self.chatMessages.count - 1, inSection: 0)], withRowAnimation: .Bottom)
                FBoxHelper.delay(0.5, closure: { () -> () in
                    self.scrollToBottom()
                })
            }).onFailure { (error) -> Void in
//                UIAlertView(title: "ERROR", message: error.localizedDescription, delegate: nil, cancelButtonTitle: "OK").show()
            }
            messageTextView.text = ""
            computeHeight()
            checkEmpty()
        }
        }
    }
    func saveMessages()
    {
        if self.user == nil
        {
            return
        }
        var people: User?
        let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        //2
        let fetchRequest = NSFetchRequest(entityName: "User")
        
        //3
        do {
            let results =
                try managedContext.executeFetchRequest(fetchRequest)
            people = results.first as? User
        } catch _ as NSError {
            return
        }
        var dic:[String : AnyObject] = (people?.messages)! as! [String: AnyObject]
        if let key = self.cdKey
        {
            let messages = self.chatMessages
            let msgs = NSKeyedArchiver.archivedDataWithRootObject(messages)
//            do {
//                messages = try NSKeyedUnarchiver.unarchiveObjectWithData(msgs) as! [ChatMessage]
//            } catch let error as NSError  {
//                print("Could not save \(error), \(error.userInfo)")
//            }
            var dictionary: [String : AnyObject] = Dictionary()
            dictionary["messages"] = msgs
            dictionary["username"] = self.user?.name
            dictionary["avatar"] = self.user?.avatar
            dic[key] = dictionary
            people?.messages = dic
            do {
                try managedContext.save()
            } catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
            }
        }

       

    }
    @IBAction func profileAction(sender: AnyObject) {
        if let currentUser = self.user
        {
        let profileDetailVC = self.storyboard!.instantiateViewControllerWithIdentifier("ProfileDetailViewController") as! ProfileDetailViewController
        profileDetailVC.userID = currentUser.facebookId
        self.showViewController(profileDetailVC, sender: sender)
        }
    }
    // MARK: - UITextViewDelegate
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        return true
    }
    func textViewShouldEndEditing(textView: UITextView) -> Bool {
        return true
    }
    func textViewDidBeginEditing(textView: UITextView) {
        scrollToBottom()
    }
    func textViewDidChange(textView: UITextView) {
        checkEmpty()
        computeHeight()
    }
    
//    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
//        if text == "\n" {
//            textView.text = ""
//            textView.resignFirstResponder()
//            return false
//        }
//        return true
//    }
    
    // MARK: - UITableView
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatMessages.count
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        closeKeyboard()
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell? = nil
        let chatMessage = chatMessages[indexPath.row]
        if !chatMessage.isMy {
            cell = tableView.dequeueReusableCellWithIdentifier("ChatTableViewCell", forIndexPath: indexPath)
        }else{
            cell = tableView.dequeueReusableCellWithIdentifier("ChatMyTableViewCell", forIndexPath: indexPath)
        }
        if let chatTableViewCell = cell as? ChatTableViewCell {
			chatTableViewCell.configureWithData(chatMessage.text, timeStr: chatMessage.time, usersAvatar: chatMessage.avatar);
			chatTableViewCell.delegate = self;
        }
        if let chatMyTableViewCell = cell as? ChatMyTableViewCell {
            chatMyTableViewCell.configureWithData(chatMessage.text, timeStr: chatMessage.time)
        }
        return cell!
    }
	
    func tableView(tableView: UITableView, didEndDisplayingCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if let chatTableViewCell = cell as? ChatTableViewCell {
            chatTableViewCell.avatar.nk_cancelLoading()
        }
    }
    // MARK: - Helper methods
    private func scrollToBottom() {
        if self.tableView.contentSize.height > self.tableView.frame.size.height {
            tableView.setContentOffset(CGPointMake(0, tableView.contentSize.height - self.tableView.frame.size.height), animated: true)
        }
    }
    private func checkEmpty() {
        if (messageTextView.text as NSString).length > 0 {
            emptyLabel.hidden = true
        }else{
            emptyLabel.hidden = false
        }
    }
    func closeKeyboard(){
        self.view.endEditing(true)
    }
    private let kMaxHeight: CGFloat = 80
    private let kDefaultHeight: CGFloat = 40
    private func computeHeight() {
        let attributes = [NSFontAttributeName : messageTextView.font!]
        let rect = messageTextView.text!.boundingRectWithSize(CGSizeMake(messageTextView.frame.size.width - 12 , kMaxHeight), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: attributes, context: nil)
        var height = rect.height
        if height < 40 {
            height = 40
        }
        if height > kMaxHeight {
            height = kMaxHeight
        }
        messageHeight.constant = height
        self.view.layoutIfNeeded()
    }
	
	//MARK: -OpenProfile stuff
//	private func openConverserProfile(){
//		if let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ProfileViewController") as? ProfileViewController {
//			controller.userDetailed = self.converser
//			FBoxHelper.getMainController()?.hideMenuButton(false)
//			self.navigationController?.pushViewController(controller, animated: true)
//		}
//	}	
	//MARK: - ChatTableViewCellDelegate
	func imageTapped() {
//		self.openConverserProfile();
	}
}

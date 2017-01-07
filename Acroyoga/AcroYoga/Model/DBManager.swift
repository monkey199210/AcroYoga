//
//  DBManager.swift
//  AcroYoga
//
//  Created by GLOW on 9/16/16.
//  Copyright © 2016 ku. All rights reserved.
//
import Foundation
import CoreData
class DBManager{
    
    class func checkUser(uid: String) -> Bool {
        let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        //2
        let fetchRequest = NSFetchRequest(entityName: "User")
        
        //3
        var firstUser: User!
        do {
            let results =
                try managedContext.executeFetchRequest(fetchRequest)
            if results.count > 0
            {
                firstUser = results.first as! User
                let message: [String: AnyObject] = (firstUser?.messages)! as! [String : AnyObject]
                //            self.messages = userIDsArray.allValues
                let lazyMapCollection = message.keys
                let keys = Array(lazyMapCollection)
                for i in 0 ..< keys.count
                {
                    if uid == keys[i]
                    {
                        return true
                    }
                }
            }
        } catch _ as NSError {
            return false
        }
        return false
    }
    class func saveUser(user: AYUser, text: String?, date: String?)
    {
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
        var msgList = [ChatMessage]()
        if let txt = text
        {
            let msg = ChatMessage(text: txt, time: date!, isMy: false, avatar: user.profileMainImage!)
            msgList.append(msg)
        }
        var dic:[String : AnyObject] = (people?.messages)! as! [String: AnyObject]
        let messages = NSKeyedArchiver.archivedDataWithRootObject(msgList)
        var dictionary: [String : AnyObject] = Dictionary()
        dictionary["messages"] = messages
        dictionary["username"] = user.username
        dictionary["avatar"] = user.profileMainImage
        dic[user.facebookid!] = dictionary
        people?.messages = dic
        do {
            try managedContext.save()
            
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }

    }
    class func saveInputMessage(uid: String, text: String?, date: String?)
    {
        var person:User?
        let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        //2
        let fetchRequest = NSFetchRequest(entityName: "User")
        
        //3
        do {
            let results =
                try managedContext.executeFetchRequest(fetchRequest)
            person = results.first as? User
        } catch _ as NSError {
            return
        }
        
        if person != nil
        {
            
            var dic: [String: AnyObject] = (person?.messages)! as! [String : AnyObject]
            //            self.messages = userIDsArray.allValues
                if let messageDetail = dic[uid]
                {
                    let name = messageDetail["username"] as! String
                    let avatar = messageDetail["avatar"] as! String
                    let msgData = messageDetail["messages"]
                    var chatMessageList = NSKeyedUnarchiver.unarchiveObjectWithData((msgData as? NSData)!) as? [ChatMessage]
                    
                    if chatMessageList != nil
                    {
                        if let txt = text
                        {
                            let msg = ChatMessage(text: txt, time: date!, isMy: false, avatar: avatar)
                            chatMessageList?.append(msg)
                        }
                        let messages = NSKeyedArchiver.archivedDataWithRootObject(chatMessageList!)
                        var dictionary: [String : AnyObject] = Dictionary()
                        dictionary["messages"] = messages
                        dictionary["username"] = name
                        dictionary["avatar"] = avatar
                        dic[uid] = dictionary
                        person?.messages = dic
                        do {
                            try managedContext.save()
                            
                        } catch let error as NSError  {
                            print("Could not save \(error), \(error.userInfo)")
                        }
                    }
                }
            
        }
        
    }
    
}
//
//  Net.swift
//  AcroYoga
//
//  Created by Rui Caneira on 9/10/16.
//  Copyright © 2016 ku. All rights reserved.
//

import Foundation
import BrightFutures

class Net {
    private static let kMeRequestKey = "kMeRequestKey"
    class func me() -> Future<AYUser, NSError> {
        let promise = Promise<AYUser, NSError>()
        let urlString = AYNet.me
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let userID = userDefaults.objectForKey("userid")
        //        Webservice.cancelRequestForKey(kMeRequestKey)
        Webservice.request(urlString, params: [AYNet.USERFACEBOOKID: userID!], animated: true).onSuccess { (result: WebResult<AYUser>) -> Void in
            promise.success(result.value!)
            }.onFailure { (error) -> Void in
                print("Error: \(error)")
                promise.failure(error)
        }
        return promise.future
    }
    
    class func getUserInfoById(uid: String) -> Future<AYUser, NSError> {
        let promise = Promise<AYUser, NSError>()
        let urlString = AYNet.me
        //        Webservice.cancelRequestForKey(kMeRequestKey)
        Webservice.request(urlString, params: [AYNet.USERFACEBOOKID: uid], animated: true).onSuccess { (result: WebResult<AYUser>) -> Void in
            promise.success(result.value!)
            }.onFailure { (error) -> Void in
                print("Error: \(error)")
                promise.failure(error)
        }
        return promise.future
    }
    
    //Register User.
    class func requestUser() -> Future<Bool, NSError>
    {
        let promise = Promise<Bool, NSError>()
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let username = userDefaults.objectForKey("username")
        let userID = userDefaults.objectForKey("userid")
        let mainImageUrl = userDefaults.objectForKey("userImage")
        let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        if( appDelegate.deviceToken == nil)
        {
            appDelegate.deviceToken = "aaaa"
        }
        if let token = appDelegate.deviceToken
        {
            Webservice.request(AYNet.ACROYOGA_LOGIN, params: [ AYNet.USERFACEBOOKID: userID!, AYNet.USERNAME: username!, AYNet.USERMAINIMAGEURL: mainImageUrl!, AYNet.KEY_DEVICE_TOKEN: token ], animated: true).onSuccess { (result: WebResult<AYResult>) -> Void in
                if result.value?.message == "success" {
                    promise.success(true)
                }else{
                    let error = NSError(domain: result.value!.message, code: 1, userInfo: nil)
                    promise.failure(error)
                }
                }.onFailure { (error) -> Void in
                    print("Error: \(error)")
                    promise.failure(error)
            }
        }else{
            
            Webservice.closeBlocking(true)
        }
        
        return promise.future
    }
    class func requestServer(urlString: String, params: [String: AnyObject]) -> Future<Bool, NSError>
    {
        let promise = Promise<Bool, NSError>()
        //        let userDefaults = NSUserDefaults.standardUserDefaults()
        //        let username = userDefaults.objectForKey("username")
        //        let userID = userDefaults.objectForKey("userid")
        //        let mainImageUrl = userDefaults.objectForKey("userImage")
        Webservice.request(urlString, params: params, animated: true).onSuccess { (result: WebResult<AYResult>) -> Void in
            if result.value?.message == "success" {
                promise.success(true)
            }else{
                let error = NSError(domain: result.value!.message, code: 1, userInfo: nil)
                promise.failure(error)
            }
            }.onFailure { (error) -> Void in
                print("Error: \(error)")
                promise.failure(error)
        }
        
        return promise.future
    }
    class func searchUsers(params: [String: AnyObject]) -> Future<[AYUser], NSError> {
        let promise = Promise<[AYUser], NSError>()
        let urlString = AYNet.SEARCH_URL
        //        Webservice.cancelRequestForKey(kMeRequestKey)
        Webservice.request(urlString, params: params, animated: true).onSuccess { (result: WebResult<AYUser>) -> Void in
            promise.success(result.array)
            }.onFailure { (error) -> Void in
                print("Error: \(error)")
                promise.failure(error)
        }
        return promise.future
    }
    class func NewMessage(params: [String: AnyObject]) -> Future<[AYMessage], NSError> {
        let promise = Promise<[AYMessage], NSError>()
        let urlString = AYNet.check_chatting_message
        //        Webservice.cancelRequestForKey(kMeRequestKey)
        Webservice.request(urlString, params: params, animated: true).onSuccess { (result: WebResult<AYMessage>) -> Void in
            promise.success(result.array)
            }.onFailure { (error) -> Void in
                print("Error: \(error)")
                promise.failure(error)
        }
        return promise.future
    }
    
    
    //    class func uploadProfileImage(Index: Int, image: UIImage) -> Future<Bool, NSError>
    //    {
    //        let promise = Promise<Bool, NSError>()
    //        let userDefaults = NSUserDefaults.standardUserDefaults()
    //        let userID = userDefaults.objectForKey("userid")
    //        let urlString = AYNet.UPLOAD_PROFILEIMAGE1
    //        let date = NSDate()
    //        let calendar = NSCalendar.currentCalendar()
    //        let components = calendar.components([.Hour , .Minute , .Second, .Day , .Month , .Year], fromDate: date)
    //        let fileName = "\(components.year)\(components.month)\(components.day)\(components.hour)\(components.minute)\(components.second)"
    //        let parameters = [
    //            AYNet.USERFACEBOOKID: userID!,
    //            AYNet.KEY_PROFILEIMAGENAME: fileName,
    //            AYNet.KEY_IMAGEURL:"" ,
    //        ]
    ////
    ////        let postDataProlife:[String:AnyObject] = ["CardId":(dataCardDetail?.userId)!,"ImageType":1,"ImageData":imageView.image!]
    //        Webservice.uplaodImageData(urlString, postData: parameters, animated: true).onSuccess { (result: WebResult<AYResult>) -> Void in
    //            if result.value?.message == "success" {
    //                promise.success(true)
    //            }else{
    //                let error = NSError(domain: result.value!.message, code: 1, userInfo: nil)
    //                promise.failure(error)
    //            }
    //            }.onFailure { (error) -> Void in
    //                print("Error: \(error)")
    //                promise.failure(error)
    //        }
    //        return promise.future
    //    }
    class func uploadImage(image: UIImage, index: Int, progressCallback: (Double->Void)? = nil) -> Future<Bool, NSError> {
        let keyList = [AYNet.KEY_MAINPROFILEIMAGE, AYNet.KEY_PROFILEIMAGENAME1, AYNet.KEY_PROFILEIMAGENAME2, AYNet.KEY_PROFILEIMAGENAME3]
        let imageData = NSData(data: UIImageJPEGRepresentation(image, 1.0)!)
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let userID = userDefaults.objectForKey("userid")
        let urlString = AYNet.UPLOAD_PROFILEIMAGE1
        
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Hour , .Minute , .Second, .Day , .Month , .Year], fromDate: date)
        let fileName = "\(components.year)\(components.month)\(components.day)\(components.hour)\(components.minute)\(components.second)"
        let parameters = [
            AYNet.USERFACEBOOKID: userID! as! String,
            keyList[index]: fileName
        ]
        
        return ImageUploader.uploadImage(urlString, params: parameters, imageData: imageData, progressCallback: progressCallback)
    }
    
    
}
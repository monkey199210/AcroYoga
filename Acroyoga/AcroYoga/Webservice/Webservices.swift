//
//  Webservices.swift
//  AcroYoga
//
//  Created by Rui Caneira on 9/9/16.
//  Copyright © 2016 ku. All rights reserved.
//

import Foundation
import Alamofire
import MRProgress
import Genome
import BrightFutures
import Async
struct AYNet {
    
    static let baseUrl = "https://maps.googleapis.com/maps/api/geocode/json?"
    static let apikey = "AIzaSyDJB1td3VUEUGwakZ4yehMLn_66luNweAY"
    
    static let  INFO_TO_DETAIL = "goodsinfo_to_detail"
    static let  INFO_TO_MESSAGE = "go to Message"
    static let INFO_TO_CHAT = "go_to_chat"
    
    static let  me = "http://www.myacroyoga.com/AcroYoga/me.php"
    static let  SEARCH_URL = "http://www.myacroyoga.com/AcroYoga/search_users.php"
    static let  UPLOADPROFILE_URL = "http://www.myacroyoga.com/AcroYoga/uploaddata.php"
    static let UPLOADPROFILEIMAGE_URL = "http://www.myacroyoga.com/AcroYoga/uploadimg.php"
    static let NOTIFICATION_URL = "http://www.myacroyoga.com/AcroYoga/notification.php"
    static let DOWNLOADFACEBOOK_URL = "http://www.myacroyoga.com/AcroYoga/facebookfriend.php"
    
    static let UPLOADSETTING_URL = "http://www.myacroyoga.com/AcroYoga/uploadsetting.php"
    static let ACROYOGA_LOGIN = "http://www.myacroyoga.com/AcroYoga/login.php"
    static let DOWNLOADSETTING_URL = "http://www.myacroyoga.com/AcroYoga/downloadsetting.php"
    
    static let LOADRATING_URL = "http://www.myacroyoga.com/AcroYoga/check_rating.php"
    static let INSERTRATING_URL = "http://www.myacroyoga.com/AcroYoga/insertrating.php"
    
    static let Insert_chatmessage_URL = "http://www.myacroyoga.com/chatting/Insert_chatmessageios.php"
    static let check_chatting_message = "http://www.myacroyoga.com/chatting/check_chatting_messageios.php"
    static let UPLOAD_PROFILEIMAGE1 = "http://www.myacroyoga.com/AcroYoga/upload_profileImage.php"
    
    
    //sign in param
    static let USERNAME = "key_Name"
    static let USERFACEBOOKID = "key_facebookid"
    static let USERMAINIMAGEURL = "key_ImageUrl"
    static let KEY_IMAGEURL = "key_ImageUrl"
    static let KEY_PROFILEIMAGE = "key_profileImg1"
    static let KEY_PROFILEIMAGENAME1 = "key_profileImgName1"
    static let KEY_PROFILEIMAGENAME2 = "key_profileImgName2"
    static let KEY_PROFILEIMAGENAME3 = "key_profileImgName3"
    static let KEY_MAINPROFILEIMAGE = "key_profileImgName4"
    static let KEY_DETAIL = "key_detail"
    static let KEY_PHONENUMBER = "key_PhoneNumber"
    static let KEY_BASE = "key_base"
    static let KEY_FLY = "key_fly"
    static let KEY_BOTH = "key_both"
    static let KEY_LBASING = "key_lbasing"
    static let KEY_WHIP = "key_whip"
    static let KEY_POP = "key_pop"
    static let KEY_HAND = "key_hand"
    static let KEY_ACROTYPE = "key_acrotype"
    static let KEY_EXPERIENCE = "key_experience"
    static let KEY_DISTANCE = "key_distance"
    static let KEY_HIDE = "key_hide"
    static let KEY_READY = "key_ready"
    static let KEY_RATE = "key_rate"
    static let KEY_DEVICE_TOKEN = "key_device_token"
    
    static let KEY_LATITUDE = "key_lat"
    static let KEY_LONGITUDE = "key_long"
    static let KEY_SEARCH_DISTANCE = "search_distance"
    static let KEY_SEARCH_BASE = "search_base"
    static let KEY_SEARCH_FLY = "search_fly"
    static let KEY_SEARCH_BOTH = "search_both"
    static let KEY_SEARCH_LBASING = "search_lbasing"
    static let KEY_SEARCH_WHIP = "search_whip"
    static let KEY_SEARCH_POP = "search_pop"
    static let KEY_SEARCH_HAND = "search_hand"
    static let KEY_SEARCH_ACROTYPE = "search_acrotype"
    static let KEY_SEARCH_EXPERIENCE = "search_experience"
    static let KEY_MESSAGE_SENDERID = "Chatting_meId"
    static let KEY_MESSAGE_RECEIVERID = "Chatting_youId"
    static let KEY_MESSAGE_TEXT = "Chatting_msg"
    static let KEY_MESSAGE_DATE = "Chatting_date"
}
class WebResult<T> {
    var value: T?
    var array: Array<T> = []
    init(value: T?, array: Array<T>) {
        self.value = value
        self.array = array
    }
    init(value: T?) {
        self.value = value
    }
}
enum ConvertingError : ErrorType {
    case UnableToConvertJson
    case UnableToConvertJsonParsed
}
class Webservice {
    
    static func toJson(value: AnyObject) throws -> Genome.JSON {
        if let json = value as? Genome.JSON {
            return json
        } else {
            throw ConvertingError.UnableToConvertJson
        }
    }
    
    
    class func request<T: BasicMappable>(urlString: String, params: [String: AnyObject]?, animated: Bool) -> Future<WebResult<T>, NSError> {
        print(urlString)
        
        let promise = Promise<WebResult<T>, NSError>()
        //         showBlocking(animated)
        Alamofire.request(.POST, urlString, parameters: params).responseJSON { (response) -> Void in
            Async.background {
                //let dataString = NSString(data: response.data!, encoding: NSUTF8StringEncoding)
                //print(dataString)
                mapResult(response, promise: promise)
                }.main{
                    //                    closeBlocking(animated)
            }
        }
        return promise.future
    }
    
    
    
    class func uplaodImageData<T: BasicMappable>(RequestURL: String,postData:[String:AnyObject]?, animated: Bool) -> Future<WebResult<T>, NSError>  {
        let promise = Promise<WebResult<T>, NSError>()
        //        let headerData:[String : String] = ["Content-Type":"application/json"]
        
        Alamofire.request(.POST,RequestURL, parameters: postData, encoding: .URLEncodedInURL).responseJSON{ response in
            Async.background {
                //let dataString = NSString(data: response.data!, encoding: NSUTF8StringEncoding)
                //print(dataString)
                mapResult(response, promise: promise)
                }.main{
                    closeBlocking(animated)
            }
            
        }
        return promise.future
    }
    private class func mapResult<T: BasicMappable>(response: Response<AnyObject, NSError>, promise: Promise<WebResult<T>, NSError>) {
        switch response.result {
        case .Success(let value):
            Async.background {
                do {
                    if let array = value as? NSArray {
                        var resultArray: Array<T> = []
                        for arrayValue in array {
                            let json = try toJson(arrayValue)
                            let resultObject = try T.mappedInstance(json)
                            resultArray.append(resultObject)
                        }
                        Async.main {
                            promise.success(WebResult(value: nil, array: resultArray))
                        }
                    }else{
                        let json = try toJson(value)
                        let resultObject = try T.mappedInstance(json)
                        Async.main {
                            promise.success(WebResult(value: resultObject))
                        }
                    }
                } catch {
                    handleError(error)
                    Async.main {
                        promise.failure(NSError(domain: "UnableToConvertJson", code: -1, userInfo: nil))
                    }
                }
            }
        case .Failure(let error):
            handleError(error)
            promise.failure(error)
        }
    }
    class func handleError(error: ErrorType) {
        print(error)
    }
    // MARK: - progress HUD
    private static var isBlocked = false
    private static var blockCount: Int = 0 {
        didSet {
            if !isBlocked && blockCount > 0 {
                isBlocked = true
                MRProgressOverlayView.showOverlayAddedTo(FBoxHelper.getWindow(), title: "", mode: .Indeterminate, animated: true)
            }else if isBlocked && blockCount == 0 {
                isBlocked = false
                MRProgressOverlayView.dismissOverlayForView(FBoxHelper.getWindow(), animated: true)
            }
        }
    }
    class func showBlocking(animated: Bool) {
        if animated {
            self.blockCount += 1
        }
    }
    class func closeBlocking(animated: Bool) {
        if animated {
            self.blockCount -= 1
            if self.blockCount < 0 {
                print("blockCount < 0")
                self.blockCount = 0
            }
        }
    }
    private static var requestsForKey: [String: Request] = [:]
    class func cancelRequestForKey(key: String) {
        if let request = requestsForKey[key] {
            request.cancel()
            requestsForKey.removeValueForKey(key)
        }
    }
    func urlRequestWithComponents(urlString:String, parameters:Dictionary<String, String>, imageData:NSData) -> (URLRequestConvertible, NSData) {
        
        // create url request to send
        let mutableURLRequest = NSMutableURLRequest(URL: NSURL(string: urlString)!)
        mutableURLRequest.HTTPMethod = Alamofire.Method.POST.rawValue
        let boundaryConstant = "myRandomBoundary12345";
        let contentType = "multipart/form-data;boundary="+boundaryConstant
        mutableURLRequest.setValue(contentType, forHTTPHeaderField: "Content-Type")
        
        
        
        // create upload data to send
        let uploadData = NSMutableData()
        
        // add image
        uploadData.appendData("\r\n--\(boundaryConstant)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        uploadData.appendData("Content-Disposition: form-data; name=\"file\"; filename=\"file.png\"\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        uploadData.appendData("Content-Type: image/png\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        uploadData.appendData(imageData)
        
        // add parameters
        for (key, value) in parameters {
            uploadData.appendData("\r\n--\(boundaryConstant)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
            uploadData.appendData("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n\(value)".dataUsingEncoding(NSUTF8StringEncoding)!)
        }
        uploadData.appendData("\r\n--\(boundaryConstant)--\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        
        
        
        // return URLRequestConvertible and NSData
        return (Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: nil).0, uploadData)
    }
    
}
//extension String {
//    static func FBURL(urlString: String) -> String {
//        let localeCode = getLocaleCode();
//        var urlDomain = "com";
//        if(localeCode == "de" || localeCode == "es"){
//            urlDomain = localeCode;
//        }
//        let url = (NSString(format: FBNet.API_BASE_URL, urlDomain) as String)  + urlString;
//        return url;
//    }
//    static func getLocaleCode()->String{
//        let locale = NSLocale.preferredLanguages()[0] as String;
//        return locale.substringToIndex(locale.startIndex.advancedBy(2));
//    }
//}

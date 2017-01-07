//
//  NetTypes.swift
//  AcroYoga
//
//  Created by Rui Caneira on 9/9/16.
//  Copyright © 2016 ku. All rights reserved.
//

import Foundation
import Genome
struct AYUser : BasicMappable {
    private(set) var username: String = ""
    private(set) var facebookid: String?
    private(set) var profileMainImage: String?
    private(set) var longitude: String?
    private(set) var latitude: String?
    private(set) var description: String = ""
    private(set) var base: String = "0"
    private(set) var fly: String = "0"
    private(set) var both: String = "0"
    private(set) var lbasing: String = "0"
    private(set) var whips: String = "0"
    private(set) var pops: String = "0"
    private(set) var hand: String = "0"
    private(set) var acrotype: String = "0"
    private(set) var rate: String = "0"
    private(set) var imgpath1: String?
    private(set) var imgpath2: String?
    private(set) var imgpath3: String?
    private(set) var ready: String = "0"
    private(set) var hide: String = "0"
    private(set) var phoneNumber: String = ""
    
    mutating func sequence(map: Map) throws {
        
        try username <~ map["name"]
        try facebookid <~ map["facebookid"]
        try profileMainImage <~ map["imgUri"]
        try phoneNumber <~ map["phoneNumber"]
        try longitude <~ map["longitude"]
        try latitude <~ map["latitude"]
        try description <~ map["des"]
        try base <~ map["base"]
        try fly <~ map["fly"]
        try both <~ map["both"]
        try lbasing <~ map["lbasing"]
        try whips <~ map["whips"]
        try pops <~ map["pops"]
        try hand <~ map["hand"]
        try acrotype <~ map["acrotype"]
        try rate <~ map["rate"]
        try imgpath1 <~ map["imgpath1"]
        try imgpath2 <~ map["imgpath2"]
        try imgpath3 <~ map["imgpath3"]
        try ready <~ map["ready"]
        try hide <~ map["hide"]
    }
}
struct AYMessage : BasicMappable {
    private(set) var uid: String = ""
    private(set) var date: String = ""
    private(set) var text: String = ""
    private(set) var readflag: String = ""
    var unreadMessages: AnyObject? = 0
    mutating func sequence(map: Map) throws {
        try uid <~ map["facebookid"]
        try date <~ map["date"]
        try text <~ map["text"]
        try readflag <~ map["read_flag"]
    }
}
struct AYResult : BasicMappable {
    //    private(set) var status: Int = 0
    private(set) var message: String = ""
    mutating func sequence(map: Map) throws {
        //        try status <~ map["status"]
        try message <~ map["msg"]
    }
}
struct FBFriends : BasicMappable {
    struct friend : BasicMappable {
        private(set) var uid: String = ""
        private(set) var name: String = ""
        var unreadMessages: AnyObject? = 0
        mutating func sequence(map: Map) throws {
            try uid <~ map["id"]
            try name <~ map["name"]
        }
    }
    private(set) var data: [friend] = []
    
    mutating func sequence(map: Map) throws {
        
        try data <~ map["data"]
    }
    
}
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
//    struct UserGeneral : BasicMappable {
//        private(set) var username: String = ""
//        private(set) var gender: String?
//        private(set) var age: String?
//        private(set) var dateOfBirth: String?
//        private(set) var starsign: String?
//        private(set) var country: String = ""
//        private(set) var town: String?
//        private(set) var description: String = ""
////        private(set) var email: FBEmail!
//        private(set) var phone: String = ""
//        mutating func sequence(map: Map) throws {
//            try username <~ map["username"]
//            try gender <~ map["gender"]
//            try age <~ map["age"]
//            try dateOfBirth <~ map["dateOfBirth"]
//            try starsign <~ map["starsign"]
//            try country <~ map["country"]
//            try town <~ map["town"]
//            try description <~ map["description"]
//            try phone <~ map["phone"]
//        }
//    }
//    private(set) var general: UserGeneral!
//    
//    struct UserLife : BasicMappable {
//        private(set) var occupation: String = ""
//        private(set) var education: String = ""
//        private(set) var profession: String = ""
//        mutating func sequence(map: Map) throws {
//            try occupation <~ map["occupation"]
//            try education <~ map["education"]
//            try profession <~ map["profession"]
//        }
//    }
//    private(set) var life: UserLife!
//    
//    private(set) var pictures: Array<String>?
//    private(set) var premium: Bool = false
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
struct AYResult : BasicMappable {
//    private(set) var status: Int = 0
    private(set) var message: String = ""
    mutating func sequence(map: Map) throws {
//        try status <~ map["status"]
        try message <~ map["msg"]
    }
}
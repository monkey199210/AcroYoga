//
//  User+CoreDataProperties.swift
//  AcroYoga
//
//  Created by GLOW on 9/13/16.
//  Copyright © 2016 ku. All rights reserved.
//

import Foundation
import CoreData

extension User {
    
    @NSManaged var username: String?
    @NSManaged var userid: String?
    @NSManaged var avatar: String?
    @NSManaged var messagedate: String?
    @NSManaged var messages: AnyObject?
    
}
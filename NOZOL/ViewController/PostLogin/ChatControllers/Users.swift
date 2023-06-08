//
//  User.swift
//  TenderApp
//
//  Created by Saurabh Chandra Bose on 31/10/19.
//  Copyright © 2019 Abhinav Saini. All rights reserved.
//

import UIKit

class Users: NSObject {
    var userID: String?
    var name: String?
    var email: String?
    var adminId: String?
    var chatID: String?
    
    init(dictionary: [String: AnyObject]) {
        self.userID = dictionary["userID"] as? String
        self.name = dictionary["name"] as? String
        self.email = dictionary["email"] as? String
        self.adminId = dictionary["adminId"] as? String
        self.chatID = dictionary["chatID"] as? String
    }
    
    override var description: String {
        let seperator1 = "------------------\n\n"
        let details = "userID - \(userID)\nname - \(name)\nemail - \(email)\nadminId - \(adminId)\nchatID - \(chatID)"
        let seperator2 = "\n\n================"
        return seperator1 + details + seperator2
    }
}

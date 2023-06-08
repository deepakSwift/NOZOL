//
//  User.swift
//  NOZOL
//
//  Created by Mukul Sharma on 16/07/20.
//  Copyright © 2020 Mukul Sharma. All rights reserved.
//

import Foundation
import SwiftyJSON


class User : NSObject{
    enum Keys: String, CodingKey{
        
        case userId =  "user_id"
        case name =    "name"
        case email =   "email"
        case countryCode = "country_code"
        case phoneNumber = "phone_number"
        case status = "status"
        case profileImage =  "profile_image"
        case id =  "id"
    }
    
    var userId =  "user_id"
    var name =    "name"
    var email =   "email"
    var countryCode = "country_code"
    var phoneNumber = "phone_number"
    var status = "status"
    var profileImage =  "profile_image"
    var id = ""
    
    
    override init() {
        super.init()
    }
    
    
    init(dict: Dictionary<String, AnyObject>) {
        
        if let userID = dict[Keys.userId.stringValue] as? String {
            self.userId = userID
        }
        if let email = dict[Keys.email.stringValue] as? String {
            self.email = email
        }
        if let name = dict[Keys.name.stringValue] as? String {
            self.name = name
        }
        if let countryCode = dict[Keys.countryCode.stringValue] as? String {
            self.countryCode = countryCode
        }
        if let phoneNumber = dict[Keys.phoneNumber.stringValue] as? String {
            self.phoneNumber = phoneNumber
        }
        
        if let status = dict[Keys.status.stringValue] as? String {
            self.status = status
        }
        if let profileImage = dict[Keys.profileImage.stringValue] as? String {
            self.profileImage = profileImage
        }
        if let id = dict[Keys.id.stringValue] as? String {
            self.id = id
        }
        super.init()
    }
    
    func saveUserJSON(_ json:JSON) {
        if (json["data"].dictionaryObject as [String: AnyObject]?) != nil {
            let documentPath = NSHomeDirectory() + "/Documents/"
            do {
                let data = try json.rawData(options: [.prettyPrinted])
                let path = documentPath + "data"
                try data.write(to: URL(fileURLWithPath: path), options: .atomic)
            }catch{
                print_debug("error in saving userinfo")
            }
            UserDefaults.standard.synchronize()
        }
    }
    class func loadSavedUser() -> User{
        let documentPath = NSHomeDirectory() + "/Documents/"
        let path = documentPath + "data"
        var data = Data()
        var json : JSON
        do{
            data = try Data(contentsOf: URL(fileURLWithPath: path))
            json = try JSON(data: data)
            print("newJson\(json)")
        }catch{
            json = JSON.init(data)
            print_debug("error in getting userinfo")
        }
        let parser = LoginParser(json: json)
        return parser.data
    }
}

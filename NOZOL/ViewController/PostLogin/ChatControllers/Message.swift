//
//  Message.swift
//  TenderApp
//
//  Created by Saurabh Chandra Bose on 31/10/19.
//  Copyright © 2019 Abhinav Saini. All rights reserved.
//

import UIKit
import Firebase

class Message: NSObject {
    
    var fromId: String?
    var text: String?
    var time: NSNumber?
    var toId: String?
    var messageType: String?
    var senderType: String?
    var mediaLink: String?
    
    
    var imageUrl: String?
    var videoUrl: String?
    var imageWidth: NSNumber?
    var imageHeight: NSNumber?
    
    init(dictionary: [String: Any]) {
        self.fromId = dictionary["userId"] as? String
        self.text = dictionary["text"] as? String
        self.time = dictionary["time"] as? NSNumber
        self.toId = dictionary["adminId"] as? String
        self.messageType = dictionary["messageType"] as? String
        self.senderType = dictionary["senderType"] as? String
        self.mediaLink = dictionary["mediaLink"] as? String
        
        self.imageUrl = dictionary["imageUrl"] as? String
        self.videoUrl = dictionary["videoUrl"] as? String
        self.imageWidth = dictionary["imageWidth"] as? NSNumber
        self.imageHeight = dictionary["imageHeight"] as? NSNumber
    }
    
    func chatPartnerId(loginUser: String) -> String? {
        //        return fromId == Auth.auth().currentUser?.uid ? toId : fromId
        return fromId == loginUser ? toId : fromId
    }
    
}


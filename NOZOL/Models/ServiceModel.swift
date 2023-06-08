//
//  ServiceModel.swift
//  NOZOL
//
//  Created by Mukul Sharma on 22/07/20.
//  Copyright © 2020 Mukul Sharma. All rights reserved.
//

import Foundation
import SwiftyJSON


class serviceModel : NSObject{
    
    enum Keys: String, CodingKey{
        case serviceID =  "service_id"
        case serviceName = "service_name"
        case price = "price"
        case desc =  "description"
        case imageUrl = "image_url"
        case id = "id"
        case subCategoryIcon = "subcategory_ican"
        case subCategoryId = "subcategory_id"
        case subCategoryName = "subcategory_name"
        case notification_id = "notification_id"
        case user_id = "user_id"
        case title = "title"
        case body = "body"
        case created_at = "created_at"
        case booking_id = "booking_id"
        case quantity = "quantity"
        case booking_status = "booking_status"
        case room_no = "room_no"
        case name = "name"
        case service_status = "service_status"
        
    }
    
    var serviceID =  ""
    var serviceName = ""
    var price = ""
    var desc =  ""
    var imageUrl = ""
    var id = ""
    var subCategoryIcon = ""
    var subCategoryId = ""
    var subCategoryName = ""
    var notification_id = ""
    var user_id = ""
    var title = ""
    var body = ""
    var created_at = ""
    var booking_id = ""
    var quantity = ""
    var booking_status = ""
    var room_no = [String]()
    var name = ""
    var service_status = ""
    
    override init() {
        super.init()
    }
    
    
    init(dict: Dictionary<String, AnyObject>) {
        
        if let serviceID = dict[Keys.serviceID.stringValue] as? String {
            self.serviceID = serviceID
        }
        if let serviceName = dict[Keys.serviceName.stringValue] as? String {
            self.serviceName = serviceName
        }
        
        if let price = dict[Keys.price.stringValue] as? String {
            self.price = price
        }
        if let desc = dict[Keys.desc.stringValue] as? String {
            self.desc = desc
        }
        if let imageUrl = dict[Keys.imageUrl.stringValue] as? String {
            self.imageUrl = imageUrl
        }
        if let id = dict[Keys.id.stringValue] as? String {
            self.id = id
        }
        if let subCategoryId = dict[Keys.subCategoryId.stringValue] as? String {
            self.subCategoryId = subCategoryId
        }
        if let subCategoryName = dict[Keys.subCategoryName.stringValue] as? String {
            self.subCategoryName = subCategoryName
        }
        if let subCategoryIcon = dict[Keys.subCategoryIcon.stringValue] as? String {
            self.subCategoryIcon = subCategoryIcon
        }
        if let notification_id = dict[Keys.notification_id.stringValue] as? String {
            self.notification_id = notification_id
        }
        if let user_id = dict[Keys.user_id.stringValue] as? String {
            self.user_id = user_id
        }
        if let title = dict[Keys.title.stringValue] as? String {
            self.title = title
        }
        if let body = dict[Keys.body.stringValue] as? String {
            self.body = body
        }
        if let created_at = dict[Keys.created_at.stringValue] as? String {
            self.created_at = created_at
        }
        if let booking_id = dict[Keys.booking_id.stringValue] as? String {
            self.booking_id = booking_id
        }
        if let quantity = dict[Keys.quantity.stringValue] as? String {
            self.quantity = quantity
        }
        if let booking_status = dict[Keys.booking_status.stringValue] as? String {
            self.booking_status = booking_status
        }
        if let room_no = dict[Keys.room_no.stringValue] as? [String] {
            self.room_no = room_no
        }
        if let name = dict[Keys.name.stringValue] as? String {
            self.name = name
        }
        if let service_status = dict[Keys.service_status.stringValue] as? String {
            self.service_status = service_status
        }
        super.init()
    }
}



class SubCategoryServiceModel : NSObject{
    enum Keys: String, CodingKey{
        
        case id = "id"
        case function = "function"
        case image_title = "image_title"
        case title = "title"
        case detail = "detail"
        case heading = "heading"
        case descr = "description"
        case created_at = "created_at"
        case updated_at = "updated_at"
        case images = "images"
        case room_number = "room_number"
        case reviews = "reviews"
        
        case banners = "banners"
        case category = "category"
        case subcategory_detail = "subcategory_detail"
        case image_url = "image_url"
        
    }
    
    var id = ""
    var function = ""
    var image_title = ""
    var title = ""
    var detail = ""
    var heading = ""
    var descr = ""
    var created_at = ""
    var updated_at = ""
    var images = [String]()
    var room_number = [String]()
    var reviews = 0
    
    var banners = [String]()
    var category = [categoryModel]()
    var subcategory_detail = subCategoryDetailModel()
    var image_url = ""
    
    override init() {
        super.init()
    }
    
    
    init(dict: Dictionary<String, AnyObject>) {

        if let id = dict[Keys.id.stringValue] as? String {
            self.id = id
        }
        if let function = dict[Keys.function.stringValue] as? String {
            self.function = function
        }
        if let image_title = dict[Keys.image_title.stringValue] as? String {
            self.image_title = image_title
        }
        if let title = dict[Keys.title.stringValue] as? String {
            self.title = title
        }
        if let detail = dict[Keys.detail.stringValue] as? String {
            self.detail = detail
        }
        if let heading = dict[Keys.heading.stringValue] as? String {
            self.heading = heading
        }
        if let created_at = dict[Keys.created_at.stringValue] as? String {
            self.created_at = created_at
        }
        if let descr = dict[Keys.descr.stringValue] as? String {
            self.descr = descr
        }
        if let updated_at = dict[Keys.updated_at.stringValue] as? String {
            self.updated_at = updated_at
        }
        if let reviews = dict[Keys.reviews.stringValue] as? Int {
            self.reviews = reviews
        }
        if let images = dict[Keys.images.stringValue] as? [String] {
            self.images = images
        }
        if let room_number = dict[Keys.room_number.stringValue] as? [String] {
            self.room_number = room_number
        }
        if let banners = dict[Keys.banners.stringValue] as? [String] {
            self.banners = banners
        }
        if let category = dict[Keys.category.stringValue] as? Array<Dictionary<String,AnyObject>>{
            for data in category {
                let tempData = categoryModel(dictionary: data)
                self.category.append(tempData)
            }
        }
        if let subcategory_detail = dict[Keys.subcategory_detail.stringValue] as? Dictionary<String,AnyObject>{
            self.subcategory_detail = subCategoryDetailModel(dictionary: subcategory_detail)
        }
        if let image_url = dict[Keys.image_url.stringValue] as? String {
            self.image_url = image_url
        }
        super.init()
    }
}




class bannersModel: NSObject{
    enum keys: String, CodingKey {
        case image_url = "image_url"
    }
    
    var image_url = ""
    override init() {
        super.init()
    }
    
    init(dictionary:[String: AnyObject]) {
        
        if let image_url = dictionary[keys.image_url.stringValue] as? String {
            self.image_url = image_url
        }
        
        super.init()
    }
}


class categoryModel: NSObject{
    enum keys: String, CodingKey {
        case image_url = "image_url"
        case subcategory_category_id = "subcategory_category_id"
        case subcategory_category_name = "subcategory_category_name"
    }
   
    var image_url = ""
    var subcategory_category_id = ""
    var subcategory_category_name = ""
    
    override init() {
        super.init()
    }
    init(dictionary:[String: AnyObject]) {
        
        if let image_url = dictionary[keys.image_url.stringValue] as? String {
            self.image_url = image_url
        }
        if let subcategory_category_id = dictionary[keys.subcategory_category_id.stringValue] as? String {
            self.subcategory_category_id = subcategory_category_id
        }
        if let subcategory_category_name = dictionary[keys.subcategory_category_name.stringValue] as? String {
            self.subcategory_category_name = subcategory_category_name
        }
        
        super.init()
    }
}


class subCategoryDetailModel: NSObject{
    enum keys: String, CodingKey {
        case subcategory_name = "subcategory_name"
        case descriptions = "description"
    }
    
    var subcategory_name = ""
    var descriptions = ""
    
    override init() {
        super.init()
    }
    init(dictionary:[String: AnyObject]) {
        if let subcategory_name = dictionary[keys.subcategory_name.stringValue] as? String {
            self.subcategory_name = subcategory_name
        }
        if let descriptions = dictionary[keys.descriptions.stringValue] as? String {
            self.descriptions = descriptions
        }
        
        super.init()
    }
}



class checkInModel : NSObject{
    enum Keys: String, CodingKey{
        
        case id = "id"
        case user_id = "user_id"
        case first_name = "first_name"
        case family_name = "family_name"
        case check_in_date = "check_in_date"
        case check_out_date = "check_out_date"
        case agent_name = "agent_name"
        case address = "address"
        case job = "job"
        case dob = "dob"
        case wife_name = "wife_name"
        case adult_no = "adult_no"
        case children_no = "children_no"
        case paymend_method = "paymend_method"
        case id_proof = "id_proof"
        case id_proof_image = "id_proof_image"
        case signature = "signature"
        case no_room = "no_room"
        case guest_no = "guest_no"
        case booking_status = "booking_status"
        case created_at = "created_at"
        
        case function = "function"
        case image_title = "image_title"
        case title = "title"
        case detail = "detail"
        case heading = "heading"
        case descriptions = "description"
        case updated_at = "updated_at"
        case banner = "banner_image"
        case images = "images"
        
        case notification = "notification"
        case zone = "zone"
        case message = "message"
        case reviews = "reviews"
        
    }
    
    var id = ""
    var user_id = ""
    var first_name = ""
    var family_name = ""
    var check_in_date = ""
    var check_out_date = ""
    var agent_name = ""
    var address = ""
    var job = ""
    var dob = ""
    var wife_name = ""
    var adult_no = ""
    var children_no = ""
    var paymend_method = ""
    var id_proof = ""
    var id_proof_image = ""
    var signature = ""
    var no_room = ""
    var guest_no = ""
    var booking_status = ""
    var created_at = ""
    var function = ""
    var image_title = ""
    var title = ""
    var detail = ""
    var heading = ""
    var descriptions = ""
    var updated_at = ""
    var banner = [String]()
    
    var notification = [NotificationModel]()
    var zone = ""
    var message = ""
    var images = [String]()
    var  reviews = 0
    
    override init() {
        super.init()
    }
    
    
    init(dict: Dictionary<String, AnyObject>) {

        if let id = dict[Keys.id.stringValue] as? String {
            self.id = id
        }
        if let user_id = dict[Keys.user_id.stringValue] as? String {
            self.user_id = user_id
        }
        if let first_name = dict[Keys.first_name.stringValue] as? String {
            self.first_name = first_name
        }
        if let family_name = dict[Keys.family_name.stringValue] as? String {
            self.family_name = family_name
        }
        if let check_in_date = dict[Keys.check_in_date.stringValue] as? String {
            self.check_in_date = check_in_date
        }
        if let check_out_date = dict[Keys.check_out_date.stringValue] as? String {
            self.check_out_date = check_out_date
        }
        if let created_at = dict[Keys.created_at.stringValue] as? String {
            self.created_at = created_at
        }
        if let agent_name = dict[Keys.agent_name.stringValue] as? String {
            self.agent_name = agent_name
        }
        if let address = dict[Keys.address.stringValue] as? String {
            self.address = address
        }
        
        if let job = dict[Keys.job.stringValue] as? String {
            self.job = job
        }
        if let dob = dict[Keys.dob.stringValue] as? String {
            self.dob = dob
        }
        if let wife_name = dict[Keys.wife_name.stringValue] as? String {
            self.wife_name = wife_name
        }
        if let adult_no = dict[Keys.adult_no.stringValue] as? String {
            self.adult_no = adult_no
        }
        if let children_no = dict[Keys.children_no.stringValue] as? String {
            self.children_no = children_no
        }
        if let paymend_method = dict[Keys.paymend_method.stringValue] as? String {
            self.paymend_method = paymend_method
        }
        if let id_proof = dict[Keys.id_proof.stringValue] as? String {
            self.id_proof = id_proof
        }
        if let id_proof_image = dict[Keys.id_proof_image.stringValue] as? String {
            self.id_proof_image = id_proof_image
        }
        if let signature = dict[Keys.signature.stringValue] as? String {
            self.signature = signature
        }
        
        if let no_room = dict[Keys.no_room.stringValue] as? String {
            self.no_room = no_room
        }
        if let guest_no = dict[Keys.guest_no.stringValue] as? String {
            self.guest_no = guest_no
        }
        if let booking_status = dict[Keys.booking_status.stringValue] as? String {
            self.booking_status = booking_status
        }
        if let created_at = dict[Keys.created_at.stringValue] as? String {
            self.created_at = created_at
        }
        if let function = dict[Keys.function.stringValue] as? String {
            self.function = function
        }
        if let image_title = dict[Keys.image_title.stringValue] as? String {
            self.image_title = image_title
        }
        if let title = dict[Keys.title.stringValue] as? String {
            self.title = title
        }
        if let detail = dict[Keys.detail.stringValue] as? String {
            self.detail = detail
        }
        if let heading = dict[Keys.heading.stringValue] as? String {
            self.heading = heading
        }
        if let descriptions = dict[Keys.descriptions.stringValue] as? String {
            self.descriptions = descriptions
        }
        if let updated_at = dict[Keys.updated_at.stringValue] as? String {
            self.updated_at = updated_at
        }
//        if let banner_image = dict[Keys.banner_image.stringValue] as? [String] {
//            self.banner_image = banner_image
//        }
        if let bannerData = dict[Keys.banner.stringValue] as? [String] {
            self.banner = bannerData
        }
        if let images = dict[Keys.images.stringValue] as? [String] {
            self.images = images
        }
        if let notification = dict[Keys.notification.stringValue] as? Array<Dictionary<String,AnyObject>>{
            for data in notification {
                let tempData = NotificationModel(dictionary: data)
                self.notification.append(tempData)
            }
        }
        if let zone = dict[Keys.zone.stringValue] as? String {
            self.zone = zone
        }
        if let message = dict[Keys.message.stringValue] as? String {
            self.message = message
        }
        if let reviews = dict[Keys.reviews.stringValue] as? Int {
            self.reviews = reviews
        }
        super.init()
    }
}


class NotificationModel: NSObject {
    enum keys: String, CodingKey {
        case notification_id = "notification_id"
        case user_id = "user_id"
        case title = "title"
        case body = "body"
        case created_at = "created_at"
    }
    
     var notification_id = ""
       var user_id = ""
       var title = ""
       var body = ""
       var created_at = ""
    
    override init() {
        super.init()
    }
    init(dictionary:[String: AnyObject]) {
        
        if let notification_id = dictionary[keys.notification_id.stringValue] as? String {
            self.notification_id = notification_id
        }
        if let title = dictionary[keys.title.stringValue] as? String {
            self.title = title
        }
        if let body = dictionary[keys.body.stringValue] as? String {
            self.body = body
        }
        if let created_at = dictionary[keys.created_at.stringValue] as? String {
            self.created_at = created_at
        }
        
        super.init()
    }
}

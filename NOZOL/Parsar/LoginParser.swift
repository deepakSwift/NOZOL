//
//  LoginParser.swift
//  NOZOL
//
//  Created by Mukul Sharma on 16/07/20.
//  Copyright © 2020 Mukul Sharma. All rights reserved.
//

import Foundation
import SwiftyJSON



class LoginParser: NSObject {
    let kResult = "result"
    let kMessage = "msg"
    let kUserInfo = "data"
    
    var result: Int = 1
    var message: String = ""
    var data = User()
    
    init(json: JSON) {
        if let _result = json[kResult].int as Int?{
            self.result = _result
        }
        if let _message = json[kMessage].string as String?{
            self.message = _message
        }
        if let _data  = json[kUserInfo].dictionaryObject as [String: AnyObject]?{
            self.data = User(dict: _data)
        }
        super.init()
    }
}





class CommonParser: NSObject {
    let kResult = "result"
    let kMessage = "msg"
    let kData = "data"
    
    var result: Int = 1
    var message: String = ""
    var data: Int = 0
    
    init(json: JSON) {
        if let _result = json[kResult].int as Int?{
            self.result = _result
        }
        if let _message = json[kMessage].string as String?{
            self.message = _message
        }
       if let data = json[kData].int as Int?{
            self.data = data
        }
        super.init()
    }
}




class ServiceParser: NSObject{
    
    let kResult = "result"
    let kMessage = "msg"
    let kTripMode = "data"
    
    
    var result: Int = 1
    var message: String = ""
    var tripMode = [serviceModel]()
    
    
    init(json: JSON) {
        if let result = json[kResult].int as Int?{
            self.result = result
        }
        if let message = json[kMessage].string as String?{
            self.message = message
        }
        
        if let listArray = json[kTripMode].arrayObject as? Array<Dictionary<String,AnyObject>> {
            self.tripMode.removeAll()
            for item in listArray {
                let singleTrip = serviceModel(dict: item)
                self.tripMode.append(singleTrip)
            }
        }
        super.init()
    }
}


class CheckInStatusParser: NSObject{
    
    let kResult = "result"
    let kMessage = "msg"
    let kTripMode = "data"
    
    
    var result: Int = 1
    var message: String = ""
    var statusData = serviceModel()
    
    
    init(json: JSON) {
        if let result = json[kResult].int as Int?{
            self.result = result
        }
        if let message = json[kMessage].string as String?{
            self.message = message
        }
        
        if let _data  = json[kTripMode].dictionaryObject as [String: AnyObject]?{
            self.statusData = serviceModel(dict: _data)
        }
        super.init()
    }
}



class SubCategoryServiceParser: NSObject{
    
    let kResult = "result"
    let kMessage = "msg"
    let kData = "data"
    
    
    var result: Int = 1
    var message: String = ""
    var categoryData = SubCategoryServiceModel()
    
    
    init(json: JSON) {
        if let result = json[kResult].int as Int?{
            self.result = result
        }
        if let message = json[kMessage].string as String?{
            self.message = message
        }
        
        if let _data  = json[kData].dictionaryObject as [String: AnyObject]?{
            self.categoryData = SubCategoryServiceModel(dict: _data)
        }
        super.init()
    }
}


class CheckInParser: NSObject{
    
    let kResult = "result"
    let kMessage = "msg"
    let kData = "data"
    
    
    var result: Int = 1
    var message: String = ""
    var checkInData = checkInModel()
    
    
    init(json: JSON) {
        if let result = json[kResult].int as Int?{
            self.result = result
        }
        if let message = json[kMessage].string as String?{
            self.message = message
        }
        
        if let _data  = json[kData].dictionaryObject as [String: AnyObject]?{
            self.checkInData = checkInModel(dict: _data)
        }
        super.init()
    }
}

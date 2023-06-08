//
//  Webservices.swift
//  NOZOL
//
//  Created by Mukul Sharma on 16/07/20.
//  Copyright © 2020 Mukul Sharma. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


class Webservice: NSObject{
    static let shared = Webservice()
    
    func login(email: String, password: String,tokenId : String, completionBlock: @escaping(_ result: Int, _ message: String, _ data: User?) -> Void) {
        
        var params = Dictionary<String, String>()
        params.updateValue(email, forKey: "email")
        params.updateValue(password, forKey: "password")
        params.updateValue(tokenId, forKey: "token_id")
        
        print("params===========\(params)")
        
        Alamofire.request(api.login.url(), method: .post, parameters : params).responseJSON { response in
            switch response.result {
            case.success:
                if let value = response.result.value {
                    let json = JSON(value)
                    print(json)
                    let parser = LoginParser(json: json)
                    if parser.result == 1 {
                        AppSettings.shared.isLoggedIn = true
                        parser.data.saveUserJSON(json)
                    }
                    completionBlock(parser.result, parser.message, parser.data)
                    
                }else{
                    completionBlock(0, response.result.error?.localizedDescription ?? "Some thing went wrong", nil)
                }
            case .failure(let error):
                completionBlock(0, error.localizedDescription, nil)
            }
        }
    }
    
    
    //------- Registration ------
    func registration(fullName: String, email: String,flag_code: String, password: String, confirmPassword: String,countryCode : String,mobileNumber : String, term : String,source : String, completionBlock: @escaping(_ result: Int, _ message: String) -> Void) {
        
        var params = Dictionary<String, String>()
        params.updateValue(fullName, forKey: "name")
        params.updateValue(email, forKey: "email")
        params.updateValue(password, forKey: "password")
        params.updateValue(confirmPassword, forKey: "cpassword")
        params.updateValue(countryCode, forKey: "country_code")
        params.updateValue(mobileNumber, forKey: "phone_number")
        params.updateValue(term, forKey: "term")
        params.updateValue(source, forKey: "source")
        params.updateValue(flag_code, forKey: "flag_code")
        
        print(params)
        
        Alamofire.request(api.signup.url(), method: .post, parameters : params).responseJSON { response in
            switch response.result {
            case.success:
                if let value = response.result.value {
                    let json = JSON(value)
                    print(json)
                    let parser = CommonParser(json: json)
                    completionBlock(parser.result, parser.message)
                    
                }else{
                    completionBlock(0, response.result.error?.localizedDescription ?? "Some thing went wrong")
                }
            case .failure(let error):
                completionBlock(0, error.localizedDescription)
            }
            
        }
    }
    
    
    
    
    func forgotPassword( email: String,  completionBlock: @escaping(_ result: Int, _ message: String) -> Void) {
        
        var params = Dictionary<String, String>()
        params.updateValue(email, forKey: "email")
        
        Alamofire.request(api.forgotPassword.url(), method: .post, parameters : params).responseJSON { response in
            switch response.result {
            case.success:
                if let value = response.result.value {
                    let json = JSON(value)
                    print(json)
                    let parser = CommonParser(json: json)
                    completionBlock(parser.result, parser.message)
                    
                }else{
                    completionBlock(0, response.result.error?.localizedDescription ?? "Some thing went wrong")
                }
            case .failure(let error):
                completionBlock(0, error.localizedDescription)
            }
            
        }
    }
    
    
    func setTokenId( userId: String, tokenId  :String, completionBlock: @escaping(_ result: Int, _ message: String) -> Void) {
        
        var params = Dictionary<String, String>()
        params.updateValue(userId, forKey: "user_id")
        params.updateValue(tokenId, forKey: "token_id")
        
        print("params==========\(params)")
        print("url==========\(api.setToken.url())")
        Alamofire.request(api.setToken.url(), method: .post, parameters : params).responseJSON { response in
            switch response.result {
            case.success:
                if let value = response.result.value {
                    let json = JSON(value)
                    print(json)
                    let parser = CommonParser(json: json)
                    completionBlock(parser.result, parser.message)
                    
                }else{
                    completionBlock(0, response.result.error?.localizedDescription ?? "Some thing went wrong")
                }
            case .failure(let error):
                completionBlock(0, error.localizedDescription)
            }
            
        }
    }
    
    
    
    
    func changePassword( userId: String, oldPassword  :String,newPassword : String,confirmPassword : String, completionBlock: @escaping(_ result: Int, _ message: String) -> Void) {
        
        var params = Dictionary<String, String>()
        params.updateValue(userId, forKey: "user_id")
        params.updateValue(oldPassword, forKey: "current_password")
        params.updateValue(newPassword, forKey: "password")
        params.updateValue(confirmPassword, forKey: "cpassword")

        
        Alamofire.request(api.changePassword.url(), method: .post, parameters : params).responseJSON { response in
            switch response.result {
            case.success:
                if let value = response.result.value {
                    let json = JSON(value)
                    print(json)
                    let parser = CommonParser(json: json)
                    completionBlock(parser.result, parser.message)
                    
                }else{
                    completionBlock(0, response.result.error?.localizedDescription ?? "Some thing went wrong")
                }
            case .failure(let error):
                completionBlock(0, error.localizedDescription)
            }
            
        }
    }

    
    
    
    func logout( userId: String,  completionBlock: @escaping(_ result: Int, _ message: String) -> Void) {
        
        var params = Dictionary<String, String>()
        params.updateValue(userId, forKey: "user_id")
        
        Alamofire.request(api.logOut.url(), method: .post, parameters : params).responseJSON { response in
            switch response.result {
            case.success:
                if let value = response.result.value {
                    let json = JSON(value)
                    print(json)
                    let parser = CommonParser(json: json)
                    completionBlock(parser.result, parser.message)
                    
                }else{
                    completionBlock(0, response.result.error?.localizedDescription ?? "Some thing went wrong")
                }
            case .failure(let error):
                completionBlock(0, error.localizedDescription)
            }
            
        }
    }
    
    
    
    func EditProfile( userID : String,name : String,userImage : UIImage?, completionBlock:@escaping (_  success: Int , _ dataModal: User?, _ message: String ) -> Void) {
        
        var params = Dictionary<String, String>()
        params.updateValue(userID, forKey: "user_id")
        params.updateValue(name, forKey: "name")
        
        let url = api.profileImage.url()
        
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                if let pimage = userImage{
                    if let data = pimage.jpegData(compressionQuality: 0.9) as Data?{
                        multipartFormData.append(data, withName: "image_url", fileName: "image_url.jpg", mimeType: "image/jpg")
                        
                        print("=======================\(data)")
                    }
                }
                for (key, value) in params {
                    multipartFormData.append((value).data(using: .utf8)!, withName: key)
                }
        },to: url,method:.post,encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success(let upload,_ ,_ ):
                upload.responseJSON { response in
                    
                    switch response.result {
                    case .success:
                        if let value = response.result.value {
                            let json = JSON(value)
                            print(json)
                            print_debug("update profile picture in json is:\n\(json)")
                            
                            let parser = LoginParser(json: json)
                            if parser.result == 1 {
                                // AppSettings.shared.isLoggedIn = true
                                parser.data.saveUserJSON(json)
                            }
                            completionBlock(parser.result,parser.data,parser.message)
                            
                        }else{
                            completionBlock(0,nil,response.result.error?.localizedDescription ?? "Some thing went wrong")
                            
                        }
                    case .failure(let error):
                        completionBlock(0,nil,error.localizedDescription)
                    }
                }
            case .failure(let encodingError):
                print(encodingError)
            }
        })
        
    }

    
    
    
    func loyalityAndOffers( completionBlock: @escaping(_ result: Int, _ message: String, _ data: [serviceModel]?) -> Void) {
        
       // var params = Dictionary<String, String>()
       // params.updateValue(category_id, forKey: "category_id")
        
        Alamofire.request(api.loyalityAndOffers.url(), method: .get).responseJSON { response in
            switch response.result {
            case.success:
                if let value = response.result.value {
                    let json = JSON(value)
                    print(json)
                    let parser = ServiceParser(json: json)
                    completionBlock(parser.result, parser.message, parser.tripMode)
                    
                }else{
                    completionBlock(0, response.result.error?.localizedDescription ?? "Some thing went wrong", nil)
                }
            case .failure(let error):
                completionBlock(0, error.localizedDescription, nil)
            }
            
        }
    }
    
    
    
    func serviceList(category_id : String, completionBlock: @escaping(_ result: Int, _ message: String, _ data: [serviceModel]?) -> Void) {
        
        var params = Dictionary<String, String>()
        params.updateValue(category_id, forKey: "category_id")
        
        Alamofire.request(api.paidAndUnpaid.url(), method: .post,parameters: params).responseJSON { response in
            switch response.result {
            case.success:
                if let value = response.result.value {
                    let json = JSON(value)
                    print(json)
                    let parser = ServiceParser(json: json)
                    completionBlock(parser.result, parser.message, parser.tripMode)
                    
                }else{
                    completionBlock(0, response.result.error?.localizedDescription ?? "Some thing went wrong", nil)
                }
            case .failure(let error):
                completionBlock(0, error.localizedDescription, nil)
            }
            
        }
    }
    
//-------Get subCategory------
    func subCategoryList(category_id : String, completionBlock: @escaping(_ result: Int, _ message: String, _ data: SubCategoryServiceModel?) -> Void) {
        
        var params = Dictionary<String, String>()
        params.updateValue(category_id, forKey: "subcategory_id")
        print("Params=====\(params)")
        
        Alamofire.request(api.subCategory.url(), method: .post,parameters: params).responseJSON { response in
            switch response.result {
            case.success:
                if let value = response.result.value {
                    let json = JSON(value)
                    print("Url=====\(api.subCategory.url())")
                    print(json)
                    let parser = SubCategoryServiceParser(json: json)
                    completionBlock(parser.result, parser.message, parser.categoryData)
                    
                }else{
                    completionBlock(0, response.result.error?.localizedDescription ?? "Some thing went wrong", nil)
                }
            case .failure(let error):
                completionBlock(0, error.localizedDescription, nil)
            }
            
        }
    }


    //-------Get Service------
    func getServiceList(category_id : String, completionBlock: @escaping(_ result: Int, _ message: String, _ data: [serviceModel]?) -> Void) {
        
        var params = Dictionary<String, String>()
        params.updateValue(category_id, forKey: "CategoryId")
        print("Params=====\(params)")
        
        Alamofire.request(api.getServices.url(), method: .post,parameters: params).responseJSON { response in
            switch response.result {
            case.success:
                if let value = response.result.value {
                    let json = JSON(value)
                    print("Url=====\(api.getServices.url())")
                    print(json)
                    let parser = ServiceParser(json: json)
                    completionBlock(parser.result, parser.message, parser.tripMode)
                    
                }else{
                    completionBlock(0, response.result.error?.localizedDescription ?? "Some thing went wrong", nil)
                }
            case .failure(let error):
                completionBlock(0, error.localizedDescription, nil)
            }
            
        }
    }
    
    //-------Home Screen data------
    func homeScreenData(UserId : String,completionBlock: @escaping(_ result: Int, _ message: String, _ data: SubCategoryServiceModel?) -> Void) {
        var params = Dictionary<String, String>()
        params.updateValue(UserId, forKey: "user_id")
        print("Params=====\(params)")
        
        Alamofire.request(api.nozol_detail.url(), method: .post,parameters: params).responseJSON { response in
            switch response.result {
            case.success:
                if let value = response.result.value {
                    let json = JSON(value)
                    print("Url=====\(api.nozol_detail.url())")
                    print(json)
                    let parser = SubCategoryServiceParser(json: json)
                    completionBlock(parser.result, parser.message, parser.categoryData)
                    
                }else{
                    completionBlock(0, response.result.error?.localizedDescription ?? "Some thing went wrong", nil)
                }
            case .failure(let error):
                completionBlock(0, error.localizedDescription, nil)
            }
            
        }
    }
    
    //-------Get All notification------
    func getNotificationList(UserId : String, completionBlock: @escaping(_ result: Int, _ message: String, _ data: checkInModel?) -> Void) {
        
        var params = Dictionary<String, String>()
        params.updateValue(UserId, forKey: "user_id")
        print("Params=====\(params)")
        
        Alamofire.request(api.getAllNotifications.url(), method: .post,parameters: params).responseJSON { response in
            switch response.result {
            case.success:
                if let value = response.result.value {
                    let json = JSON(value)
                    print("Url=====\(api.getAllNotifications.url())")
                    print(json)
                    let parser = CheckInParser(json: json)
                    completionBlock(parser.result, parser.message, parser.checkInData)
                    
                }else{
                    completionBlock(0, response.result.error?.localizedDescription ?? "Some thing went wrong", nil)
                }
            case .failure(let error):
                completionBlock(0, error.localizedDescription, nil)
            }
            
        }
    }
    
    //-------Get Service DetailsList------
    func userServiceDetailsList(UserId : String,key: String, completionBlock: @escaping(_ result: Int, _ message: String, _ data: [serviceModel]?) -> Void) {
        
        var params = Dictionary<String, String>()
        params.updateValue(UserId, forKey: "user_id")
        params.updateValue(key, forKey: "key")
        print("Params=====\(params)")
        
        Alamofire.request(api.userServiceDetails.url(), method: .post,parameters: params).responseJSON { response in
            switch response.result {
            case.success:
                if let value = response.result.value {
                    let json = JSON(value)
                    print("Url=====\(api.userServiceDetails.url())")
                    print(json)
                    let parser = ServiceParser(json: json)
                    completionBlock(parser.result, parser.message, parser.tripMode)
                    
                }else{
                    completionBlock(0, response.result.error?.localizedDescription ?? "Some thing went wrong", nil)
                }
            case .failure(let error):
                completionBlock(0, error.localizedDescription, nil)
            }
            
        }
    }
    
    //-----Add service to cart-----
    func review( user_id: String,cleaniness: String,wifi: String,location: String,room_service: String,comfort: String,staff: String, comments: String, completionBlock: @escaping(_ result: Int, _ message: String, _ data: Int) -> Void) {
           
        var params = Dictionary<String, String>()
        params.updateValue(user_id, forKey: "user_id")
        params.updateValue(cleaniness, forKey: "cleaniness")
        params.updateValue(wifi, forKey: "wifi")
        params.updateValue(location, forKey: "location")
        params.updateValue(cleaniness, forKey: "room_service")
        params.updateValue(comfort, forKey: "comfort")
        params.updateValue(staff, forKey: "staff")
        params.updateValue(comments, forKey: "comments")
           
           Alamofire.request(api.reviews.url(), method: .post, parameters : params).responseJSON { response in
               switch response.result {
               case.success:
                   if let value = response.result.value {
                       let json = JSON(value)
                    print("Url=====\(api.reviews.url())")
                       print(json)
                       let parser = CommonParser(json: json)
                    completionBlock(parser.result, parser.message, parser.data)
                       
                   }else{
                    completionBlock(0, response.result.error?.localizedDescription ?? "Some thing went wrong", 0)
                   }
               case .failure(let error):
                   completionBlock(0, error.localizedDescription, 0)
               }
               
           }
       }
    
    //-------Hotel Map ------
    func hotelMap(completionBlock: @escaping(_ result: Int, _ message: String, _ data: SubCategoryServiceModel?) -> Void) {
        
        Alamofire.request(api.hotelMap.url(), method: .get).responseJSON { response in
            switch response.result {
            case.success:
                if let value = response.result.value {
                    let json = JSON(value)
                    print("Url=====\(api.hotelMap.url())")
                    print(json)
                    let parser = SubCategoryServiceParser(json: json)
                    completionBlock(parser.result, parser.message, parser.categoryData)
                    
                }else{
                    completionBlock(0, response.result.error?.localizedDescription ?? "Some thing went wrong", nil)
                }
            case .failure(let error):
                completionBlock(0, error.localizedDescription, nil)
            }
            
        }
    }
    
    
    
    //-------Check In ------
    func checkInData(user_id: String,family_name: String,name: String,check_in_date: String,check_out_date: String,booking: String,agent_name: String,website_name: String,address: String,job: String,dob: String,wife_name: String,adult_no: String,children_no: String,paymend_method: String,id_proof: String,signature: UIImage?,no_room: String,guest_no: String,id_proof_image: UIImage?, completionBlock:@escaping (_  success: Int , _ dataModal: checkInModel?, _ message: String ) -> Void) {
        
        var params = Dictionary<String, String>()
        params.updateValue(user_id, forKey: "user_id")
        params.updateValue(name, forKey: "name")
        params.updateValue(family_name, forKey: "family_name")
        params.updateValue(check_in_date, forKey: "check_in_date")
        params.updateValue(check_out_date, forKey: "check_out_date")
        params.updateValue(booking, forKey: "booking")
        params.updateValue(agent_name, forKey: "agent_name")
        params.updateValue(website_name, forKey: "website_name")
        params.updateValue(address, forKey: "address")
        params.updateValue(job, forKey: "job")
        params.updateValue(dob, forKey: "dob")
        params.updateValue(wife_name, forKey: "wife_name")
        params.updateValue(adult_no, forKey: "adult_no")
        params.updateValue(children_no, forKey: "children_no")
        params.updateValue(paymend_method, forKey: "paymend_method")
        params.updateValue(id_proof, forKey: "id_proof")
        params.updateValue(no_room, forKey: "no_room")
        params.updateValue(guest_no, forKey: "guest_no")
        
        let url = api.checkIn.url()
        
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                if let pimage = signature{
                    if let data = pimage.jpegData(compressionQuality: 0.9) as Data?{
                        multipartFormData.append(data, withName: "signature", fileName: "signature.jpg", mimeType: "image/jpg")
                        
                        print("signature.jpg=======================\(data)")
                    }
                }
                if let pimage2 = id_proof_image{
                    if let data = pimage2.jpegData(compressionQuality: 0.9) as Data?{
                        multipartFormData.append(data, withName: "id_proof_image", fileName: "id_proof_image.jpg", mimeType: "image/jpg")
                        
                        print("id_proof_image.jpg=======================\(data)")
                    }
                }
                
                for (key, value) in params {
                    multipartFormData.append((value).data(using: .utf8)!, withName: key)
                }
        },to: url,method:.post,encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success(let upload,_ ,_ ):
                upload.responseJSON { response in
                    
                    switch response.result {
                    case .success:
                        if let value = response.result.value {
                            let json = JSON(value)
                            print(json)
                            print_debug("checkIn  json is:\n\(json)")
                            
                            let parser = CheckInParser(json: json)
                            if parser.result == 1 {
                                // AppSettings.shared.isLoggedIn = true
                                //parser.data.saveUserJSON(json)
                            }
                            completionBlock(parser.result,parser.checkInData,parser.message)
                            
                        }else{
                            completionBlock(0,nil,response.result.error?.localizedDescription ?? "Some thing went wrong")
                            
                        }
                    case .failure(let error):
                        completionBlock(0,nil,error.localizedDescription)
                    }
                }
            case .failure(let encodingError):
                print(encodingError)
            }
        })
        
    }
    
    //-------Room Details ------
    func roomDetails(completionBlock: @escaping(_ result: Int, _ message: String, _ data: checkInModel?) -> Void) {
        
        Alamofire.request(api.roomDetails.url(), method: .get).responseJSON { response in
            switch response.result {
            case.success:
                if let value = response.result.value {
                    let json = JSON(value)
                    print("Url=====\(api.roomDetails.url())")
                    print(json)
                    let parser = CheckInParser(json: json)
                    completionBlock(parser.result, parser.message, parser.checkInData)
                    
                }else{
                    completionBlock(0, response.result.error?.localizedDescription ?? "Some thing went wrong", nil)
                }
            case .failure(let error):
                completionBlock(0, error.localizedDescription, nil)
            }
            
        }
    }

    //-----Add service to cart-----
    func rescheduleBooking( user_id: String,check_in_date: String,check_out_date: String,no_room: String,adult_no: String,children_no: String,message: String, completionBlock: @escaping(_ result: Int, _ message: String, _ data: Int) -> Void) {
           
        var params = Dictionary<String, String>()
        params.updateValue(user_id, forKey: "user_id")
        params.updateValue(check_in_date, forKey: "check_in_date")
        params.updateValue(check_out_date, forKey: "check_out_date")
        params.updateValue(no_room, forKey: "no_room")
        params.updateValue(adult_no, forKey: "adult_no")
        params.updateValue(children_no, forKey: "children_no")
        params.updateValue(message, forKey: "message")
        
           
           Alamofire.request(api.rescheduleBooking.url(), method: .post, parameters : params).responseJSON { response in
               switch response.result {
               case.success:
                   if let value = response.result.value {
                       let json = JSON(value)
                    print("Url=====\(api.rescheduleBooking.url())")
                       print(json)
                       let parser = CommonParser(json: json)
                    completionBlock(parser.result, parser.message, parser.data)
                       
                   }else{
                    completionBlock(0, response.result.error?.localizedDescription ?? "Some thing went wrong", 0)
                   }
               case .failure(let error):
                   completionBlock(0, error.localizedDescription, 0)
               }
           }
       }
    
    //-------check Status------
    func checkStatus(UserId : String, completionBlock: @escaping(_ result: Int, _ message: String, _ data: serviceModel?) -> Void) {
        
        var params = Dictionary<String, String>()
        params.updateValue(UserId, forKey: "user_id")
        print("Params=====\(params)")
        print("Url=====\(api.checkcheckinformstatus.url())")
        
        Alamofire.request(api.checkcheckinformstatus.url(), method: .get,parameters: params).responseJSON { response in
            switch response.result {
            case.success:
                if let value = response.result.value {
                    let json = JSON(value)
                    print("----------------------------------------------------------")
                    print(json)
                    let parser = CheckInStatusParser(json: json)
                    completionBlock(parser.result, parser.message, parser.statusData)
                    
                }else {
                    completionBlock(0, response.result.error?.localizedDescription ?? "Some thing went wrong", nil)
                }
            case .failure(let error):
                completionBlock(0, error.localizedDescription, nil)
            }
        }
    }
    
    
    //-------Check In ------
    func addServiceToCart(user_id: String, service_id: String, quantity: String,type: String, image_url: UIImage?, completionBlock:@escaping (_ result: Int, _ message: String) -> Void) {
        
        var params = Dictionary<String, String>()
        params.updateValue(user_id, forKey: "user_id")
        params.updateValue(service_id, forKey: "service_id")
        params.updateValue(quantity, forKey: "quantity")
        params.updateValue(type, forKey: "type")
        //params.updateValue(image_url, forKey: "image_url")
        
        let url = api.addServices.url()
        
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                if let pimage = image_url{
                    if let data = pimage.jpegData(compressionQuality: 0.9) as Data?{
                        multipartFormData.append(data, withName: "image_url", fileName: "image_url.jpg", mimeType: "image/jpg")
                        
                        print("signature.jpg=======================\(data)")
                    }
                }
                
                for (key, value) in params {
                    multipartFormData.append((value).data(using: .utf8)!, withName: key)
                }
        },to: url,method:.post,encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success(let upload,_ ,_ ):
                upload.responseJSON { response in
                    
                    switch response.result {
                    case .success:
                        if let value = response.result.value {
                            let json = JSON(value)
                            print(json)
                            print("signature.jpg=======================\(api.addServices.url())")
                            print_debug("checkIn  json is:\n\(json)")
                            
                            let parser = CommonParser(json: json)
                            if parser.result == 1 {
                                // AppSettings.shared.isLoggedIn = true
                                //parser.data.saveUserJSON(json)
                            }
                            completionBlock(parser.result, parser.message)
                            
                        }else{
                            completionBlock(0, response.result.error?.localizedDescription ?? "Some thing went wrong")
                            
                        }
                    case .failure(let error):
                        completionBlock(0, error.localizedDescription)
                    }
                }
            case .failure(let encodingError):
                print(encodingError)
            }
        })
    }
    
    //-------Get Payment Option------
       func paymentOption(completionBlock: @escaping(_ result: Int, _ message: String, _ data: [serviceModel]?) -> Void) {
           
           Alamofire.request(api.paymentoption.url(), method: .get).responseJSON { response in
               switch response.result {
               case.success:
                   if let value = response.result.value {
                       let json = JSON(value)
                       print("Url=====\(api.paymentoption.url())")
                       print(json)
                       let parser = ServiceParser(json: json)
                       completionBlock(parser.result, parser.message, parser.tripMode)
                       
                   }else{
                       completionBlock(0, response.result.error?.localizedDescription ?? "Some thing went wrong", nil)
                   }
               case .failure(let error):
                   completionBlock(0, error.localizedDescription, nil)
               }
               
           }
       }
       
    //-------Get Payment Option------
    func identificationOption(completionBlock: @escaping(_ result: Int, _ message: String, _ data: [serviceModel]?) -> Void) {
        
        Alamofire.request(api.identification.url(), method: .get).responseJSON { response in
            switch response.result {
            case.success:
                if let value = response.result.value {
                    let json = JSON(value)
                    print("Url=====\(api.identification.url())")
                    print(json)
                    let parser = ServiceParser(json: json)
                    completionBlock(parser.result, parser.message, parser.tripMode)
                    
                }else{
                    completionBlock(0, response.result.error?.localizedDescription ?? "Some thing went wrong", nil)
                }
            case .failure(let error):
                completionBlock(0, error.localizedDescription, nil)
            }
            
        }
    }
    
    //------Social login--------
    func socialLogin(email: String, name: String,tokenId : String,source : String, completionBlock: @escaping(_ result: Int, _ message: String, _ data: User?) -> Void) {
        
        var params = Dictionary<String, String>()
        params.updateValue(email, forKey: "email")
        params.updateValue(tokenId, forKey: "token_id")
        params.updateValue(name, forKey: "name")
        params.updateValue(source, forKey: "source")
        
        Alamofire.request(api.socialLogin.url(), method: .post, parameters : params).responseJSON { response in
            switch response.result {
            case.success:
                if let value = response.result.value {
                    let json = JSON(value)
                    print("Url=====\(api.socialLogin.url())")
                    print(json)
                    let parser = LoginParser(json: json)
                    if parser.result == 1 {
                        AppSettings.shared.isLoggedIn = true
                        parser.data.saveUserJSON(json)
                    }
                    completionBlock(parser.result, parser.message, parser.data)
                    
                }else{
                    completionBlock(0, response.result.error?.localizedDescription ?? "Some thing went wrong", nil)
                }
            case .failure(let error):
                completionBlock(0, error.localizedDescription, nil)
            }
            
        }
    }
    
    
    //------Social login Signup--------
    func socialLoginSignup(email: String, name: String,flag_code: String, tokenId : String,source : String,country_code: String, phone_number: String, completionBlock: @escaping(_ result: Int, _ message: String, _ data: User?) -> Void) {
        
        var params = Dictionary<String, String>()
        params.updateValue(email, forKey: "email")
        params.updateValue(tokenId, forKey: "token_id")
        params.updateValue(name, forKey: "name")
        params.updateValue(source, forKey: "source")
        params.updateValue(tokenId, forKey: "token_id")
        params.updateValue(country_code, forKey: "country_code")
        params.updateValue(phone_number, forKey: "phone_number")
        params.updateValue(flag_code, forKey: "flag_code")
         print("Params=====\(params)")
        
        Alamofire.request(api.socialLogin.url(), method: .post, parameters : params).responseJSON { response in
            switch response.result {
            case.success:
                if let value = response.result.value {
                    let json = JSON(value)
                    print("Url=====\(api.socialLogin.url())")
                    print(json)
                    let parser = LoginParser(json: json)
                    if parser.result == 1 {
                        AppSettings.shared.isLoggedIn = true
                        parser.data.saveUserJSON(json)
                    }
                    completionBlock(parser.result, parser.message, parser.data)
                    
                }else{
                    completionBlock(0, response.result.error?.localizedDescription ?? "Some thing went wrong", nil)
                }
            case .failure(let error):
                completionBlock(0, error.localizedDescription, nil)
            }
            
        }
    }
      
    //-----UpdateToken------
    func updateToken( userId: String, tokenId  :String, completionBlock: @escaping(_ result: Int, _ message: String) -> Void) {
        
        var params = Dictionary<String, String>()
        params.updateValue(userId, forKey: "user_id")
        params.updateValue(tokenId, forKey: "token_id")
        
        Alamofire.request(api.updateToken.url(), method: .post, parameters : params).responseJSON { response in
            switch response.result {
            case.success:
                if let value = response.result.value {
                    let json = JSON(value)
                    print("Url=====\(api.updateToken.url())")
                    print(json)
                    let parser = CommonParser(json: json)
                    completionBlock(parser.result, parser.message)
                    
                }else{
                    completionBlock(0, response.result.error?.localizedDescription ?? "Some thing went wrong")
                }
            case .failure(let error):
                completionBlock(0, error.localizedDescription)
            }
        }
    }
    
    //----Chat inserted------
    func chatInsertData(userId: String,type: String,message: String, completionBlock:@escaping (_ success: Int, _ data : checkInModel?, _ message: String) -> Void) {
        
        var params = Dictionary<String, String>()
        params.updateValue(userId, forKey: "user_id")
        params.updateValue(type, forKey: "type")
        params.updateValue(message, forKey: "msg")
        print("==========\(params)")
        
     Alamofire.request(api.chatInsert.url(),method: .post, parameters : params).responseJSON { response in
            switch response.result {
            case.success:
                if let value = response.result.value {
                    let json = JSON(value)
                    print("============\(api.chatInsert.url())")
                    print(" insertChat json is:\n\(json)")
                    let parser = CheckInParser(json: json)
                    
                    completionBlock(parser.result,parser.checkInData,parser.message)
                }else{
                    completionBlock(0,nil,response.result.error?.localizedDescription ?? "Some thing went wrong")
                }
            case .failure(let error):
                completionBlock(0,nil,error.localizedDescription)
            }
        }
    }
    
    
    //----Media Image Chat inserted------
    func chatInserted( userId: String,type: String,message: UIImage?, completionBlock:@escaping (_ success: Int, _ data : checkInModel?, _ message: String ) -> Void) {
           
        var params = Dictionary<String, String>()
        params.updateValue(userId, forKey: "user_id")
        params.updateValue(type, forKey: "type")
        //params.updateValue(message, forKey: "msg")
        print("==========\(params)")
           
           let url = api.chatInsert.url()
           
           Alamofire.upload(
               multipartFormData: { multipartFormData in
                   if let pimage = message{
                       if let data = pimage.jpegData(compressionQuality: 0.9) as Data?{
                           multipartFormData.append(data, withName: "msg", fileName: "msg.jpg", mimeType: "msg/jpg")
                           
                           print("=======================\(data)")
                       }
                   }
                   for (key, value) in params {
                       multipartFormData.append((value).data(using: .utf8)!, withName: key)
                   }
           },to: url,method:.post,encodingCompletion: { encodingResult in
               switch encodingResult {
               case .success(let upload,_ ,_ ):
                   upload.responseJSON { response in
                       
                       switch response.result {
                       case .success:
                           if let value = response.result.value {
                               let json = JSON(value)
                               print(json)
                               print_debug("update profile picture in json is:\n\(json)")
                               
                               let parser = CheckInParser(json: json)
                               if parser.result == 1 {
                                   // AppSettings.shared.isLoggedIn = true
                                   //parser.data.saveUserJSON(json)
                               }
                               completionBlock(parser.result,parser.checkInData,parser.message)
                               
                           }else{
                               completionBlock(0,nil,response.result.error?.localizedDescription ?? "Some thing went wrong")
                               
                           }
                       case .failure(let error):
                           completionBlock(0,nil,error.localizedDescription)
                       }
                   }
               case .failure(let encodingError):
                   print(encodingError)
               }
           })
           
       }

    //----Media doc Chat inserted------
    func chatDocInserted( userId: String,type: String,message: Data?, completionBlock:@escaping (_ success: Int, _ data : checkInModel?, _ message: String ) -> Void) {
           
        var params = Dictionary<String, String>()
        params.updateValue(userId, forKey: "user_id")
        params.updateValue(type, forKey: "type")
        //params.updateValue(message, forKey: "msg")
        print("==========\(params)")
           
           let url = api.chatInsert.url()
           
           Alamofire.upload(
               multipartFormData: { multipartFormData in
                   if let data = message{
                       //if let data = pimage {
                           //multipartFormData.append(data, withName: "msg", fileName: "msg.jpg", mimeType: "msg/jpg")
                           
                        
                         multipartFormData.append(data, withName: "msg", fileName: "\(Date().timeIntervalSince1970).pdf", mimeType: "application/pdf")
                        
                        
                           print("=======================\(data)")
                       //}
                   }
                   for (key, value) in params {
                       multipartFormData.append((value).data(using: .utf8)!, withName: key)
                   }
           },to: url,method:.post,encodingCompletion: { encodingResult in
               switch encodingResult {
               case .success(let upload,_ ,_ ):
                   upload.responseJSON { response in
                       
                       switch response.result {
                       case .success:
                           if let value = response.result.value {
                               let json = JSON(value)
                               print(json)
                               print_debug("update profile picture in json is:\n\(json)")
                               
                               let parser = CheckInParser(json: json)
                               if parser.result == 1 {
                                   // AppSettings.shared.isLoggedIn = true
                                   //parser.data.saveUserJSON(json)
                               }
                               completionBlock(parser.result,parser.checkInData,parser.message)
                               
                           }else{
                               completionBlock(0,nil,response.result.error?.localizedDescription ?? "Some thing went wrong")
                               
                           }
                       case .failure(let error):
                           completionBlock(0,nil,error.localizedDescription)
                       }
                   }
               case .failure(let encodingError):
                   print(encodingError)
               }
           })
           
       }

    
    func getProfileData(userId: String, completionBlock: @escaping(_ result: Int, _ message: String, _ data: User?) -> Void) {
        
        var params = Dictionary<String, String>()
        params.updateValue(userId, forKey: "user_id")
        print("==========\(params)")
        
        Alamofire.request(api.getuserdata.url(), method: .post, parameters : params).responseJSON { response in
            switch response.result {
            case.success:
                if let value = response.result.value {
                    let json = JSON(value)
                    print(json)
                    let parser = LoginParser(json: json)
                    if parser.result == 1 {
                        AppSettings.shared.isLoggedIn = true
                        parser.data.saveUserJSON(json)
                    }
                    completionBlock(parser.result, parser.message, parser.data)
                    
                }else{
                    completionBlock(0, response.result.error?.localizedDescription ?? "Some thing went wrong", nil)
                }
            case .failure(let error):
                completionBlock(0, error.localizedDescription, nil)
            }
            
        }
    }
    
    
    //-------checkRoom Status------
    func checkRoomStatus(userId: String, completionBlock: @escaping(_ result: Int, _ message: String, _ data: serviceModel?) -> Void) {
        
        var params = Dictionary<String, String>()
        params.updateValue(userId, forKey: "user_id")
        print("==========\(params)")
        print("Url=====\(api.checkcheckinformstatus.url())")
        
        Alamofire.request(api.checkcheckinformstatus.url(), method: .post, parameters : params).responseJSON { response in
            switch response.result {
            case.success:
                if let value = response.result.value {
                    let json = JSON(value)
                    print(json)
                    let parser = CheckInStatusParser(json: json)

                    completionBlock(parser.result, parser.message, parser.statusData)
                    
                }else{
                    completionBlock(0, response.result.error?.localizedDescription ?? "Some thing went wrong", nil)
                }
            case .failure(let error):
                completionBlock(0, error.localizedDescription, nil)
            }
            
        }
    }
       
    
}


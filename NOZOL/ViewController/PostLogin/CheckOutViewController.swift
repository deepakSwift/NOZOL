//
//  CheckOutViewController.swift
//  NOZOL
//
//  Created by Mukul Sharma on 15/07/20.
//  Copyright © 2020 Mukul Sharma. All rights reserved.
//

import UIKit
import Cosmos
import RSKPlaceholderTextView

class CheckOutViewController: UIViewController {

    @IBOutlet weak var cleanessView : CosmosView!
    @IBOutlet weak var wifiView : CosmosView!
    @IBOutlet weak var locationView : CosmosView!
    @IBOutlet weak var roomServiceView : CosmosView!
    @IBOutlet weak var comfortView : CosmosView!
    @IBOutlet weak var staffView : CosmosView!
    @IBOutlet weak var reviewTextView : RSKPlaceholderTextView!
    @IBOutlet weak var checkOutTableView : UITableView!
    @IBOutlet weak var labelTitle: UILabel!

    @IBOutlet weak var labelRateExp: UILabel!
    @IBOutlet weak var labelClean: UILabel!
    @IBOutlet weak var labelWifi: UILabel!
    @IBOutlet weak var labelLocation: UILabel!
    @IBOutlet weak var labelRoomService: UILabel!
    @IBOutlet weak var labelComfirt: UILabel!
    @IBOutlet weak var labelStaff: UILabel!
    @IBOutlet weak var labelComment: UILabel!
    @IBOutlet weak var buttonSubmit: UIButton!
    @IBOutlet weak var labelWriteComment: RSKPlaceholderTextView!
    
    
    var currentUserLogin : User!
    var statusResponse = serviceModel()
    var getTitle = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLocalization()
        //self.reviewTextView.placeholder = "Write your comment..."
        CommonClass.makeViewCircularWithCornerRadius(reviewTextView, borderColor: .orange, borderWidth: 1.0, cornerRadius: 10.0)
        labelTitle.text = self.getTitle
        setuUI()
//checkOutTableView.contentInset = UIEdgeInsets(top: -UIApplication.shared.statusBarFrame.size.height, left: 0, bottom: 0, right: 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.currentUserLogin = User.loadSavedUser()
        checkRoomStatus(userId: currentUserLogin.userId)
    }
    
    func setuUI() {
        cleanessView.rating = 0.0
        wifiView.rating = 0.0
        locationView.rating = 0.0
        roomServiceView.rating = 0.0
        comfortView.rating = 0.0
        staffView.rating = 0.0
    }
    
    @IBAction func onClickBackButton(_ sender : UIButton){
        self.navigationController?.pop(true)
    }
    
    
    @IBAction func onClickSubmitButton(_ sender : UIButton){
        
        if reviewTextView.text == "" {
           NKToastHelper.sharedInstance.showErrorAlert(self, message: "Please write the review.")
        } else {
            let cleanessViewRating = Int(cleanessView.rating)
            let wifiViewRating = Int(wifiView.rating)
            let locationViewRating = Int(locationView.rating)
            let roomServiceViewRating = Int(roomServiceView.rating)
            let comfortViewRating = Int(comfortView.rating)
            let staffViewRating = Int(staffView.rating)
            
            addReview(user_id: self.currentUserLogin.userId, cleaniness: "\(cleanessViewRating)", wifi: "\(wifiViewRating)", location: "\(locationViewRating)", room_service: "\(roomServiceViewRating)", comfort: "\(comfortViewRating)", staff: "\("\(staffViewRating)")", comments: reviewTextView.text)
        }
        
    }
    
    func addReview(user_id: String,cleaniness: String,wifi: String,location: String,room_service: String,comfort: String,staff: String, comments: String) {
        CommonClass.showLoader()
    
        Webservice.shared.review(user_id: user_id, cleaniness: cleaniness, wifi: wifi, location: location, room_service: room_service, comfort: comfort, staff: staff, comments: comments) { (result,msg,response) in
            CommonClass.hideLoader()
            
            if result == 1 {
                UserDefaults.standard.removeObject(forKey: "checkInStatus")
                UserDefaults.standard.removeObject(forKey: "checkInId")
                roomNumber = ""
                NKToastHelper.sharedInstance.showAlert(self, title: .alertTitle, message: msg)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                    self.navigationController?.popViewController(animated: true)
                })

            }else {
                NKToastHelper.sharedInstance.showAlert(self, title: .alertTitle, message: msg)

            }
            
        }
    }
    
    //-----CheckIn status Api call----
    func checkRoomStatus(userId: String) {
        //CommonClass.showLoader()
        Webservice.shared.checkRoomStatus(userId: userId) { (result, message, response) in
            //CommonClass.hideLoader()
            if result == 1 {
                if let data = response {
                    self.statusResponse = data
                }
                //----for block the service
                UserDefaults.standard.set("true", forKey: "checkInStatus")
                //-----for stop timer Api
                //self.timer.invalidate()
                //------update room number in global variable---
                roomNumber = self.statusResponse.room_no[0]
                //self.accountTableView.reloadData()
            } else {
                //NKToastHelper.sharedInstance.showAlert(self, title: .alertTitle, message: message)
                if let data = response {
                    self.statusResponse = data
                }
                
                if self.statusResponse.booking_status == "Disapprove" {
                    UserDefaults.standard.removeObject(forKey: "checkInId")
                    UserDefaults.standard.removeObject(forKey: "checkInStatus")
                    roomNumber = ""
                } else if self.statusResponse.booking_status == "Pending"{
                    UserDefaults.standard.set("true", forKey: "checkInId")
                    roomNumber = ""
                } else {
                    UserDefaults.standard.removeObject(forKey: "checkInId")
                    UserDefaults.standard.removeObject(forKey: "checkInStatus")
                    roomNumber = ""
                }
            }
        }
    }
}


//----- Set Localization------
extension CheckOutViewController {
    
    func setLocalization() {
        let lang = UserDefaults.standard.value(forKey: "language") as? String
        if lang == "en" {
            buttonSubmit.setTitle("SubmitKey".localizableString(loc: "en"), for: .normal)
            labelRateExp.text = "RateYourExperienceKey".localizableString(loc: "en")
            labelWifi.text = "WifiKey".localizableString(loc: "en")
            labelLocation.text = "LocationKey".localizableString(loc: "en")
            labelRoomService.text = "RoomServiceKey".localizableString(loc: "en")
            labelComfirt.text = "ComfortKey".localizableString(loc: "en")
            labelStaff.text = "Staff".localizableString(loc: "en")
            labelComment.text = "CommentsKey".localizableString(loc: "en")
            labelClean.text = "CleaninessKey".localizableString(loc: "en")
            labelWriteComment.placeholder = "WriteCommentKey".localizableString(loc: "en") as NSString
            UIView.appearance().semanticContentAttribute = .forceLeftToRight

        } else if lang == "ar"{
            buttonSubmit.setTitle("SubmitKey".localizableString(loc: "ar"), for: .normal)
            labelRateExp.text = "RateYourExperienceKey".localizableString(loc: "ar")
            labelWifi.text = "WifiKey".localizableString(loc: "ar")
            labelLocation.text = "LocationKey".localizableString(loc: "ar")
            labelRoomService.text = "RoomServiceKey".localizableString(loc: "ar")
            labelComfirt.text = "ComfortKey".localizableString(loc: "ar")
            labelStaff.text = "Staff".localizableString(loc: "ar")
            labelComment.text = "CommentsKey".localizableString(loc: "ar")
            labelClean.text = "CleaninessKey".localizableString(loc: "ar")
            labelWriteComment.placeholder = "WriteCommentKey".localizableString(loc: "ar") as NSString
            UIView.appearance().semanticContentAttribute = .forceRightToLeft

        } else if lang == "ru" {
            buttonSubmit.setTitle("SubmitKey".localizableString(loc: "ru"), for: .normal)
            labelRateExp.text = "RateYourExperienceKey".localizableString(loc: "ru")
            labelWifi.text = "WifiKey".localizableString(loc: "ru")
            labelLocation.text = "LocationKey".localizableString(loc: "ru")
            labelRoomService.text = "RoomServiceKey".localizableString(loc: "ru")
            labelComfirt.text = "ComfortKey".localizableString(loc: "ru")
            labelStaff.text = "Staff".localizableString(loc: "ru")
            labelComment.text = "CommentsKey".localizableString(loc: "ru")
            labelClean.text = "CleaninessKey".localizableString(loc: "ru")
            labelWriteComment.placeholder = "WriteCommentKey".localizableString(loc: "ru") as NSString
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
        }
    }
}

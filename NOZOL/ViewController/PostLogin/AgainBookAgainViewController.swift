//
//  AgainBookAgainViewController.swift
//  NOZOL
//
//  Created by Mukul Sharma on 18/07/20.
//  Copyright © 2020 Mukul Sharma. All rights reserved.
//

import UIKit
import RSKPlaceholderTextView


class AgainBookAgainViewController: UIViewController {

    
    @IBOutlet weak var descTextView : RSKPlaceholderTextView!
     @IBOutlet weak var textFieldCheckIn : UITextField!
    @IBOutlet weak var textFieldCheckOut : UITextField!
    @IBOutlet weak var textFieldNoRooms : UITextField!
    @IBOutlet weak var textFieldNoAdults : UITextField!
    @IBOutlet weak var textFieldNoChildren : UITextField!
    @IBOutlet weak var textFieldDOB : UITextField!
     @IBOutlet weak var labelTitle : UILabel!
    @IBOutlet weak var labelStayingAt: UILabel!
    @IBOutlet weak var labelCongrats: UILabel!
    @IBOutlet weak var buttonSubmit: UIButton!
    
    var currentUserLogin : User!
    var dateD: Date?
    var datePickerView : UIDatePicker = UIDatePicker()
    var statusResponse = serviceModel()
    var getTitle = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLocalization()
        setUpCheckInDatePickerView()
        setUpCheckOutDatePickerView()
        //self.descTextView.placeholder = "Write your comment... "
        CommonClass.makeViewCircularWithCornerRadius(descTextView, borderColor: .gray, borderWidth: 0.5, cornerRadius: 10.0)
        labelTitle.text = self.getTitle
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.currentUserLogin = User.loadSavedUser()
        checkRoomStatus(userId: currentUserLogin.userId)
    }
    
    @IBAction func onClickBackButton(_ sender : UIButton){
        self.navigationController?.pop(true)
    }
    
    
    fileprivate func setUpCheckInDatePickerView(){
        
        self.textFieldCheckIn.inputView = self.datePickerView
        datePickerView = UIDatePicker()
        
        datePickerView.datePickerMode = .date
        datePickerView.minimumDate = Date()
        textFieldCheckIn.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(AgainBookAgainViewController.dateChanged(datePicker:)), for: .valueChanged)
        datePickerView.minimumDate = Date()
        
        //let todaysDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        //self.currentDate = dateFormatter.string(from: todaysDate)
        
    }
    
    @objc func dateChanged(datePicker : UIDatePicker ){
        let dateFormatter  = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateD = datePicker.date
        textFieldCheckIn.text = dateFormatter.string(from: datePicker.date)
        setUpCheckOutDatePickerView()
        setUpCheckOutDatePickerView()
    }
    
    fileprivate func setUpCheckOutDatePickerView(){
        
        self.textFieldCheckOut.inputView = self.datePickerView
        datePickerView = UIDatePicker()
        datePickerView.datePickerMode = .date
        
        let dateFormatters = DateFormatter()
        dateFormatters.dateFormat = "yyyy-MM-dd"
        let date = dateFormatters.date(from: self.textFieldCheckIn.text!)
        
        datePickerView.minimumDate = date
        textFieldCheckOut.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(AgainBookAgainViewController.dateChange(datePicker:)), for: .valueChanged)
        //datePickerView.minimumDate = Date()
        
        //let todaysDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        //self.currentDate = dateFormatter.string(from: todaysDate)
        
    }
    
    @objc func dateChange(datePicker : UIDatePicker ){
        let dateFormatter  = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateD = datePicker.date
        textFieldCheckOut.text = dateFormatter.string(from: datePicker.date)
    }
    
    
    
    @IBAction func buttonActctionSubmit(_ sender : UIButton){
        if isValidate() {
           receheduleBooking(user_id: currentUserLogin.userId, check_in_date: textFieldCheckIn.text!, check_out_date: textFieldCheckOut.text!, no_room: textFieldNoRooms.text!, adult_no: textFieldNoAdults.text!, children_no: textFieldNoChildren.text!, message: descTextView.text!)
        }
    }
    
    //-------Textfields validation------
    func isValidate()-> Bool {
        if textFieldCheckIn.text == "" {
            NKToastHelper.sharedInstance.showErrorAlert(self, message: "Please enter the check in date.")
            return false
        } else if textFieldCheckOut.text == "" {
            NKToastHelper.sharedInstance.showErrorAlert(self, message: "Please enter the check out date.")
            return false
        } else if textFieldNoRooms.text == "" {
            NKToastHelper.sharedInstance.showErrorAlert(self, message: "Please enter the number of rooms.")
            return false
        } else if textFieldNoAdults.text == "" {
            NKToastHelper.sharedInstance.showErrorAlert(self, message: "Please enter the number of adults.")
            return false
        } else if textFieldNoChildren.text == "" {
            NKToastHelper.sharedInstance.showErrorAlert(self, message: "Please enter the number of children.")
            return false
        } else if descTextView.text == "" {
            NKToastHelper.sharedInstance.showErrorAlert(self, message: "Please fill where you are staying at")
            return false
        }
        return true
    }
    
    

    //-------Call service-------
    func receheduleBooking(user_id: String,check_in_date: String,check_out_date: String,no_room: String,adult_no: String,children_no: String,message: String) {
        CommonClass.showLoader()
    
        Webservice.shared.rescheduleBooking(user_id: user_id,check_in_date: check_in_date,check_out_date: check_out_date,no_room: no_room,adult_no: adult_no,children_no: children_no,message: message) { (result,msg,response) in
            CommonClass.hideLoader()
            
            if result == 1 {
                UserDefaults.standard.set("true", forKey: "checkInId")
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
extension AgainBookAgainViewController {
    
    func setLocalization() {
        let lang = UserDefaults.standard.value(forKey: "language") as? String
        if lang == "en" {
            buttonSubmit.setTitle("SubmitKey".localizableString(loc: "en"), for: .normal)
            labelCongrats.text = "CongratsKey".localizableString(loc: "en")
            labelStayingAt.text = "StayingAtKey".localizableString(loc: "en")
            textFieldCheckIn.placeholder = "CheckinKey".localizableString(loc: "en")
            textFieldCheckOut.placeholder = "CheckoutKey".localizableString(loc: "en")
            textFieldNoRooms.placeholder = "NumberofRoomRequiredKey".localizableString(loc: "en")
            textFieldNoAdults.placeholder = "NumberofAdultKey".localizableString(loc: "en")
            textFieldNoChildren.placeholder = "NumberofChildKey".localizableString(loc: "en")
            self.descTextView.placeholder = "Write your comment..."
            UIView.appearance().semanticContentAttribute = .forceLeftToRight

        } else if lang == "ar"{
            buttonSubmit.setTitle("SubmitKey".localizableString(loc: "ar"), for: .normal)
            labelCongrats.text = "CongratsKey".localizableString(loc: "ar")
            labelStayingAt.text = "StayingAtKey".localizableString(loc: "ar")
            textFieldCheckIn.placeholder = "CheckinKey".localizableString(loc: "ar")
            textFieldCheckOut.placeholder = "CheckoutKey".localizableString(loc: "ar")
            textFieldNoRooms.placeholder = "NumberofRoomRequiredKey".localizableString(loc: "ar")
            textFieldNoAdults.placeholder = "NumberofAdultKey".localizableString(loc: "ar")
            textFieldNoChildren.placeholder = "NumberofChildKey".localizableString(loc: "ar")
            self.descTextView.placeholder = "اكتب تعليقك ..."
            UIView.appearance().semanticContentAttribute = .forceRightToLeft

        } else if lang == "ru" {
            buttonSubmit.setTitle("SubmitKey".localizableString(loc: "ru"), for: .normal)
            labelCongrats.text = "CongratsKey".localizableString(loc: "ru")
            labelStayingAt.text = "StayingAtKey".localizableString(loc: "ru")
            textFieldCheckIn.placeholder = "CheckinKey".localizableString(loc: "ru")
            textFieldCheckOut.placeholder = "CheckoutKey".localizableString(loc: "ru")
            textFieldNoRooms.placeholder = "NumberofRoomRequiredKey".localizableString(loc: "ru")
            textFieldNoAdults.placeholder = "NumberofAdultKey".localizableString(loc: "ru")
            textFieldNoChildren.placeholder = "NumberofChildKey".localizableString(loc: "ru")
            self.descTextView.placeholder = "Напишите свой комментарий ..."
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
        }
    }
}

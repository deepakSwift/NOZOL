//
//  ChangePasswordViewController.swift
//  NOZOL
//
//  Created by Mukul Sharma on 16/07/20.
//  Copyright © 2020 Mukul Sharma. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class ChangePasswordViewController: UIViewController {
    
    @IBOutlet weak var oldpasswordtextField : SkyFloatingLabelTextField!
    @IBOutlet weak var newpasswordtextField : SkyFloatingLabelTextField!
    @IBOutlet weak var confirmpasswordtextField : SkyFloatingLabelTextField!
    
    var currentUserLogin : User!
    var statusResponse = serviceModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.currentUserLogin = User.loadSavedUser()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.currentUserLogin = User.loadSavedUser()
        checkRoomStatus(userId: currentUserLogin.userId)
    }
    
    @IBAction func onClickBackButton(_ sender : UIButton){
        self.navigationController?.pop(true)
    }
    
    @IBAction func onClickSubmitButton(_ sender : UIButton){
        guard let oldPass = oldpasswordtextField.text, oldPass != "" else {
            NKToastHelper.sharedInstance.showErrorAlert(self, message: "Please enter old password.")
            return
        }
        guard let newPassword = newpasswordtextField.text, newPassword != "" else {
            NKToastHelper.sharedInstance.showErrorAlert(self, message: "Please enter new password.")
            return
        }
        if newPassword.count < 6 {
            NKToastHelper.sharedInstance.showErrorAlert(self, message: "Please enter 6 digit password.")
            return

        }
        
        guard let confirmPass = confirmpasswordtextField.text, confirmPass != "" else {
            NKToastHelper.sharedInstance.showErrorAlert(self, message: "Please enter confirm password.")
            return
        }
        
        if oldPass == newPassword{
            NKToastHelper.sharedInstance.showErrorAlert(self, message: "New password should not be same as old password.")
            return
        }
        if newPassword != confirmPass{
            NKToastHelper.sharedInstance.showErrorAlert(self, message: "Password and confirm password must be same.")
            return
        }
        
        
        self.changePassword(userid: self.currentUserLogin.userId, oldPassword: oldPass, newPassword: newPassword, confirmPassword: confirmPass)
        
    }
    
    
    
    func changePassword(userid : String,oldPassword : String,newPassword : String,confirmPassword : String){
        CommonClass.showLoader()
        Webservice.shared.changePassword(userId: userid, oldPassword: oldPassword, newPassword: newPassword, confirmPassword: confirmPassword){ (result, message) in
            CommonClass.hideLoader()
            if result == 1 {
                let matchVC = AppStoryboard.Home.viewController(PasswordPopUpViewController.self)
                self.oldpasswordtextField.text = ""
                self.newpasswordtextField.text = ""
                self.confirmpasswordtextField.text = ""
                matchVC.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
                let nav = UINavigationController(rootViewController: matchVC)
                nav.modalPresentationStyle = .overFullScreen
                nav.navigationBar.isHidden = true
                self.navigationController?.present(nav, animated: true)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.9, execute: {
                    self.dismiss(animated: true, completion: nil)
                })
                DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                    self.navigationController?.popViewController(animated: true)
                })
            } else {
                NKToastHelper.sharedInstance.showAlert(self, title: .title, message: message)
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
                //self.labelRoomNo.text = roomNumber
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

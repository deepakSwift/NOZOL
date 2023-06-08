//
//  AccountViewController.swift
//  NOZOL
//
//  Created by Mukul Sharma on 15/07/20.
//  Copyright © 2020 Mukul Sharma. All rights reserved.
//

import UIKit

class AccountViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var accountTableView : UITableView!
    
    var accountArray = ["Check in","Room & suits","Loyality and Offers","Checkout","Book again on discount","Hotel Map","Change Password","Change Language","Sign out"]
    var accountArray1 = ["تحقق في","الغرفة والبدلات","الولاء والعروض","الدفع","احجز مرة أخرى على الخصم","خريطة الفندق","غير كلمة السر","تغيير اللغة","خروج"]
    var accountArray2 = ["Регистрироваться","Комнаты и костюмы","Лояльность и предложения","Проверять, выписываться","Забронируйте снова со скидкой","Карта отеля","Сменить пароль","Изменить язык","выход"]
    
    let lang = UserDefaults.standard.value(forKey: "language") as? String
    var accountArrays = [String]()
    var accountImageArray =  [ #imageLiteral(resourceName: "Check In"),#imageLiteral(resourceName: "Room & Suits"),#imageLiteral(resourceName: "Loyality and offers"),#imageLiteral(resourceName: "Checkout"),#imageLiteral(resourceName: "Book again on discount"),#imageLiteral(resourceName: "Group 62578"),#imageLiteral(resourceName: "Change Password"),#imageLiteral(resourceName: "nozol"),#imageLiteral(resourceName: "XMLID_2_")]
    var currentUserLogin : User!
    var getRoomNo = ""
    var statusResponse = serviceModel()
    
    var isLoginWithSocial = UserDefaults.standard.value(forKey: "isLoginWithSocial") as? String
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let lang = UserDefaults.standard.value(forKey: "language") as? String
        if lang == "en" {
            accountArrays.append(contentsOf: accountArray)
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
            
        } else if lang == "ar"{
            accountArrays.append(contentsOf: accountArray1)
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
            
        } else if lang == "ru" {
            accountArrays.append(contentsOf: accountArray2)
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
        }
        self.accountTableView.dataSource = self
        self.accountTableView.delegate = self
        accountTableView.contentInset = UIEdgeInsets(top: -UIApplication.shared.statusBarFrame.size.height, left: 0, bottom: 0, right: 0)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
         self.currentUserLogin = User.loadSavedUser()
        self.getRoomNo = roomNumber
        getProfileUpdatedData(userId: currentUserLogin.userId)
         updateToken(userId: currentUserLogin.userId, tokenId: kDeviceToken)
        accountTableView.reloadData()
    }
    
    
    //--------tableView-----
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
        }else if section == 1{
            return accountArrays.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "AccountTableViewCell", for: indexPath) as! AccountTableViewCell
            CommonClass.makeViewCircular(cell.profilePicture, borderColor: .clear, borderWidth: 0.0)
            cell.usernameLabel.text = currentUserLogin.name
            cell.emailLabel.text = currentUserLogin.email
            cell.labelRoomNo.text = self.getRoomNo
            cell.profilePicture.sd_setImage(with: URL(string:"\(self.currentUserLogin.profileImage)"), placeholderImage: #imageLiteral(resourceName: "account yellow") )

            return cell
        }else if indexPath.section == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "AccountSecondTableViewCell", for: indexPath) as! AccountSecondTableViewCell
            let checkInStatus = UserDefaults.standard.value(forKey: "checkInStatus") as? String
            if checkInStatus == "true" && indexPath.row == 0 {
                cell.checkInImage.image = #imageLiteral(resourceName: "green checked")
            } else {
                cell.checkInImage.image = #imageLiteral(resourceName: "icons8-forward-50")
            }
            cell.titleImage.image = accountImageArray[indexPath.row]
            cell.titleLabel.text = accountArrays[indexPath.row]
            if indexPath.row == 8{
                cell.titleLabel.textColor = .red
                cell.titleImage.image = cell.titleImage.image?.withRenderingMode(.alwaysTemplate)
                cell.titleImage.tintColor = .red
            }
            return cell
            
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            return 300
        }else if indexPath.section == 1 {
            
            if isLoginWithSocial == "true" && indexPath.row == 6 {
                return 0
            } else {
               return 50
            }
        }
        
        return UITableView.automaticDimension
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0{
            let profileVc = AppStoryboard.Home.viewController(ProfileViewController.self)
            self.navigationController?.pushViewController(profileVc, animated: true)
        }else if indexPath.section == 1{
            if indexPath.row == 8 {
                
                if lang == "en" {

                    // create the alert
                    let alert = UIAlertController(title: "Alert", message: "Are you sure you want to sign out?", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
                    alert.addAction(UIAlertAction(title: "SignOut", style: UIAlertAction.Style.default, handler: { (actionSheetController) -> Void in
                        self.logoutUser(userid: self.currentUserLogin.userId)
                    }))
                    // show the alert
                    self.present(alert, animated: true, completion: nil)
                    
                } else if lang == "ar"{

                   // create the alert
                   let alert = UIAlertController(title: "إنذار", message: "هل أنت متأكد أنك تريد الخروج؟", preferredStyle: UIAlertController.Style.alert)
                   alert.addAction(UIAlertAction(title: "إلغاء", style: UIAlertAction.Style.cancel, handler: nil))
                   alert.addAction(UIAlertAction(title: "خروج", style: UIAlertAction.Style.default, handler: { (actionSheetController) -> Void in
                       self.logoutUser(userid: self.currentUserLogin.userId)
                   }))
                   // show the alert
                   self.present(alert, animated: true, completion: nil)

                } else if lang == "ru" {

                   // create the alert
                   let alert = UIAlertController(title: "Предупреждение", message: "Вы уверены, что хотите выйти?", preferredStyle: UIAlertController.Style.alert)
                   alert.addAction(UIAlertAction(title: "Отмена", style: UIAlertAction.Style.cancel, handler: nil))
                   alert.addAction(UIAlertAction(title: "Выход", style: UIAlertAction.Style.default, handler: { (actionSheetController) -> Void in
                       self.logoutUser(userid: self.currentUserLogin.userId)
                   }))
                   // show the alert
                   self.present(alert, animated: true, completion: nil)
                }
                
            }else if indexPath.row == 6{
                let profileVc = AppStoryboard.Home.viewController(ChangePasswordViewController.self)
                self.navigationController?.pushViewController(profileVc, animated: true)

            }else if indexPath.row == 2{
                let loyalVc = AppStoryboard.Home.viewController(LoyaltyAndOffersViewController.self)
                loyalVc.getTitle = accountArrays[indexPath.row]
                          self.navigationController?.pushViewController(loyalVc, animated: true)
            }else if indexPath.row == 4{
                let bookVc = AppStoryboard.Home.viewController(AgainBookAgainViewController.self)
                bookVc.getTitle = accountArrays[indexPath.row]
                    self.navigationController?.pushViewController(bookVc, animated: true)
            }else if indexPath.row == 1{
                let bookVc = AppStoryboard.Home.viewController(Room_SuitsViewController.self)
                    self.navigationController?.pushViewController(bookVc, animated: true)

            }else if indexPath.row == 3 {
                //let checkInID = UserDefaults.standard.value(forKey: "checkInId") as? String
                let checkInStatus = UserDefaults.standard.value(forKey: "checkInStatus") as? String
                
                if checkInStatus == nil || checkInStatus == "" {
                    NKToastHelper.sharedInstance.showAlert(self, title: .title, message: "You are not checked in yet.")
                } else {
                    let checkOutVc = AppStoryboard.Home.viewController(CheckOutViewController.self)
                    checkOutVc.getTitle = accountArrays[indexPath.row]
                    self.navigationController?.pushViewController(checkOutVc, animated: true)
                }
                

            }else if indexPath.row == 0 {
                let checkInID = UserDefaults.standard.value(forKey: "checkInId") as? String
                let checkInStatus = UserDefaults.standard.value(forKey: "checkInStatus") as? String
                
                if checkInStatus == "true"  {
                    NKToastHelper.sharedInstance.showAlert(self, title: .title, message: "Your are already check in.")
                } else {
                    if checkInID == nil || checkInID == "" {
                        let checkInVc = AppStoryboard.Home.viewController(CheckinViewController.self)
                        self.navigationController?.pushViewController(checkInVc, animated: true)
                    } else {
                       NKToastHelper.sharedInstance.showAlert(self, title: .title, message: "Your check in request is under process")
                    }
                }
                
                    
                
            }else if indexPath.row == 5{
                let HotelMapVC = AppStoryboard.Home.viewController(HotelMapViewController.self)
                HotelMapVC.getTitle = accountArrays[indexPath.row]
                self.navigationController?.pushViewController(HotelMapVC, animated: true)
               // NKToastHelper.sharedInstance.showAlert(self, title: .title, message: "Please ignore it. Under development")

            } else if indexPath.row == 7 {
                let languageVC = self.storyboard?.instantiateViewController(withIdentifier: "ChangeLanguageVC") as! ChangeLanguageVC
                languageVC.delegate = self
                self.present(languageVC, animated: true, completion: nil)
            }
        }
    }
    
    
    
    func logoutUser(userid : String){
        CommonClass.showLoader(withStatus: "Logout...")
        Webservice.shared.logout(userId: userid){ (result,message) in
            CommonClass.hideLoader()
            if result == 1 {
                UserDefaults.standard.removeObject(forKey: "checkInStatus")
                UserDefaults.standard.removeObject(forKey: "checkInId")
                UserDefaults.standard.removeObject(forKey: "isLoginWithSocial")
                UserDefaults.standard.removeObject(forKey: "language")
                roomNumber = ""
                NotificationCenter.default.post(name: .stopTimer, object: nil)
                AppSettings.shared.isLoggedIn = false
                AppSettings.shared.proceedToLoginModule()
            } else {
                NKToastHelper.sharedInstance.showAlert(self, title: .title, message: message)
            }
        }
    }

    //------Update Token-------
    func updateToken(userId: String, tokenId: String) {
        Webservice.shared.updateToken(userId: userId, tokenId: tokenId) { (result, message) in
            if result == 1 {
                print("Token Updated")
            } else {
                print("Failed to update token")
            }
        }
    }
    
    //--------getProfileData------
    func getProfileUpdatedData(userId: String) {
        CommonClass.showLoader()
        Webservice.shared.getProfileData(userId: userId) { (result, message, data) in
            CommonClass.hideLoader()
            if result == 1 {
                self.accountTableView.reloadData()
                self.checkRoomStatus(userId: self.currentUserLogin.userId)
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
                self.getRoomNo = roomNumber
                self.accountTableView.reloadData()
            } else {
                
                if let data = response {
                    self.statusResponse = data
                }
                
                if self.statusResponse.booking_status == "Disapprove" {
                    UserDefaults.standard.removeObject(forKey: "checkInId")
                    UserDefaults.standard.removeObject(forKey: "checkInStatus")
                    self.getRoomNo = ""
                    roomNumber = ""
                    self.accountTableView.reloadData()
                } else if self.statusResponse.booking_status == "Pending"{
                    UserDefaults.standard.set("true", forKey: "checkInId")
                    self.getRoomNo = ""
                    roomNumber = ""
                    self.accountTableView.reloadData()
                } else {
                    UserDefaults.standard.removeObject(forKey: "checkInId")
                    UserDefaults.standard.removeObject(forKey: "checkInStatus")
                    self.getRoomNo = ""
                    roomNumber = ""
                    self.accountTableView.reloadData()
                }
            }
        }
    }
}


extension AccountViewController: CallFromChangeLanguage {
    func callHomeController() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabBarController") as! TabBarController
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

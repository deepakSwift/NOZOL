//
//  NotificationViewController.swift
//  NOZOL
//
//  Created by Mukul Sharma on 15/07/20.
//  Copyright © 2020 Mukul Sharma. All rights reserved.
//

import UIKit

class NotificationViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var notificationTableView : UITableView!
    @IBOutlet weak var labelNotification : UILabel!
    
    var currentUserLogin : User!
    var notificationList = checkInModel()
    var statusResponse = serviceModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLocalization()
        self.notificationTableView.dataSource = self
        self.notificationTableView.delegate = self
         self.currentUserLogin = User.loadSavedUser()
        print("userId========\(currentUserLogin.userId)")
        
        getAllNotification(userId: currentUserLogin.userId)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.currentUserLogin = User.loadSavedUser()
        checkRoomStatus(userId: currentUserLogin.userId)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notificationList.notification.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "NotificationTableViewCell", for: indexPath) as! NotificationTableViewCell
        cell.labelTitle.text = notificationList.notification[indexPath.row].title
        cell.labeldesc.text = notificationList.notification[indexPath.row].body
        cell.labelTime.text = notificationList.notification[indexPath.row].created_at
        return cell
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90.0
    }
    
    func getAllNotification(userId: String) {
        CommonClass.showLoader()
        Webservice.shared.getNotificationList(UserId: userId) { (result,msg,response) in
            CommonClass.hideLoader()
            if result == 1 {
                if let data = response {
                    self.notificationList = data
                    self.notificationTableView.reloadData()
                    
                    if self.notificationList.notification.count == 0 {
                        let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: self.notificationTableView.bounds.size.width, height: self.notificationTableView.bounds.size.height))
                        noDataLabel.text          = "No notification found."
                        noDataLabel.textColor     = UIColor.black
                        noDataLabel.textAlignment = .center
                        self.notificationTableView.backgroundView  = noDataLabel
                        self.notificationTableView.backgroundColor = UIColor.white
                        self.notificationTableView.separatorStyle  = .none
                    }
                    
                }
            } else {
                let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: self.notificationTableView.bounds.size.width, height: self.notificationTableView.bounds.size.height))
                noDataLabel.text          = msg
                noDataLabel.textColor     = UIColor.black
                noDataLabel.textAlignment = .center
                self.notificationTableView.backgroundView  = noDataLabel
                self.notificationTableView.backgroundColor = UIColor.white
                self.notificationTableView.separatorStyle  = .none
                //NKToastHelper.sharedInstance.showAlert(self, title: .alertTitle, message: msg)
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
extension NotificationViewController {
    
    func setLocalization() {
        let lang = UserDefaults.standard.value(forKey: "language") as? String
        if lang == "en" {
            labelNotification.text = "NotificationKey".localizableString(loc: "en")
            UIView.appearance().semanticContentAttribute = .forceLeftToRight

        } else if lang == "ar"{
            labelNotification.text = "NotificationKey".localizableString(loc: "ar")
            UIView.appearance().semanticContentAttribute = .forceRightToLeft

        } else if lang == "ru" {
            labelNotification.text = "NotificationKey".localizableString(loc: "ru")
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
        }
    }
}

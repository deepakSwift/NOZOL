//
//  LoyaltyAndOffersViewController.swift
//  NOZOL
//
//  Created by Mukul Sharma on 18/07/20.
//  Copyright © 2020 Mukul Sharma. All rights reserved.
//

import UIKit

class LoyaltyAndOffersViewController: UIViewController ,UITableViewDataSource,UITableViewDelegate{
    
    
    @IBOutlet weak var loyalTableview : UITableView!
    @IBOutlet weak var labelTitle : UILabel!
    
    var loyalList = [serviceModel]()
    var currentUserLogin : User!
    var statusResponse = serviceModel()
    var getTitle = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loyalTableview.dataSource = self
        self.loyalTableview.delegate = self
        labelTitle.text = self.getTitle
        self.getLoyalList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.currentUserLogin = User.loadSavedUser()
        checkRoomStatus(userId: currentUserLogin.userId)
    }
    
    @IBAction func onClickBackButton(_ sender : UIButton){
        self.navigationController?.pop(true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return loyalList.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LoyaltyTableViewCell", for: indexPath) as! LoyaltyTableViewCell
        let newData = loyalList[indexPath.row]
        cell.laytyImage.sd_setImage(with: URL(string:"\(newData.imageUrl)"), placeholderImage: #imageLiteral(resourceName: "checkin form image") )

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150.0
    }
    
    
    func getLoyalList(){
        CommonClass.showLoader()
        Webservice.shared.loyalityAndOffers(){ (result,msg,response) in
            CommonClass.hideLoader()
            if result == 1 {
                if let data = response {
                    self.loyalList.removeAll()
                    self.loyalList.append(contentsOf: data)
                    self.loyalTableview.reloadData()
                }
            } else {
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

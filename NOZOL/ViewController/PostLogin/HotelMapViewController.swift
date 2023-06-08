//
//  HotelMapViewController.swift
//  NOZOL
//
//  Created by deepak Kumar on 24/07/20.
//  Copyright © 2020 Mukul Sharma. All rights reserved.
//

import UIKit
import SDWebImage

class HotelMapViewController: UIViewController {

    @IBOutlet weak var MapImage: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    
    var currentUserLogin : User!
    var statusResponse = serviceModel()
    var getTitle = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getMap()
        MapImage.isUserInteractionEnabled = true
        
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(self.pinchGesture(sender:)))
        let painGesture = UIPanGestureRecognizer(target: self, action: #selector(self.painGesture(sender:)))
        MapImage.addGestureRecognizer(pinchGesture)
        MapImage.addGestureRecognizer(painGesture)
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
    
    @objc func pinchGesture(sender: UIPinchGestureRecognizer) {
        sender.view?.transform = (sender.view?.transform.scaledBy(x: sender.scale, y: sender.scale))!
        sender.scale = 1.0
    }
    
    @objc func painGesture(sender: UIPanGestureRecognizer) {
    
        let translation = sender.translation(in: view)
        guard let gestureView = sender.view else {
          return
        }

        gestureView.center = CGPoint(
          x: gestureView.center.x + translation.x,
          y: gestureView.center.y + translation.y
        )

        sender.setTranslation(.zero, in: view)
    }
    
    func getMap() {
        CommonClass.showLoader()
        Webservice.shared.hotelMap { (result, message, data) in
            CommonClass.hideLoader()
            if result == 1 {
                self.MapImage.sd_setImage(with: URL(string:"\(data?.image_url ?? "")"), placeholderImage: #imageLiteral(resourceName: "Splash dumy logo") )
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

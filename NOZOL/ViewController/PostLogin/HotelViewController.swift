//
//  HotelViewController.swift
//  NOZOL
//
//  Created by Mukul Sharma on 15/07/20.
//  Copyright © 2020 Mukul Sharma. All rights reserved.
//

import UIKit
import SDWebImage
import Cosmos

class HotelViewController: UIViewController, UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var roomsCollectionView : UICollectionView!
    @IBOutlet weak var roommTableView : UITableView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var labelHotelTtile: UILabel!
    @IBOutlet weak var labelHotelHeading: UILabel!
    @IBOutlet weak var labelTextHeading: UILabel!
    @IBOutlet weak var buttonCheckIn: UIButton!
    @IBOutlet weak var starRating: CosmosView!

    var statusResponse = serviceModel()
    var currentUserLogin : User!
    var homeData = SubCategoryServiceModel()
    var timer = Timer()
    var getCheckInId = ""
    var checkInID = UserDefaults.standard.value(forKey: "checkInId") as? String
    let lang = UserDefaults.standard.value(forKey: "language") as? String
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLocalization()
        self.currentUserLogin = User.loadSavedUser()
        self.roommTableView.dataSource = self
        self.roommTableView.delegate = self
        self.roomsCollectionView.dataSource = self
        self.roomsCollectionView.delegate = self
        starRating.isUserInteractionEnabled = false
         roommTableView.contentInset = UIEdgeInsets(top: -UIApplication.shared.statusBarFrame.size.height, left: 0, bottom: 0, right: 0)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 2
        layout.minimumInteritemSpacing = 0
        roomsCollectionView.setCollectionViewLayout(layout, animated: false)
        
        NotificationCenter.default.addObserver(self, selector: #selector(checkinId(notification:)), name: .passCheckInId, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(stopTimer(notification:)), name: .stopTimer, object: nil)
        
        updateToken(userId: currentUserLogin.userId, tokenId: kDeviceToken)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        getHomeData(userId: currentUserLogin.userId)
        
    }
    
    func setupData() {
        labelHotelTtile.text = homeData.title
        labelHotelHeading.text = homeData.detail
        labelTextHeading.text = homeData.heading
        starRating.rating = Double((homeData.reviews))
        
        checkRoomNoStatus()
    }
    
    //------Check if allready room no available
    func checkRoomNoStatus() {
        
        if homeData.room_number.count == 0 {
            checkRoomStatus(userId: currentUserLogin.userId)

        } else {
            if lang == "en" {
                self.buttonCheckIn.setTitle("Room No: \(self.homeData.room_number[0])", for: .normal)
            } else if lang == "ar" {
                self.buttonCheckIn.setTitle("رقم الغرفة: \(self.homeData.room_number[0])", for: .normal)
            } else if lang == "ru" {
                self.buttonCheckIn.setTitle("Комната нет. \(self.homeData.room_number[0])", for: .normal)
            }
            roomNumber = self.homeData.room_number[0]
            self.buttonCheckIn.isUserInteractionEnabled = false
            UserDefaults.standard.set("true", forKey: "checkInStatus")
        }
        
    }
    
    @objc func checkinId(notification: Notification) {
        let id = notification.userInfo?["keyId"] as! String
        print("checkinId===============\(id)")
        self.checkInID = id
        scheduledTimerWithTimeInterval()
    }
    
    @objc func stopTimer(notification: Notification) {
        self.timer.invalidate()
    }
    
    
    @IBAction func onClickcheckInButton(_ sender : UIButton){
        let checkinVC = AppStoryboard.Home.viewController(CheckinViewController.self)
        self.navigationController?.pushViewController(checkinVC, animated: true)
    }
    
    @IBAction func onClickChatButton(_ sender : UIButton){
        
        let chatVC = ChatLogController()
        let userDict: [String : AnyObject] = ["userID" : self.currentUserLogin.userId as AnyObject, "name" : self.currentUserLogin.name as AnyObject, "email" : self.currentUserLogin.email as AnyObject, "adminId" : "TyM1oIvSbn" as AnyObject, "chatID" : "\(self.currentUserLogin.userId)_\("TyM1oIvSbn")" as AnyObject]
        
        let user = Users(dictionary: userDict)
        chatVC.user = user
        navigationController?.pushViewController(chatVC, animated: true)
        
    }
    
    //-----_TableView------
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        cell.titlelabel.text  = homeData.descr
        return cell
    }
    
    
    //-----_CollectionView------
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        pageControl.numberOfPages = homeData.images.count
        return homeData.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RoomsCollectionViewCell", for: indexPath) as! RoomsCollectionViewCell
        
        let imageUrl = homeData.images[indexPath.item]
        if let url = URL(string: imageUrl) {
         cell.bannerImage.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "hhotel yellow") )
        }
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        let cellWidth = (width) // compute your cell width
        return CGSize(width: cellWidth, height: collectionView.bounds.height)
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
           pageControl.currentPage = indexPath.row
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if pageControl.currentPage == indexPath.row {
            pageControl.currentPage = collectionView.indexPath(for: collectionView.visibleCells.first!)!.row
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
           let currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
           pageControl?.currentPage = currentPage
       }
       
       func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
           let currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
           pageControl?.currentPage = currentPage
       }
    
    //------_Service called-------
    func getHomeData(userId: String){
        CommonClass.showLoader()
        Webservice.shared.homeScreenData(UserId: userId){ (result,msg,response) in
            CommonClass.hideLoader()
            if result == 1 {
                if let data = response {
                    self.homeData = data
                    self.roomsCollectionView.reloadData()
                    self.roommTableView.reloadData()
                    self.setupData()
                }
            } else {
                
                NKToastHelper.sharedInstance.showAlert(self, title: .alertTitle, message: msg)
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
    
    //-----Check status Api call----
    func checkRoomStatus(userId: String) {
        //CommonClass.showLoader()
        Webservice.shared.checkRoomStatus(userId: userId) { (result, message, response) in
            //CommonClass.hideLoader()
            if result == 1 {
                if let data = response {
                    self.statusResponse = data
                }
                NKToastHelper.sharedInstance.showAlert(self, title: .alertTitle, message: self.statusResponse.booking_status)
                //self.buttonCheckIn.setTitle("Room No: \(self.statusResponse.room_no[0])", for: .normal)
                if self.lang == "en" {
                    self.buttonCheckIn.setTitle("Room No: \(self.statusResponse.room_no[0])", for: .normal)
                } else if self.lang == "ar" {
                    self.buttonCheckIn.setTitle("رقم الغرفة: \(self.statusResponse.room_no[0])", for: .normal)
                } else if self.lang == "ru" {
                    self.buttonCheckIn.setTitle("Комната нет. \(self.statusResponse.room_no[0])", for: .normal)
                }
                self.buttonCheckIn.isUserInteractionEnabled = false
                //----for block the service
                UserDefaults.standard.set("true", forKey: "checkInStatus")
                //-----for stop timer Api
                self.timer.invalidate()
                //------update room number in global variable---
                roomNumber = self.statusResponse.room_no[0]
                
            } else {
                
                if let data = response {
                    self.statusResponse = data
                }
                
                if self.statusResponse.booking_status == "Disapprove" {
                    UserDefaults.standard.removeObject(forKey: "checkInId")
                    self.buttonCheckIn.isUserInteractionEnabled = true
                    roomNumber = ""
                    if self.lang == "en" {
                        self.buttonCheckIn.setTitle("Check In", for: .normal)
                    } else if self.lang == "ar" {
                         self.buttonCheckIn.setTitle("تحقق في", for: .normal)
                    } else if self.lang == "ru" {
                         self.buttonCheckIn.setTitle("Регистрироваться", for: .normal)
                    }
                } else if self.statusResponse.booking_status == "Pending"{
                    UserDefaults.standard.set("true", forKey: "checkInId")
                    self.buttonCheckIn.isUserInteractionEnabled = false
                    roomNumber = ""
                    if self.lang == "en" {
                        self.buttonCheckIn.setTitle("Pending...", for: .normal)
                    } else if self.lang == "ar" {
                         self.buttonCheckIn.setTitle("قيد الانتظار", for: .normal)
                    } else if self.lang == "ru" {
                         self.buttonCheckIn.setTitle("В ожидании", for: .normal)
                    }
                } else {
                    UserDefaults.standard.removeObject(forKey: "checkInId")
                    self.buttonCheckIn.isUserInteractionEnabled = true
                    roomNumber = ""
                    if self.lang == "en" {
                        self.buttonCheckIn.setTitle("Check In", for: .normal)
                    } else if self.lang == "ar" {
                         self.buttonCheckIn.setTitle("تحقق في", for: .normal)
                    } else if self.lang == "ru" {
                         self.buttonCheckIn.setTitle("Регистрироваться", for: .normal)
                    }
                }
            }
        }
    }
    
    

    func scheduledTimerWithTimeInterval(){
        // Scheduling timer to Call the function "updateCounting" with the interval of 1 seconds
        timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.updateCounting), userInfo: nil, repeats: true)
    }

    @objc func updateCounting(){
 //       checkRoomStatus(userId: currentUserLogin.userId)
//        let checkInID = UserDefaults.standard.value(forKey: "checkInId") as? String
//        if checkInID == nil || checkInID == "" {
//            print("cant call service because checkin id empty")
//        } else {
//            checkRoomStatus(userId: currentUserLogin.userId)
//        }
    }
}

//-----Notification Center-----
extension Notification.Name {
    static let passCheckInId = Notification.Name("passCheckInId")
    static let roomNumberUpdate = Notification.Name("roomNumberUpdate")
    static let stopTimer = Notification.Name("stopTimer")
}

//----- Set Localization------
extension HotelViewController {
    
    func setLocalization() {
        let lang = UserDefaults.standard.value(forKey: "language") as? String
        if lang == "en" {
            buttonCheckIn.setTitle("RoomNoKey".localizableString(loc: "en"), for: .normal)
            UIView.appearance().semanticContentAttribute = .forceLeftToRight

        } else if lang == "ar"{
            buttonCheckIn.setTitle("RoomNoKey".localizableString(loc: "ar"), for: .normal)
            UIView.appearance().semanticContentAttribute = .forceRightToLeft

        } else if lang == "ru" {
            buttonCheckIn.setTitle("RoomNoKey".localizableString(loc: "ru"), for: .normal)
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
        }
    }
}

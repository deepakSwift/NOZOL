//
//  Room&SuitsViewController.swift
//  NOZOL
//
//  Created by Mukul Sharma on 18/07/20.
//  Copyright © 2020 Mukul Sharma. All rights reserved.
//

import UIKit
import Cosmos

class Room_SuitsViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    

    @IBOutlet weak var roomsCollectionView : UICollectionView!
    @IBOutlet weak var roommTableView : UITableView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var labelHotelTtile: UILabel!
    @IBOutlet weak var labelHotelHeading: UILabel!
    @IBOutlet weak var labelTextHeading: UILabel!
    @IBOutlet weak var starRating: CosmosView!

    var roomData = checkInModel()
    var currentUserLogin : User!
    var statusResponse = serviceModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        getRoomDetails()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.currentUserLogin = User.loadSavedUser()
        checkRoomStatus(userId: currentUserLogin.userId)
    }
    
    func setupData() {
        labelHotelTtile.text = roomData.title
        labelHotelHeading.text = roomData.detail
        labelTextHeading.text = roomData.heading
        starRating.rating = Double(roomData.reviews)

    }
    
    
    @IBAction func onClickBackButton(_ sender : UIButton){
        self.navigationController?.pop(true)
    }
    
    
    //--------TableView-----
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        cell.titlelabel.text  = roomData.descriptions
        return cell
    }
    
    //-------CollectionView------
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        pageControl.numberOfPages = roomData.images.count
        return roomData.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RoomsCollectionViewCell", for: indexPath) as! RoomsCollectionViewCell
        let url = roomData.images[indexPath.item]
        cell.bannerImage.sd_setImage(with: URL(string:"\(url)"), placeholderImage: #imageLiteral(resourceName: "hhotel yellow") )
        cell.labelTitle.text = roomData.image_title
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        let cellWidth = (width) // compute your cell width
        return CGSize(width: cellWidth, height: collectionView.bounds.height)
    }


    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
           let currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
           pageControl?.currentPage = currentPage
       }
       
       func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
           let currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
           pageControl?.currentPage = currentPage
       }
    
    
    func getRoomDetails() {
        CommonClass.showLoader()
        Webservice.shared.roomDetails { (result, message, response) in
            CommonClass.hideLoader()
            if result == 1 {
                if let data = response {
                    self.roomData = data
                    self.setupData()
                    self.roommTableView.reloadData()
                    self.roomsCollectionView.reloadData()
                }
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

//
//  ServiceDetailViewController.swift
//  NOZOL
//
//  Created by Mukul Sharma on 21/07/20.
//  Copyright © 2020 Mukul Sharma. All rights reserved.
//

import UIKit
import Cosmos
import SDWebImage

class ServiceDetailViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    
    @IBOutlet weak var roomsCollectionView : UICollectionView!
    @IBOutlet weak var categoryView : UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var ratingView : CosmosView!
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelRoomNo : UILabel!
    
    var subCategoryData = SubCategoryServiceModel()
    var subCategoryId = ""
    var currentUserLogin : User!
    var serviceType = ""
    var statusResponse = serviceModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.currentUserLogin = User.loadSavedUser()
        self.categoryView.dataSource = self
        self.categoryView.delegate = self
        self.roomsCollectionView.dataSource = self
        self.roomsCollectionView.delegate = self
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 0
        roomsCollectionView.setCollectionViewLayout(layout, animated: false)
        let layouts = UICollectionViewFlowLayout()
        layouts.scrollDirection = .vertical
        layouts.minimumLineSpacing = 10
        layouts.minimumInteritemSpacing = 0
        categoryView.setCollectionViewLayout(layouts, animated: false)
        
        
        //----Api call----
        getSubCategory(subCategoryId: subCategoryId)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        checkRoomStatus(userId: currentUserLogin.userId)
        self.labelRoomNo.text = roomNumber
        ratingView.isHidden = true
    }
    
    func setupData() {
        labelDescription.text = subCategoryData.subcategory_detail.descriptions
        labelTitle.text = subCategoryData.subcategory_detail.subcategory_name
    }
    
    @IBAction func onClickChatButton(_ sender : UIButton){
        
        let chatVC = ChatLogController()
        let userDict: [String : AnyObject] = ["userID" : self.currentUserLogin.userId as AnyObject, "name" : self.currentUserLogin.name as AnyObject, "email" : self.currentUserLogin.email as AnyObject, "adminId" : "TyM1oIvSbn" as AnyObject, "chatID" : "\(self.currentUserLogin.userId)_\("TyM1oIvSbn")" as AnyObject]
        
        let user = Users(dictionary: userDict)
        chatVC.user = user
        navigationController?.pushViewController(chatVC, animated: true)
        
    }
    
    @IBAction func onClickBackButton(_ sender : UIButton){
        self.navigationController?.pop(true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == roomsCollectionView{
            pageControl.numberOfPages = subCategoryData.banners.count
            return subCategoryData.banners.count
        }else if collectionView == categoryView{
            return subCategoryData.category.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == roomsCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RoomsCollectionViewCell", for: indexPath) as! RoomsCollectionViewCell
            let imageUrl = subCategoryData.banners[indexPath.item]
            cell.bannerImage.sd_setImage(with: URL(string:"\(imageUrl)"), placeholderImage: #imageLiteral(resourceName: "Kids sitting") )
            return cell
            
        }else if collectionView == categoryView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionViewCell", for: indexPath) as! CategoryCollectionViewCell
            cell.labelcategory.text = subCategoryData.category[indexPath.item].subcategory_category_name
            let imageUrl = subCategoryData.category[indexPath.item].image_url
            cell.categoryImage.sd_setImage(with: URL(string:"\(imageUrl)"), placeholderImage: #imageLiteral(resourceName: "Dry Cleaning") )
            return cell
            
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == roomsCollectionView{
            let width = roomsCollectionView.bounds.width
            let cellWidth = (width) // compute your cell width
            return CGSize(width: cellWidth, height: roomsCollectionView.bounds.height)
            
        }else if collectionView == categoryView{
            let width = categoryView.bounds.width - 10
            let cellWidth = (width)  / 2 // compute your cell width
            return CGSize(width: cellWidth, height: cellWidth)
            
        }
        return CGSize(width: 0.0, height: 0.0)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == categoryView{
            let detailVc = AppStoryboard.Home.viewController(CategoryDetailViewController.self)
            detailVc.categoryId = subCategoryData.category[indexPath.row].subcategory_category_id
            detailVc.serviceType = self.serviceType
            detailVc.serviceName = subCategoryData.category[indexPath.row].subcategory_category_name
            self.navigationController?.pushViewController(detailVc, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        pageControl.currentPage = indexPath.row
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if pageControl.currentPage == indexPath.row {
            pageControl.currentPage = collectionView.indexPath(for: collectionView.visibleCells.first!)!.row
        }
    }
    
    //------_Service called-------
    func getSubCategory(subCategoryId : String){
        CommonClass.showLoader()
        Webservice.shared.subCategoryList(category_id: subCategoryId){ (result,msg,response) in
            CommonClass.hideLoader()
            if result == 1 {
                if let data = response {
                    self.subCategoryData = data
                    self.roomsCollectionView.reloadData()
                    self.categoryView.reloadData()
                    self.setupData()
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
                self.labelRoomNo.text = roomNumber
                
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


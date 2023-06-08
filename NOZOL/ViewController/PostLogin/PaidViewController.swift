//
//  PaidViewController.swift
//  NOZOL
//
//  Created by Mukul Sharma on 21/07/20.
//  Copyright © 2020 Mukul Sharma. All rights reserved.
//

import UIKit

class PaidViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var paidCollectionView : UICollectionView!
    
    let lang = UserDefaults.standard.value(forKey: "language") as? String
    var paidList = [serviceModel]()
    
    var titleArray = [String]()
    var imageArray = [String]()
    var currentUserLogin : User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.paidCollectionView.dataSource = self
        self.paidCollectionView.delegate = self
        let layout = UICollectionViewFlowLayout()
        self.currentUserLogin = User.loadSavedUser()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 0
        paidCollectionView.setCollectionViewLayout(layout, animated: false)
        self.getPaidCategory(category: "1")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titleArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ServicesCollectionViewCell", for: indexPath) as! ServicesCollectionViewCell
        CommonClass.makeViewCircularWithCornerRadius(cell.contentView, borderColor: .white, borderWidth: 1.0, cornerRadius: 10.0)
        //let newData = paidList[indexPath.row]
        cell.titleImage.sd_setImage(with: URL(string:"\(imageArray[indexPath.item])"), placeholderImage: #imageLiteral(resourceName: "Spa & Massage") )
        cell.titleLabel.text = titleArray[indexPath.item]
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width - 10
        let cellWidth = (width) / 3 // compute your cell width
        return CGSize(width: cellWidth, height: cellWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let checkInStatus = UserDefaults.standard.value(forKey: "checkInStatus") as? String
        
        if checkInStatus == "true" {
            
            
            if self.lang == "en" {

                if titleArray[indexPath.item] == "Looking for some others services" {
                    let chatVC = ChatLogController()
                    let userDict: [String : AnyObject] = ["userID" : self.currentUserLogin.userId as AnyObject, "name" : self.currentUserLogin.name as AnyObject, "email" : self.currentUserLogin.email as AnyObject, "adminId" : "TyM1oIvSbn" as AnyObject, "chatID" : "\(self.currentUserLogin.userId)_\("TyM1oIvSbn")" as AnyObject]
                    
                    let user = Users(dictionary: userDict)
                    chatVC.user = user
                    navigationController?.pushViewController(chatVC, animated: true)
                } else {
                    let detailVC = AppStoryboard.Home.viewController(ServiceDetailViewController.self)
                    detailVC.subCategoryId = paidList[indexPath.row].subCategoryId
                    detailVC.serviceType = "Paid"
                    self.navigationController?.pushViewController(detailVC, animated: true)
                }
        
            } else if self.lang == "ar"{

              if titleArray[indexPath.item] == "أبحث عن بعض الخدمات الأخرى" {
                  let chatVC = ChatLogController()
                  let userDict: [String : AnyObject] = ["userID" : self.currentUserLogin.userId as AnyObject, "name" : self.currentUserLogin.name as AnyObject, "email" : self.currentUserLogin.email as AnyObject, "adminId" : "TyM1oIvSbn" as AnyObject, "chatID" : "\(self.currentUserLogin.userId)_\("TyM1oIvSbn")" as AnyObject]
                  
                  let user = Users(dictionary: userDict)
                  chatVC.user = user
                  navigationController?.pushViewController(chatVC, animated: true)
              } else {
                  let detailVC = AppStoryboard.Home.viewController(ServiceDetailViewController.self)
                  detailVC.subCategoryId = paidList[indexPath.row].subCategoryId
                  detailVC.serviceType = "Paid"
                  self.navigationController?.pushViewController(detailVC, animated: true)
              }
                
            } else if self.lang == "ru" {

              if titleArray[indexPath.item] == "Ищу другие услуги" {
                  let chatVC = ChatLogController()
                  let userDict: [String : AnyObject] = ["userID" : self.currentUserLogin.userId as AnyObject, "name" : self.currentUserLogin.name as AnyObject, "email" : self.currentUserLogin.email as AnyObject, "adminId" : "TyM1oIvSbn" as AnyObject, "chatID" : "\(self.currentUserLogin.userId)_\("TyM1oIvSbn")" as AnyObject]
                  
                  let user = Users(dictionary: userDict)
                  chatVC.user = user
                  navigationController?.pushViewController(chatVC, animated: true)
              } else {
                  let detailVC = AppStoryboard.Home.viewController(ServiceDetailViewController.self)
                  detailVC.subCategoryId = paidList[indexPath.row].subCategoryId
                  detailVC.serviceType = "Paid"
                  self.navigationController?.pushViewController(detailVC, animated: true)
              }
            }
            
        } else {
            NKToastHelper.sharedInstance.showAlert(self, title: .title, message: "You are not checked in yet.")
        }
    }
    
    
    func getPaidCategory(category : String){
        CommonClass.showLoader()
        Webservice.shared.serviceList(category_id: category){ (result,msg,response) in
            CommonClass.hideLoader()
            if result == 1 {
                if let data = response {
                    self.paidList.removeAll()
                    self.paidList.append(contentsOf: data)
                    
                    for data in self.paidList.enumerated() {
                        self.titleArray.append(data.element.subCategoryName)
                        self.imageArray.append(data.element.subCategoryIcon)
                    }
                }
                
                if self.lang == "en" {
                   self.titleArray.append("Looking for some others services")
                    UIView.appearance().semanticContentAttribute = .forceLeftToRight

                } else if self.lang == "ar"{
                   self.titleArray.append("أبحث عن بعض الخدمات الأخرى")
                    UIView.appearance().semanticContentAttribute = .forceRightToLeft

                } else if self.lang == "ru" {
                    self.titleArray.append("Ищу другие услуги")
                    UIView.appearance().semanticContentAttribute = .forceLeftToRight
                }
                
                self.imageArray.append("")
                self.paidCollectionView.reloadData()
                
            } else {
                NKToastHelper.sharedInstance.showAlert(self, title: .alertTitle, message: msg)
            }
        }
    }

}

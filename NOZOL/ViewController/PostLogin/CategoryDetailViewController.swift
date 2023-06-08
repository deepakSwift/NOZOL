//
//  CategoryDetailViewController.swift
//  NOZOL
//
//  Created by Mukul Sharma on 21/07/20.
//  Copyright © 2020 Mukul Sharma. All rights reserved.
//

import UIKit
import GMStepper

class CategoryDetailViewController: UIViewController,UITableViewDataSource,UITableViewDelegate{
    

    @IBOutlet weak var categoryDetailTableView : UITableView!
    @IBOutlet weak var labelRoomNo : UILabel!
    @IBOutlet weak var labelTopCategory : UILabel!
    
    var serviceList = [serviceModel]()
    var currentUserLogin : User!
    var categoryId = ""
    var getSignatureImage:UIImageView = UIImageView()
    var selectedArray = [IndexPath]()
    var service_id = [Int]()
    var quantity = [Int]()
    var serviceType = ""
    var serviceName = ""
    var statusResponse = serviceModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.categoryDetailTableView.dataSource = self
        self.categoryDetailTableView.delegate = self
        labelTopCategory.text = serviceName
        getCategoryService(category: categoryId)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.currentUserLogin = User.loadSavedUser()
        checkRoomStatus(userId: currentUserLogin.userId)
        labelRoomNo.text = roomNumber
    }
    
    @IBAction func onclickBackButton(_ sender : UIButton){
        self.navigationController?.pop(true)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return serviceList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyServiceTableViewCell", for: indexPath) as! MyServiceTableViewCell
        
        if serviceType == "Unpaid" {
            //cell.labelPrice.isHidden = true
            cell.labelPrice.text = "free"
        } else {
            //cell.labelPrice.isHidden = false
            cell.labelPrice.text = "E£" + serviceList[indexPath.row].price
        }
        
        
        cell.labelServiceName.text = serviceList[indexPath.row].serviceName
        cell.labelDescription.text = serviceList[indexPath.row].desc
        let imageUrl = serviceList[indexPath.row].imageUrl
        cell.imageViewService.sd_setImage(with: URL(string:"\(imageUrl)"), placeholderImage: #imageLiteral(resourceName: "Dry Cleaning") )
        
        cell.addStepperView.labelFont = UIFont(name: "AvenirNext-Bold", size: 15.0)!
        cell.addStepperView.isHidden = true
        cell.stepperView.isHidden = false
        cell.addBtn.tag = indexPath.row
        cell.addBtn.addTarget(self, action: #selector(addBtnTapped), for: .touchUpInside)
        
        return cell
    }
    
    @objc func addBtnTapped(sender:UIButton){
        let indexPath = IndexPath(row: sender.tag, section: 0)
        let cell =  categoryDetailTableView.cellForRow(at:indexPath ) as! MyServiceTableViewCell
        cell.addStepperView.isHidden = false
        cell.stepperView.isHidden = true
        cell.addStepperView.value = 1
        selectedArray.append(indexPath)
        
    }
    
    
    
    @IBAction func onClickProceedButton(_ sender : UIButton){
        
        if getSignatureImage.image == nil && serviceType == "Paid" {
            let matchVC = AppStoryboard.Home.viewController(SignatureViewController.self)
            matchVC.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            matchVC.signatureDelegate = self
            let nav = UINavigationController(rootViewController: matchVC)
            nav.modalPresentationStyle = .overFullScreen
            nav.navigationBar.isHidden = true
            self.navigationController?.present(nav, animated: true)
        } else {

            for indexPath in selectedArray {
                 let cell =  categoryDetailTableView.cellForRow(at:indexPath ) as! MyServiceTableViewCell
                self.service_id.append(Int(serviceList[indexPath.row].serviceID)!)
                self.quantity.append(Int(cell.addStepperView!.value))
            }
            
            print("service_id===========\(service_id)")
            print("quantity===========\(quantity)")
            
            addService(user_id: currentUserLogin.userId, service_id: "\(service_id)", quantity: "\(quantity)", type: serviceType, image_url: getSignatureImage.image ?? UIImage())
            
        }

    }
    
    //------Service list Api--------
    func getCategoryService(category : String){
        CommonClass.showLoader()
        Webservice.shared.getServiceList(category_id: category){ (result,msg,response) in
            CommonClass.hideLoader()
            if result == 1 {
                if let data = response {
                    self.serviceList.removeAll()
                    self.serviceList.append(contentsOf: data)
                    self.categoryDetailTableView.reloadData()
                }
            } else {
                let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: self.categoryDetailTableView.bounds.size.width, height: self.categoryDetailTableView.bounds.size.height))
                noDataLabel.text          = msg
                noDataLabel.textColor     = UIColor.black
                noDataLabel.textAlignment = .center
                self.categoryDetailTableView.backgroundView  = noDataLabel
                self.categoryDetailTableView.backgroundColor = UIColor.white
                self.categoryDetailTableView.separatorStyle  = .none
                //NKToastHelper.sharedInstance.showAlert(self, title: .alertTitle, message: msg)
            }
        }
    }
    
    
    //-------Add service---------
    
    func addService(user_id: String, service_id: String, quantity: String,type: String, image_url: UIImage?) {
        CommonClass.showLoader()
        Webservice.shared.addServiceToCart(user_id: user_id, service_id: service_id, quantity: quantity, type: type, image_url: image_url) { (result, message) in
            CommonClass.hideLoader()
            if result == 1 {
                NKToastHelper.sharedInstance.showAlert(self, title: .alertTitle, message: message)
                DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                    self.navigationController?.popViewController(animated: true)
                })
            } else {
                NKToastHelper.sharedInstance.showAlert(self, title: .alertTitle, message: message)
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

//-----getting signature Image
extension CategoryDetailViewController: sendSignature {
    func getSignature(image: UIImageView) {
        self.getSignatureImage = image
    }
}

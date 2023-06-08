//
//  OnGoingViewController.swift
//  NOZOL
//
//  Created by Mukul Sharma on 21/07/20.
//  Copyright © 2020 Mukul Sharma. All rights reserved.
//

import UIKit

class OnGoingViewController: UIViewController ,UITableViewDataSource,UITableViewDelegate{
    

    @IBOutlet weak var ongoingTableView : UITableView!
    
    let lang = UserDefaults.standard.value(forKey: "language") as? String
    var currentUserLogin : User!
    var serviceList = [serviceModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ongoingTableView.dataSource = self
        self.ongoingTableView.delegate = self
        self.currentUserLogin = User.loadSavedUser()
        getServiceList(userId: currentUserLogin.userId, key: "ongoing")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        NotificationCenter.default.addObserver(self, selector: #selector(updateValue(notification:)), name: .refreshTableView, object: nil)
    }
    
    @objc func updateValue(notification: Notification) {
        self.currentUserLogin = User.loadSavedUser()
        getServiceList(userId: currentUserLogin.userId, key: "ongoing")
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return serviceList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyServiceTableViewCell", for: indexPath) as! MyServiceTableViewCell
        if lang == "en" {
            cell.labelPriceTag.text = "PriceKey".localizableString(loc: "en")
            cell.labelQuantityTag.text = "QuantityKey".localizableString(loc: "en")
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
            
        } else if lang == "ar"{
            cell.labelPriceTag.text = "PriceKey".localizableString(loc: "ar")
            cell.labelQuantityTag.text = "QuantityKey".localizableString(loc: "ar")
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
            
        } else if lang == "ru" {
            cell.labelPriceTag.text = "PriceKey".localizableString(loc: "ru")
            cell.labelQuantityTag.text = "QuantityKey".localizableString(loc: "ru")
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
        }
        cell.labelPrice.text = "E£" + serviceList[indexPath.row].price
        cell.labelQuantity.text = serviceList[indexPath.row].quantity
        cell.labelDescription.text = serviceList[indexPath.row].desc
        cell.labelServiceName.text = serviceList[indexPath.row].serviceName
        let imageUrl = serviceList[indexPath.row].imageUrl
        
        cell.labelServiceStatus.text = serviceList[indexPath.row].service_status
        cell.imageViewService.sd_setImage(with: URL(string:"\(imageUrl)"), placeholderImage: #imageLiteral(resourceName: "Dry Cleaning") )
        return cell
    }
    
    //-------Call Service-----------
    func getServiceList(userId: String, key: String) {
        CommonClass.showLoader()
        Webservice.shared.userServiceDetailsList(UserId: userId, key: key) { (result,msg,response) in
            CommonClass.hideLoader()
            if result == 1 {
                if let data = response {
                    self.serviceList.removeAll()
                    self.serviceList.append(contentsOf: data)
                    self.ongoingTableView.reloadData()
                }
            } else {
                let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: self.ongoingTableView.bounds.size.width, height: self.ongoingTableView.bounds.size.height))
                noDataLabel.text          = msg
                noDataLabel.textColor     = UIColor.black
                noDataLabel.textAlignment = .center
                self.ongoingTableView.backgroundView  = noDataLabel
                self.ongoingTableView.backgroundColor = UIColor.white
                self.ongoingTableView.separatorStyle  = .none
            }
        }
    }

}


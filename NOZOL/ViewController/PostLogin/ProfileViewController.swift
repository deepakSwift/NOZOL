//
//  ProfileViewController.swift
//  NOZOL
//
//  Created by Mukul Sharma on 16/07/20.
//  Copyright © 2020 Mukul Sharma. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import SDWebImage
import CountryPickerView
import CoreTelephony


class ProfileViewController: UIViewController,UINavigationControllerDelegate, UIImagePickerControllerDelegate ,CountryPickerViewDataSource,CountryPickerViewDelegate{
    
    @IBOutlet weak var profileImage : UIImageView!
    @IBOutlet weak var cameraButton : UIButton!
    @IBOutlet weak var emailTextField : SkyFloatingLabelTextField!
    @IBOutlet weak var mobileTextField : UITextField!
    @IBOutlet weak var nameTextField : SkyFloatingLabelTextField!
    
    @IBOutlet weak var countryPickerView: UIView!
    @IBOutlet weak var countryCodeButton: UIButton!
    @IBOutlet weak var contryFlagImage : UIImageView!
    @IBOutlet weak var countryNamelabel : UILabel!
    
    
    var imagePicker = UIImagePickerController()
    var statusResponse = serviceModel()
    var currentUserLogin : User!
    
    var cpv : CountryPickerView!
    var selectedCountry : Country!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.currentUserLogin = User.loadSavedUser()
        decorateView()
        imagePicker.delegate = self
        self.countryPickerSetUp()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.currentUserLogin = User.loadSavedUser()
        checkRoomStatus(userId: currentUserLogin.userId)
        
    }
    
    func decorateView(){
        CommonClass.makeViewCircular(profileImage, borderColor: .yellow, borderWidth: 0.0)
        CommonClass.makeViewCircular(cameraButton, borderColor: .clear, borderWidth: 0.0)
        mobileTextField.isUserInteractionEnabled = false
        emailTextField.isUserInteractionEnabled = false
        self.emailTextField.text = currentUserLogin.email
        self.nameTextField.text = currentUserLogin.name
        self.mobileTextField.text = currentUserLogin.phoneNumber
        profileImage.sd_setImage(with: URL(string:"\(self.currentUserLogin.profileImage)"), placeholderImage: #imageLiteral(resourceName: "account yellow") )

    }
    
    @IBAction func onClickBackButton(_ sender : UIButton){
        self.navigationController?.pop(true)
    }
    
    
    
    @IBAction func onClickUpdateButton(_ sender : UIButton){
        self.updateProfilePicture(userid: self.currentUserLogin.userId, name: nameTextField.text!, userImage: profileImage.image!)
    }
    
    
    
    @IBAction func onClickCamerabutton(_ sender : UIButton){
        
        let alert = UIAlertController(title: "Choose Image for Update Profile Picture", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallary()
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            alert.popoverPresentationController?.sourceView = sender
            alert.popoverPresentationController?.sourceRect = sender.bounds
            alert.popoverPresentationController?.permittedArrowDirections = .up
        default:
            break
        }
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera))
        {
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func openGallary(){
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let chosenImage = info[.editedImage] as? UIImage{
            
            profileImage.image = chosenImage
            //            self.updateProfilePicture(userid: self.currentUserLogin.userId, name: nameTextField.text!, userImage: chosenImage)
        } else if let choossenImage = info[.editedImage] as? UIImage {
            profileImage.image = choossenImage
            //            self.updateProfilePicture(userid: self.currentUserLogin.userId, name: nameTextField.text!, userImage: choossenImage)
            
        }
        dismiss(animated: true, completion: nil)
    }
    
    
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    
    func countryPickerSetUp() {
        if cpv != nil{
            cpv.removeFromSuperview()
        }
        cpv = CountryPickerView(frame: self.countryPickerView.frame)
        cpv.alpha = 1.0
        self.countryPickerView.addSubview(cpv)
        cpv.showPhoneCodeInView = false
        cpv.showCountryCodeInView = false
        cpv.flagImageView.isHidden = true
        cpv.setCountryByCode(self.currentCountryCode)
        self.selectedCountry = cpv.selectedCountry
        cpv.dataSource = self
        cpv.delegate = self
        cpv.translatesAutoresizingMaskIntoConstraints = false
        self.countryNamelabel.text = "(\(selectedCountry.code) )"+selectedCountry.phoneCode
        self.contryFlagImage.image = selectedCountry.flag
        //self.countryCodeButton.setTitle(self.selectedCountry.phoneCode, for: .normal)
    }
    
    var currentCountryCode:String{
        let networkInfo = CTTelephonyNetworkInfo()
        if let carrier = networkInfo.subscriberCellularProvider{
            let countryCode = carrier.isoCountryCode
            return (countryCode ?? "SG").uppercased()
        }else{
            return (Locale.autoupdatingCurrent.regionCode ?? "SG").uppercased()
        }
    }
    
    
    var countryCode : String {
        get {
            var result = ""
            if let r = kUserDefaults.value(forKey:kCountryCode) as? String{
                result = r
            }
            return result
        }
        set(newCountryCode){
            kUserDefaults.set(newCountryCode, forKey: kCountryCode)
        }
    }
    
    
    func sectionTitleForPreferredCountries(in countryPickerView: CountryPickerView) -> String? {
        return (currentCountryCode.count != 0) ? "Current" : nil
    }
    
    func showOnlyPreferredSection(in countryPickerView: CountryPickerView) -> Bool {
        return false
    }
    
    
    func navigationTitle(in countryPickerView: CountryPickerView) -> String? {
        return "Select Country"
    }
    
    func closeButtonNavigationItem(in countryPickerView: CountryPickerView) -> UIBarButtonItem? {
        return nil
    }
    
    func searchBarPosition(in countryPickerView: CountryPickerView) -> SearchBarPosition {
        return .navigationBar
    }
    
    
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
        self.selectedCountry = country
        //self.countryCodeButton.setTitle("\(self.selectedCountry.phoneCode)", for: .normal)
        self.countryNamelabel.text = "(\(country.code) )"+country.phoneCode
        self.contryFlagImage.image = country.flag
    }
    func preferredCountries(in countryPickerView: CountryPickerView) -> [Country] {
        if let currentCountry = countryPickerView.getCountryByPhoneCode(currentCountryCode){
            return [currentCountry]
        }else{
            return [countryPickerView.selectedCountry]
        }
    }
    
    func showPhoneCodeInList(in countryPickerView: CountryPickerView) -> Bool {
        return true
    }
    
    
    
    func updateProfilePicture(userid : String,name : String, userImage : UIImage ){
        CommonClass.showLoader(withStatus: "Update...")
        Webservice.shared.EditProfile(userID: userid, name: name, userImage: userImage){ (result, response,message) in
            CommonClass.hideLoader()
            if result == 1 {
                NKToastHelper.sharedInstance.showAlert(self, title: .title, message: message)
                DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                    self.navigationController?.popViewController(animated: true)
                })
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

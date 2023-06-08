//
//  SignupViewController.swift
//  NOZOL
//
//  Created by Mukul Sharma on 15/07/20.
//  Copyright © 2020 Mukul Sharma. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import CountryPickerView
import CoreTelephony


//Keys
let kPhoneNumber = "phoneNumber"
let kCountryCode = "countryCode"


class SignupViewController: UIViewController ,CountryPickerViewDataSource,CountryPickerViewDelegate{
    
    @IBOutlet weak var nameTextField : SkyFloatingLabelTextField!
    @IBOutlet weak var emailTextField : SkyFloatingLabelTextField!
    @IBOutlet weak var passwordTextField : SkyFloatingLabelTextField!
    @IBOutlet weak var confrimpasswordTextField : SkyFloatingLabelTextField!
    @IBOutlet weak var phoneTextField : UITextField!
    
    @IBOutlet weak var countryPickerView: UIView!
    @IBOutlet weak var countryCodeButton: UIButton!
    @IBOutlet weak var contryFlagImage : UIImageView!
    @IBOutlet weak var countryNamelabel : UILabel!
    
    var cpv : CountryPickerView!
    var selectedCountry : Country!
    var isTermsAccepted : Bool = false
    var flag_code = "EG"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIView.appearance().semanticContentAttribute = .forceLeftToRight
        self.countryPickerSetUp()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        contryFlagImage.image = #imageLiteral(resourceName: "egypt")
        countryNamelabel.text = "(EG)+20"
    }
    
    
    @IBAction func onClickSignupButton(_ sender : UIButton){
        self.navigationController?.pop(true)
    }
    
    @IBAction func onClickTermConditionBtn(_ sender : UIButton){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TermConditionVC") as! TermConditionVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func onClickSignButton(_ sender : UIButton){
        guard let name = nameTextField.text, name != "" else {
            NKToastHelper.sharedInstance.showErrorAlert(self, message: "Please enter your name.")
            return
        }
        guard let email = emailTextField.text, email != "" else {
            NKToastHelper.sharedInstance.showErrorAlert(self, message: "Please enter your email ID.")
            return
        }
        guard let phoneNumber = phoneTextField.text, phoneNumber != "" else {
            NKToastHelper.sharedInstance.showErrorAlert(self, message: "Please enter mobile number.")
            return
        }
        
        if phoneTextField.text!.count <= 5 || phoneTextField.text!.count >= 15  {
            NKToastHelper.sharedInstance.showErrorAlert(self, message: "Please enter valid mobile number.")
        }
        guard let password = passwordTextField.text, password != "" else {
            NKToastHelper.sharedInstance.showErrorAlert(self, message: "Please enter password")
            return
        }
        if password.count < 6{
            NKToastHelper.sharedInstance.showErrorAlert(self, message: "Password must be of 6 digits.")
        }
        
        guard let confrimPassword = confrimpasswordTextField.text, confrimPassword != "" else {
            NKToastHelper.sharedInstance.showErrorAlert(self, message: "Please enter confirm password")
            return
        }
        if password != confrimPassword{
            NKToastHelper.sharedInstance.showErrorAlert(self, message: "Password and confirm password must be same.")
            return
        }
        if !self.isTermsAccepted{
            NKToastHelper.sharedInstance.showErrorAlert(self, message: "Please accept Terms and Conditions")
            return
        }
        self.userSignUp(name: name, email: email, password: password, confirmPassword: confrimPassword, countryCode: self.countryNamelabel.text!, mobileNumber: phoneNumber, term: "yes", source: "self", flag_code: self.flag_code)
    }
    
    
    @IBAction func onClickCheckButton(_ sender : UIButton){
        self.isTermsAccepted = !self.isTermsAccepted
        sender.isSelected = self.isTermsAccepted
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
        self.flag_code = selectedCountry.code
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
         self.flag_code = selectedCountry.code
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
    
    
    func userSignUp(name : String,email : String,password : String,confirmPassword : String,countryCode: String,mobileNumber : String, term : String,source : String,flag_code : String){
        CommonClass.showLoader()
        Webservice.shared.registration(fullName: name, email: email, flag_code: flag_code, password: password, confirmPassword: confirmPassword, countryCode: countryCode, mobileNumber: mobileNumber, term: term, source: source){ (result, message) in
            CommonClass.hideLoader()
            if result == 1 {
                UserDefaults.standard.set("en", forKey: "language")
                let matchVC = AppStoryboard.Main.viewController(VerifySignupViewController.self)
//                self.nameTextField.text = ""
//                self.emailTextField.text = ""
//                self.phoneTextField.text = ""
//                self.passwordTextField.text = ""
//                self.confrimpasswordTextField.text = ""
//                self.isTermsAccepted = false
                matchVC.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
                let nav = UINavigationController(rootViewController: matchVC)
                nav.modalPresentationStyle = .overFullScreen
                nav.navigationBar.isHidden = true
                self.navigationController?.present(nav, animated: true)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                    self.dismiss(animated: true, completion: nil)
                })
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                    self.navigationController?.popViewController(animated: true)
                    self.dismiss(animated: true, completion: nil)
                })
                
            } else {
                NKToastHelper.sharedInstance.showAlert(self, title: .title, message: message)
            }
        }
    }
}

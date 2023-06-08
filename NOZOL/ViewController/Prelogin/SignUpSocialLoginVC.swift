//
//  SignUpSocialLoginVC.swift
//  NOZOL
//
//  Created by deepak Kumar on 31/07/20.
//  Copyright © 2020 Mukul Sharma. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import CountryPickerView
import CoreTelephony


class SignUpSocialLoginVC: UIViewController,CountryPickerViewDataSource,CountryPickerViewDelegate {

    
    @IBOutlet weak var nameTextField : SkyFloatingLabelTextField!
    @IBOutlet weak var emailTextField : SkyFloatingLabelTextField!
    @IBOutlet weak var phoneTextField : UITextField!
    @IBOutlet weak var countryPickerView: UIView!
    @IBOutlet weak var countryCodeButton: UIButton!
    @IBOutlet weak var contryFlagImage : UIImageView!
    @IBOutlet weak var countryNamelabel : UILabel!
    
    var window : UIWindow?
    var cpv : CountryPickerView!
    var selectedCountry : Country!
    var isTermsAccepted : Bool = false
    var flag_code = "EG"
    
    var userName = ""
    var userEmail = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.countryPickerSetUp()
        emailTextField.isUserInteractionEnabled = false
        emailTextField.text = self.userEmail
        nameTextField.text = self.userName
        // Do any additional setup after loading the view.
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
                NKToastHelper.sharedInstance.showErrorAlert(self, message: "Please enter your email address.")
                return
            }
            guard let phoneNumber = phoneTextField.text, phoneNumber != "" else {
                NKToastHelper.sharedInstance.showErrorAlert(self, message: "Please enter mobile number.")
                return
            }
            if !self.isTermsAccepted{
                NKToastHelper.sharedInstance.showErrorAlert(self, message: "Please accept terms and conditions")
                return
            }
            //self.userSignUp(name: name, email: email, password: password, confirmPassword: confrimPassword, countryCode: self.countryNamelabel.text!, mobileNumber: phoneNumber, term: "yes", source: "self")
            signUpSocialLogin(email: email, name: name, tokenId: kDeviceToken, source: "google", country_code: self.countryNamelabel.text!, phone_number: phoneNumber, flag_code: self.flag_code)
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
        
        
        //------Social login Api-----
    func signUpSocialLogin(email: String, name: String,tokenId : String,source : String,country_code: String, phone_number: String,flag_code : String) {
        CommonClass.showLoader()
        Webservice.shared.socialLoginSignup(email: email, name: name, flag_code: flag_code, tokenId: tokenId, source: source, country_code: country_code, phone_number: phone_number) { (result, message, data) in
            CommonClass.hideLoader()
            if result == 1 {
                UserDefaults.standard.set("true", forKey: "isLoginWithSocial")
                let storyBoard = AppStoryboard.Home.instance
                let navigationController = storyBoard.instantiateViewController(withIdentifier: "TabBarNavigationController") as! UINavigationController
                self.window?.rootViewController = navigationController
                (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController = navigationController
            } else {
                NKToastHelper.sharedInstance.showAlert(self, title: .title, message: message)
            }
        }
    }

}

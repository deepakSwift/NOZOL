//
//  ForgotPasswordViewController.swift
//  NOZOL
//
//  Created by Mukul Sharma on 15/07/20.
//  Copyright © 2020 Mukul Sharma. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class ForgotPasswordViewController: UIViewController {
    
    
    @IBOutlet weak var emailTextField : SkyFloatingLabelTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    @IBAction func onClickBackButton(_ sender : UIButton){
        self.navigationController?.pop(true)
    }
    
    @IBAction func onClickForgotButton(_ sender : UIButton){
        guard let email = emailTextField.text, email != "" else {
            NKToastHelper.sharedInstance.showErrorAlert(self, message: "Please enter your email ID.")
            return
        }
        if !CommonClass.validateEmail(email) {
            NKToastHelper.sharedInstance.showErrorAlert(self, message: "Please enter valid email.")
            return
        }
        
        forgotpassword(email: email)
    }
    
    
    func  forgotpassword(email : String){
        CommonClass.showLoader()
        Webservice.shared.forgotPassword(email: email){ (result, message) in
            CommonClass.hideLoader()
            if result == 1 {
                let matchVC = AppStoryboard.Main.viewController(VerifySignupViewController.self)
                matchVC.fromPage = "forgot"
                self.emailTextField.text = ""
                matchVC.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
                let nav = UINavigationController(rootViewController: matchVC)
                nav.modalPresentationStyle = .overFullScreen
                nav.navigationBar.isHidden = true
                self.navigationController?.present(nav, animated: true)
            } else {
                NKToastHelper.sharedInstance.showAlert(self, title: .title, message: message)
            }
        }
    }
}

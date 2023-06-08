//
//  VerifySignupViewController.swift
//  NOZOL
//
//  Created by Mukul Sharma on 15/07/20.
//  Copyright © 2020 Mukul Sharma. All rights reserved.
//

import UIKit

class VerifySignupViewController: UIViewController {

    @IBOutlet weak var verifyView : UIView!
    @IBOutlet weak var titleLabel : UILabel!
    
    var fromPage = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if fromPage == "forgot"{
            self.titleLabel.text = "We have sent a link to your registered Email ID to recover password"
        }else{
            self.titleLabel.text = "We have sent a link to your registered Email ID for verification of your account"
        }
        CommonClass.makeViewCircularWithCornerRadius(verifyView, borderColor: .lightGray, borderWidth: 1.0, cornerRadius: 10.0)

    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.dismiss(animated: true)
    }




}

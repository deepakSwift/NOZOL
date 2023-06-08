//
//  CheckinPopupViewController.swift
//  NOZOL
//
//  Created by Mukul Sharma on 21/07/20.
//  Copyright © 2020 Mukul Sharma. All rights reserved.
//

import UIKit

class CheckinPopupViewController: UIViewController {

    
    @IBOutlet weak var containerView : UIView!
    @IBOutlet weak var showActivityIndicator : UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CommonClass.makeViewCircularWithCornerRadius(containerView, borderColor: .darkGray, borderWidth: 1.0, cornerRadius: 10.0)

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.dismiss(animated: true)
    }
    
}

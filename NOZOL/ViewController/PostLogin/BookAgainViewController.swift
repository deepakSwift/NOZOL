//
//  BookAgainViewController.swift
//  NOZOL
//
//  Created by Mukul Sharma on 18/07/20.
//  Copyright © 2020 Mukul Sharma. All rights reserved.
//

import UIKit
import RSKPlaceholderTextView

class BookAgainViewController: UIViewController {

    @IBOutlet weak var descTextView : RSKPlaceholderTextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.descTextView.placeholder = "Write your comment... "
        CommonClass.makeViewCircularWithCornerRadius(descTextView, borderColor: .gray, borderWidth: 0.5, cornerRadius: 10.0)

    }
    
    
    

}

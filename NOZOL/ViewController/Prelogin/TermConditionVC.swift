//
//  TermConditionVC.swift
//  NOZOL
//
//  Created by deepak Kumar on 06/08/20.
//  Copyright © 2020 Mukul Sharma. All rights reserved.
//

import UIKit
import WebKit

class TermConditionVC: UIViewController {

    @IBOutlet weak var webView:WKWebView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let request = URLRequest(url: URL(string: "http://nozol-hospitality.com/nozol/terms-and-condition")!)
        webView?.load(request)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onClickBackBtn(_ sender : UIButton){
        self.navigationController?.pop(true)
    }


}

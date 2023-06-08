//
//  ChatMediaDetailsVC.swift
//  NOZOL
//
//  Created by deepak Kumar on 11/08/20.
//  Copyright © 2020 Mukul Sharma. All rights reserved.
//

import UIKit

class ChatMediaDetailsVC: UIViewController {
    
    @IBOutlet weak var mediaImage : UIImageView!
    
    var getImage = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("getimage==============\(getImage)")
        
        //imageViewDetails.image = #imageLiteral(resourceName: "kids outfit")//self.getImage.base64Convert()
        
        if let imageView = mediaImage {
            imageView.image = getImage.base64Convert()
            
        }
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onClickBackButton(_ sender : UIButton){
           self.navigationController?.pop(true)
       }

   
}

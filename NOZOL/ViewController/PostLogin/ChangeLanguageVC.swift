//
//  ChangeLanguageVC.swift
//  NOZOL
//
//  Created by deepak Kumar on 27/08/20.
//  Copyright © 2020 Mukul Sharma. All rights reserved.
//

import UIKit

protocol CallFromChangeLanguage {
    func callHomeController()
}

class ChangeLanguageVC: UIViewController {

    @IBOutlet weak var buttonEnglish : UIButton!
    @IBOutlet weak var buttonRussian : UIButton!
    @IBOutlet weak var buttonArabic : UIButton!
    
    @IBOutlet weak var labelEng : UILabel!
    @IBOutlet weak var labelArabic : UILabel!
    @IBOutlet weak var labelRussian : UILabel!
    
    
    var delegate: CallFromChangeLanguage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

            let lang = UserDefaults.standard.value(forKey: "language") as? String
            if lang == "en" {
                labelEng.textColor = .black
                labelArabic.textColor = .lightGray
                labelRussian.textColor = .lightGray
            } else if lang == "ar"{
               labelEng.textColor = .lightGray
               labelArabic.textColor = .black
               labelRussian.textColor = .lightGray
            } else if lang == "ru" {
                labelEng.textColor = .lightGray
               labelArabic.textColor = .lightGray
               labelRussian.textColor = .black
            }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onClickBackButton(_ sender : UIButton){
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onClickEnglishButton(_ sender : UIButton){
        
        buttonEnglish.setImage(#imageLiteral(resourceName: "icons8-unchecked-radio-button-24"), for: .normal)
        UserDefaults.standard.set("en", forKey: "language")
        
        self.dismiss(animated: true) {
            self.delegate?.callHomeController()
        }
    }
    
    @IBAction func onClickRussianButton(_ sender : UIButton){
        buttonRussian.setImage(#imageLiteral(resourceName: "icons8-unchecked-radio-button-24"), for: .normal)
        UserDefaults.standard.set("ru", forKey: "language")
        
        self.dismiss(animated: true) {
            self.delegate?.callHomeController()
        }
    }
    
    @IBAction func onClickArabicButton(_ sender : UIButton){
        buttonArabic.setImage(#imageLiteral(resourceName: "icons8-unchecked-radio-button-24"), for: .normal)
        UserDefaults.standard.set("ar", forKey: "language")
        self.dismiss(animated: true) {
            self.delegate?.callHomeController()
        }
    }

}

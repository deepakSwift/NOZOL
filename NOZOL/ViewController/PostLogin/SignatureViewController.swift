//
//  SignatureViewController.swift
//  NOZOL
//
//  Created by Mukul Sharma on 18/07/20.
//  Copyright © 2020 Mukul Sharma. All rights reserved.
//

import UIKit

protocol sendSignature {
    func getSignature(image: UIImageView)
}

class SignatureViewController: UIViewController,YPSignatureDelegate {
    
    @IBOutlet weak var signatureView: YPDrawSignatureView!
    @IBOutlet weak var clearButton : UIButton!
    @IBOutlet weak var containerView : UIView!
    @IBOutlet weak var saveButton : UIButton!
    @IBOutlet weak var cancelButton : UIButton!
    @IBOutlet weak var labelTitle : UILabel!
    
    var getSignatureImage:UIImageView = UIImageView()
    var signatureDelegate: sendSignature?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLocalization()
        signatureView.delegate = self
        CommonClass.makeViewCircularWithCornerRadius(clearButton, borderColor: .white, borderWidth: 1.0, cornerRadius: 10.0)
        CommonClass.makeViewCircularWithCornerRadius(containerView, borderColor: .gray, borderWidth: 1.0, cornerRadius: 5.0)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func clearSignature(_ sender: UIButton) {
        self.signatureView.clear()
    }
    
    @IBAction func onClickBackButton(_ sender : UIButton){
        self.navigationController?.pop(true)
    }
    
    @IBAction func saveSignature(_ sender: UIButton) {
       
        
        self.dismiss(animated: true) {
             if let signatureImage = self.signatureView.getSignature(scale: 10) {
                       UIImageWriteToSavedPhotosAlbum(signatureImage, nil, nil, nil)
                       self.signatureView.clear()
                       self.getSignatureImage.image = signatureImage
                self.signatureDelegate?.getSignature(image: self.getSignatureImage)
                   }
        }
    }
    
    func didStart(_ view : YPDrawSignatureView) {
        print("Started Drawing")
    }
    func didFinish(_ view : YPDrawSignatureView) {
        print("Finished Drawing")
    }
    
    @IBAction func onClickCancelButton(_ sender : UIButton){
        self.dismiss(animated: true)
    }
}

//----- Set Localization------
extension SignatureViewController {
    
    func setLocalization() {
        let lang = UserDefaults.standard.value(forKey: "language") as? String
        if lang == "en" {
            saveButton.setTitle("SaveKey".localizableString(loc: "en"), for: .normal)
            cancelButton.setTitle("CancelKey".localizableString(loc: "en"), for: .normal)
            clearButton.setTitle("ClearKey".localizableString(loc: "en"), for: .normal)
            labelTitle.text = "SignatureTitleKey".localizableString(loc: "en")
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
        } else if lang == "ar"{
            saveButton.setTitle("SaveKey".localizableString(loc: "ar"), for: .normal)
            cancelButton.setTitle("CancelKey".localizableString(loc: "ar"), for: .normal)
            clearButton.setTitle("ClearKey".localizableString(loc: "ar"), for: .normal)
            labelTitle.text = "SignatureTitleKey".localizableString(loc: "ar")
            UIView.appearance().semanticContentAttribute = .forceRightToLeft

        } else if lang == "ru" {
            saveButton.setTitle("SaveKey".localizableString(loc: "ru"), for: .normal)
            cancelButton.setTitle("CancelKey".localizableString(loc: "ru"), for: .normal)
            clearButton.setTitle("ClearKey".localizableString(loc: "ru"), for: .normal)
            labelTitle.text = "SignatureTitleKey".localizableString(loc: "ru")
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
        }
    }
}

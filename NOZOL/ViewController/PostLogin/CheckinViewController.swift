//
//  CheckinViewController.swift
//  NOZOL
//
//  Created by Mukul Sharma on 21/07/20.
//  Copyright © 2020 Mukul Sharma. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class CheckinViewController: UIViewController,UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    @IBOutlet weak var labelTitles: UILabel!
    @IBOutlet weak var labelUploadSignature: UILabel!
    @IBOutlet weak var labelUploadId: UILabel!
    @IBOutlet weak var buttonSubmit: UIButton!
//    @IBOutlet weak var tableViewContainer: UITableView!
//    @IBOutlet weak var checkOutTableView : UITableView!
     
    @IBOutlet weak var scrollView: UIScrollView!
    //@IBOutlet weak var signatureView: YPDrawSignatureView!
    //@IBOutlet weak var clearButton : UIButton!
    //@IBOutlet weak var containerView : UIView!
    
    @IBOutlet weak var textFieldFirstName : SkyFloatingLabelTextField!
    @IBOutlet weak var textFieldFamilyName : SkyFloatingLabelTextField!
    @IBOutlet weak var textFieldCheckIn : SkyFloatingLabelTextField!
    @IBOutlet weak var textFieldCheckOut : SkyFloatingLabelTextField!
    @IBOutlet weak var textFieldHowBook : SkyFloatingLabelTextField!
    @IBOutlet weak var textFieldTravelName : SkyFloatingLabelTextField!
    @IBOutlet weak var textFieldWebsiteName : SkyFloatingLabelTextField!
    @IBOutlet weak var textFieldAddress : SkyFloatingLabelTextField!
    @IBOutlet weak var textFieldJob : SkyFloatingLabelTextField!
    @IBOutlet weak var textFieldDOB : SkyFloatingLabelTextField!
    @IBOutlet weak var textFieldWifeName : SkyFloatingLabelTextField!
    @IBOutlet weak var textFieldNoAdult : SkyFloatingLabelTextField!
    @IBOutlet weak var textFieldNoChildren : SkyFloatingLabelTextField!
    @IBOutlet weak var textFieldNoRoom : SkyFloatingLabelTextField!
    @IBOutlet weak var textFieldPaymentMode : SkyFloatingLabelTextField!
    @IBOutlet weak var textFieldSelectIdType : SkyFloatingLabelTextField!
    @IBOutlet weak var textFieldNoOfGuest : SkyFloatingLabelTextField!
    @IBOutlet weak var imageViewId : UIImageView!
    @IBOutlet weak var imageViewSignature : UIImageView!
    @IBOutlet weak var buttonUpload : UIButton!
    @IBOutlet weak var buttonUploadSignature : UIButton!
    
    let lang = UserDefaults.standard.value(forKey: "language") as? String
    var getSignatureImage:UIImageView = UIImageView()
    let paymentPickerView = UIPickerView()
    let IDPickerView = UIPickerView()
    var currentUserLogin : User!
    var imagePicker = UIImagePickerController()
    var dateD: Date?
    var datePickerView : UIDatePicker = UIDatePicker()
    var paymentMode = [String]()
    var IdType = [String]()
    var checkInData = checkInModel()
    var paymentOption = [serviceModel]()
    var IdOption = [serviceModel]()
    
    var statusResponse = serviceModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLocalization()
        //signatureView.delegate = self
        imagePicker.delegate = self
        setUpCheckInDatePickerView()
        setUpCheckOutDatePickerView()
        setUpDOBPickerView()
      //  CommonClass.makeViewCircularWithCornerRadius(clearButton, borderColor: .white, borderWidth: 1.0, cornerRadius: 10.0)
        //CommonClass.makeViewCircularWithCornerRadius(containerView, borderColor: .gray, borderWidth: 1.0, cornerRadius: 5.0)
        
        textFieldPaymentMode.inputView = paymentPickerView
        textFieldPaymentMode.delegate = self
        paymentPickerView.dataSource = self
        paymentPickerView.delegate = self
        
        textFieldSelectIdType.inputView = IDPickerView
        textFieldSelectIdType.delegate = self
        IDPickerView.dataSource = self
        IDPickerView.delegate = self
        
//        textFieldFirstName.text = "deepak"
//        textFieldFamilyName.text = "nivas"
//        textFieldCheckIn.text = "22-08-2020"
//        textFieldCheckOut.text = "28-08-2020"
//        textFieldHowBook.text = "web"
//        textFieldTravelName.text = "axo travel"
//        textFieldWebsiteName.text = "wiki"
//        textFieldAddress.text = "India"
//        textFieldJob.text = "No"
//        textFieldDOB.text = "22-08-1996"
//        textFieldWifeName.text = "lisa"
//        textFieldNoAdult.text = "2"
//        textFieldNoChildren.text = "2"
//         textFieldNoRoom.text = "1"
//        textFieldPaymentMode.text = "cash"
//        textFieldSelectIdType.text = "passport"
//        textFieldNoOfGuest.text = "4"
        
        getPaymentOption()
        getIdOption()

    }
    
//    @IBAction func clearSignature(_ sender: UIButton) {
//        self.signatureView.clear()
//    }
//
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.currentUserLogin = User.loadSavedUser()
    }
    
    fileprivate func setUpCheckInDatePickerView(){
        
        self.textFieldCheckIn.inputView = self.datePickerView
        datePickerView = UIDatePicker()
        
        datePickerView.datePickerMode = .date
        datePickerView.minimumDate = Date()
        textFieldCheckIn.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(AgainBookAgainViewController.dateChanged(datePicker:)), for: .valueChanged)
        datePickerView.minimumDate = Date()
        
        //let todaysDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        //self.currentDate = dateFormatter.string(from: todaysDate)
        
        
    }
    
    @objc func dateChanged(datePicker : UIDatePicker ){
        let dateFormatter  = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateD = datePicker.date
        textFieldCheckIn.text = dateFormatter.string(from: datePicker.date)
        setUpCheckOutDatePickerView()
    }
    
    fileprivate func setUpCheckOutDatePickerView(){
        
        self.textFieldCheckOut.inputView = self.datePickerView
        datePickerView = UIDatePicker()
        datePickerView.datePickerMode = .date
        
        let dateFormatters = DateFormatter()
        dateFormatters.dateFormat = "yyyy-MM-dd"
        let date = dateFormatters.date(from: self.textFieldCheckIn.text!)
        
        datePickerView.minimumDate = date
        textFieldCheckOut.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(AgainBookAgainViewController.dateChange(datePicker:)), for: .valueChanged)
        
        
        //let todaysDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        //self.currentDate = dateFormatter.string(from: todaysDate)
        
    }
    
    @objc func dateChange(datePicker : UIDatePicker ){
        let dateFormatter  = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateD = datePicker.date
        textFieldCheckOut.text = dateFormatter.string(from: datePicker.date)
    }
    
    fileprivate func setUpDOBPickerView(){
        
        self.textFieldDOB.inputView = self.datePickerView
        datePickerView = UIDatePicker()
        datePickerView.datePickerMode = .date
        //datePickerView.minimumDate = Date()
        textFieldDOB.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(CheckinViewController.dateChanges(datePicker:)), for: .valueChanged)
        //datePickerView.minimumDate = Date()
        
        //let todaysDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        //self.currentDate = dateFormatter.string(from: todaysDate)
        
    }
    
    @objc func dateChanges(datePicker : UIDatePicker ){
           let dateFormatter  = DateFormatter()
           dateFormatter.dateFormat = "yyyy-MM-dd"
           dateD = datePicker.date
           textFieldDOB.text = dateFormatter.string(from: datePicker.date)
       }
    
    @IBAction func buttonActionSignature(_ sender: UIButton) {
        let matchVC = AppStoryboard.Home.viewController(SignatureViewController.self)
        matchVC.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        matchVC.signatureDelegate = self
        let nav = UINavigationController(rootViewController: matchVC)
        nav.modalPresentationStyle = .overFullScreen
        nav.navigationBar.isHidden = true
        self.navigationController?.present(nav, animated: true)
    }
    
    @IBAction func buttonActionUploadId(_ sender: UIButton) {
        
        
        if lang == "en" {

            let alert = UIAlertController(title: "Choose ID Proof", message: nil, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
                self.openCamera()
            }))
            
            alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
                self.openGallary()
            }))
            
            alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
            switch UIDevice.current.userInterfaceIdiom {
            case .pad:
                alert.popoverPresentationController?.sourceView = sender
                alert.popoverPresentationController?.sourceRect = sender.bounds
                alert.popoverPresentationController?.permittedArrowDirections = .up
            default:
                break
            }
            
            self.present(alert, animated: true, completion: nil)

        } else if lang == "ar"{

           let alert = UIAlertController(title: "اختر إثبات الهوية", message: nil, preferredStyle: .actionSheet)
           alert.addAction(UIAlertAction(title: "الة تصوير", style: .default, handler: { _ in
               self.openCamera()
           }))
           
           alert.addAction(UIAlertAction(title: "صالة عرض", style: .default, handler: { _ in
               self.openGallary()
           }))
           
           alert.addAction(UIAlertAction.init(title: "إلغاء", style: .cancel, handler: nil))
           switch UIDevice.current.userInterfaceIdiom {
           case .pad:
               alert.popoverPresentationController?.sourceView = sender
               alert.popoverPresentationController?.sourceRect = sender.bounds
               alert.popoverPresentationController?.permittedArrowDirections = .up
           default:
               break
           }
           
           self.present(alert, animated: true, completion: nil)
           

        } else if lang == "ru" {

           let alert = UIAlertController(title: "Выберите удостоверение личности", message: nil, preferredStyle: .actionSheet)
           alert.addAction(UIAlertAction(title: "Камера", style: .default, handler: { _ in
               self.openCamera()
           }))
           
           alert.addAction(UIAlertAction(title: "Галерея", style: .default, handler: { _ in
               self.openGallary()
           }))
           
           alert.addAction(UIAlertAction.init(title: "Отмена", style: .cancel, handler: nil))
           switch UIDevice.current.userInterfaceIdiom {
           case .pad:
               alert.popoverPresentationController?.sourceView = sender
               alert.popoverPresentationController?.sourceRect = sender.bounds
               alert.popoverPresentationController?.permittedArrowDirections = .up
           default:
               break
           }
           
           self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera))
        {
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func openGallary(){
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let chosenImage = info[.editedImage] as? UIImage{
            
            imageViewId.image = chosenImage
            buttonUpload.isHidden = true
            //            self.updateProfilePicture(userid: self.currentUserLogin.userId, name: nameTextField.text!, userImage: chosenImage)
        } else if let choossenImage = info[.editedImage] as? UIImage {
            imageViewId.image = choossenImage
            buttonUpload.isHidden = true
            //            self.updateProfilePicture(userid: self.currentUserLogin.userId, name: nameTextField.text!, userImage: choossenImage)
            
        }
        dismiss(animated: true, completion: nil)
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
 
    
//    @IBAction func saveSignature(_ sender: UIButton) {
//        if let signatureImage = self.signatureView.getSignature(scale: 10) {
//            UIImageWriteToSavedPhotosAlbum(signatureImage, nil, nil, nil)
//            self.signatureView.clear()
//            self.getSignatureImage.image = signatureImage
//        }
//    }
    
//    func didStart(_ view : YPDrawSignatureView) {
//        print("Started Drawing")
//        self.scrollView.isScrollEnabled = false
//    }
    
//    func didFinish(_ view : YPDrawSignatureView) {
//        print("Finished Drawing")
//        self.scrollView.isScrollEnabled = true
//        if let signatureImage = self.signatureView.getSignature(scale: 10) {
//            UIImageWriteToSavedPhotosAlbum(signatureImage, nil, nil, nil)
//            //self.signatureView.clear()
//            self.getSignatureImage.image = signatureImage
//        }
//    }

    
    @IBAction func onClickBackButton(_ sender : UIButton){
        self.navigationController?.pop(true)
    }
    
    @IBAction func OnClickSubmitButton(_ sender : UIButton){
//        let matchVC = AppStoryboard.Home.viewController(CheckinPopupViewController.self)
//        matchVC.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
//        let nav = UINavigationController(rootViewController: matchVC)
//        nav.modalPresentationStyle = .overFullScreen
//        nav.navigationBar.isHidden = true
//        self.navigationController?.present(nav, animated: true)
        if isValidate() {
            getCheckInData(user_id: currentUserLogin.userId, family_name: textFieldFamilyName.text!, name: textFieldFirstName.text!, check_in_date: textFieldCheckIn.text!, check_out_date: textFieldCheckOut.text!, booking: textFieldHowBook.text!, agent_name: textFieldTravelName.text!, website_name: textFieldWebsiteName.text!, address: textFieldAddress.text!, job: textFieldJob.text!, dob: textFieldDOB.text!, wife_name: textFieldWifeName.text!, adult_no: textFieldNoAdult.text!, children_no: textFieldNoChildren.text!, paymend_method: textFieldPaymentMode.text!, id_proof: textFieldSelectIdType.text!, signature: getSignatureImage.image!, no_room: textFieldNoRoom.text!, guest_no: textFieldNoOfGuest.text!, id_proof_image: imageViewId.image!)
        }

    }
    
    //-------Textfields validation------
    func isValidate()-> Bool {
        if textFieldFirstName.text == "" {
            NKToastHelper.sharedInstance.showErrorAlert(self, message: "Please enter the name.")
            return false
        } else if textFieldFamilyName.text == "" {
            NKToastHelper.sharedInstance.showErrorAlert(self, message: "Please enter the family name.")
            return false
        } else if textFieldCheckIn.text == "" {
            NKToastHelper.sharedInstance.showErrorAlert(self, message: "Please enter the check in date.")
            return false
        } else if textFieldCheckOut.text == "" {
            NKToastHelper.sharedInstance.showErrorAlert(self, message: "Please enter the check out date.")
            return false
        } else if textFieldHowBook.text == "" {
            NKToastHelper.sharedInstance.showErrorAlert(self, message: "Please write how did you book")
            return false
        } else if textFieldTravelName.text == "" {
            NKToastHelper.sharedInstance.showErrorAlert(self, message: "Please write name of travel agent")
            return false
        } else if textFieldWebsiteName.text == "" {
            NKToastHelper.sharedInstance.showErrorAlert(self, message: "Please enter the website name.")
            return false
        } else if textFieldAddress.text == "" {
            NKToastHelper.sharedInstance.showErrorAlert(self, message: "Please enter the full address.")
            return false
        } else if textFieldJob.text == "" {
            NKToastHelper.sharedInstance.showErrorAlert(self, message: "Please enter the job profile.")
            return false
        } else if textFieldDOB.text == "" {
            NKToastHelper.sharedInstance.showErrorAlert(self, message: "Please select date of birth")
            return false
        } else if textFieldWifeName.text == "" {
            NKToastHelper.sharedInstance.showErrorAlert(self, message: "Please enter the wife name.")
            return false
        } else if textFieldNoAdult.text == "" {
            NKToastHelper.sharedInstance.showErrorAlert(self, message: "Please enter the number of adult.")
            return false
        } else if textFieldNoChildren.text == "" {
            NKToastHelper.sharedInstance.showErrorAlert(self, message: "Please enter the number of children.")
            return false
        }
        else if textFieldNoOfGuest.text == "" {
            NKToastHelper.sharedInstance.showErrorAlert(self, message: "Please enter the number of guest.")
            return false
        }
        else if textFieldNoRoom.text == "" {
            NKToastHelper.sharedInstance.showErrorAlert(self, message: "Please enter the number of rooms.")
            return false
        }else if textFieldPaymentMode.text == "" {
            NKToastHelper.sharedInstance.showErrorAlert(self, message: "Please select the payment type.")
            return false
        } else if textFieldSelectIdType.text == "" {
            NKToastHelper.sharedInstance.showErrorAlert(self, message: "Please select the ID type.")
            return false
        } else if imageViewId.image == nil {
            NKToastHelper.sharedInstance.showErrorAlert(self, message: "Please upload the valid ID.")
            return false
        } else if getSignatureImage.image == nil {
            NKToastHelper.sharedInstance.showErrorAlert(self, message: "Please draw the signature.")
            return false
        } 
        return true
    }
    
    
    //-----CheckIn service called-----
    func getCheckInData(user_id: String,family_name: String,name: String,check_in_date: String,check_out_date: String,booking: String,agent_name: String,website_name: String,address: String,job: String,dob: String,wife_name: String,adult_no: String,children_no: String,paymend_method: String,id_proof: String,signature: UIImage?,no_room: String,guest_no: String,id_proof_image: UIImage?) {
        CommonClass.showLoader()
        Webservice.shared.checkInData(user_id: user_id, family_name: family_name, name: name, check_in_date: check_in_date, check_out_date: check_out_date, booking: booking, agent_name: agent_name, website_name: website_name, address: address, job: job, dob: dob, wife_name: wife_name, adult_no: adult_no, children_no: children_no, paymend_method: paymend_method, id_proof: id_proof, signature: signature, no_room: no_room, guest_no: guest_no, id_proof_image: id_proof_image) { (result, response, message) in
            CommonClass.hideLoader()
            
            if result == 1 {
                //NKToastHelper.sharedInstance.showAlert(self, title: .title, message: message)
                //CommonClass.showLoader(withStatus: "waiting for approved")
                if let data = response {
                    self.checkInData = data
                }
                self.checkRoomStatus(userId: self.currentUserLogin.userId)
                NotificationCenter.default.post(name: .passCheckInId, object: nil, userInfo:["keyId": self.checkInData.id])
                //UserDefaults.standard.setValue(self.checkInData.id, forKey: "checkInId")
                UserDefaults.standard.set("true", forKey: "checkInId")
                NKToastHelper.sharedInstance.showAlert(self, title: .title, message: message)
                DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                    self.navigationController?.popViewController(animated: true)
                })
                
            } else {
                NKToastHelper.sharedInstance.showAlert(self, title: .title, message: message)
            }
        }
    }
    
    
    func getPaymentOption() {
        CommonClass.showLoader()
        Webservice.shared.paymentOption { (result, message, response) in
            CommonClass.hideLoader()
            if result == 1 {
                if let data = response {
                    self.paymentOption.removeAll()
                    self.paymentOption.append(contentsOf: data)
                    for id in self.paymentOption.enumerated() {
                        self.paymentMode.append(id.element.name)
                    }
                }
            } else {
                NKToastHelper.sharedInstance.showAlert(self, title: .title, message: message)
            }
        }
    }
    
    func getIdOption() {
        CommonClass.showLoader()
        Webservice.shared.identificationOption { (result, message, response) in
            CommonClass.hideLoader()
            if result == 1 {
                if let data = response {
                    self.IdOption.removeAll()
                    self.IdOption.append(contentsOf: data)
                    for id in self.IdOption.enumerated() {
                        self.IdType.append(id.element.name)
                    }
                    
                }
            } else {
                NKToastHelper.sharedInstance.showAlert(self, title: .title, message: message)
            }
        }
    }
    
    //-----CheckIn status Api call----
    func checkRoomStatus(userId: String) {
        //CommonClass.showLoader()
        Webservice.shared.checkRoomStatus(userId: userId) { (result, message, response) in
            //CommonClass.hideLoader()
            if result == 1 {
                if let data = response {
                    self.statusResponse = data
                }
                //----for block the service
                UserDefaults.standard.set("true", forKey: "checkInStatus")
                //-----for stop timer Api
                //self.timer.invalidate()
                //------update room number in global variable---
                roomNumber = self.statusResponse.room_no[0]
                //self.accountTableView.reloadData()
            } else {
                //NKToastHelper.sharedInstance.showAlert(self, title: .alertTitle, message: message)
                if let data = response {
                    self.statusResponse = data
                }
                
                if self.statusResponse.booking_status == "Disapprove" {
                    UserDefaults.standard.removeObject(forKey: "checkInId")
                    UserDefaults.standard.removeObject(forKey: "checkInStatus")
                    roomNumber = ""
                } else if self.statusResponse.booking_status == "Pending"{
                    UserDefaults.standard.set("true", forKey: "checkInId")
                    roomNumber = ""
                } else {
                    UserDefaults.standard.removeObject(forKey: "checkInId")
                    UserDefaults.standard.removeObject(forKey: "checkInStatus")
                    roomNumber = ""
                }
            }
        }
    }
}

//--------PickerView Delegate---------
extension CheckinViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == paymentPickerView {
            return paymentMode.count
        } else {
            return IdType.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView == paymentPickerView {
            return paymentMode[row]
        } else {
            return IdType[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    
        if pickerView == paymentPickerView {
            textFieldPaymentMode.text = paymentMode[row]
        } else {
            textFieldSelectIdType.text = IdType[row]
        }
    }
}

extension CheckinViewController: UITextFieldDelegate {

    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == textFieldPaymentMode {
        } else {
           
        }
    }
}


//-----getting signature Image
extension CheckinViewController: sendSignature {
    func getSignature(image: UIImageView) {
        self.getSignatureImage = image
        self.imageViewSignature.image = image.image
        self.buttonUploadSignature.isHidden = true
    }
}

//        textFieldFirstName.text = "deepak"
//        textFieldFamilyName.text = "nivas"
//        textFieldCheckIn.text = "22-08-2020"
//        textFieldCheckOut.text = "28-08-2020"
//        textFieldHowBook.text = "web"
//        textFieldTravelName.text = "axo travel"
//        textFieldWebsiteName.text = "wiki"
//        textFieldAddress.text = "India"
//        textFieldJob.text = "No"
//        textFieldDOB.text = "22-08-1996"
//        textFieldWifeName.text = "lisa"
//        textFieldNoAdult.text = "2"
//        textFieldNoChildren.text = "2"
//         textFieldNoRoom.text = "1"
//        textFieldPaymentMode.text = "cash"
//        textFieldSelectIdType.text = "passport"
//        textFieldNoOfGuest.text = "4"

//----- Set Localization------
extension CheckinViewController {
    
    func setLocalization() {
        let lang = UserDefaults.standard.value(forKey: "language") as? String
        if lang == "en" {
            buttonSubmit.setTitle("SubmitKey".localizableString(loc: "en"), for: .normal)
            labelTitles.text = "CheckinTitelekey".localizableString(loc: "en")
            labelUploadId.text = "UploadyouridProofKey".localizableString(loc: "en")
            labelUploadSignature.text = "UploadSignKey".localizableString(loc: "en")
            textFieldFirstName.placeholder = "FirstNameKey".localizableString(loc: "en")
            textFieldFamilyName.placeholder = "FamilyNameKey".localizableString(loc: "en")
            textFieldCheckIn.placeholder = "CheckinKey".localizableString(loc: "en")
            textFieldCheckOut.placeholder = "CheckoutKey".localizableString(loc: "en")
            textFieldHowBook.placeholder = "HowdidYoubooKey".localizableString(loc: "en")
            textFieldTravelName.placeholder = "NameofTravelAgentKey".localizableString(loc: "en")
            textFieldWebsiteName.placeholder = "NameofyourWebsiteKey".localizableString(loc: "en")
            textFieldAddress.placeholder = "FullAddressKey".localizableString(loc: "en")
            textFieldJob.placeholder = "JobKey".localizableString(loc: "en")
            textFieldDOB.placeholder = "DateofbirthKey".localizableString(loc: "en")
            textFieldWifeName.placeholder = "WifeNameKey".localizableString(loc: "en")
            textFieldNoAdult.placeholder = "NumberofAdultsKeys".localizableString(loc: "en")
            textFieldNoChildren.placeholder = "NumberofChildKey".localizableString(loc: "en")
            textFieldNoRoom.placeholder = "NumberofRoomsRequiredKey".localizableString(loc: "en")
            textFieldPaymentMode.placeholder = "PaymentMethodKey".localizableString(loc: "en")
            textFieldSelectIdType.placeholder = "SelectYouridproofKey".localizableString(loc: "en")
            textFieldNoOfGuest.placeholder = "NumberofGuestKey".localizableString(loc: "en")
            UIView.appearance().semanticContentAttribute = .forceLeftToRight

        } else if lang == "ar"{
            buttonSubmit.setTitle("SubmitKey".localizableString(loc: "ar"), for: .normal)
            labelTitles.text = "CheckinTitelekey".localizableString(loc: "ar")
            labelUploadId.text = "UploadyouridProofKey".localizableString(loc: "ar")
            labelUploadSignature.text = "UploadSignKey".localizableString(loc: "ar")
            textFieldFirstName.placeholder = "FirstNameKey".localizableString(loc: "ar")
            textFieldFamilyName.placeholder = "FamilyNameKey".localizableString(loc: "ar")
            textFieldCheckIn.placeholder = "CheckinKey".localizableString(loc: "ar")
            textFieldCheckOut.placeholder = "CheckoutKey".localizableString(loc: "ar")
            textFieldHowBook.placeholder = "HowdidYoubooKey".localizableString(loc: "ar")
            textFieldTravelName.placeholder = "NameofTravelAgentKey".localizableString(loc: "ar")
            textFieldWebsiteName.placeholder = "NameofyourWebsiteKey".localizableString(loc: "ar")
            textFieldAddress.placeholder = "FullAddressKey".localizableString(loc: "ar")
            textFieldJob.placeholder = "JobKey".localizableString(loc: "ar")
            textFieldDOB.placeholder = "DateofbirthKey".localizableString(loc: "ar")
            textFieldWifeName.placeholder = "WifeNameKey".localizableString(loc: "ar")
            textFieldNoAdult.placeholder = "NumberofAdultsKeys".localizableString(loc: "ar")
            textFieldNoChildren.placeholder = "NumberofChildKey".localizableString(loc: "ar")
            textFieldNoRoom.placeholder = "NumberofRoomsRequiredKey".localizableString(loc: "ar")
            textFieldPaymentMode.placeholder = "PaymentMethodKey".localizableString(loc: "ar")
            textFieldSelectIdType.placeholder = "SelectYouridproofKey".localizableString(loc: "ar")
            textFieldNoOfGuest.placeholder = "NumberofGuestKey".localizableString(loc: "ar")
            UIView.appearance().semanticContentAttribute = .forceRightToLeft

        } else if lang == "ru" {
            buttonSubmit.setTitle("SubmitKey".localizableString(loc: "ru"), for: .normal)
            labelTitles.text = "CheckinTitelekey".localizableString(loc: "ru")
            labelUploadId.text = "UploadyouridProofKey".localizableString(loc: "ru")
            labelUploadSignature.text = "UploadSignKey".localizableString(loc: "ru")
            textFieldFirstName.placeholder = "FirstNameKey".localizableString(loc: "ru")
            textFieldFamilyName.placeholder = "FamilyNameKey".localizableString(loc: "ru")
            textFieldCheckIn.placeholder = "CheckinKey".localizableString(loc: "ru")
            textFieldCheckOut.placeholder = "CheckoutKey".localizableString(loc: "ru")
            textFieldHowBook.placeholder = "HowdidYoubooKey".localizableString(loc: "ru")
            textFieldTravelName.placeholder = "NameofTravelAgentKey".localizableString(loc: "ru")
            textFieldWebsiteName.placeholder = "NameofyourWebsiteKey".localizableString(loc: "ru")
            textFieldAddress.placeholder = "FullAddressKey".localizableString(loc: "ru")
            textFieldJob.placeholder = "JobKey".localizableString(loc: "ru")
            textFieldDOB.placeholder = "DateofbirthKey".localizableString(loc: "ru")
            textFieldWifeName.placeholder = "WifeNameKey".localizableString(loc: "ru")
            textFieldNoAdult.placeholder = "NumberofAdultsKeys".localizableString(loc: "ru")
            textFieldNoChildren.placeholder = "NumberofChildKey".localizableString(loc: "ru")
            textFieldNoRoom.placeholder = "NumberofRoomsRequiredKey".localizableString(loc: "ru")
            textFieldPaymentMode.placeholder = "PaymentMethodKey".localizableString(loc: "ru")
            textFieldSelectIdType.placeholder = "SelectYouridproofKey".localizableString(loc: "ru")
            textFieldNoOfGuest.placeholder = "NumberofGuestKey".localizableString(loc: "ru")
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
        }
    }
}





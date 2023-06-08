//
//  ChatLogController.swift
//  TenderApp
//
//  Created by Saurabh Chandra Bose on 31/10/19.
//  Copyright © 2019 Abhinav Saini. All rights reserved.

import UIKit
import Firebase
import IQKeyboardManagerSwift
import MobileCoreServices

class ChatLogController: UIViewController {
    
    lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        
        let cv = UICollectionView(frame: self.view.bounds, collectionViewLayout: flowLayout)
        cv.register(ChatMessageCell.self, forCellWithReuseIdentifier: "collectionCell")
        cv.alwaysBounceVertical = true
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = UIColor.init(rgb: 0xF7F7F7)
        cv.keyboardDismissMode = UIScrollView.KeyboardDismissMode.interactive
        cv.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 120, right: 0)
        cv.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 120, right: 0)
        cv.translatesAutoresizingMaskIntoConstraints = false
        
        return cv
    }()
    
    var textViewHeight: NSLayoutConstraint!
    let lang = UserDefaults.standard.value(forKey: "language") as? String
    lazy var inputTextField: UITextView = {
        let textField = UITextView()
//                textField.placeholder = "Write message"
        textField.delegate = self
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.borderWidth = 0
        textField.makeBorder(2, color: .lightGray)
//        textField.text = "placeholder text here..."
//        textField.textColor = .lightGray
        textField.textContainerInset = UIEdgeInsets(top: 10, left: 6, bottom: 8, right: 6)
        textField.font = UIFont.systemFont(ofSize: 14)
        //        textField.isScrollEnabled = false
        //        textField.borderStyle = UITextField.BorderStyle.line
        //        textField.layer.masksToBounds = false
        textField.layer.cornerRadius = 20
        //        textField.backgroundColor = .lightGray
        //        textField.layer.shadowRadius = 3.0
        //        textField.layer.shadowColor = UIColor.black.cgColor
        //        textField.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        //        textField.layer.shadowOpacity = 1.0
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    //    lazy var nameLabel: UILabel = {
    //
    //        return nameLabel
    //    }()
    
    let sendButton = UIButton(type: .custom)
    let backButton = UIButton(type: .custom)
    
    
    var textArray: [Any] = ["A", "B", "C", "1"] {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    // To check weather send message is image or text
    var sentMessageType: [String] = ["text", "text", "text", "text"]
    
        var sentImage: UIImage? {
            didSet {
                self.collectionView.reloadData()
            }
        }
    
    var mediaData = checkInModel()
    var imagePicker = UIImagePickerController()
    var selectedPDF: URL?
    var pdfdata = Data()
    
    var messages = [Message]()
    
    var user: Users? {
        didSet {
            print(user!.description)
            //            navigationItem.title = user?.email
//            currentUserLogin = user.loadSavedUser()
            observeMessages()
            //CommonClass.showLoader()
        }
    }
    
    //------Api Call for text ---------
    func chatInsertData(userId: String,Type: String,message: String){
        //CommonClass.showLoader()
        Webservice.shared.chatInsertData(userId: userId,type: Type,message: message){(result, response,message) in
            //CommonClass.hideLoader()
            if result == 1 {
        
            print(message)
                
            }else {
                //NKToastHelper.sharedInstance.showAlert(self, title: warningMessage.title, message: message)
            }
        }
    }
    
    //------Api Call for image media -------
    func MediachatInserted(userId: String,Type: String,message: UIImage){
        CommonClass.showLoader()
        Webservice.shared.chatInserted(userId: userId, type: Type, message: message) { (result, response,message) in
            CommonClass.hideLoader()
            if result == 1 {
                if let data = response {
                    self.mediaData = data
                }
                //----update data in firebase
                guard let chatId = self.user?.chatID, chatId != "" else { return }
                let ref = Database.database().reference().child("messages").child(chatId)
                let childRef = ref.childByAutoId()
                let toID = self.user!.adminId!
                let fromID = self.user!.userID!
                let time = ServerValue.timestamp()
                
                let values: [String: Any] = ["adminId": toID,"messageType": "file", "userId": fromID, "time": time, "senderType": "USER","mediaLink": self.mediaData.message]
                
                childRef.updateChildValues(values) { (error, ref) in
                    if error != nil {
                        print(error!)
                        return
                    }
                   
                    self.inputTextField.text = nil
                }
                
            }else {
                NKToastHelper.sharedInstance.showAlert(self, title: warningMessage.title, message: message)
            }
        }
    }
    
    //------Api Call for doc media -------
    func MediaDocchatInserted(userId: String,Type: String,message: Data){
        CommonClass.showLoader()
        Webservice.shared.chatDocInserted(userId: userId, type: Type, message: message) { (result, response,message) in
            CommonClass.hideLoader()
            if result == 1 {
                if let data = response {
                    self.mediaData = data
                }
                //----update data in firebase
                guard let chatId = self.user?.chatID, chatId != "" else { return }
                let ref = Database.database().reference().child("messages").child(chatId)
                let childRef = ref.childByAutoId()
                let toID = self.user!.adminId!
                let fromID = self.user!.userID!
                let time = ServerValue.timestamp()
                
                let values: [String: Any] = ["adminId": toID,"messageType": "file", "userId": fromID, "time": time, "senderType": "USER","mediaLink": self.mediaData.message]
                
                childRef.updateChildValues(values) { (error, ref) in
                    if error != nil {
                        print(error!)
                        return
                    }
                   
                    self.inputTextField.text = nil
                }
                
            }else {
                NKToastHelper.sharedInstance.showAlert(self, title: warningMessage.title, message: message)
            }
        }
    }
    
    
    func observeMessages() {
        guard let chatId = user?.chatID else {
            return
        }
        
        let messageRef = Database.database().reference().child("messages").child(chatId)
        
        messageRef.observe(.childAdded, with: { (snapshot) in
            guard let dictionary = snapshot.value as? [String: AnyObject] else {
                return
            }
            let tempMessage = Message(dictionary: dictionary)
            
            print(dictionary as NSDictionary)
            
            self.messages.append(tempMessage)
            DispatchQueue.main.async(execute: {
                //CommonClass.hideLoader()
                self.collectionView.reloadData()
                //                        scroll to the last index
                let indexPath = IndexPath(item: self.messages.count - 1, section: 0)
                self.collectionView.scrollToItem(at: indexPath, at: .bottom, animated: true)
            })
        }, withCancel: nil)
        
    }
    
    var currentUserLogin: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.currentUserLogin = User.loadSavedUser()
        self.view.addSubview(collectionView)
        self.view.addSubview(topBar)
        setupContraints()
        setupKeyboardObservers()
        setupSwipeGesture()
        
        self.tabBarController?.tabBar.isHidden = true
        //        self.view.backgroundColor = .green
        IQKeyboardManager.shared.enable = false
        //        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goBack)))
        
        
    }
    
    @objc func goBack() {
        navigationController?.popViewController(animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.shared.enable = true
    }
    
    func setupSwipeGesture() {
        let leftRecognizer = UISwipeGestureRecognizer(target: self, action:
            #selector(swipeMade(_:)))
        leftRecognizer.direction = .right
        view.addGestureRecognizer(leftRecognizer)
    }
    
    @objc func swipeMade(_ sender: UISwipeGestureRecognizer) {
        navigationController?.popViewController(animated: true)
    }
    
    lazy var topBar: UIView = {
        let tb = UIView()
        tb.backgroundColor = .white
        tb.addBottomThinBorderWithColor(.red)
        tb.translatesAutoresizingMaskIntoConstraints = false
        
        //        backButton.setTitle("Back", for: .normal)
        backButton.setImage(UIImage(named: "back icon"), for: [])
        backButton.backgroundColor = .clear
        backButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        backButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        
        //what is handleSend?
        
        tb.addSubview(backButton)
        //x,y,w,h
        
        
//        let profileImage = RoundImageView(frame: .zero)
//        //        if let userImageURL = self.user?.profileImageUrl {
//        //            profileImage.loadImageUsingCacheWithUrlString(userImageURL)
//        //        }
//        //        profileImage.loadImageUsingCacheWithUrlString(userImage)
//        //        profileImage.loadImageUsingCacheWithUrlString(self.user!.profileImageUrl!)
//        //        profileImage.makeRoundCorner(borderColor: nil, borderWidth: 1)
//        profileImage.translatesAutoresizingMaskIntoConstraints = false
//
//        tb.addSubview(profileImage)
//
//        profileImage.leftAnchor.constraint(equalTo: backButton.rightAnchor, constant: 10).isActive = true
//        profileImage.widthAnchor.constraint(equalTo: profileImage.heightAnchor, multiplier: 1).isActive = true
//        profileImage.topAnchor.constraint(equalTo: tb.topAnchor, constant: 5).isActive = true
//        profileImage.bottomAnchor.constraint(equalTo: tb.bottomAnchor, constant: -5).isActive = true
        
        let brandLabel = UILabel()
        brandLabel.text = "Support Chat"
        
        if lang == "en" {
            brandLabel.text = "SupportChatKey".localizableString(loc: "en")
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
        } else if lang == "ar"{
            brandLabel.text = "SupportChatKey".localizableString(loc: "ar")
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
            
        } else if lang == "ru" {
            brandLabel.text = "SupportChatKey".localizableString(loc: "ru")
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
        }
        
        
        
        brandLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
//        brandLabel.font = UIFont(name: "montserrat", size: 18)
        brandLabel.backgroundColor = UIColor.clear
        brandLabel.textColor = .black
        brandLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        tb.addSubview(brandLabel)
        
        //        nameLabel.leftAnchor.constraint(equalTo: profileImage.rightAnchor, constant: 5).isActive = true
        brandLabel.centerYAnchor.constraint(equalTo: tb.centerYAnchor, constant: 5).isActive = true
        brandLabel.centerXAnchor.constraint(equalTo: tb.centerXAnchor, constant: 0).isActive = true
        //        nameLabel.rightAnchor.constraint(equalTo: tb.rightAnchor, constant: -5).isActive = true
        
        
//        let nameLabel = UILabel()
//        nameLabel.text = self.user?.name
//        nameLabel.font = UIFont.systemFont(ofSize: 18, weight: .regular)
//        nameLabel.backgroundColor = UIColor.clear
//        nameLabel.textColor = .black
//        nameLabel.translatesAutoresizingMaskIntoConstraints = false
//
//
//        tb.addSubview(nameLabel)
        
        //        nameLabel.leftAnchor.constraint(equalTo: profileImage.rightAnchor, constant: 5).isActive = true
//        nameLabel.centerYAnchor.constraint(equalTo: tb.centerYAnchor, constant: 25).isActive = true
//        nameLabel.centerXAnchor.constraint(equalTo: tb.centerXAnchor, constant: 0).isActive = true
        //        nameLabel.rightAnchor.constraint(equalTo: tb.rightAnchor, constant: -5).isActive = true
        
        backButton.leftAnchor.constraint(equalTo: tb.leftAnchor, constant: 5).isActive = true
        backButton.centerYAnchor.constraint(equalTo: brandLabel.bottomAnchor).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        backButton.heightAnchor.constraint(equalTo: backButton.widthAnchor, multiplier: 1).isActive = true
        
        return tb
    }()
    
    lazy var testingViewContainer: UIView = {
        let testingView = UIView()
        testingView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 60)
        testingView.backgroundColor = UIColor.init(rgb: 0xF7F7F7)
        
        //------open gallery
        let uploadImageView = UIImageView()
        uploadImageView.image = UIImage(named: "Mask Group 80")
        uploadImageView.isUserInteractionEnabled = true
        uploadImageView.translatesAutoresizingMaskIntoConstraints = false
        uploadImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleUploadTap)))
        //uploadImageView.isHidden = true
        
        testingView.addSubview(uploadImageView)
        
        uploadImageView.leftAnchor.constraint(equalTo: testingView.leftAnchor, constant: 10).isActive = true
        uploadImageView.centerYAnchor.constraint(equalTo: testingView.centerYAnchor).isActive = true
        uploadImageView.heightAnchor.constraint(equalToConstant: 35).isActive = true
        uploadImageView.widthAnchor.constraint(equalToConstant: 35).isActive = true
        
        
        
        //        sendButton.setTitle("Send", for: .normal)
        sendButton.setImage(UIImage(named: "icons8-email-send-32"), for: [])
        sendButton.setBackgroundImage(UIImage(named: "Ellipse 15"), for: [])
        //        sendButton.contentEdgeInsets = UIEdgeInsets(top: 17, left: 15, bottom: 17, right: 15)
                sendButton.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        sendButton.backgroundColor =  UIColor.init(r: 255, g: 227, b: 16)
        sendButton.makeRoundCorner(25)
        sendButton.addTarget(self, action: #selector(handleSendButton), for: .touchUpInside)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        
        //what is handleSend?
        
        testingView.addSubview(sendButton)
        //x,y,w,h
        sendButton.rightAnchor.constraint(equalTo: testingView.rightAnchor, constant: -8).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: testingView.centerYAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 48).isActive = true
        sendButton.heightAnchor.constraint(equalTo: sendButton.widthAnchor).isActive = true
        
        testingView.addSubview(self.inputTextField)
        //x,y,w,h
        self.inputTextField.leftAnchor.constraint(equalTo: testingView.leftAnchor, constant: 60).isActive = true
        //        self.inputTextField.centerYAnchor.constraint(equalTo: testingView.centerYAnchor).isActive = true
        self.inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor, constant:  -8).isActive = true
        //        self.inputTextField.topAnchor.constraint(equalTo: testingView.topAnchor, constant: 10).isActive = true
        self.inputTextField.bottomAnchor.constraint(equalTo: testingView.bottomAnchor, constant: -10).isActive = true
        textViewHeight = self.inputTextField.heightAnchor.constraint(equalToConstant: 40)
        textViewHeight.isActive = true
        //        self.inputTextField.heightAnchor.constraint(equalTo: testingView.heightAnchor).isActive = true
        
        //        let separatorLineView = UIView()
        //        separatorLineView.backgroundColor = UIColor(rgb: 0xbcd9ce)
        //        separatorLineView.translatesAutoresizingMaskIntoConstraints = false
        //        testingView.addSubview(separatorLineView)
        //        //x,y,w,h
        //        separatorLineView.leftAnchor.constraint(equalTo: testingView.leftAnchor).isActive = true
        //        separatorLineView.topAnchor.constraint(equalTo: testingView.topAnchor).isActive = true
        //        separatorLineView.widthAnchor.constraint(equalTo: testingView.widthAnchor).isActive = true
        //        separatorLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        return testingView
    }()
    
    
    @objc func handleUploadTap() {
        
//        let imagePickerController = UIImagePickerController()
//        imagePickerController.allowsEditing = true
//        imagePickerController.delegate = self
//        //imagePickerController.mediaTypes = [kUTTypeImage as String, kUTTypeMovie as String]
//        present(imagePickerController, animated: true, completion: nil)
        
        if lang == "en" {
            let alert = UIAlertController(title: "Add Media", message: nil, preferredStyle: .actionSheet)
            
            alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
                self.openCamera()
            }))
            
            alert.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { _ in
                self.openGallary()
            }))
            
            alert.addAction(UIAlertAction(title: "Documents", style: .default, handler: { _ in
                self.openFile()
            }))
            
            alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else if lang == "ar"{
            let alert = UIAlertController(title: "أضف الوسائط", message: nil, preferredStyle: .actionSheet)
            
            alert.addAction(UIAlertAction(title: "الة تصوير", style: .default, handler: { _ in
                self.openCamera()
            }))
            
            alert.addAction(UIAlertAction(title: "مكتبة الصور", style: .default, handler: { _ in
                self.openGallary()
            }))
            
            alert.addAction(UIAlertAction(title: "مستندات", style: .default, handler: { _ in
                self.openFile()
            }))
            
            alert.addAction(UIAlertAction.init(title: "إلغاء", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        } else if lang == "ru" {
            let alert = UIAlertController(title: "Добавить медиа", message: nil, preferredStyle: .actionSheet)
            
            alert.addAction(UIAlertAction(title: "Камера", style: .default, handler: { _ in
                self.openCamera()
            }))
            
            alert.addAction(UIAlertAction(title: "Фото библиотека", style: .default, handler: { _ in
                self.openGallary()
            }))
            
            alert.addAction(UIAlertAction(title: "Документы", style: .default, handler: { _ in
                self.openFile()
            }))
            
            alert.addAction(UIAlertAction.init(title: "Отмена", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    
    override var inputAccessoryView: UIView? {
        get {
            return testingViewContainer
        }
    }
    
    override var canBecomeFirstResponder : Bool {
        return true
    }
    
    // Function for when device rotate
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        //MARK: To hide inputAccessoryView view in image picker view. Took a lot fo time. phew
        //        self.inputAccessoryView?.removeFromSuperview()
        self.inputAccessoryView?.isHidden = true
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.inputAccessoryView?.isHidden = false
    }
    
    fileprivate func setupContraints() {
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 90).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
        
        topBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        topBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        topBar.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        topBar.bottomAnchor.constraint(equalTo: collectionView.topAnchor, constant: 0).isActive = true
        //        topBar.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
    }
    
    var containerViewBottomAnchor: NSLayoutConstraint?
    
    func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
        let keyboardDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
        print(keyboardDuration)
        print(keyboardFrame.height)
        //        containerViewBottomAnchor?.constant = -keyboardFrame.height
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.height, right: 0)
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.height, right: 0)
        UIView.animate(withDuration: keyboardDuration) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        let keyboardDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        //        self.containerViewBottomAnchor?.constant = 0
        UIView.animate(withDuration: keyboardDuration) {
            
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func handleSendButton() {
        
        if !self.inputTextField.text.isEmpty {
            guard let chatId = user?.chatID, chatId != "" else { return }
                   
                   let ref = Database.database().reference().child("messages").child(chatId)
                   let childRef = ref.childByAutoId()
                   let toID = user!.adminId!
                   let fromID = user!.userID!
                   let time = ServerValue.timestamp()
                   let values: [String: Any] = ["text" : inputTextField.text!, "adminId": toID,"messageType": "text", "userId": fromID, "time": time, "senderType": "USER"]
                   //        childRef.updateChildValues(values)
                   childRef.updateChildValues(values) { (error, ref) in
                       if error != nil {
                           print(error!)
                           return
                       }
                       //Chat insert API=========
                       self.chatInsertData(userId: self.user!.userID!,Type: "msg",message: self.inputTextField.text!)
                       
                       self.inputTextField.text = nil
                   }
        }else {
            self.textViewDidChange(self.inputTextField)
        }
    }
    
     //======Media Chat insert API=========
    
    func sendMediaMessage(image: UIImage) {
       
        self.MediachatInserted(userId: self.user!.userID!,Type: "file",message: image)
        
    }
    
    func sendMediaPdf(docPdf: Data) {
       
        self.MediaDocchatInserted(userId: self.user!.userID!, Type: "file", message: docPdf)
        
    }
}


// MARK:- UICollectionView extension
extension ChatLogController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("number of cell --- \(textArray.count)")
        return messages.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath as IndexPath) as! ChatMessageCell
        
        let message = messages[indexPath.item]
        
        
        // handle time
        var timeText: String?
        if let seconds = message.time?.doubleValue {
            let timestampDate = Date(timeIntervalSince1970: seconds/1000)
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "hh:mm a"
            timeText = dateFormatter.string(from: timestampDate)
            cell.timeLabel.text = timeText
        }
        
        
        if message.messageType == "text" || message.senderType == "ADMIN" {
            setupTextCell(cell, message: message)
            cell.textView.text = message.text
            cell.textView.textColor = UIColor.black
            cell.textView.sizeToFit()
            cell.bubbleWidthAnchor?.constant = (estimateFrameForText(text: message.text ?? "").width + 32) > (estimateFrameForText(text: timeText ?? " ").width + 32) ? (estimateFrameForText(text: message.text!).width + 32) : (estimateFrameForText(text: timeText ?? "").width + 32)
            
        } else if message.messageType == "file" {
            setupMediaCell(cell, message: message)
            //cell.messageImageView.image = #imageLiteral(resourceName: "room and suits")
            //cell.messageImageView.image = message.mediaLink?.base64Convert()
            
            let fileFormat = message.mediaLink?.fileExtension() ?? ""
            
            if fileFormat == "pdf" {
                cell.messageImageView.image = #imageLiteral(resourceName: "export-pdf")
                cell.messageImageView.contentMode = .scaleToFill
            }else{
               cell.messageImageView.sd_setImage(with: URL(string: message.mediaLink ?? ""), placeholderImage: #imageLiteral(resourceName: "hotel white") )
            }
            cell.bubbleWidthAnchor?.constant = 150
        }
        
        
        
        //        cell.bubbleWidthAnchor?.constant = estimateFrameForText(text: message.text!).width + 32
        
        // handel bubble width, compare width between text and time, set bubble with according to whichever is big
        //cell.bubbleWidthAnchor?.constant = (estimateFrameForText(text: message.text ?? "").width + 32) > (estimateFrameForText(text: timeText ?? " ").width + 32) ? (estimateFrameForText(text: message.text!).width + 32) : (estimateFrameForText(text: timeText ?? "").width + 32)
        
        //        let UpSwipe = UISwipeGestureRecognizer(target: self, action: #selector(someMethod(sender:)))
        //        UpSwipe.direction = UISwipeGestureRecognizer.Direction.left
        //        cell.addGestureRecognizer(UpSwipe)
        
        return cell
    }
    
    fileprivate func setupTextCell(_ cell: ChatMessageCell, message: Message) {
//        cell.profileImage2.sd_setImage(with: URL(string: self.user?.senderImage ?? ""), placeholderImage: UIImage(named: "default_profile"), completed: nil)
//        cell.profileImage.sd_setImage(with: URL(string: self.user?.receiverImage ?? ""),placeholderImage: UIImage(named: "default_profile"), completed: nil)
        
//        cell.profileImage2.image = UIImage(named: "usename")
        
        if message.senderType == "USER" {
            cell.bubbleView.backgroundColor = .white
            cell.textView.textColor = .black
//            cell.profileImage.isHidden = true
//            cell.profileImage2.isHidden = false
            cell.textView.isHidden = false
            cell.messageImageView.isHidden = true
            cell.bubbleRightAnchor?.isActive = true
            cell.bubbleLeftAnchor?.isActive = false
        } else if message.senderType == "ADMIN" {
            cell.bubbleView.backgroundColor = .white
            cell.textView.textColor = .black
            cell.textView.isHidden = false
//            cell.profileImage.isHidden = false
//            cell.profileImage2.isHidden = true
            cell.messageImageView.isHidden = true
            cell.bubbleRightAnchor?.isActive = false
            cell.bubbleLeftAnchor?.isActive = true
        }
    }
    
    fileprivate func setupMediaCell(_ cell: ChatMessageCell, message: Message) {
       
        
        if message.fromId == self.user?.userID {
            cell.bubbleView.backgroundColor = .clear
            //cell.messageImageView.image = textArray[indexPath.item] as! UIImage
            cell.messageImageView.isHidden = false
            cell.textView.isHidden = true
            cell.profileImage.isHidden = true
            cell.bubbleRightAnchor?.isActive = true
            cell.bubbleLeftAnchor?.isActive = false
        } else {
            cell.bubbleView.backgroundColor = .clear
            //cell.messageImageView.image = textArray[indexPath.item] as! UIImage
            cell.messageImageView.isHidden = false
            cell.textView.isHidden = true
            cell.profileImage.isHidden = true
            cell.bubbleRightAnchor?.isActive = false
            cell.bubbleLeftAnchor?.isActive = true
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var height: CGFloat = 180
        
        let message = messages[indexPath.item]
        if let text = message.text {
            height = estimateFrameForText(text: text).height + 30
        } else if let imageWidth = message.imageWidth?.floatValue, let imageHeight = message.imageHeight?.floatValue {
            
            // h1 / w1 = h2 / w2
            // solve for h1
            // h1 = h2 / w2 * w1
            
            height = CGFloat(imageHeight / imageWidth * 400)
            
        }
        
        let width = UIScreen.main.bounds.width
        return CGSize(width: width, height: height)
    }
    
    // Function to get the estimated height of given text. You need to specify the width, height and text font size in the function.
    private func estimateFrameForText(text: String) -> CGRect {
        // "size" is the maximum width and height the text bubble can have.
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)], context: nil)
    }
    
    private func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.height, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
        let message = messages[indexPath.item]
        if message.messageType == "file" {
            
            let cell = collectionView.cellForItem(at: indexPath) as! ChatMessageCell
            let storyboard = UIStoryboard(name: "Home", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "ZoomableImageViewController") as! ZoomableImageViewController
            vc.image = cell.messageImageView.image
            self.navigationController?.pushViewController(vc, animated: true)

        } else {

        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
}


// MARK:- UITextField extension
extension ChatLogController: UITextFieldDelegate {
    
}


// MARK:- UIImagePickerControlle extension
//extension ChatLogController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        var selectedImageFromPicker: UIImage?
//
//        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
//            selectedImageFromPicker = editedImage
//        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
//            selectedImageFromPicker = originalImage
//        }
//
//        if let selectedImage = selectedImageFromPicker {
//            print("selectedimage")
//            //            sentImage = selectedImage
//            textArray.append(selectedImage)
//            sentMessageType.append("image")
//        }
//
//        dismiss(animated: true, completion: nil)
//    }
//
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        dismiss(animated: true, completion: nil)
//    }
//}
//

extension ChatLogController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func openCamera() {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera)) {
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = true
            imagePicker.delegate = self
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func openGallary() {
        imagePicker.mediaTypes = ["public.image"]
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
            if let chosenImage = info[.editedImage] as? UIImage{
                sentImage = chosenImage
                self.sendMediaMessage(image: chosenImage)
                sentMessageType.append("image")
            }else if let chosenImage = info[.originalImage] as? UIImage{
                sentImage = chosenImage
                 self.sendMediaMessage(image: chosenImage)
                sentMessageType.append("image")
            }
    
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}

// MARK:- Document Picker extension
extension ChatLogController: UIDocumentPickerDelegate {
    
    func openFile() {
        let documentPicker = UIDocumentPickerViewController(documentTypes: [kUTTypePDF as String,], in: .import)
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = true
        present(documentPicker, animated: true, completion: nil)
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        
        guard let selectedFileURL = urls.first else {
            print("URL Failed")
            return
        }
        self.selectedPDF = selectedFileURL
        let pdfViewController = PDFController(pdfUrl: selectedFileURL)
        
//        imageViewPdfThumnails.isHidden = false
//        labelPdfName.isHidden = false
        //notificationButton.setImage(#imageLiteral(resourceName: "images"), for: .normal)
        //labelfileName.text = "application.pdf"
        //pdfViewController.delegate = self

        //-------convert pdf url into data---------
        guard let datas = selectedPDF else {
            return NKToastHelper.sharedInstance.showErrorAlert(self, message: "Please select the document.")
        }
        do {
            pdfdata = try Data(contentsOf: datas)
            
            sendMediaPdf(docPdf: pdfdata)
            
        } catch {}

        present(pdfViewController, animated: true, completion: nil)
        

    }
}




//********************************** EXTENSION FOR COLOR *******************************//
extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
    static let greenColor = UIColor(rgb: 0x00FE46)
    static let redColor = UIColor(rgb: 0xFF3741)
}



// To make the UIImage round in layoutSubviews because as an extension that doesn't work properly.
class RoundImageView: UIImageView {
    
    override init(frame: CGRect) {
        // 1. setup any properties here
        // 2. call super.init(frame:)
        super.init(frame: frame)
        // 3. Setup view from .xib file
    }
    
    required init?(coder aDecoder: NSCoder) {
        // 1. setup any properties here
        // 2. call super.init(coder:)
        super.init(coder: aDecoder)
        // 3. Setup view from .xib file
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.borderWidth = 0
        self.layer.masksToBounds = true
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.cornerRadius = self.frame.size.width/2
        self.clipsToBounds = true
    }
}


// Add round corner or add round corner with radius to tha view
extension UIView {
    func makeRoundCorner(borderColor: UIColor?, borderWidth: CGFloat, cornerRadius: CGFloat) {
        if let color = borderColor {
            self.layer.borderColor = color.cgColor
        }
        //        if borderColor != nil {
        //            self.layer.borderColor = borderColor?.cgColor
        //        }
        self.layer.borderWidth = borderWidth
        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = true
    }
    
    func makeRoundCorner(borderColor: UIColor?, borderWidth: CGFloat) {
        if let color = borderColor {
            self.layer.borderColor = color.cgColor
        }
        self.layer.borderWidth = borderWidth
        self.layer.cornerRadius = self.layer.frame.size.height/2
        self.layer.masksToBounds = true
    }
}

extension ChatLogController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        let sizeToFitIn = CGSize(width: self.inputTextField.bounds.size.width, height: CGFloat(MAXFLOAT))
        let newSize = self.inputTextField.sizeThatFits(sizeToFitIn)
        let height = newSize.height > 40 ? (newSize.height > 60 ? 60 : newSize.height) : 40
        print("height --- \(height)")
        self.textViewHeight.constant = height
        testingViewContainer.invalidateIntrinsicContentSize()
        testingViewContainer.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: height + 20)
    }
}




extension UIImage{
    func toBase64() -> String{
        let imageData = self.pngData()!
        return imageData.base64EncodedString(options: .lineLength64Characters)//base64EncodedStringWithOptions(.Encoding64CharacterLineLength)
    }
}

extension String {
    func base64Convert() -> UIImage? {
        
        if let decodedData = NSData(base64Encoded: self, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters),
            let decodedimage = UIImage(data: decodedData as Data) {
            return decodedimage
        }else {
            return nil
        }
    }
}

extension String {

    func fileName() -> String {
        return URL(fileURLWithPath: self).deletingPathExtension().lastPathComponent
    }

    func fileExtension() -> String {
        return URL(fileURLWithPath: self).pathExtension
    }
}

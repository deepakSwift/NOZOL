//
//  MyServicesViewController.swift
//  NOZOL
//
//  Created by Mukul Sharma on 15/07/20.
//  Copyright © 2020 Mukul Sharma. All rights reserved.
//

import UIKit

class MyServicesViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var upcomingBookingButton : UIButton!
    @IBOutlet weak var completeBookingButton : UIButton!
    @IBOutlet weak var ButtonView: UIView!
    @IBOutlet weak var moveView: UIView!
    @IBOutlet weak var buttonOutdoor: UIButton!
    @IBOutlet weak var buttonIndoor: UIButton!
    @IBOutlet weak var labelService: UILabel!
    
    var selectedPage:CGFloat = 0
    var currentUserLogin : User!
    var statusResponse = serviceModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLocalization()
        self.scrollView.isPagingEnabled = true
        self.scrollView.bounces = false
        self.toggleRateButton(button: upcomingBookingButton)
        let upcomingBokk = AppStoryboard.Home.viewController(OnGoingViewController.self)
        self.addChild(upcomingBokk)
        let completeBook = AppStoryboard.Home.viewController(PastViewController.self)
        self.addChild(completeBook)
        self.perform(#selector(LoadScollView), with: nil, afterDelay: 0.5)
        self.ButtonView.addShadow()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.currentUserLogin = User.loadSavedUser()
        checkRoomStatus(userId: currentUserLogin.userId)
         updateToken(userId: currentUserLogin.userId, tokenId: kDeviceToken)
        self.raceScrollTo(CGPoint(x:selectedPage*self.view.frame.size.width,y:0), withSnapBack: false, delegate: nil, callback: nil)
        if selectedPage == 0{
            self.raceTo(CGPoint(x:self.upcomingBookingButton.frame.origin.x,y: 38), withSnapBack: false, delegate: nil, callbackmethod: nil)
            
        }else{
            self.raceTo(CGPoint(x:self.completeBookingButton.frame.origin.x,y: 38), withSnapBack: false, delegate: nil, callbackmethod: nil)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func onClickChatButton(_ sender : UIButton){
        
        let chatVC = ChatLogController()
        let userDict: [String : AnyObject] = ["userID" : self.currentUserLogin.userId as AnyObject, "name" : self.currentUserLogin.name as AnyObject, "email" : self.currentUserLogin.email as AnyObject, "adminId" : "TyM1oIvSbn" as AnyObject, "chatID" : "\(self.currentUserLogin.userId)_\("TyM1oIvSbn")" as AnyObject]
        
        let user = Users(dictionary: userDict)
        chatVC.user = user
        navigationController?.pushViewController(chatVC, animated: true)
        
    }
    
    
    //------Update Token-------
    func updateToken(userId: String, tokenId: String) {
        Webservice.shared.updateToken(userId: userId, tokenId: tokenId) { (result, message) in
            if result == 1 {
                print("Token Updated")
            } else {
                print("Failed to update token")
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



extension MyServicesViewController : UIScrollViewDelegate{
    
    func toggleRateButton(button:UIButton){
        if button == upcomingBookingButton{
            upcomingBookingButton.isSelected = true
            completeBookingButton.isSelected = false
        }else {
            upcomingBookingButton.isSelected = false
            completeBookingButton.isSelected = true
        }
    }
    
    
    
    @IBAction func onClickActiveAdsButton(_ sender: UIButton){
        //----Fire notification for update table
        NotificationCenter.default.post(name: .refreshTableView, object: nil)
        
        self.toggleRateButton(button: upcomingBookingButton )
        selectedPage=0
        self.raceScrollTo(CGPoint(x:0,y:0), withSnapBack: false, delegate: nil, callback: nil)
        self.raceTo(CGPoint(x:self.upcomingBookingButton.frame.origin.x,y: 38), withSnapBack: false, delegate: nil, callbackmethod: nil)
    }
    
    
    @IBAction func onClickInactiveButton(_ sender: UIButton){
        //----Fire notification for update table
        NotificationCenter.default.post(name: .refreshTableView, object: nil)
        
        self.toggleRateButton(button: completeBookingButton)
        selectedPage=1
        self.raceScrollTo(CGPoint(x:1*self.view.frame.size.width,y: 0), withSnapBack: false, delegate: nil, callback: nil)
        self.raceTo(CGPoint(x:self.completeBookingButton.frame.origin.x,y: 38), withSnapBack: false, delegate: nil, callbackmethod: nil)
    }
    
    
    @objc func LoadScollView() {
        scrollView.delegate = nil
        // scrollView.contentSize = CGSize(width:kScreenWidth * 2, height:scrollView.frame.size.height)
        for i in 0 ..< self.children.count {
            self.loadScrollViewWithPage(i)
        }
        scrollView.delegate = self
    }
    
    
    func loadScrollViewWithPage(_ page: Int) {
        if page < 0 {
            return
        }
        if page >= self.children.count {
            return
        }
        var upcomingbook : OnGoingViewController
        var completebook : PastViewController
        var frame: CGRect = scrollView.frame
        switch page {
        case 0:
            upcomingbook = self.children[page] as! OnGoingViewController
            upcomingbook.viewWillAppear(true)
            frame.origin.x = frame.size.width * CGFloat(page)
            frame.origin.y = 0
            upcomingbook.view.frame = frame
            scrollView.addSubview(upcomingbook.view!)
            upcomingbook.view.setNeedsLayout()
            upcomingbook.view.layoutIfNeeded()
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
            upcomingbook.view.setNeedsLayout()
            upcomingbook.view.layoutIfNeeded()
            
        case 1:
            completebook = self.children[page] as! PastViewController
            completebook.viewWillAppear(true)
            frame.origin.x = frame.size.width * CGFloat(page)
            frame.origin.y = 0
            completebook.view.frame = frame
            scrollView.addSubview(completebook.view!)
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
            completebook.view.setNeedsLayout()
            completebook.view.layoutIfNeeded()
            
            
        default:
            break
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageCurrent = Int(floor(scrollView.contentOffset.x / self.view.frame.size.width))
        switch pageCurrent {
        case 0:
            self.toggleRateButton(button: upcomingBookingButton)
            self.raceScrollTo(CGPoint(x:0,y:0), withSnapBack: false, delegate: nil, callback: nil)
            self.raceTo(CGPoint(x:self.upcomingBookingButton.frame.origin.x,y: 38), withSnapBack: false, delegate: nil, callbackmethod: nil)
            
        case 1:
            self.toggleRateButton(button: completeBookingButton)
            self.raceScrollTo(CGPoint(x:1*self.view.frame.size.width,y: 0), withSnapBack: false, delegate: nil, callback: nil)
            self.raceTo(CGPoint(x:self.completeBookingButton.frame.origin.x,y: 38), withSnapBack: false, delegate: nil, callbackmethod: nil)
            
        default:
            break
        }
    }
    
    func raceTo(_ destination: CGPoint, withSnapBack: Bool, delegate: AnyObject?, callbackmethod : (()->Void)?) {
        var stopPoint: CGPoint = destination
        if withSnapBack {
            let diffx = destination.x - moveView.frame.origin.x
            let diffy = destination.y - moveView.frame.origin.y
            if diffx < 0 {
                stopPoint.x -= 10.0
            }
            else if diffx > 0 {
                stopPoint.x += 10.0
            }
            
            if diffy < 0 {
                stopPoint.y -= 10.0
            }
            else if diffy > 0 {
                stopPoint.y += 10.0
            }
        }
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.2)
        UIView.setAnimationCurve(UIView.AnimationCurve.easeIn)
        moveView.frame = CGRect(x:stopPoint.x, y:stopPoint.y, width: moveView.frame.size.width,height: moveView.frame.size.height)
        UIView.commitAnimations()
        let firstDelay = 0.1
        let startTime = firstDelay * Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: .now() + startTime) {
            UIView.beginAnimations(nil, context: nil)
            UIView.setAnimationDuration(0.1)
            UIView.setAnimationCurve(UIView.AnimationCurve.linear)
            self.moveView.frame = CGRect(x:destination.x, y:destination.y,width: self.moveView.frame.size.width, height: self.moveView.frame.size.height)
            UIView.commitAnimations()
        }
    }
    
    
    func raceScrollTo(_ destination: CGPoint, withSnapBack: Bool, delegate: AnyObject?, callback method:(()->Void)?) {
        var stopPoint = destination
        var isleft: Bool = false
        if withSnapBack {
            let diffx = destination.x - scrollView.contentOffset.x
            if diffx < 0 {
                isleft = true
                stopPoint.x -= 10
            }
            else if diffx > 0 {
                isleft = false
                stopPoint.x += 10
            }
        }
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.3)
        UIView.setAnimationCurve(UIView.AnimationCurve.easeIn)
        if isleft {
            scrollView.contentOffset = CGPoint(x:destination.x - 5, y:destination.y)
        }
        else {
            scrollView.contentOffset = CGPoint(x:destination.x + 5, y:destination.y)
        }
        
        UIView.commitAnimations()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0) {() -> Void in
            UIView.beginAnimations(nil, context: nil)
            UIView.setAnimationDuration(0.1)
            UIView.setAnimationCurve(UIView.AnimationCurve.linear)
            if isleft {
                self.scrollView.contentOffset = CGPoint(x:destination.x + 5, y:destination.y)
            }
            else {
                self.scrollView.contentOffset = CGPoint(x:destination.x - 5,y: destination.y)
            }
            UIView.commitAnimations()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0){() -> Void in
                UIView.beginAnimations(nil, context: nil)
                UIView.setAnimationDuration(0.1)
                UIView.setAnimationCurve(.easeInOut)
                self.scrollView.contentOffset = CGPoint(x:destination.x, y:destination.y)
                UIView.commitAnimations()
            }
        }
    }
}

extension Notification.Name {
    static let refreshTableView = Notification.Name("refreshTableView")
}


//----- Set Localization------
extension MyServicesViewController {
    
    func setLocalization() {
        let lang = UserDefaults.standard.value(forKey: "language") as? String
        if lang == "en" {
            buttonOutdoor.setTitle("OngoingServicesKey".localizableString(loc: "en"), for: .normal)
            buttonIndoor.setTitle("PastServicesKey".localizableString(loc: "en"), for: .normal)
            labelService.text = "MyServicesKey".localizableString(loc: "en")
            UIView.appearance().semanticContentAttribute = .forceLeftToRight

        } else if lang == "ar"{
            buttonOutdoor.setTitle("OngoingServicesKey".localizableString(loc: "ar"), for: .normal)
            buttonIndoor.setTitle("PastServicesKey".localizableString(loc: "ar"), for: .normal)
            labelService.text = "MyServicesKey".localizableString(loc: "ar")
            UIView.appearance().semanticContentAttribute = .forceRightToLeft

        } else if lang == "ru" {
            buttonOutdoor.setTitle("OngoingServicesKey".localizableString(loc: "ru"), for: .normal)
            buttonIndoor.setTitle("PastServicesKey".localizableString(loc: "ru"), for: .normal)
            labelService.text = "MyServicesKey".localizableString(loc: "ru")
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
        }
    }
}

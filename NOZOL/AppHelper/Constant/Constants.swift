//
//  ChangePasswordVC.swift
//  CellMe
//
//  Created by Sagar Gupta on 06/04/20.
//  Copyright © 2020 Sagar Gupta. All rights reserved.
//
import UIKit
import JDStatusBarNotification
import TSMessages

let kNavigationColor = UIColor(red:30.0/255.0, green:48.0/255.0, blue:58.0/255, alpha:1.0)
let kApplicationRedColor = UIColor(red:250.0/255.0, green:99.0/255.0, blue:98.0/255, alpha:1.0)
let warningMessageShowingDuration = 1.25

let kUserDefaults = UserDefaults.standard

let separatorText = "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"

/*============== NOTIFICATIONS ==================*/
extension NSNotification.Name {
    public static let RIDE_REQUEST_NOTIFICATION = NSNotification.Name("RideAcceptNotification")
    public static let RIDE_CANCELLED_NOTIFICATION = NSNotification.Name("RideCancelledNotification")
    public static let ADD_EMERGENCY_CONTACT_NOTIFICATION = NSNotification.Name("AddEmergencyContactNotification")
    public static let ADD_CAR_NOTIFICATION = NSNotification.Name("AddCarNotification")
    public static let EDIT_PROFILE_NOTIFICATION = NSNotification.Name("EditProfileNotification")
    public static let COLLECT_FARE_NOTIFICATION = NSNotification.Name("CollectFareNotification")
    public static let RIDE_COMPLETE_NOTIFICATION = NSNotification.Name("RideCompleteNotification")
    public static let GOTO_DASHBOARD_NOTIFICATION = NSNotification.Name("GoToDashboardNotification")
    public static let START_RIDE_NOTIFICATION = NSNotification.Name("StartRideNotification")
    public static let RIDE_REJECT_NOTIFICATION = NSNotification.Name("RideRejectNotification")
    public static let CAR_SELECTED_NOTIFICATION = NSNotification.Name("CarSelectedNotification")
    public static let ADDED_EMERGENCY_CONTACT_NOTIFICATION = NSNotification.Name("AddedEmergrncyContactNotification")

    public static let FORGET_PASSWORD_NOTIFICATION = NSNotification.Name("ForgetPasswordNitofication")

    public static let USER_LOGIN_NOTIFICATION = NSNotification.Name("UserLoginNitofication")
    public static let PAYMENT_RIDE_NOTIFICATION = NSNotification.Name("PaymentRideNitofication")



}

extension Notification.Name {
    public static let nextManualTest = Notification.Name("nextManualTest")
    public static let nextAutometicTest = Notification.Name("nextAutometicTest")
    public static let quickTest = Notification.Name("quickTest")
    public static let fullTest = Notification.Name("fullTest")
}


let kNotificationType = "notification_type"
let kRideRequestNotification = "ride_request"
let kRideCancelledNotification = "cancel_ride"
let kPaymentRideNotification = "payment_for_ride"


/*========== SOME GLOBAL VARIABLE FOR USERS ==============*/


let kUserName = "user_name"
let kFCMToken = "FCMToken"

let appID = ""


let kIsLoggedIN = "is_logged_in"
let kUserEmail = "user_email"
let kPassword = "password"
let kDeviceToken = "DeviceToken"
let kAppToken = "App-Token"
let kUser = "user_id"
let kCurrentDashboard = "currentDashboard"

/*============= Error Code ===================*/

enum ErrorCode:Int{
    case success
    case failure
    case forceUpdate
    case sessionExpire

    init(rawValue:Int) {
        if rawValue == 102{
            self = .forceUpdate
        }else if rawValue == 345{
            self = .sessionExpire
        }else if ((rawValue >= 200) && (rawValue < 300)){
            self = .success
        }else{
            self = .failure
        }
    }
}

/*================== API URLs ====================================*/
let BASE_URL = "http://designoweb.work/teksmart/Api/"

let SIGN_UP_URL = "\(BASE_URL)login_register"
let SIGN_IN_URL = "\(BASE_URL)login"
let FORGOT_PASSWORD_URL = "\(BASE_URL)forgot_password"
let CHANGED_PASSWORD_URL = "\(BASE_URL)change_password"
let EDIT_PROFILE_URL = "\(BASE_URL)edit_profile"
let SITE_SETTING = "\(BASE_URL)siteSettings"
let FAQ = "\(BASE_URL)faq"
let GET_NOTIFICATION_LIST = "\(BASE_URL)getNotificationList"
let WARRANTY = "\(BASE_URL)warranty"
let USER_DEVICE = "\(BASE_URL)userDevice"
let COSMATIC_TEST = "\(BASE_URL)cosmeticTesting"
let RESULT = "\(BASE_URL)result"
let SELLME = "\(BASE_URL)sellMe"
let OTP = "\(BASE_URL)otpVerification"
let MANNUAL_TOUCH_SCREEN = "\(BASE_URL)manualTouchScreen"
let AUTOMATIC_TESTING_BATTARY = "\(BASE_URL)automaticBattery"
let OUT_OF_WARRENTY = "\(BASE_URL)outOfWarranty"
let CLAIM = "\(BASE_URL)claim"
let QUICK_TESTING = "\(BASE_URL)quickTesting"
let QUICK_TOUCH_SCREEN = "\(BASE_URL)quickTouchscreen"
let AUTOMATIC_TESTING = "\(BASE_URL)automaticTesting"
let TEST_STATUS = "\(BASE_URL)testStatus"
let MANNUAL_TESTING = "\(BASE_URL)manualTesting"
let QUICK_TEST = "\(BASE_URL)quickTestStatus"
let POSTAGE = "\(BASE_URL)postage"
let TEST_HISTORY = "\(BASE_URL)testHistory"
let PHONE_LIST_BY_USERID = "\(BASE_URL)phoneListByUserId"
let DISPATCHED_LIST = "\(BASE_URL)dispatchedList"
let SEND_PHONE = "\(BASE_URL)sendPhone"
let BANK_DETAIL = "\(BASE_URL)bankDetails"
let RESET_PASSWORD = "\(BASE_URL)do_reset_passowrd"


enum api: String {
    case base
    case signup
    case login
    case forgotPassword
    case change_password
    case edit_profile
    case siteSetting
    case faq
    case notificationList
    case warranty
    case userDevice
    case cosmaticTest
    case result
    case sellMe
    case otp
    case mannualTouchScreen
    case automaticTestBattry
    case outOfWarranty
    case claim
    case quickTesting
    case quickTouchScreen
    case automaticTesting
    case testStatus
    case mannualTesting
    case quickTestingStatus
    case postage
    case testHistory
    case phoneListByUserid
    case dispatchedList
    case sendPhone
    case bankDetail
    case resetPassword
    

    func url() -> String {
        switch self {
        case.base : return BASE_URL
        case.signup: return SIGN_UP_URL
        case.login: return SIGN_IN_URL
        case.forgotPassword:return FORGOT_PASSWORD_URL
        case.change_password:return CHANGED_PASSWORD_URL
        case.edit_profile:return EDIT_PROFILE_URL
        case.siteSetting: return"\(BASE_URL)siteSettings"
        case.faq : return  "\(BASE_URL)faq"
        case.notificationList: return "\(BASE_URL)getNotificationList"
        case.warranty : return "\(BASE_URL)warranty"
        case.userDevice : return "\(BASE_URL)userDevice"
        case.cosmaticTest : return "\(BASE_URL)cosmeticTesting"
        case.result : return "\(BASE_URL)result"
        case.sellMe : return "\(BASE_URL)sellMe"
        case.otp : return "\(BASE_URL)otpVerification"
        case.mannualTouchScreen: return  "\(BASE_URL)manualTouchScreen"
        case.automaticTestBattry : return "\(BASE_URL)automaticBattery"
        case.outOfWarranty : return "\(BASE_URL)outOfWarranty"
        case.claim : return "\(BASE_URL)claim"
        case.quickTesting: return "\(BASE_URL)quickTesting"
        case.quickTouchScreen : return "\(BASE_URL)quickTouchscreen"
        case.automaticTesting: return "\(BASE_URL)automaticTesting"
        case.testStatus: return "\(BASE_URL)testStatus"
        case.mannualTesting : return "\(BASE_URL)manualTesting"
        case.quickTestingStatus : return "\(BASE_URL)quickTestStatus"
        case.postage : return "\(BASE_URL)postage"
        case.testHistory : return "\(BASE_URL)testHistory"
        case.phoneListByUserid: return  "\(BASE_URL)phoneListByUserId"
        case.dispatchedList: return "\(BASE_URL)dispatchedList"
        case.sendPhone : return "\(BASE_URL)sendPhone"
        case.bankDetail : return "\(BASE_URL)bankDetails"
        case.resetPassword : return"\(BASE_URL)do_reset_passowrd"
            
        }
    }
}


/*================== SOCIAL LOGIN TYPE ====================================*/
enum SocialLoginType: String {
    case facebook = "facebook"
    case google = "google"
}

/*======================== CONSTANT MESSAGES ==================================*/

let NETWORK_NOT_CONNECTED_MESSAGE = "Network is not connected!"
let FUNCTIONALITY_PENDING_MESSAGE = "Under Development. Please ignore it!"
let ALERT_TITTLE_MESSAGE = "Important Message"


/*============== SOCIAL MEDIA URL SCHEMES ==================*/

//let SELF_URL_SCHEME = "com.designOweb.Fitizen"

/*============== PRINTING IN DEBUG MODE ==================*/

func print_debug <T>(_ object : T){
    print(object)
}

func print_log <T>(_ object : T){
//    NSLog("\(object)")
}





/*============== SHOW MESSAGE ==================*/


func showSuccessWithMessage(_ message: String)
{
    JDStatusBarNotification.show(withStatus: message, dismissAfter: warningMessageShowingDuration, styleName: JDStatusBarStyleSuccess)

    // TSMessage.showNotification(withTitle: message, type: TSMessageNotificationType.success)
}
func showErrorWithMessage(_ message: String)
{
    JDStatusBarNotification.show(withStatus: message, dismissAfter: warningMessageShowingDuration, styleName: JDStatusBarStyleError)
    //TSMessage.showNotification(withTitle: message, type: TSMessageNotificationType.error)
}
func showWarningWithMessage(_ message: String)
{
   // JDStatusBarNotification.show(withStatus: message, dismissAfter: warningMessageShowingDuration, styleName: JDStatusBarStyleWarning)
    TSMessage.showNotification(withTitle: message, type: TSMessageNotificationType.warning)
}
func showMessage(_ message: String)
{
   // JDStatusBarNotification.show(withStatus: message, dismissAfter: warningMessageShowingDuration, styleName: JDStatusBarStyleDefault)
    TSMessage.showNotification(withTitle: message, type: TSMessageNotificationType.message)
}


func showAlertWith(_ viewController: UIViewController,message:String,title:String){
    let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
    let okayAction = UIAlertAction(title: "Okay", style: .default) { (action) in
        alert.dismiss(animated: true, completion: nil)
    }
    alert.addAction(okayAction)
    viewController.present(alert, animated: true, completion: nil)
}

func showAlertWith(viewController: UIViewController?,message:String,title:String, complitionBlock : ((_ done: Bool) ->Void)? = nil){
    let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
    
    let okayAction = UIAlertAction(title: "Okay", style: .cancel) { (action) in
        guard let handler = complitionBlock else{
            alert.dismiss(animated: false, completion: nil)
            return
        }
        handler(true)
        alert.dismiss(animated: false, completion: nil)
    }
    alert.addAction(okayAction)
    var vc: UIViewController
    if let pvc = viewController{
        vc = pvc
    }else{
        vc = ((UIApplication.shared.delegate as! AppDelegate).window?.rootViewController)!
    }
    vc.present(alert, animated: true, completion: nil)
}



@objc protocol DataToPreviousController {
    @objc optional func locationName(name: String, locationID: String)
    @objc optional func pdfSelected()
    @objc optional func pdfNotSelected()
}





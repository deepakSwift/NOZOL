//
//  NOZOL
//
//  Created by Mukul Sharma on 14/07/20.
//  Copyright © 2020 Mukul Sharma. All rights reserved.
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
var kDeviceToken = "DeviceToken"
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
//let BASE_URL = "http://designoweb.work/nozol/api/"
let BASE_URL = "https://nozol-hospitality.com/nozol/Api/"

let LOGIN = "\(BASE_URL)login"
let SIGN_UP = "\(BASE_URL)login_registration"
let FORGOT_PASSWORD = "\(BASE_URL)forgot_password"
let SET_TOKENID = "\(BASE_URL)setToken"
let CHNAGE_PASSWORD = "\(BASE_URL)changes_password"
let PROFILE_IMAGE = "\(BASE_URL)edit_profile"
let LOGOUT = "\(BASE_URL)logout"
let LOYALTY_AND_OFFERS = "\(BASE_URL)banner_image"
let PAID_AND_UNPAID = "\(BASE_URL)subcategory"


enum api: String {
    case base
    case login
    case signup
    case forgotPassword
    case setToken
    case changePassword
    case profileImage
    case logOut
    case loyalityAndOffers
    case paidAndUnpaid
    
    case subCategory
    case getServices
    case nozol_detail
    case addServices
    
    case userServiceDetails
    case chatInsert
    case reviews
    case hotelMap
    case getAllNotifications
    case roomDetails
    case checkIn
    case rescheduleBooking
    case checkcheckinformstatus
    case paymentoption
    case identification
    case socialLogin
    case updateToken
    case getuserdata

    func url() -> String {
        switch self {
        case.base : return BASE_URL
        case.login: return "\(BASE_URL)login"
        case.signup: return "\(BASE_URL)login_registration"
        case.forgotPassword: return "\(BASE_URL)forgot_password"
        case.setToken: return "\(BASE_URL)setToken"
        case.changePassword: return "\(BASE_URL)changes_password"
        case.profileImage : return "\(BASE_URL)edit_profile"
        case.logOut : return "\(BASE_URL)logout"
        case.loyalityAndOffers : return "\(BASE_URL)banner_image"
        case.paidAndUnpaid : return "\(BASE_URL)subcategory"
            
        case .subCategory : return "\(BASE_URL)subcategory_category"
        case .getServices : return "\(BASE_URL)getServices"
        case .nozol_detail: return "\(BASE_URL)nozol_detail"
        case .addServices: return "\(BASE_URL)addServices"
            
        case .userServiceDetails: return "\(BASE_URL)userServiceDetails"
        case .chatInsert: return "\(BASE_URL)chatInsert"
        case .reviews: return "\(BASE_URL)reviews"
        case .hotelMap: return "\(BASE_URL)hotelMap"
        case .getAllNotifications: return "\(BASE_URL)getAllNotifications"
        case .roomDetails: return "\(BASE_URL)roomDetails"
        case .checkIn: return "\(BASE_URL)checkIn"
        case .rescheduleBooking: return "\(BASE_URL)rescheduleBooking"
        case .checkcheckinformstatus: return "\(BASE_URL)checkcheckinformstatus"
        case .paymentoption: return "\(BASE_URL)paymentoption"
        case .identification: return "\(BASE_URL)identification"
        case .socialLogin: return "\(BASE_URL)socialLogin"
        case .updateToken: return "\(BASE_URL)updateToken"
        case .getuserdata: return "\(BASE_URL)getuserdata"
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




//------global variable

var roomNumber = ""

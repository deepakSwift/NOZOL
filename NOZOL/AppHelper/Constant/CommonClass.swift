//
//  ChangePasswordVC.swift
//  CellMe
//
//  Created by Sagar Gupta on 06/04/20.
//  Copyright © 2020 Sagar Gupta. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD
import SystemConfiguration


let loaderSize = CGSize(width: 120, height: 120)

let screenWidth = UIScreen.main.bounds.width
let imgV = UIImageView(frame: CGRect(x:0, y:-22,width:screenWidth, height:68))
var vSpinner : UIView?

enum ImageAction: String {
    case update = "update"
    case remove = "remove"
    case new = "new"
}

func generateBoundaryString() -> String {
    return "Boundary-\(UUID().uuidString)"

}

class CommonClass: NSObject {
    
    static let sharedInstance = CommonClass()
    override init() {
        super.init()
    }
    
    let colors: [UIColor] = [
        UIColor.red,
        UIColor.green,
        UIColor.blue,
        UIColor.orange,
        UIColor.yellow
    ]

    class func setLeftIconForTextField(_ textField:UITextField,leftIcon: UIImage){
        let leftImageView = UIImageView()
        leftImageView.image = leftIcon
        let imgFrame = textField.frame
        leftImageView.frame = CGRect(x: 15, y: 5, width: imgFrame.size.height-10, height:imgFrame.size.height-10)
        textField.leftView = leftImageView
        textField.leftViewMode = UITextField.ViewMode.always
    }
    
//   class func setPlaceHolder(_ textField: UITextField, placeHolderString placeHolder: String, withColor color: UIColor){
//        let p = NSAttributedString(string: placeHolder, attributes: [NSAttributedStringKey.foregroundColor : color])
//        textField.attributedPlaceholder = p;
//    }
    


    class func presentControllerWithShadow(_ viewController:UIViewController, overViewController presentingViewController: UIViewController,completion: (() -> Void)?){
        imgV.backgroundColor = UIColor.black
        imgV.alpha = 0.3
        presentingViewController.modalPresentationStyle = .custom
        presentingViewController.navigationController?.navigationBar.addSubview(imgV)
        presentingViewController.present(viewController, animated: true, completion: completion)
    }
    class func dismissWithShadow(_ viewController:UIViewController,completion: (() -> Void)?){
        imgV.removeFromSuperview()
        viewController.dismiss(animated: true, completion: completion)
    }

    class func makeViewCircular(_ view:UIView,borderColor:UIColor,borderWidth:CGFloat)
    {
        view.layer.borderColor = borderColor.cgColor
        view.layer.borderWidth = borderWidth
        view.layer.cornerRadius = view.frame.size.width/2
        view.layer.masksToBounds = true
    }
    class func makeViewCircularWithRespectToHeight(_ view:UIView,borderColor:UIColor,borderWidth:CGFloat)
    {
        view.layer.borderColor = borderColor.cgColor
        view.layer.borderWidth = borderWidth
        view.layer.cornerRadius = view.frame.size.height/2
        view.layer.masksToBounds = true
    }


    class func makeViewCircularWithCornerRadius(_ view:UIView,borderColor:UIColor,borderWidth:CGFloat, cornerRadius: CGFloat)
    {
        view.layer.borderColor = borderColor.cgColor
        view.layer.borderWidth = borderWidth
        view.layer.cornerRadius = cornerRadius
        view.layer.masksToBounds = true
    }


    class var isConnectedToNetwork: Bool {

    var zeroAddress = sockaddr_in()
    zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
    zeroAddress.sin_family = sa_family_t(AF_INET)

    guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
    $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
    SCNetworkReachabilityCreateWithAddress(nil, $0)
    }
    }) else {

    return false
    }

    var flags: SCNetworkReachabilityFlags = []
    if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
    return false
    }

    let isReachable = flags.contains(.reachable)
    let needsConnection = flags.contains(.connectionRequired)

    return (isReachable && !needsConnection)
    }

     var isLoggedIn: Bool{
        var result = false
        if let r = kUserDefaults.bool(forKey:kIsLoggedIN) as Bool?{
            result = r
        }
        return result//kUserDefaults.bool(forKey: kIsLoggedIN)
    }

    
    

    
        
    
    
     func setPlaceHolder(_ textField: UITextField, placeHolderString placeHolder: String, withColor color: UIColor){
        let p = NSAttributedString(string: placeHolder, attributes: [NSAttributedString.Key.foregroundColor : color])
        textField.attributedPlaceholder = p;
    }

    class var isRunningSimulator: Bool
        {
        get
        {
            return TARGET_OS_SIMULATOR != 0
        }
    }

    class func validateMaxLength(_ textField: UITextField, maxLength: Int, range: NSRange, replacementString string: String) -> Bool{
        let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        return newString.count <= maxLength
    }

    //MARK:- Loader display Methods
    class func showLoader()
    {
        SVProgressHUD.setMinimumSize(loaderSize)
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.setForegroundColor(.black)
        SVProgressHUD.show()
        
    }

    class var isLoaderOnScreen: Bool
    {
        return SVProgressHUD.isVisible()
    }
    class func showError(withStatus status: String)
    {
        SVProgressHUD.showError(withStatus: status)
    }
    class func showSuccess(withStatus status: String)
    {
        SVProgressHUD.showSuccess(withStatus: status)
    }


    class func showLoader(withStatus status: String)
    {
       
        SVProgressHUD.setMinimumSize(loaderSize)
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.setForegroundColor(.black)
        SVProgressHUD.show(withStatus: status)
    }
    class func updateLoader(withStatus status: String)
    {
        SVProgressHUD.setStatus(status)
        SVProgressHUD.setMinimumSize(loaderSize)

    }

    class func showLoader(withStatus status: String, inView view: UIView)
    {
        //SVProgressHUD.show(withStatus: status, on: view)
    }
    
    class func hideLoader()
    {
        SVProgressHUD.dismiss()
    }
    

    class func getETAFromDateString(_ dateString: String) -> String
    {
        var eta = ""
        let df  = DateFormatter()
        df.locale = Locale.current
        df.locale = Locale.autoupdatingCurrent
        df.timeZone = TimeZone.autoupdatingCurrent
        df.dateFormat = "YYYY-MM-dd"
        let date = df.date(from: dateString)!
        df.dateFormat = "EEEE"
        let etaDay = df.string(from: date);
        df.dateFormat = "MM-dd-YY"
        let etaDate = df.string(from: date);
        eta = "ETA \(etaDay), \(etaDate)"
        return eta
    }


    class func getDayAndDateFromDateString(_ dateString: String) -> String
    {
        var eta = ""
        let df  = DateFormatter()
        df.locale = Locale.current
        df.timeZone = TimeZone.current
        df.dateFormat = "YYYY-MM-dd"
        let date = df.date(from: dateString)!
        df.dateFormat = "EEEE"
        let etaDay = df.string(from: date);
        df.dateFormat = "MM-dd-YY"
        let etaDate = df.string(from: date);
        eta = "ETA \(etaDay), \(etaDate)"
        return eta
    }

    class func dateWithString(_ dateString: String) -> String {

        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.locale = Locale.autoupdatingCurrent
        dayTimePeriodFormatter.timeZone = TimeZone.autoupdatingCurrent

        dayTimePeriodFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
        let dfs = dateString.replacingOccurrences(of: "T", with: " ")
        let dArray  = dfs.components(separatedBy: ".")
        let sourceTimeZone = TimeZone(abbreviation: "GMT")
        let myTimeZone = TimeZone.current

        if dArray.count>0{
            if let d = dayTimePeriodFormatter.date(from: dArray[0]) as Date?{
                dayTimePeriodFormatter.dateFormat = "hh:mm a, dd-MMM-YYYY"
                //let date = dayTimePeriodFormatter.string(from: d)
                let sourceGMTOffset = sourceTimeZone?.secondsFromGMT(for: d)
                let destinationGMTOffset = myTimeZone.secondsFromGMT(for: d)
                let interval = destinationGMTOffset - sourceGMTOffset!
                let destinationDate = Date(timeInterval: TimeInterval(interval), since: d)
                dayTimePeriodFormatter.dateFormat = "EEE, MMM dd, h:mm a"
                dayTimePeriodFormatter.timeZone = myTimeZone
                let formattedDate = dayTimePeriodFormatter.string(from: destinationDate)
                return formattedDate//date
            }
        }
        return " "
    }

    class func formattedDateWithString(_ dateString: String,format :String) -> String {
        //"dd-MMM-YYYY, hh:mm a"
        //"EEEE dd-MMM-YYYY h:mm a"
        //"hh:mm a, dd-MMM-YYYY"
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.locale = Locale.autoupdatingCurrent
        dayTimePeriodFormatter.timeZone = TimeZone.autoupdatingCurrent

        dayTimePeriodFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
        let dfs = dateString.replacingOccurrences(of: "T", with: " ")
        let dArray  = dfs.components(separatedBy: ".")
        let sourceTimeZone = TimeZone(abbreviation: "GMT")
        let myTimeZone = TimeZone.current

        if dArray.count>0{
            if let d = dayTimePeriodFormatter.date(from: dArray[0]) as Date?{
                dayTimePeriodFormatter.dateFormat = "hh:mm a, dd-MMM-YYYY"
                let sourceGMTOffset = sourceTimeZone?.secondsFromGMT(for: d)
                let destinationGMTOffset = myTimeZone.secondsFromGMT(for: d)
                let interval = destinationGMTOffset - sourceGMTOffset!
                let destinationDate = Date(timeInterval: TimeInterval(interval), since: d)
                dayTimePeriodFormatter.dateFormat = format
                dayTimePeriodFormatter.timeZone = myTimeZone
                let formattedDate = dayTimePeriodFormatter.string(from: destinationDate)
                return formattedDate//date
            }
        }
        return " "
    }
    
    class func formattedCompletedTaskDateWithString(_ dateStr: String,timeStr:String) -> String {
        //"dd-MMM-YYYY, hh:mm a"
        //"EEEE dd-MMM-YYYY h:mm a"
        //"hh:mm a, dd-MMM-YYYY"

        let dateString = "\(dateStr)T\(timeStr):00.000Z"

        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.locale = Locale.autoupdatingCurrent
        dayTimePeriodFormatter.timeZone = TimeZone.autoupdatingCurrent

        dayTimePeriodFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
        let dfs = dateString.replacingOccurrences(of: "T", with: " ")
        let dArray  = dfs.components(separatedBy: ".")
        let sourceTimeZone = TimeZone(abbreviation: "GMT")
        let myTimeZone = TimeZone.current

        if dArray.count>0{
            if let d = dayTimePeriodFormatter.date(from: dArray[0]) as Date?{
                dayTimePeriodFormatter.dateFormat = "hh:mm a, dd-MMM-YYYY"
                //let date = dayTimePeriodFormatter.string(from: d)
                let sourceGMTOffset = sourceTimeZone?.secondsFromGMT(for: d)
                let destinationGMTOffset = myTimeZone.secondsFromGMT(for: d)
                let interval = destinationGMTOffset - sourceGMTOffset!
                let destinationDate = Date(timeInterval: TimeInterval(interval), since: d)
                dayTimePeriodFormatter.dateFormat = "hh:mm a, dd MMM YYYY"
                dayTimePeriodFormatter.timeZone = myTimeZone
                let formattedDate = dayTimePeriodFormatter.string(from: destinationDate)
                return formattedDate//date
            }
        }
        return " "
    }


    class func formattedDateWith(_ date:Date,format: String) -> String {
        //"dd-MMM-YYYY, hh:mm a"
        //"EEEE dd-MMM-YYYY h:mm a"
        //"h:mm a, dd-MMM-YYYY"

        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.autoupdatingCurrent
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        //dateFormatter.defaultDate = date
//        let dStr = dateFormatter.string(from: date)
//        if let d = dateFormatter.date(from: dStr) as Date?{
            dateFormatter.dateFormat = format
            let da = dateFormatter.string(from: date)
            return da
        // }
        // return " "
    }



    class func formattedTimeFromDateWith(_ date:Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.autoupdatingCurrent
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        dateFormatter.defaultDate = date
        dateFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
        let da = "\(dateFormatter.string(from: date)) UTC"
        return da
    }

    class func formattedDateForSubmittionFromDateWith(_ date:Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.autoupdatingCurrent
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        dateFormatter.defaultDate = date
        dateFormatter.dateFormat = "dd-MM-YYYY"
        let da = dateFormatter.string(from: date)
        return da
    }



    class func getModifiedDateFromDateString(_ dateString: String) -> String
    {

        let df  = DateFormatter()
        df.locale = Locale.autoupdatingCurrent
        df.timeZone = TimeZone.autoupdatingCurrent
        df.dateFormat = "YYYY-MM-dd"
        let date = df.date(from: dateString)!
        df.dateFormat = "dd-MM-YY"
        return df.string(from: date);
    }
    
    class func getModifiedDateFromDateString(_ dateString: String,format:String) -> String
    {
        
        let df  = DateFormatter()
        df.locale = Locale.autoupdatingCurrent
        df.timeZone = TimeZone.autoupdatingCurrent
        df.dateFormat = "YYYY-MM-dd"
        let date = df.date(from: dateString)!
        df.dateFormat = format//"dd-MM-YY"
        return df.string(from: date);
    }
    
    class func getModifiedDateFromString(_ dateString: String,format:String) -> String
    {
        
        let df  = DateFormatter()
        df.dateFormat = "dd-MM-YYYY"
        df.dateStyle = .short
//        df.locale = Locale.autoupdatingCurrent
//        df.timeZone = TimeZone.autoupdatingCurrent
        
        if let date = df.date(from: dateString){
            df.defaultDate = date
            df.dateFormat = format
            return df.string(from: date);
        }else{
            return dateString
        }
        
    }


    //MARK:- Email Validation
    class func isValidEmailAddress(_ emailStr: String) -> Bool
    {
        if((emailStr.isEmpty) || emailStr.count == 0)
        {
            return false
        }
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@",emailRegex)
        if(emailPredicate.evaluate(with: emailStr)){
            return true
        }
        return false
    }
    class func validateUserName(_ username: String) -> Bool {

        let MINIMUM_LENGTH_LIMIT_USERNAME = 1
        let MAXIMUM_LENGTH_LIMIT_USERNAME = 20

        let nameRegex = "[a-zA-Z _.@ ]+$"
        let nameTest = NSPredicate(format: "SELF MATCHES %@", nameRegex)

        if username.count == 0
        {
            return false
        }

        else if username.count < MINIMUM_LENGTH_LIMIT_USERNAME
        {
            return false
        }

        else if username.count > MAXIMUM_LENGTH_LIMIT_USERNAME
        {
            return false
        }

        else if !nameTest.evaluate(with: username)
        {
            return false
        }

        else
        {
            return true
        }
    }

    //Password Validation
    class func validatePassword(_ password: String) -> Bool {

        let MINIMUM_LENGTH_LIMIT_PASSWORD = 6
        let MAXIMUM_LENGTH_LIMIT_PASSWORD = 20

        if password.count == 0
        {
            return false
        }

        else if password == " "
        {
            return false
        }

        else if password.count < MINIMUM_LENGTH_LIMIT_PASSWORD
        {
            return false
        }

        else if password.count > MAXIMUM_LENGTH_LIMIT_PASSWORD
        {
            return false
        }

        else
        {
            return true
        }
    }

    //Email Validation
    class func validateEmail(_ email : String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        if email.count == 0
        {
            return false
        }

        else if !emailTest.evaluate(with: email)
        {
            return false
        }

        else
        {
            return true
        }
    }
    
   class func validateUrl (urlString: String) -> Bool {
    let urlRegEx = "(http|https):((\\w)*|([0-9]*)|([-|_])*)+([\\.|]((\\w)*|([0-9]*)|([-|_])*))+"
        let urlTest = NSPredicate(format: "SELF MATCHES %@", urlRegEx).evaluate(with: urlString)
        return urlTest
    }


    class func matchConfirmPassword(_ password :String , confirmPassword : String)-> Bool{


        if password==confirmPassword {
            return true
        }
        else{
            return false
        }
    }
    class func validatePhoneNumber(_ phone : String) -> Bool {
        let PHONE_REGEX = "^\\d{10}"
        let PhoneTest = NSPredicate(format:"SELF MATCHES %@", PHONE_REGEX)
        if !PhoneTest.evaluate(with: phone){
            return false

        }
        else{
            return true
        }
    }

    class func classNameAsString(_ obj: Any) -> String {
        return String(describing: type(of: obj)).components(separatedBy:"__").last!
    }

    func openLocationSetting(){
        if #available(iOS 10.0, *) {
            if let url = URL(string: "App-Prefs:root=LOCATION_SERVICES") {
                UIApplication.shared.open(url, completionHandler: .none)
            }
        } else {
            if let url = URL(string: "prefs:root=LOCATION_SERVICES") {
//                if #available(iOS 10.0, *) {
//                    UIApplication.shared.open(url, completionHandler: .none)
//                } else {
                    if UIApplication.shared.canOpenURL(url){
                        UIApplication.shared.openURL(url)
                 //   }
                }
            }
        }
    }
    
    class func validatePhoneNumber(_ phone : String, number: Int) -> Bool {
        let PHONE_REGEX = "^\\d{\(number)}"
        let PhoneTest = NSPredicate(format:"SELF MATCHES %@", PHONE_REGEX)
        if !PhoneTest.evaluate(with: phone){
            return false
        }
        else{
            return true
        }
    }

 /*   func validate(value: String) -> Bool {
        let PHONE_REGEX = "^\\d{3}-\\d{3}-\\d{4}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: value)
        return result
    } */
    
    class func setupNoDataView(_ tableView:UITableView,message:String){
        let bgView = UIView()
        bgView.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        let noReviewLabel = UILabel()
        noReviewLabel.sizeToFit()
        bgView.addSubview(noReviewLabel)
        noReviewLabel.center = CGPoint(x:tableView.center.x, y:tableView.frame.size.height*1/2)
        noReviewLabel.textAlignment = NSTextAlignment.center
        noReviewLabel.text = message
        tableView.backgroundView = noReviewLabel
    }
    
    
    class func timeStringFromRideTime(seconds : Double) -> String {
        var timeStr = ""
        let secondsInAMinute : Int = 60
        let minutesInAnHour : Int = 60
        let secondsInAnHour : Int = 3600
        
        let secs = Int(seconds)
        if secs >= 3600{
            let hrs = Int(secs/secondsInAnHour)
            let remSec = secs%secondsInAnHour
            let mms = remSec%minutesInAnHour
            var hhStr = ""
            var mmStr = ""
            if hrs > 0{
                hhStr = "\(hrs) Hrs "
            }
            if mms > 0{
                mmStr = "\(mms) Min"
            }
            timeStr = hhStr+mmStr
        }else if secs >= 60{
            let mms = Int(secs/secondsInAMinute)
            let scs = secs%secondsInAMinute
            var mmStr = ""
            var scStr = ""
            if mms > 0{
                mmStr = "\(mms) Min "
            }
            if scs > 0{
                scStr = "\(scs) Sec"
            }
            timeStr = mmStr+scStr
        }else{
            timeStr = String(format: "%.0f Sec",seconds)
        }
        return timeStr
    }

    func addShadowWithView(view:UIView){
        //view.layer.cornerRadius = cornerRadius
        view.shadow = true
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.2
        view.layer.shadowRadius = 4.0
        
    }

   
    @available(iOS 13.0, *)
    class func showSpinner(onView : UIView) {
           let spinnerView = UIView.init(frame: onView.bounds)
     spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.0)
          let ai = UIActivityIndicatorView.init(style: .large)
           ai.startAnimating()
           ai.center = spinnerView.center
           
           DispatchQueue.main.async {
               spinnerView.addSubview(ai)
               onView.addSubview(spinnerView)
           }
           
          vSpinner = spinnerView
       }
     
    class func hideSpinner() {
         DispatchQueue.main.async {
             vSpinner?.removeFromSuperview()
             vSpinner = nil
         }
     }
     

    
}

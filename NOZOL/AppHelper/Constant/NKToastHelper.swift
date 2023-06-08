//
//  ChangePasswordVC.swift
//  CellMe
//
//  Created by Sagar Gupta on 06/04/20.
//  Copyright © 2020 Sagar Gupta. All rights reserved.
//

import UIKit
import Toast
/*============== SHOW MESSAGE ==================*/
enum ToastPosition {
    case top,center,bottom
}
enum warningMessage : String{
    case alertTitle = "Important Message"
    case enterPassword = "Please enter your password"
    case validPassword = "Please enter a valid password. Passwords should be 6-20 characters long."
    
    case enterOldPassword = "Please enter your current password"
    case validOldPassword = "Please enter a valid current password. Passwords should be 6-20 characters long."
    
    case enterNewPassword = "Please enter your new password"
    case validNewPassword = "Please enter a valid new password. Passwords should be 6-20 characters long."
    
    case validPhoneNumber = "Please enter a valid phone number"
    case validName = "Please enter a valid name"
    case validEmailAddress = "Please enter a valid email address"
    case emailCanNotBeEmpty = "Please enter your email address"
    case restYourPassword = "An email was sent to you to rest your password"
    case changePassword = "Your password has been changed successfully"
    case logoutMsg = "You've been logged out successfully."
    case networkIsNotConnected = "Network is not connected!"
    case functionalityPending = "Under development. Please ignore it"
    case confirmPassword = "Please confirm your password"
    case passwordDidNotMatch = "Please enter matching passwords"
    
    case cardDeclined = "The card was declined. Please reenter the payment details"
    case enterCVV = "Please enter the CVV"
    case enterValidCVV = "Please enter a valid CVV"
    case cardHolderName = "Please enter the card holder's name"
    case expMonth = "Please enter the exp. month"
    case expYear = "Please enter the exp. year"
    case validExpMonth = "Please enter a valid exp. month"
    case validExpYear = "Please enter a valid exp. year"
    case validCardNumber = "Please enter a valid card number"
    case cardNumber = "Please enter the card number"
    case title = "CellMe"
    case updateVersion = "You are using a version of Carting Kidzs that\'s no longer supported. Please upgrade your app to the newest app version to use Carting Kidzs. Thanks!"
    case sessionExpired = "Your session has expired, Please login again"
    
}

class NKToastHelper {
    let duration : TimeInterval = 1.5
    static let sharedInstance = NKToastHelper()
    fileprivate init() {}

    func showToastWithViewController(_ viewController: UIViewController?,message: String, position:ToastPosition,completionBlock:@escaping () -> Void){
        var toastPosition : String!
        var toastShowingVC :UIViewController!

        if let vc = viewController{
            toastShowingVC = vc
        }else{
            toastShowingVC = (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController
        }
        switch position {
        case .top:
            toastPosition = CSToastPositionTop
        case .center :
            toastPosition = CSToastPositionCenter
        case .bottom:
            toastPosition = CSToastPositionBottom
        }
        toastShowingVC.view.makeToast(message, duration: duration, position: toastPosition)
        completionBlock()
    }

    func showSuccessAlert(_ viewController: UIViewController?, message: String,completionBlock :(() -> Void)? = nil){
        self.showAlertWithViewController(viewController, title: warningMessage.title, message: message) {
            completionBlock?()
        }
    }

    func showAlert(_ viewController: UIViewController?,title:warningMessage, message: String,completionBlock :(() -> Void)? = nil){
        self.showAlertWithViewController(viewController, title: title, message: message) {
            completionBlock?()
        }
    }

    func showErrorAlert(_ viewController: UIViewController?, message: String, completionBlock :(() -> Void)? = nil){
        self.showAlertWithViewController(viewController, title: warningMessage.title, message: message) {
            completionBlock?()
        }
    }


    //complitionBlock : ((_ done: Bool) ->Void)? = nil
    private func showAlertWithViewController(_ viewController: UIViewController?, title: warningMessage, message: String,completionBlock :(() -> Void)? = nil){
        var toastShowingVC :UIViewController!

        if let vc = viewController{
            toastShowingVC = vc
        }else{
            toastShowingVC = (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController
        }
        let alert = UIAlertController(title: title.rawValue, message: message, preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "Okay", style: .cancel) { (action) in
            guard let handler = completionBlock else{
                alert.dismiss(animated: false, completion: nil)
                return
            }
            handler()
            alert.dismiss(animated: false, completion: nil)
        }
        alert.addAction(okayAction)
        toastShowingVC.present(alert, animated: true, completion: nil)
    }



    func showErrorToast(message:String,completionBlock:@escaping () -> Void){

    }

}



extension UIViewController {

func showToast(message : String, font: UIFont) {

    let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: 150, height: 35))
    toastLabel.backgroundColor = UIColor.red.withAlphaComponent(1.0)
    toastLabel.textColor = UIColor.white
    toastLabel.font = font
    toastLabel.textAlignment = .center;
    toastLabel.text = message
    toastLabel.alpha = 1.0
    toastLabel.layer.cornerRadius = 10;
    toastLabel.clipsToBounds  =  true
    self.view.addSubview(toastLabel)
    UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
         toastLabel.alpha = 0.0
    }, completion: {(isCompleted) in
        toastLabel.removeFromSuperview()
    })
}
    
    func showGreenToast(message : String, font: UIFont) {
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: 150, height: 35))
        toastLabel.backgroundColor = UIColor.green.withAlphaComponent(1.0)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
             toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
}

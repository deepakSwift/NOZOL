//
//  LoginViewController.swift
//  NOZOL
//
//  Created by Mukul Sharma on 14/07/20.
//  Copyright © 2020 Mukul Sharma. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import GoogleSignIn
import FBSDKCoreKit
import FBSDKLoginKit
import AuthenticationServices
import KeychainSwift

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField : SkyFloatingLabelTextField!
    @IBOutlet weak var passwordTextField : SkyFloatingLabelTextField!
    @IBOutlet weak var appleLoginBtn : UIButton!
    @IBOutlet weak var facebookLoginBtn : UIButton!
    
    var window : UIWindow?
    
    var userData = User()
    var getUserName = ""
    var getUserEmail = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIView.appearance().semanticContentAttribute = .forceLeftToRight
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.restorePreviousSignIn()
        appleLoginBtn.addTarget(self, action: #selector(handleLogInWithAppleIDButtonPress), for: .touchUpInside)
        facebookLoginBtn.addTarget(self, action: #selector(FacebookLoginBtnTapped), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        emailTextField.text = ""
        passwordTextField.text = ""
    }
    
    @IBAction func onClickSignupButton(_ sender : UIButton){
        let sinupVC = AppStoryboard.Main.viewController(SignupViewController.self)
        self.navigationController?.pushViewController(sinupVC, animated: true)
    }
    
    @IBAction func onClickGoogleButton(_ sender : UIButton){
        GIDSignIn.sharedInstance()?.signIn()
        GIDSignIn.sharedInstance()?.delegate = self
    }
    
    @IBAction func onClickForgotButton(_ sender : UIButton){
        let sinupVC = AppStoryboard.Main.viewController(ForgotPasswordViewController.self)
        self.navigationController?.pushViewController(sinupVC, animated: true)
    }
    
    
    @IBAction func onClickSigninButton(_ sender : UIButton){
        guard let email = emailTextField.text, email != "" else {
            NKToastHelper.sharedInstance.showErrorAlert(self, message: "Please enter email ID.")
            return
        }
        
        if !CommonClass.validateEmail(email) {
            NKToastHelper.sharedInstance.showErrorAlert(self, message: "Please enter valid email.")
            return
        }
        
        guard let password = passwordTextField.text, password != "" else {
            NKToastHelper.sharedInstance.showErrorAlert(self, message: "Please enter password.")
            return
        }
        
        if password.count < 6{
            NKToastHelper.sharedInstance.showErrorAlert(self, message: "Password must be of 6 digits.")
            return
        }
        
        loginUser(email: email, password: password, tokenID: kDeviceToken)
    }
    
    
    
    //--------login------
    func loginUser(email: String, password: String,tokenID : String) {
        CommonClass.showLoader(withStatus: "Login...")
        Webservice.shared.login(email: email, password: password, tokenId: tokenID) { (result, message, data) in
            CommonClass.hideLoader()
            if result == 1 {
                if let data = data {
                  self.userData = data
                    UserDefaults.standard.setValue(self.userData.id, forKey: "checkInId")
                    UserDefaults.standard.set("en", forKey: "language")
                }
                
                let storyBoard = AppStoryboard.Home.instance
                let navigationController = storyBoard.instantiateViewController(withIdentifier: "TabBarNavigationController") as! UINavigationController
                self.window?.rootViewController = navigationController
                (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController = navigationController
            } else {
                NKToastHelper.sharedInstance.showAlert(self, title: .title, message: message)
            }
        }
    }
    
    //----_Social login
    func socialUseroginUser(email: String, source: String,tokenId : String,name : String) {
        CommonClass.showLoader()
        Webservice.shared.socialLogin(email: email, name: name, tokenId: tokenId, source: source) { (result, message, data) in
            CommonClass.hideLoader()
            if result == 1 {
                if let data = data {
                  self.userData = data
                    UserDefaults.standard.setValue(self.userData.id, forKey: "checkInId")
                }
               
                UserDefaults.standard.set("true", forKey: "isLoginWithSocial")
                UserDefaults.standard.set("en", forKey: "language")
                let storyBoard = AppStoryboard.Home.instance
                let navigationController = storyBoard.instantiateViewController(withIdentifier: "TabBarNavigationController") as! UINavigationController
                self.window?.rootViewController = navigationController
                (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController = navigationController
            } else {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignUpSocialLoginVC") as! SignUpSocialLoginVC
                UserDefaults.standard.set("en", forKey: "language")
                vc.userEmail = self.getUserEmail
                vc.userName = self.getUserName
                self.navigationController?.pushViewController(vc, animated: true)
                //logic going here........
                //NKToastHelper.sharedInstance.showAlert(self, title: .title, message: message)
            }
        }
    }
}


//-----Google Login
extension LoginViewController: GIDSignInDelegate {
    
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        if let error = error {
            if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
                print("The user has not signed in before or they have since signed out.")
            } else {
                print("\(error.localizedDescription)")
            }
            return
        }
        
        if let user = user {
            print("userId:\(user.userID ?? "")")
            print("idToken:\(user.authentication.idToken ?? "")")
            print("fullName:\(user.profile.name ?? "")")
            print("givenName:\(user.profile.givenName ?? "")")
            print("familyName:\(user.profile.familyName ?? "")")
            print("email:\(user.profile.email ?? "")")
            let url = user.profile.imageURL(withDimension: UInt(200))
            print("ImageUrl: \(url)")
            
            self.getUserEmail = user.profile.email ?? ""
            self.getUserName = user.profile.name ?? ""
            self.socialUseroginUser(email: user.profile.email ?? "", source: "Google", tokenId: kDeviceToken, name: user.profile.name ?? "")
        
        }
    }
    
}

//-----facebook Login
extension LoginViewController {
    
    @objc func FacebookLoginBtnTapped(){
        
        let loginManager = LoginManager()
        loginManager.logIn(permissions: ["public_profile", "email"], from: self) { (result, error) in
            
            if let error = error {
                print("Failed to login: \(error.localizedDescription)")
                return
            }
            
            guard let accessToken = AccessToken.current else {
                print("Failed to get access token")
                return
            }
            
            if let result = result, result.isCancelled == true {
                print("--------------------------------------------------------------------------------")
                return
            }
            
            // get user info and image from facebook login
            let r = GraphRequest(graphPath: "me", parameters: ["fields":"email,name"], tokenString: AccessToken.current?.tokenString, version: nil, httpMethod: HTTPMethod(rawValue: "GET"))
            
            r.start(completionHandler: { (test, result, error) in
                if(error == nil) {
                    guard let field = result! as? [String:Any], let userID = field["id"] as? NSString, let userName = field["name"] as? String, let userEmail = field["email"] as? String else {
                        return
                    }
                    let facebookProfileUrl = "http://graph.facebook.com/\(userID)/picture?type=large"
                    let url = URL(string: facebookProfileUrl)
                    let data = NSData(contentsOf: url!)
                    let image = UIImage(data: data! as Data)
//                    self.profileImage.image = image
                    
                    self.getUserEmail = userEmail
                    self.getUserName = userName
                    print("UserName====================\(userName)")
                    print("UserEmail====================\(userEmail)")
                    
                    
                    self.socialUseroginUser(email: userName, source: "Facebook", tokenId: kDeviceToken, name: userEmail)
                    
                    
                } else {
                    print(error?.localizedDescription)
                }
            })
            
            
        }
    }
    
    
}


//-----Apple Login---------
extension LoginViewController : ASAuthorizationControllerDelegate,ASAuthorizationControllerPresentationContextProviding {
    
    @objc private func handleLogInWithAppleIDButtonPress() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
        
    }
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
    
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        
        print(error.localizedDescription)
        
    }
    
    // ASAuthorizationControllerDelegate function for successful authorization
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            
            
            let appleId = appleIDCredential.user
            
            if let appleUserFirstName = appleIDCredential.fullName?.givenName, let appleUserLastName = appleIDCredential.fullName?.familyName, let appleUserEmail = appleIDCredential.email {
                
                
                let keychain = KeychainSwift()
                keychain.accessGroup = "DZY2G9354J.com.kasie.users"
                if let userName = keychain.get("userName"),
                    let email = keychain.get("email") {
                    print("=============user and email  =====\(userName), \(email)")
                   
                    self.getUserEmail = email
                    self.getUserName = userName
                    self.socialUseroginUser(email: userName, source: "Apple", tokenId: kDeviceToken, name: email)
                    
                }
                
            }else{
                let keychain = KeychainSwift()
                keychain.accessGroup = "DZY2G9354J.com.kasie.users"
                if let userName = keychain.get("userName"),
                    let email = keychain.get("email") {
                    print("=============user and email  =====\(userName), \(email)")
                    
                    self.getUserEmail = email
                    self.getUserName = userName
                     self.socialUseroginUser(email: userName, source: "Apple", tokenId: kDeviceToken, name: email)
                    
                }
            }
            
        }
        
    }
}

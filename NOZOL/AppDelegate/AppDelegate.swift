//
//  AppDelegate.swift
//  NOZOL
//
//  Created by Mukul Sharma on 14/07/20.
//  Copyright © 2020 Mukul Sharma. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import GoogleSignIn
import Firebase
import FirebaseMessaging
import FBSDKCoreKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate,MessagingDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        IQKeyboardManager.shared.enable = true
//        FirebaseApp.configure()
//        //self.registerForRemoteNotification()
//        application.registerForRemoteNotifications()
        
        
        
        FirebaseApp.configure()
        self.registerPush(forApp: application)
        Messaging.messaging().delegate = self
        self.registerForRemoteNotification()

        if #available(iOS 10.0, *) {
        // For iOS 10 display notification (sent via APNS)
        UNUserNotificationCenter.current().delegate = self
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
//        UNUserNotificationCenter.current().requestAuthorization(
//        options: authOptions,
//        completionHandler: {_,_ in , in })
        // For iOS 10 data message (sent via FCM

        } else {
        let settings: UIUserNotificationSettings =
        UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
        application.registerUserNotificationSettings(settings)
        }

        application.registerForRemoteNotifications()

        IQKeyboardManager.shared.enable = true

        if AppSettings.shared.isLoggedIn {
            let storyBoard = AppStoryboard.Home.instance
            let navigationController = storyBoard.instantiateViewController(withIdentifier: "TabBarNavigationController") as! UINavigationController
            self.window?.rootViewController = navigationController
            
        }else{
            let storyBoard = AppStoryboard.Main.instance
            let navigationController = storyBoard.instantiateViewController(withIdentifier: "GetStartNavigationController")
            self.window?.rootViewController = navigationController
        }
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)

        
        GIDSignIn.sharedInstance().clientID = "709774385813-cdkd3kn5mcvb71omb57033ptka5onfas.apps.googleusercontent.com"
        
        return true
    }
    
    // MARK:- Register Push
    private func registerPush(forApp application : UIApplication){
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options:[.alert, .sound]) { (granted, error) in
            
            if granted {
                DispatchQueue.main.async {
                    application.registerForRemoteNotifications()
                }
            }
        }
    }
    
    static func getAppDelegate()-> AppDelegate{
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return (GIDSignIn.sharedInstance()?.handle(url))!
        
        ApplicationDelegate.shared.application(
            app,
            open: url,
            sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
            annotation: options[UIApplication.OpenURLOptionsKey.annotation]
        )
    }
    
    
    //******************** NOTIFICATION HANDLING ******************************//
    
    
    func registerForRemoteNotification() {
        // For iOS 10 display notification (sent via APNS)
        UNUserNotificationCenter.current().delegate = self
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: {_,_ in
                DispatchQueue.main.async {
                    Messaging.messaging().delegate = self
                    UIApplication.shared.registerForRemoteNotifications()
                }
        })
    }
    
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("===============\(fcmToken)")
        //kUserDefaults.set(fcmToken, forKey: kDeviceToken)
         kDeviceToken = fcmToken
        
    }
    
    func application(_ application: UIApplication,didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        Messaging.messaging().apnsToken = deviceToken
        if let token = Messaging.messaging().fcmToken{
            kUserDefaults.set(token, forKey: kDeviceToken)
            print_debug("registered to firebase with token : \(Messaging.messaging().fcmToken ?? "--")")
            print("===================\(token)")
        }else{
            print_debug("already registered to firebase with token : \(kUserDefaults.value(forKey: kDeviceToken) ?? "--")")
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        if self.window?.rootViewController?.topViewController is NotificationViewController{
            completionHandler([])
        }
        if self.window?.rootViewController?.topViewController is NotificationViewController{
            completionHandler([])
        }
        if let userInfo = notification.request.content.userInfo as? Dictionary<String,AnyObject>{
            self.openNotification(userInfoDict: userInfo)
            completionHandler([.alert, .badge, .sound])
            
        }else{
            completionHandler([.alert, .badge, .sound])
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if let userInfoDict = response.notification.request.content.userInfo as? Dictionary<String,AnyObject>{
            print_debug("userInfo: \(userInfoDict)")
            self.openNotification(userInfoDict: userInfoDict)
            print("=========================\(userInfoDict)")
        }
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print_debug("userInfo: \(userInfo)")
        if let userDict = userInfo as? Dictionary<String,AnyObject>{
            self.openNotification(userInfoDict: userDict)
        }
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        print_debug("userInfo: \(userInfo)")
        if let userDict = userInfo as? Dictionary<String,AnyObject>{
            self.openNotification(userInfoDict: userDict)
        }
    }
    
    func openNotification(userInfoDict:Dictionary<String,AnyObject>){
        
        print_debug("userInfo: \(userInfoDict)")
        var userID = ""
        if let _userID = userInfoDict["id"] as? String{
            userID = _userID
        }else if let _userID = userInfoDict["id"] as? Int{
            userID = "\(_userID)"
        }
        if userID != ""{
            openNotificationDetails(userID : userID)
            
        }
        // }
        
    }
    
    
    func openNotificationDetails(userID : String){
        if (self.window?.rootViewController?.topViewController is NotificationViewController) {
            return
        }else{
            let detailVc = AppStoryboard.Main.viewController(NotificationViewController.self)
            // detailVc.userID = userID
            // detailVc.isFromTapNotification = true
            guard let navigationController = self.getWindowNavigation() else{return}
            navigationController.pushViewController(detailVc, animated: true)
        }
    }
    func getWindowNavigation()-> UINavigationController?{
        guard let window = self.window else {
            return nil
        }
        guard let nav = window.rootViewController as? UINavigationController else {
            return nil
        }
        return nav
    }
    
}








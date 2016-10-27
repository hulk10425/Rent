//
//  AppDelegate.swift
//  Rent
//
//  Created by apple on 2016/10/21.
//  Copyright © 2016年 Johnny Demo. All rights reserved.
//

import UIKit
import CoreData
import FirebaseMessaging
import FirebaseInstanceID
import FBSDKCoreKit
import FBSDKLoginKit
import FBSDKShareKit
import Fabric
import Crashlytics
import Firebase



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        registerForPushNotifications(application)
        FIRApp.configure()
    
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
       
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
        Fabric.with([Crashlytics.self])
//        
//        let notificationTypes: UIUserNotificationType = [.Alert, .Badge, .Sound]
//        let notificationSettings = UIUserNotificationSettings(forTypes: notificationTypes, categories: nil)
//        application.registerForRemoteNotifications()
//        application.registerUserNotificationSettings(notificationSettings)
//       
        NSNotificationCenter
            .defaultCenter()
            .addObserver(self, selector: #selector(AppDelegate.tokenRefreshNotificaiton),
                         name: kFIRInstanceIDTokenRefreshNotification, object: nil)

        
        return true
    }
   
//    func registerForPushNotifications(application: UIApplication) {
//        let notificationSettings = UIUserNotificationSettings(
//            forTypes: [.Badge, .Sound, .Alert], categories: nil)
//        application.registerUserNotificationSettings(notificationSettings)
//    }
    
    func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
        if notificationSettings.types != .None {
            application.registerForRemoteNotifications()
        }
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let tokenChars = UnsafePointer<CChar>(deviceToken.bytes)
        var tokenString = ""
        
        for i in 0..<deviceToken.length {
            tokenString += String(format: "%02.2hhx", arguments: [tokenChars[i]])
        }
        
        //Tricky line
        FIRInstanceID.instanceID().setAPNSToken(deviceToken, type: FIRInstanceIDAPNSTokenType.Unknown)
        print("Device Token:", tokenString)
    }
    func registerForPushNotifications(application: UIApplication) {
        let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
        application.registerUserNotificationSettings(settings)
        application.registerForRemoteNotifications()
    }
    
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject],
                     fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        print("===== didReceiveRemoteNotification ===== %@", userInfo)
    }
    
    
    func tokenRefreshNotificaiton(notification: NSNotification) {
        let refreshedToken = FIRInstanceID.instanceID().token()!
        print("InstanceID token: \(refreshedToken)")
        
        // Connect to FCM since connection may have failed when attempted before having a token.
        connectToFcm()
    }
    
    func connectToFcm() {
        FIRMessaging.messaging().connectWithCompletion { (error) in
            if (error != nil) {
                print("Unable to connect with FCM. \(error)")
            } else {
                print("Connected to FCM.")
            }
        }
    }
//    func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
//        if notificationSettings.types != .None {
//            application.registerForRemoteNotifications()
//        }
//    }
//    
//    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
//        let tokenChars = UnsafePointer<CChar>(deviceToken.bytes)
//        var tokenString = ""
//        
//        for i in 0..<deviceToken.length {
//            tokenString += String(format: "%02.2hhx", arguments: [tokenChars[i]])
//        }
//        FIRInstanceID.instanceID().setAPNSToken(deviceToken, type: .Sandbox)
//        //Tricky line
//        FIRInstanceID.instanceID().setAPNSToken(deviceToken, type: FIRInstanceIDAPNSTokenType.Unknown)
//        print("Device Token:", tokenString)
//    }
  
//    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
//        #if DEBUG
//            FIRInstanceID.instanceID().setAPNSToken(deviceToken, type: .Sandbox)
//        #else
//            FIRInstanceID.instanceID().setAPNSToken(deviceToken, type: .Prod)
//        #endif
//    }
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
          //換頁到TabController
    func login() {
        //          if FIRAuth.auth()?.currentUser != nil{
        // switch root view controllers
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let nav = storyboard.instantiateViewControllerWithIdentifier("TabBarController")
        
        self.window?.rootViewController = nav
        //presentViewController的view只會被覆蓋而不會被destory
        //        }
    }
    

//    
//       func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
//        
//        print("MseeageID: \(userInfo["gcm_message_id"]!)")
//        
//   
//        print(userInfo)
//    }

   
}


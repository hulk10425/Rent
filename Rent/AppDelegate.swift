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
        
        
        FIRApp.configure()
    
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
       
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default
        Fabric.with([Crashlytics.self])
        
        let notificationTypes: UIUserNotificationType = [.Alert, .Badge, .Sound]
        let notificationSettings = UIUserNotificationSettings(forTypes: notificationTypes, categories: nil)
        application.registerForRemoteNotifications()
        application.registerUserNotificationSettings(notificationSettings)
        
        connectToFcm()
        
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(tokenRefreshNotification(_:)),
            name: kFIRInstanceIDTokenRefreshNotification,
            object: nil)
        let refreshedToken = FIRInstanceID.instanceID().token()
        print("InstanceID token: \(refreshedToken)")

        return true
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        
        FIRInstanceID.instanceID().setAPNSToken(deviceToken, type: FIRInstanceIDAPNSTokenType.Sandbox)
    }

    func tokenRefreshNotification(notification: NSNotification) {
        // NOTE: It can be nil here
        let refreshedToken = FIRInstanceID.instanceID().token()
        print("InstanceID token: \(refreshedToken)")
        
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
    
    func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
        if notificationSettings.types != .None {
            application.registerForRemoteNotifications()
        }
    }
   
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
    
    func applicationDidBecomeActive(application: UIApplication) {
        application.applicationIconBadgeNumber = 0
        connectToFcm()
    }
    
       func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        
//        print("MseeageID: \(userInfo["gcm_message_id"]!)")
        
   
        print(userInfo)
    }

   
}


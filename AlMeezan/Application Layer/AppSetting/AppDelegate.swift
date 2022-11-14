//
//  AppDelegate.swift
//  AlMeezan
//
//  Created by Atta khan on 28/08/2019.
//  Copyright © 2019 Atta khan. All rights reserved.
//

import UIKit
import CoreData
import GoogleMaps
import IQKeyboardManagerSwift
import PKRevealController
import Firebase
import FBSDKCoreKit
import FirebaseCrashlytics


var environment: Environment = .development
//@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let gcmMessageIDKey = "gcm.message_id"
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    IQKeyboardManager.shared.enable = true
    UIApplication.shared.statusBarStyle = .lightContent
    if let url = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).last {
        print("Local Db url: \(url.absoluteString)")
    }
    setAnonymousUser()
    
    setUpRootViewController(2)
    
    
    #if DEVELOPMENT
    environment = .development
    #else
    environment = .production
    #endif
    
    
    for family in UIFont.familyNames.sorted() {
        let names = UIFont.fontNames(forFamilyName: family)
        print("Family: \(family) Font names: \(names)")
    }
    NotificationCenter.default.addObserver(self, selector: #selector(AppDelegate.applicationDidTimout(notification:)), name: .appTimeout, object: nil)
    application.statusBarStyle = .lightContent
    GMSServices.provideAPIKey("AIzaSyA1VuQ_JGQmpB3v3WTIjB8bBiJVBPn7gm0")
    
    //FirebaseApp.configure()
    // [START set_messaging_delegate]
    
    Messaging.messaging().delegate = self
    Messaging.messaging().subscribe(toTopic: "general_users") { error in
        //print("Subscribed to weather topic")
    }
    // [END set_messaging_delegate]
    if #available(iOS 10.0, *) {
    // For iOS 10 display notification (sent via APNS)
        UNUserNotificationCenter.current().delegate = self

        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
    application.registerForRemoteNotifications()
    

    return true
}
    
    func application( _ app: UIApplication,  open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:] ) -> Bool {

        ApplicationDelegate.shared.application(
            app,
            open: url,
            sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
            annotation: options[UIApplication.OpenURLOptionsKey.annotation]
        )

    }
    // The callback for when the timeout was fired.
    @objc func applicationDidTimout(notification: NSNotification) {
        print("application did timeout, perform actions")
        NotificationCenter.default.post(name: .sessionExpire, object: nil)
    }    // MARK: - Set Anonymous user credentials
    func setAnonymousUser() {
        Utility.shared.logout()
    }
    func setUpRootViewController(_ index: Int = 2) {
        window?.makeKeyAndVisible()
        window?.rootViewController = CustomTabBarViewController()
        let frontViewController: CustomTabBarViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CustomTabBarViewController") as! CustomTabBarViewController
        frontViewController.isFromSideMenu = false
        frontViewController.selectedTabindex = index
        let leftViewController: UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LeftSideMenuVC")
        let revealController: PKRevealController = PKRevealController(frontViewController: frontViewController, leftViewController: leftViewController)
        self.window?.rootViewController = revealController
        NotificationCenter.default.post(name: .tabBarSwitchNotifications, object: nil, userInfo: ["Index": index])
    }
    
    
    
    func applicationWillTerminate(_ application: UIApplication) {
        defaults.removeObject(forKey: OnlineOperationStatus.bank.rawValue)
        defaults.removeObject(forKey: OnlineOperationStatus.user.rawValue)
        setAnonymousUser()
    }
}
extension AppDelegate: UNUserNotificationCenterDelegate {

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
         Messaging.messaging().appDidReceiveMessage(userInfo)
        
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
         Messaging.messaging().appDidReceiveMessage(userInfo)
        
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
                    
        completionHandler(UIBackgroundFetchResult.newData)
    }
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        // Let FCM know about the message for analytics etc.
        Messaging.messaging().appDidReceiveMessage(userInfo)
        // handle your message
    }
    
    // application in foreground
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let content = notification.request.content
        // Process notification content
        print("\(content.userInfo)")
        //totalUnreadNotify = totalUnreadNotify + 1
        completionHandler([.alert, .sound]) // Display notification as
        
    }
    
    // tap on notification when app in background
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        // Print full message.
        print(userInfo)
        //totalUnreadNotify = totalUnreadNotify + 1
        if let destination = userInfo["Destination"] as? String {
            redirectScreen(destination, userInfo)
        }
        completionHandler()
    }

    func redirectScreen(_ type: String, _ userInfo: [AnyHashable : Any]) {
        print(Destination.fmr.rawValue)
        var title = ""
        var bodyDes = ""
        
        if let aps = userInfo["aps"] as? NSDictionary {
            if let alert = aps["alert"] as? NSDictionary {
                if let text = alert["title"] as? NSString {
                    title = text as String
                }
                if let message = alert["body"] as? NSString {
                    bodyDes = message as String
                }
            } else if let alert = aps["alert"] as? NSString {
                //Do stuff
            }
        }
        if type == Destination.nav.rawValue {
            setUpRootViewController(1)
        } else if type == Destination.blog.rawValue {
            NotificationCenter.default.post(name: .remoteNotification, object: nil, userInfo: ["type": "blog"])
        } else if type == Destination.fmr.rawValue {
            NotificationCenter.default.post(name: .remoteNotification, object: nil, userInfo: ["type": "FUND_REPORTS"])
        } else if type == Destination.mkt.rawValue {
            NotificationCenter.default.post(name: .homeViewControllerPopup, object: nil, userInfo: ["title": title, "des": bodyDes])
        } else if type == Destination.lead.rawValue {
            
        } else if type == Destination.investment.rawValue {
            
        } else if type == Destination.conversion.rawValue {
            
        } else if type == Destination.redemption.rawValue {
            
        } else if type == Destination.news.rawValue {
            NotificationCenter.default.post(name: .remoteNotification, object: nil, userInfo: ["type": "news"])
        } else if type == Destination.youtube.rawValue {
            NotificationCenter.default.post(name: .remoteNotification, object: nil, userInfo: ["type": "youtube"])
        } else if type == Destination.reg.rawValue {
            
        } else {
            
        }
    }
}
extension AppDelegate: MessagingDelegate {
    
    
    
    func application(application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        Messaging.messaging().apnsToken = deviceToken as Data
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        Messaging.messaging().token { (token, _) in
            print("Firebase registration token: \(fcmToken)")

        }

//
//        
//        
//        
//        InstanceID.instanceID().instanceID(handler: { (result, error) in
//            if let error = error {
//                print("Error fetching remote instange ID: \(error)")
//            } else if let result = result {
//                print("Remote instance ID token: \(result.token)")
//            }
//        })
        print("Firebase registration token: \(fcmToken)")
        let dataDict:[String: String] = ["token": fcmToken ?? ""]
        UserDefaults.standard.set(fcmToken, forKey: "device_id")
    }
    
}

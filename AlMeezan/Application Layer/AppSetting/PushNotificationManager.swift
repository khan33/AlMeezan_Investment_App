//
//  PushNotificationManager.swift
//  AlMeezan
//
//  Created by Atta khan on 23/01/2020.
//  Copyright © 2020 Atta khan. All rights reserved.
//
import UIKit
import Firebase
import FirebaseMessaging
import UserNotifications

class PushNotificationManager: NSObject , MessagingDelegate, UNUserNotificationCenterDelegate {
    let userID: String
    init(userID: String) {
        self.userID = userID
        super.init()
    }
    func registerForPushNotifications() {
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
            // For iOS 10 data message (sent via FCM)
            Messaging.messaging().delegate = self
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
        }
        UIApplication.shared.registerForRemoteNotifications()
        updateFirestorePushTokenIfNeeded()
    }
    func updateFirestorePushTokenIfNeeded() {
        if let token = Messaging.messaging().fcmToken {
//            let usersRef = Firestore.firestore().collection("users_table").document(userID)
//            usersRef.setData(["fcmToken": token], merge: true)
        }
    }
//    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
//        print(remoteMessage.appData)
//    }
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        updateFirestorePushTokenIfNeeded()
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print(response)
    }
// ya kia yakh ha yara marey pasy yahy setting ma araha ha yara
    // I think ap na jo firebase ma app bnai h wo abi sae config ni hoi ... ma ap ko daikta ho
    // ?? koi nae aa yar acha tu wo jaga par chala ja wo tick ajata ha ?okay
    
    // ab wo ge h iska matlb ka notification tu sahy ha setting ma han lakin marey pas direct tu ajata ha yara yahy code kar lya ma na be
    
}

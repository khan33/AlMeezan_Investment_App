//
//  Utility.swift
//  AlMeezan
//
//  Created by Atta khan on 13/11/2019.
//  Copyright © 2019 Atta khan. All rights reserved.
//

import Foundation
import UIKit
import PKRevealController
import Network
import Firebase
import SwiftKeychainWrapper
import AVFoundation
import FirebaseAnalytics

class Utility: NSObject {
    static let shared = Utility()
    
    var player: AVAudioPlayer?
    
    var rootViewContoller = UIApplication.shared.keyWindow?.rootViewController
    
    func goToHomeController(vc: UIViewController, navController: UINavigationController?) {
        let menuStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let menuVC = menuStoryboard.instantiateViewController(withIdentifier: "LeftSideMenuVC")
        let homeNavigation = UINavigationController(rootViewController: vc)
        let menuController = PKRevealController(frontViewController: homeNavigation, leftViewController: menuVC)
        menuController?.recognizesPanningOnFrontView = false
        UIApplication.shared.keyWindow?.rootViewController = menuController
        
    }
    
    func phoneCall() {
        let phoneNumber = "080042525" //"021 111 633 926
        if let phoneURL = NSURL(string: ("tel://" + phoneNumber)) {

            let alert = UIAlertController(title: ("Call now on our toll free number 0800-42525"), message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Call", style: .default, handler: { (action) in
                UIApplication.shared.open(phoneURL as URL, options: [:], completionHandler: nil)
            }))

            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            rootViewContoller?.present(alert, animated: true, completion: nil)
        }
    }
    
    func logout() {
        KeychainWrapper.standard.set("ibex", forKey: "CustomerId")
        KeychainWrapper.standard.set("_!b3xGl0b@L", forKey: "AccessToken")
        KeychainWrapper.standard.set("anonymous", forKey: "UserType")
        UserDefaults.standard.set(false, forKey: "isCorporateId")
        totalUnreadNotify = 0
        NotificationCenter.default.post(name: .logoutNotification, object: nil)
        //NotificationCenter.default.post(name: .leftMenuNotifications, object: nil)
        NotificationCenter.default.post(name: .tabBarSwitchNotifications, object: nil, userInfo: ["Index": 2])
    }
    
    
    func dateTimeConverstion(_ date: String, _ formate: String) -> String {
        var dateStr = ""
        if date.count == 19 {
               if let date = date.toDate(withFormat: "yyyy-MM-dd'T'HH:mm:ss") {
                   let currentDate = Date()
                    dateStr = date.toString(format: formate) //"EEE HH:mm a, MMM d YYYY"
                   
                   return dateStr
               }
            }
            else {
                if let date = date.toDate(withFormat: "yyyy-MM-dd'T'HH:mm:ss.SSS") {
                    let currentDate = Date()
                    dateStr = date.toString(format: formate) //"EEE HH:mm a, MMM d YYYY"
                    return dateStr
                }
            }
            return dateStr
    }
    
    
    
    func converTimeString(_ date: String) -> String {
        if date.count == 19 {
           if let date = date.toDate(withFormat: "yyyy-MM-dd'T'HH:mm:ss") {
               let currentDate = Date()
               var dateStr = ""
               print(Calendar.current.isDateInToday(date))
            
                dateStr = date.toString(format: "MMM d, YYYY HH:mm")
               
               return dateStr
           }
        }
        else {
            if let date = date.toDate(withFormat: "yyyy-MM-dd'T'HH:mm:ss.SSS") {
                let currentDate = Date()
                var dateStr = ""
                print(Calendar.current.isDateInToday(date))
                
                dateStr = date.toString(format: "MMM d, YYYY HH:mm")
                return dateStr
            }
        }
        return ""
    }
    
    func emptyTableViewForMW(_ tableView: UITableView) {
        tableView.separatorStyle = .none
        var emptyView = Bundle.main.loadNibNamed("EmptyView", owner: self, options: nil)?[0] as? EmptyView
        if let aView = emptyView {
            tableView.backgroundView = aView
        }
    }
    
    
    func emptyTableView(_ tableView: UITableView) {
        tableView.separatorStyle = .none
        var emptyScreenView = Bundle.main.loadNibNamed("EmptyListView", owner: self, options: nil)?[0] as? EmptyListView
        if let aView = emptyScreenView {
            tableView.backgroundView = aView
        }
    }
    func analyticsCode(_ name: String) {
        Analytics.logEvent("User_Event", parameters: [
        "event_name": name as NSObject  ])
    }

    func filterIdAscending() -> [CustomerInvestment]? {
        var list: [CustomerInvestment]?
        PersistenceServices.shared.fetch(CustomerInvestment.self) { [weak self] (data) in
            list = data
//            if list?.count ?? 0 > 0 {
//                list = list?.filter({
//                        if let str = $0.portfolioID?.components(separatedBy: "-").last, let num = Int(str) {
//                            return !(900...999).contains(num)
//                        }
//                    return true
//                })
//            }
        }
        
       list = list?.filter( {$0.portfolioID != Message.allPortfolio} )

        list = list?.sorted {
            if let id1 = $0.portfolioID, let id2 = $1.portfolioID {
               return id1.localizedStandardCompare(id2) == .orderedAscending
            }
            return true
        }
        return list
    }
    
    func formatPoints(num: Double) ->String {
        var thousandNum = num/1000
        var millionNum = num/1000000
        var billionNum = num/1000000000
        if num >= 1000 && num < 1000000{
//            if(floor(thousandNum) == thousandNum){
//                return("\(Int(thousandNum))k")
//            }
            return("\(thousandNum.roundToPlaces(places: 2))k")
        }
        if num > 1000000 && num <= 999999999 {
//            if(floor(millionNum) == millionNum){
//                return("\(Int(thousandNum))k")
//            }
            return ("\(millionNum.roundToPlaces(places: 2))M")
        }
        if num >= 999999999 {
            return ("\(billionNum.roundToPlaces(places: 2))B")
        }
        else{
//            if(floor(num) == num){
//                return ("\(Int(num))")
//            }
            return String(format: "%.2f", locale: Locale.current, num)
                
        }

    }
    
    func renderNotificationCount(_ btn: UIButton) {
        btn.isHidden = true
        btn.setTitleColor(UIColor.themeColor, for: .normal)
        btn.backgroundColor = UIColor.white
        btn.titleLabel?.font =  .systemFont(ofSize: 9)
        if totalUnreadNotify > 99 {
            btn.isHidden = false
            btn.titleLabel?.font =  .systemFont(ofSize: 8)
            btn.setTitle("99+", for: .normal)
        } else if totalUnreadNotify == 0 {
            btn.isHidden = false
            btn.setTitle("\(totalUnreadNotify)", for: .normal)
        }  else {
            btn.isHidden = false
            btn.setTitle("\(totalUnreadNotify)", for: .normal)
        }
    }
    
    
    func getUserdefaultValues<D: Codable>(_ key: String, modelType: D.Type, success: @escaping ( _ response: D) -> Void) {
        if let savedUserData = defaults.object(forKey: key) as? Data {
            let decoder = JSONDecoder()
            if let data = try? decoder.decode(D.self, from: savedUserData) {
                print("Saved user: \(data)")
                success(data)
            }
        }
    }
    
    func fetchAndSaveUserObject() {
        getUserdefaultValues(OnlineOperationStatus.user.rawValue, modelType: UserDetails.self) { (result) in
            let response = result
            let cnic = response.CNIC
            let email = response.email
            let mobile = response.mobileNO
            let name = response.name
            let fName = response.fName
            let occupation = response.occupation
            let income = response.income
            let otherSource = response.otherSource
            let cnicIssue = response.cnicIssue
            let cnicExpire = response.cnicExpire
            let age  = response.age
            let gender = response.gender
            let dob = response.dob
            
            let user    =   UserDetails(CNIC: cnic, email: email, mobileNO: mobile, name: name, fName: fName, occupation: occupation, income: income, otherSource: otherSource, cnicIssue: cnicIssue, cnicExpire: cnicExpire, age: age, gender: gender, dob: dob)
            let encoder = JSONEncoder()
            if let encodedUser = try? encoder.encode(user) {
                defaults.set(encodedUser, forKey: OnlineOperationStatus.user.rawValue)
            }
        }
    }
    
    func saveUserObject(_ user: UserDetails) {
//        let response = user
//        let cnic = response.CNIC
//        let email = response.email
//        let mobile = response.mobileNO
//        let name = response.name
//        let fName = response.fName
//        let occupation = response.occupation
//        let income = response.income
//        let otherSource = response.otherSource
//        let cnicIssue = response.cnicIssue
//        let cnicExpire = response.cnicExpire
//        let age  = response.age
//        let gender = response.gender
//        let dob = response.dob
//        
//        let user    =   UserDetails(CNIC: cnic, email: email, mobileNO: mobile, name: name, fName: fName, occupation: occupation, income: income, otherSource: otherSource, cnicIssue: cnicIssue, cnicExpire: cnicExpire, age: age, gender: gender, dob: dob)
        let encoder = JSONEncoder()
        if let encodedUser = try? encoder.encode(user) {
            defaults.set(encodedUser, forKey: OnlineOperationStatus.user.rawValue)
        }
    }
    func formatCurrencyInWords(string: String) -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .spellOut
        let num = string.integerValue ?? 0
        let resultStr = formatter.string(from: NSNumber(value: num))
        return resultStr?.capitalized
    }
    func playAudioSunod() {
        guard let url = Bundle.main.url(forResource: "bell", withExtension: "mp3") else { return }

            do {
                try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
                try AVAudioSession.sharedInstance().setActive(true)

                /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
                player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)

                /* iOS 10 and earlier require the following line:
                player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */

                guard let player = player else { return }

                player.play()

            } catch let error {
                print(error.localizedDescription)
            }
    }
    open func takeScreenshot(_ shouldSave: Bool = true) -> UIImage? {
        var screenshotImage :UIImage?
        let layer = UIApplication.shared.keyWindow!.layer
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, scale);
        guard let context = UIGraphicsGetCurrentContext() else {return nil}
        layer.render(in:context)
        screenshotImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        if let image = screenshotImage, shouldSave {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        }
        return screenshotImage
    }
    
    
    func googleAnalyticsEvent(_ itemId: Int, _ itemName: String, _ screenName: String, _ screenClass: String ) {
        let device_id = UserDefaults.standard.string(forKey: "device_id") ?? ""
        var guest_key = ""
        if let key = UserDefaults.standard.string(forKey: "guestkey") {
            guest_key = key
        }
        Analytics.logEvent(AnalyticsEventScreenView, parameters: [
            AnalyticsParameterItemID: itemId,
            AnalyticsParameterItemName: itemName,
            AnalyticsParameterScreenName: screenName,
            AnalyticsParameterScreenClass: screenClass,
            "NotificationGuestKey": guest_key,
            "DeviceID": device_id,
            "Platform": "iOS"
        ])
    }
}

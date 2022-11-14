//
//  ViewController.swift
//  AlMeezan
//
//  Created by Atta khan on 28/08/2019.
//  Copyright © 2019 Atta khan. All rights reserved.
//

import UIKit
import CryptoSwift
import PKRevealController
import Network
import SVProgressHUD
import SwiftKeychainWrapper
import FirebaseCrashlytics

class ViewController: BaseViewController {
    
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view3: UIView!
    @IBOutlet weak var view4: UIView!
    @IBOutlet weak var view5: UIView!
    @IBOutlet weak var view6: UIView!
    @IBOutlet weak var view7: GradientView!
    @IBOutlet weak var Invest_lbl: UILabel!
    @IBOutlet weak var investment_product_lbl: UILabel!
    @IBOutlet weak var marketWatchLbl: UILabel!
    @IBOutlet weak var investor_login_lbl: UILabel!
    @IBOutlet weak var investment_education_lbl: UILabel!
    @IBOutlet weak var fundPerformanceLbl: UILabel!
    @IBOutlet weak var countNotificationLbl: UIButton!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var blurView: UIView!
    @IBOutlet weak var notificationView: UIView!
    @IBOutlet weak var notification_title: UILabel!
    @IBOutlet weak var desc_lbl: UITextView!
    
    var notification_list: [NotificationList]?
    //var responseModel: [ResponseModel]?
    var errorResponse: [ErrorResponse]?
    var key_data : [GuestKeyModel]?
    let manager = Manager()
    let gradientLayer = CAGradientLayer()
    var isFromSideMenu: Bool = false
    var selectedMenuItem: Int = 0
    var timer: Timer?
    var tmpString = "PxehATu1nLbAY06eJVtM40jI7nBCD1c90fzr7EJecoyw5+fYrXjSp0MzCoJx2IwAhpM92f8OySQ1Afq044tkOBKMMcqXiijR2xVr3kW2ef4ylcGekSM1DpXj/4JSY9QUQIGsqFoZ2wUfnzlIDBQC9mqBXmMyzhXG0TGrzHepj/Bh5UQRX4yP8hJSzIh3TJVmtdYMIJ82N3SLFOU248bIndZ+kLk9/80CBSP50MuJueX1JQhMN5k0b+yf2qGKIVNu0YLdUgOOG6O5WhnKzhkk8vDL8DqPbf0tUx7Vn3U1ssvq3X49xMF/LmP6Kxr/fRxMlx0dSlUjb1844YRddaT/y5dpqnVoB1BV+S0DXbgQYaRMNtNKLjDN95yNWQiOZ1jxCngUCXJA4PuTn52hRJI+9msZgIn4harQYcjtTM4tg28="
    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        
        if isFromSideMenu {
            navigateToController(selectedMenuItem)
        }
        NotificationCenter.default.addObserver(self, selector: #selector(self.popupNotification), name: .homeViewControllerPopup, object: nil)

//        NotificationCenter.default.addObserver(self, selector: #selector(self.generateGuestKey), name: Notification.Name("FCMToken"), object: nil)
        countNotificationLbl.isHidden = true
        getNotificationData()
        notificationPopup(true)
        setupAppearance()
        fundPerformanceLbl.adjustsFontSizeForLbl()
        Invest_lbl.adjustsFontSizeForLbl()
        investment_product_lbl.adjustsFontSizeForLbl()
        marketWatchLbl.adjustsFontSizeForLbl()
        investor_login_lbl.adjustsFontSizeForLbl()
        investment_education_lbl.adjustsFontSizeForLbl()
        timer = Timer.scheduledTimer(timeInterval: 20, target: self, selector: #selector(generateGuestKey), userInfo: nil, repeats: false)
        fetchSecretKey()
        do {
            try aesDecrypt(key: "UsmanAlmeezan123", iv: "Hello World12345", tmpString)
        } catch let error {
            print(error)
        }
    }
    
    
    func aesDecrypt(key: String = "UsmanAlmeezan123" , iv: String = "Hello World12345", _ decrptyData: String) throws -> String {
        guard let data = Data(base64Encoded: decrptyData) else { return "" }
        let decrypted = try! AES(key: key, iv: iv, padding: .pkcs7).decrypt([UInt8](data))
        let decryptedData = Data(decrypted)
        let str = String(bytes: decryptedData.bytes, encoding: .utf8) ?? "Could not decrypt"
        return str
    }
    
    func aesEncrypt(key: String = "UsmanAlmeezan123", iv: String = "Hello World12345") throws -> String {
        let data: Data = tmpString.data(using: .utf8)!
        let encrypted = try AES(key: key, iv: iv, padding: .pkcs7).encrypt((data.bytes))
        let encData = Data(bytes: encrypted, count: encrypted.count)
        let base64str = encData.base64EncodedString(options: .init(rawValue: 0))
        let result = String(base64str)
        return result
    }
    
    func fetchSecretKey() {
        let apiKey = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String
        
        guard let key = apiKey, !key.isEmpty else { return }
        
        print("REST API KEY IS = ", key)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    @objc func generateGuestKey() {
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        if launchedBefore {
            print("Not first launch.")
            timer?.invalidate()
        }
        else {
            print("First launch")
            if let device_id = UserDefaults.standard.string(forKey: "device_id") {
                UserDefaults.standard.set(true, forKey: "launchedBefore")
                getGuestKey(device_id)
                timer?.invalidate()
            }
        }
    }
    private func estimatedFrameForTxt(text: String) -> CGRect {
        let size = CGSize(width: 250, height: 1000)
        let option = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: option, attributes: [ NSAttributedString.Key.font: UIFont(name: "CircularStd-Book", size: 12)], context: nil)
    }
    @objc func popupNotification(notification: NSNotification) {
        if let titleTxt = notification.userInfo?["title"] as? String {
            notification_title.text = titleTxt
        }
        
        if let bodyMsg = notification.userInfo?["des"] as? String {
            let TxtViewHeight = estimatedFrameForTxt(text: bodyMsg).height + 180
            if TxtViewHeight > SCREEN_HEGHT - 120 {
                desc_lbl.isScrollEnabled = true
                heightConstraint.constant = SCREEN_HEGHT - 120
            } else {
                heightConstraint.constant = TxtViewHeight
            }
            
            
            desc_lbl.text = bodyMsg
        }
        notificationPopup(false)
    }
    
    func getGuestKey(_ device_id: String) {

        let customerId = "ibex"
        let password = "_!b3xGl0b@L"
        let bodyParam = RequestBody(CustomerID: customerId, Password: password, DeviceID: device_id)
        let bodyRequest = bodyParam.encryptData(bodyParam)
        let url = URL(string: GUEST_KEY)!
        
        WebServiceManager.sharedInstance.fetch(params: bodyRequest as Dictionary<String, AnyObject>, url: url, serviceType: "Guest Key", modelType: GuestKeyModel.self, errorMessage: { (errorMessage) in
            self.errorResponse = errorMessage
            //self.showErrorMsg(errorMessage)
        }, success: { (response) in
            self.key_data = response
            if let key_id = self.key_data?[0].Key_id {
                Crashlytics.crashlytics().setUserID(key_id)
                UserDefaults.standard.set(key_id, forKey: "guestkey")
            }
            
        }, fail: { (error) in
            print(error.localizedDescription)
        }, showHUD: true)
    }
    
    func getNotificationData() {
        var guest_key = ""
        if let userAuth = KeychainWrapper.standard.string(forKey: "UserType") {
            if userAuth != "loggedInUser" {
                if let key = UserDefaults.standard.string(forKey: "guestkey") {
                    guest_key = key
                }
            }
        }
        let bodyParam = RequestBody(Key:guest_key)
        let bodyRequest = bodyParam.encryptData(bodyParam)
        let url = URL(string: NOTIFICATION_LIST)!
        SVProgressHUD.show()
        
        WebServiceManager.sharedInstance.fetch(params: bodyRequest as Dictionary<String, AnyObject>, url: url, serviceType: "Notification list", modelType: NotificationList.self, errorMessage: { (errorMessage) in
            self.errorResponse = errorMessage
            //self.showErrorMsg(errorMessage)
        }, success: { (response) in
            self.notification_list = response
            let filterList = self.notification_list?.filter( { $0.read == 0 } )
            totalUnreadNotify = filterList?.count ?? 0
            UserDefaults.standard.set(totalUnreadNotify, forKey: "totalNotification")
            Utility.shared.renderNotificationCount(self.countNotificationLbl)
        }, fail: { (error) in
            print(error.localizedDescription)
        }, showHUD: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideNavigationBar()
        Utility.shared.renderNotificationCount(self.countNotificationLbl)
    }
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func setupAppearance() {
        
        view1.roundCorners([.layerMinXMinYCorner,.layerMaxXMinYCorner], radius: 50, borderColor: .lightGray, borderWidth: 0.5)
        view2.roundCorners([.layerMinXMinYCorner,.layerMaxXMinYCorner], radius: 50, borderColor: .lightGray, borderWidth: 0.5)
        view3.roundCorners([.layerMinXMinYCorner,.layerMaxXMinYCorner], radius: 50, borderColor: .lightGray, borderWidth: 0.5)
        
        view4.roundCorners([.layerMinXMinYCorner,.layerMaxXMinYCorner], radius: 50, borderColor: .lightGray, borderWidth: 0.5)
        view5.roundCorners([.layerMinXMinYCorner,.layerMaxXMinYCorner], radius: 50, borderColor: .lightGray, borderWidth: 0.5)
        view6.roundCorners([.layerMinXMinYCorner,.layerMaxXMinYCorner], radius: 50, borderColor: .lightGray, borderWidth: 0.5)
        view7.roundCorners([.layerMinXMinYCorner,.layerMaxXMinYCorner], radius: 50, borderColor: .lightGray, borderWidth: 0.5)
        
        
        
        
        //view6.rounCornersWithGradientBackgroud([.layerMinXMinYCorner,.layerMaxXMinYCorner], radius: 50, borderColor: .lightGray, borderWidth: 0.5)
        
        
    }
    
    
    
    func transicationController() {
        let transition:CATransition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromTop
        self.navigationController!.view.layer.add(transition, forKey: kCATransition)
    }
    
    
    @IBAction func tapOnMarketWatchBtn(_ sender: Any) {
        transicationController()
        let vc = MarketWatchVC.instantiateFromAppStroyboard(appStoryboard: .marketWatch)
        vc.isTransition = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func tapOnInvestmentProductBtn(_ sender: UIButton) {
        transicationController()
        let vc = InvestmentProductsVC.instantiateFromAppStroyboard(appStoryboard: .main)
        vc.isTransition = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func tapOnInvestBtn(_ sender: Any) {
        transicationController()
        let vc = WhereInvestVC.instantiateFromAppStroyboard(appStoryboard: .main)
        vc.isTransition = true
        self.navigationController?.pushViewController(vc, animated: true)

    }
    
    @IBAction func tapOnEducationalInvestment(_ sender: Any) {
        transicationController()
        let vc = InvestmentEducationVC.instantiateFromAppStroyboard(appStoryboard: .main)
        vc.isTransition = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func tapOnFundPerformance(_ sender: Any) {
        transicationController()
        let vc = BlogsViewController.instantiateFromAppStroyboard(appStoryboard: .main)
        vc.urlStr = FUND_REPORTS
        vc.titleStr = "Fund Performance Report"
        vc.isTransition = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func didTapOnInvestorBtn(_ sender: Any) {
        transicationController()
        let vc = OpenNewAccountVC.instantiateFromAppStroyboard(appStoryboard: .onlineAccount)
        navigationController?.pushViewController(vc, animated: false)
    }
    
    @IBAction func tapOnLoginBtn(_ sender: Any) {
        transicationController()
        let vc = LoginViewController.instantiateFromAppStroyboard(appStoryboard: .home)
        vc.isTransition = true
        LoginConfigurator.configureModule(viewController: vc)
        navigationController?.pushViewController(vc, animated: false)
        
    }
    @IBAction func tapOnMenuBtn(_ sender: Any) {
        self.revealController.show(self.revealController.leftViewController)
    }
    
    @IBAction func tapOnNotificationBtn(_ sender: Any) {
        let vc = NotificationsVC.instantiateFromAppStroyboard(appStoryboard: .home)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func notificationPopup(_ flag: Bool) {
        notificationView.isHidden = flag
        blurView.isHidden = flag
    }
    
    @IBAction func tapOnCloseBtn(_ sender: Any) {
        notificationPopup(true)
    }
}

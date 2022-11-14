//
//  BlogsViewController.swift
//  AlMeezan
//
//  Created by Atta khan on 25/10/2019.
//  Copyright © 2019 Atta khan. All rights reserved.
//

import UIKit
import WebKit
import SVProgressHUD
import SwiftKeychainWrapper

class BlogsViewController: UIViewController {

    @IBOutlet weak var navigationTitle: UILabel!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var notificationBtn: UIButton!
    @IBOutlet weak var countNotificationLbl: UIButton!
    var isPresentView: Bool = false
    var urlStr: String?
    var titleStr: String?
    var isTransition: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        navigationTitle.text = titleStr ?? ""
        //countNotificationLbl.isHidden = true
        // Remove all cache
        URLCache.shared.removeAllCachedResponses()

        // Delete any associated cookies
        if let cookies = HTTPCookieStorage.shared.cookies {
            for cookie in cookies {
                HTTPCookieStorage.shared.deleteCookie(cookie)
            }
        }
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
                print("[WebCacheCleaner] Record \(record) deleted")
            }
        }
        
        let url = URL(string: urlStr!)
        var request = URLRequest(url: url!)
        request.cachePolicy = .returnCacheDataElseLoad
        webView.load(request)
        SVProgressHUD.show()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideNavigationBar()
        /*Utility.shared.renderNotificationCount(countNotificationLbl)
        
        if let userAuth = KeychainWrapper.standard.string(forKey: "UserType") {
            if userAuth == "loggedInUser" {
                loginBtn.setImage(UIImage(named: "logout-icon-1"), for: .normal)
            } else {
                loginBtn.setImage(UIImage(named: "logout-icon"), for: .normal)
            }
        }
 */
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Utility.shared.googleAnalyticsEvent(HomeScreenEnums.FUND_PERFORMANCE_REPORT.index, HomeScreenEnums.FUND_PERFORMANCE_REPORT.value, HomeScreenEnums.FUND_PERFORMANCE_REPORT.screenName, String(describing: type(of: self)))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if SVProgressHUD.isVisible() {
            SVProgressHUD.dismiss()
        }
    }
    
    @IBAction func tapOnNavigationBtn(_ sender: Any) {
        if isTransition == false {
            if isPresentView == true {
                dismiss(animated: true, completion: nil)
            } else {
                self.navigationController?.popViewController(animated: true)
            }
        } else {
            let transition:CATransition = CATransition()
            transition.duration = 0.5
            transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
            transition.type = CATransitionType.push
            transition.subtype = CATransitionSubtype.fromBottom
            self.navigationController!.view.layer.add(transition, forKey: kCATransition)
            self.navigationController?.popViewController(animated: false)
        }
    }
    
    @IBAction func tapOnNotificationBtn(_ sender: Any) {
        let vc = NotificationsVC.instantiateFromAppStroyboard(appStoryboard: .home)
        self.navigationController?.pushViewController(vc, animated: true)
    }
       
    @IBAction func tapOnLoginBtn(_ sender: Any) {
        loginOption()
     }

}

extension BlogsViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("End loading.....")
        SVProgressHUD.dismiss()
    }
}

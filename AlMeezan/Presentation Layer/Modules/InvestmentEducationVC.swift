//
//  InvestmentEducationVC.swift
//  AlMeezan
//
//  Created by Atta khan on 15/10/2019.
//  Copyright © 2019 Atta khan. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

class InvestmentEducationVC: UIViewController {

    @IBOutlet weak var view4: UIView!
    @IBOutlet weak var view3: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var notificationBtn: UIButton!
    @IBOutlet weak var countNotificationLbl: UIButton!

    var isTransition: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
    
        view1.roundCorners([.layerMinXMinYCorner,.layerMaxXMinYCorner], radius: 30, borderColor: .lightGray, borderWidth: 0.5)
        view2.roundCorners([.layerMinXMinYCorner,.layerMaxXMinYCorner], radius: 30, borderColor: .lightGray, borderWidth: 0.5)
        view3.roundCorners([.layerMinXMinYCorner,.layerMaxXMinYCorner], radius: 30, borderColor: .lightGray, borderWidth: 0.5)
        view4.roundCorners([.layerMinXMinYCorner,.layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner ], radius: 30, borderColor: .lightGray, borderWidth: 0.5)
         countNotificationLbl.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        Utility.shared.renderNotificationCount(countNotificationLbl)
        hideNavigationBar()
        if let userAuth = KeychainWrapper.standard.string(forKey: "UserType") {
            if userAuth == "loggedInUser" {
                loginBtn.setImage(UIImage(named: "logout-icon-1"), for: .normal)
            } else {
                loginBtn.setImage(UIImage(named: "logout-icon"), for: .normal)
            }
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Utility.shared.googleAnalyticsEvent(HomeScreenEnums.INVESTOR_EDUCATION.index, HomeScreenEnums.INVESTOR_EDUCATION.value, HomeScreenEnums.INVESTOR_EDUCATION.screenName, String(describing: type(of: self)))
    }
    
    @IBAction func tapOnBlogsBtn(_ sender: UIButton) {
        let vc = BlogsViewController.instantiateFromAppStroyboard(appStoryboard: .main)
        let tag = sender.tag
        switch tag {
        case 1:
            vc.urlStr = BLOG_URL
            vc.titleStr = "Blogs & Articles"
        case 2:
            vc.urlStr = YOUTUBE_CHANNEL
            vc.titleStr = "Awareness Videos"
        case 3:
            vc.urlStr = NEWS_UPDATE
            vc.titleStr = "Company News"
        default:
            vc.urlStr = FAQS
            vc.titleStr = "FAQs"
        }
        
        navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func navigateBackController(_ sender: Any) {
       if isTransition == false {
            self.navigationController?.popViewController(animated: true)
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
    }
       
    @IBAction func tapOnLoginBtn(_ sender: Any) {
        loginOption()
     }
}

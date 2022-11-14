//
//  WhereInvestVC.swift
//  AlMeezan
//
//  Created by Atta khan on 09/10/2019.
//  Copyright © 2019 Atta khan. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

class WhereInvestVC: UIViewController {

    @IBOutlet weak var financial_calculator_lbl: UILabel!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var notificationBtn: UIButton!
    @IBOutlet weak var countNotificationLbl: UIButton!

    @IBOutlet weak var view3: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view1: UIView!
    var isTransition: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        financial_calculator_lbl.adjustsFontSizeForLbl()
        view1.roundCorners([.layerMinXMinYCorner,.layerMaxXMinYCorner], radius: 30, borderColor: .lightGray, borderWidth: 0.5)
        view2.roundCorners([.layerMinXMinYCorner,.layerMaxXMinYCorner], radius: 30, borderColor: .lightGray, borderWidth: 0.5)
        view3.roundCorners([.layerMinXMinYCorner,.layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner ], radius: 30, borderColor: .lightGray, borderWidth: 0.5)
         countNotificationLbl.isHidden = true
        Utility.shared.renderNotificationCount(countNotificationLbl)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        Utility.shared.googleAnalyticsEvent(HomeScreenEnums.WHERE_TO_INVEST.index, HomeScreenEnums.WHERE_TO_INVEST.value, HomeScreenEnums.WHERE_TO_INVEST.screenName, String(describing: type(of: self)))
    }
    
    @IBAction func tapOnAllFundBtn(_ sender: Any) {
        let vc = InvestAllFundVC.instantiateFromAppStroyboard(appStoryboard: .main)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func tapOnFundSuggestionBtn(_ sender: Any) {
        let vc = FundSuggestionVC.instantiateFromAppStroyboard(appStoryboard: .main)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func tapOnCalcultorBtn(_ sender: Any) {
        let vc = FinancialCalculatorsVC.instantiateFromAppStroyboard(appStoryboard: .main)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func navigateBack(_ sender: Any) {
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
        let vc = NotificationsVC.instantiateFromAppStroyboard(appStoryboard: .home)
        self.navigationController?.pushViewController(vc, animated: true)
    }
       
    @IBAction func tapOnLoginBtn(_ sender: Any) {
        loginOption()
     }
}

//
//  MarketWatchVC.swift
//  AlMeezan
//
//  Created by Atta khan on 20/11/2019.
//  Copyright © 2019 Atta khan. All rights reserved.
//

import UIKit
import PKRevealController
import SwiftKeychainWrapper

class MarketWatchVC: BaseViewController, MainViewProtocol {

    @IBOutlet weak var equityView: UIView!
    @IBOutlet weak var moneyView: UIView!
    @IBOutlet weak var commodotiesView: UIView!
    @IBOutlet weak var forexView: UIView!
    
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var notificationBtn: UIButton!
    @IBOutlet weak var countNotificationLbl: UIButton!

    @IBOutlet weak var equityLbl: UILabel!
    @IBOutlet weak var equitydesLbl: UILabel!
    @IBOutlet weak var commodiesDesc: UILabel!
    @IBOutlet weak var commodotiesLbl: UILabel!
    @IBOutlet weak var forexDesc: UILabel!
    @IBOutlet weak var forexLbl: UILabel!
    @IBOutlet weak var moneydesc: UILabel!
    @IBOutlet weak var moneyLbl: UILabel!
    var isTransition: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBarAppearance(false)
        updateUI()
        countNotificationLbl.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        countNotificationBadge(countNotificationLbl)
        let image = isUserLoggedIn() ? "logout-icon-1" : "logout-icon"
        loginBtn.setImage(UIImage(named: image), for: .normal)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Utility.shared.googleAnalyticsEvent(HomeScreenEnums.MARKET_WATCH.index, HomeScreenEnums.MARKET_WATCH.value, HomeScreenEnums.MARKET_WATCH.screenName, String(describing: type(of: self)))
    }
    
    private func updateUI() {
        equityView.layer.zPosition = 1
        moneyView.layer.zPosition = 1
        commodotiesView.layer.zPosition = 1
        forexView.layer.zPosition = 1
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.tapOnEquity))
        self.equityView.addGestureRecognizer(gesture)

       
        
        let forexGesture = UITapGestureRecognizer(target: self, action: #selector(tapOnForexView))
        forexView.addGestureRecognizer(forexGesture)
        
        
        let moneyGesture = UITapGestureRecognizer(target: self, action: #selector(tapOnMoneyView))
        moneyView.addGestureRecognizer(moneyGesture)
        
        let commodityGesture = UITapGestureRecognizer(target: self, action: #selector(tapOnComodityView))
        commodotiesView.addGestureRecognizer(commodityGesture)
        
        equityLbl.font = UIFont(name: AppFontName.circularStdRegular, size: 16)
        commodotiesLbl.font = UIFont(name: AppFontName.circularStdRegular, size: 16)
        forexLbl.font = UIFont(name: AppFontName.circularStdRegular, size: 16)
        moneyLbl.font = UIFont(name: AppFontName.circularStdRegular, size: 16)
        moneydesc.font = UIFont(name: AppFontName.circularStdRegular, size: 12)
        equitydesLbl.font = UIFont(name: AppFontName.circularStdRegular, size: 12)
        forexDesc.font = UIFont(name: AppFontName.circularStdRegular, size: 12)
        commodiesDesc.font = UIFont(name: AppFontName.circularStdRegular, size: 12)
        
        
        equityLbl.textColor = UIColor.init(rgb: 0x000000)
        commodotiesLbl.textColor = UIColor.init(rgb: 0x000000)
        forexLbl.textColor = UIColor.init(rgb: 0x000000)
        moneyLbl.textColor = UIColor.init(rgb: 0x000000)
        
        
        moneydesc.textColor = UIColor.init(rgb: 0xADAFBB)
        equitydesLbl.textColor = UIColor.init(rgb: 0xADAFBB)
        forexDesc.textColor = UIColor.init(rgb: 0xADAFBB)
        commodiesDesc.textColor = UIColor.init(rgb: 0xADAFBB)
        
    }
    @objc func tapOnEquity(sender : UITapGestureRecognizer) {
        let vc = EquityViewController.instantiateFromAppStroyboard(appStoryboard: .marketWatch)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func tapOnMoneyView(sender: UITapGestureRecognizer) {
        let vc = MoneyMarketVC.instantiateFromAppStroyboard(appStoryboard: .marketWatch)
        navigationController?.pushViewController(vc, animated: true)
    }
    @objc func tapOnForexView(sender: UITapGestureRecognizer) {
        let vc = ForexViewController.instantiateFromAppStroyboard(appStoryboard: .marketWatch)
        ForexConfigurator.configureModule(viewController: vc)
        navigationController?.pushViewController(vc, animated: true)
    }
    @objc func tapOnComodityView(sender: UITapGestureRecognizer) {
        let vc = CommoditiesVC.instantiateFromAppStroyboard(appStoryboard: .marketWatch)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func leftMenuBtn(_ sender: Any) {
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

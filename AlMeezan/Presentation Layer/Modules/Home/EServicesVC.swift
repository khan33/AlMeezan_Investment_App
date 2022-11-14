//
//  EServicesVC.swift
//  AlMeezan
//
//  Created by Atta khan on 04/11/2019.
//  Copyright © 2019 Atta khan. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

class EServicesVC: UIViewController {

    @IBOutlet weak var conversionView: UIView!
    @IBOutlet weak var conversionLbl: UILabel!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var redemptionView: UIView!
    @IBOutlet weak var redemptionLbl: UILabel!
    @IBOutlet weak var investmentView: UIView!
    @IBOutlet weak var investmentLbl: UILabel!
    @IBOutlet weak var topViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var notificationBtn: UIButton!
    @IBOutlet weak var investmentBtn: UIButton!
    @IBOutlet weak var conversionBtn: UIButton!
    @IBOutlet weak var redemptionBtn: UIButton!
    @IBOutlet weak var countNotificationLbl: UIButton!
    var isFromSideMenu: Bool = false
    var selectedMenuItem: Int = 0
    var pageVC: UIPageViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if isFromSideMenu {
            navigateToController(selectedMenuItem)
        }
        configStyle()
        countNotificationLbl.isHidden = true
        let portfolioID = UserDefaults.standard.string(forKey: "portfolioId")
        if portfolioID?.contains("-") ?? false {
            let ids = portfolioID?.components(separatedBy: "-")
               let id = Int(ids?[1] ?? "0")!
            let isExist = (900...999).contains(id)
            if isExist == false {
                
            } else {
                self.showAlert(title: "Alert", message: Message.MTPFPMessage, controller: self) {
                }
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideNavigationBar()
        Utility.shared.renderNotificationCount(countNotificationLbl)
        if let userAuth = KeychainWrapper.standard.string(forKey: "UserType") {
            if userAuth == "loggedInUser" {
                loginBtn.setImage(UIImage(named: "logout-icon-1"), for: .normal)
            } else {
                loginBtn.setImage(UIImage(named: "logout-icon"), for: .normal)
            }
        }
    }
    func configStyle() {
        setPager()
        self.view.bringSubviewToFront(self.topView)
        
    }
    func setPager() {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        pageVC = storyboard.instantiateViewController(withIdentifier: "PageViewController") as! UIPageViewController
        let startVC = viewControllerAtIndex(tempIndex: 0)
        _ = startVC.view
        pageVC?.setViewControllers([startVC], direction: .reverse, animated: true, completion: nil)
        pageVC?.view.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEGHT)
        self.addChild(pageVC!)
        self.view.addSubview((pageVC?.view)!)
        self.pageVC?.didMove(toParent: self)
    }
    
    func viewControllerAtIndex(tempIndex: Int) -> UIViewController {
        print("template index = ", tempIndex)
        if tempIndex == 0 {
            let vc = InvestmentVC.instantiateFromAppStroyboard(appStoryboard: .home)
            return vc
        } else if tempIndex == 1 {
            let vc = ConversionVC.instantiateFromAppStroyboard(appStoryboard: .home)
            return vc
        } else  {
            let vc = RedemptionVC.instantiateFromAppStroyboard(appStoryboard: .home)
            return vc
        }
    }
    
    
    
    func navigateTopBarMenu(_ tag: Int) {
        switch tag {
        case 0:
            
            let startVC = viewControllerAtIndex(tempIndex: 0)
            _ = startVC.view
            pageVC?.setViewControllers([startVC], direction: .reverse , animated: true, completion: nil)
            investmentLbl.textColor = UIColor.white
            investmentView.backgroundColor = UIColor.white
            investmentView.isHidden = false
            redemptionLbl.textColor = UIColor.rgb(red: 255.0, green: 255.0, blue: 255.0, alpha: 0.5)
            redemptionView.backgroundColor = UIColor.clear
            redemptionView.isHidden = true
            conversionLbl.textColor = UIColor.rgb(red: 255.0, green: 255.0, blue: 255.0, alpha: 0.5)
            conversionView.backgroundColor = UIColor.clear
            conversionView.isHidden = true
            investmentBtn.isUserInteractionEnabled    = false
            conversionBtn.isUserInteractionEnabled   = true
            redemptionBtn.isUserInteractionEnabled     = true
        case 1:
            
            let startVC = viewControllerAtIndex(tempIndex: 1)
            _ = startVC.view
            pageVC?.setViewControllers([startVC], direction: .reverse , animated: true, completion: nil)
            conversionLbl.textColor = UIColor.white
            conversionView.backgroundColor = UIColor.white
            conversionView.isHidden = false
            redemptionLbl.textColor = UIColor.rgb(red: 255.0, green: 255.0, blue: 255.0, alpha: 0.5)
            redemptionView.backgroundColor = UIColor.clear
            redemptionView.isHidden = true
            investmentLbl.textColor = UIColor.rgb(red: 255.0, green: 255.0, blue: 255.0, alpha: 0.5)
            investmentView.backgroundColor = UIColor.clear
            investmentView.isHidden = true
            investmentBtn.isUserInteractionEnabled    = true
            conversionBtn.isUserInteractionEnabled   = false
            redemptionBtn.isUserInteractionEnabled     = true
        default:
            let startVC = viewControllerAtIndex(tempIndex: 2)
            _ = startVC.view
            pageVC?.setViewControllers([startVC], direction: .reverse , animated: true, completion: nil)
            redemptionLbl.textColor = UIColor.white
            redemptionView.backgroundColor = UIColor.white
            redemptionView.isHidden = false
            conversionLbl.textColor = UIColor.rgb(red: 255.0, green: 255.0, blue: 255.0, alpha: 0.5)
            conversionView.backgroundColor = UIColor.clear
            conversionView.isHidden = true
            investmentLbl.textColor = UIColor.rgb(red: 255.0, green: 255.0, blue: 255.0, alpha: 0.5)
            investmentView.backgroundColor = UIColor.clear
            investmentView.isHidden = true
            investmentBtn.isUserInteractionEnabled    = true
            conversionBtn.isUserInteractionEnabled   = true
            redemptionBtn.isUserInteractionEnabled     = false
        }
    }
    
    
    @IBAction func tapOnTabBar(_ sender: UIButton) {
        let tag = sender.tag
        navigateTopBarMenu(tag)
    }
   
    
    @IBAction func navigateController(_ sender: Any) {
        self.revealController.show(self.revealController.leftViewController)
    }
    
    @IBAction func logoutBtn(_ sender: Any) {
        loginOption()
    }
    @IBAction func tapOnNotificationBtn(_ sender: Any) {
        let vc = NotificationsVC.instantiateFromAppStroyboard(appStoryboard: .home)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

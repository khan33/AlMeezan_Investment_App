//
//  EquityViewController.swift
//  AlMeezan
//
//  Created by Atta khan on 20/11/2019.
//  Copyright © 2019 Atta khan. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

class EquityViewController: BaseViewController {
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var indicesView: UIView!
    @IBOutlet weak var indicesLbl: UILabel!
    @IBOutlet weak var marketView: UIView!
    @IBOutlet weak var marketLbl: UILabel!
    @IBOutlet weak var mystockView: UIView!
    @IBOutlet weak var mystockLbl: UILabel!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var notificationBtn: UIButton!
    @IBOutlet weak var countNotificationLbl: UIButton!
    @IBOutlet weak var indicesBtn: UIButton!
    @IBOutlet weak var performanceBtn: UIButton!
    @IBOutlet weak var myStockBtn: UIButton!
    
    
    var pageVC: UIPageViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        countNotificationLbl.isHidden = true
        configStyle()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Utility.shared.renderNotificationCount(self.countNotificationLbl)
        hideNavigationBar()
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
        if tempIndex == 0 {
            let vc = IndicesViewController.instantiateFromAppStroyboard(appStoryboard: .marketWatch)
            return vc
        } else if tempIndex == 1 {
            let vc = MarketPerformersVC.instantiateFromAppStroyboard(appStoryboard: .marketWatch)
            return vc
        } else  {
            let vc = MyStocksViewController.instantiateFromAppStroyboard(appStoryboard: .marketWatch)
            return vc
        }
    }



    func navigateTopBarMenu(_ tag: Int) {
     switch tag {
     case 0:
        let startVC = viewControllerAtIndex(tempIndex: 0)
        _ = startVC.view
        pageVC?.setViewControllers([startVC], direction: .reverse , animated: true, completion: nil)
        indicesLbl.textColor = UIColor.white
        indicesView.backgroundColor = UIColor.white
        indicesView.isHidden = false
        mystockLbl.textColor = UIColor.rgb(red: 255.0, green: 255.0, blue: 255.0, alpha: 0.5)
        mystockView.backgroundColor = UIColor.clear
        mystockView.isHidden = true
        marketLbl.textColor = UIColor.rgb(red: 255.0, green: 255.0, blue: 255.0, alpha: 0.5)
        marketView.backgroundColor = UIColor.clear
        marketView.isHidden = true
        indicesBtn.isUserInteractionEnabled    = false
        performanceBtn.isUserInteractionEnabled   = true
        myStockBtn.isUserInteractionEnabled     = true
     case 1:
        let startVC = viewControllerAtIndex(tempIndex: 1)
        _ = startVC.view
        pageVC?.setViewControllers([startVC], direction: .reverse , animated: true, completion: nil)
        marketLbl.textColor = UIColor.white
        marketView.backgroundColor = UIColor.white
        marketView.isHidden = false
        mystockLbl.textColor = UIColor.rgb(red: 255.0, green: 255.0, blue: 255.0, alpha: 0.5)
        mystockView.backgroundColor = UIColor.clear
        mystockView.isHidden = true
        indicesLbl.textColor = UIColor.rgb(red: 255.0, green: 255.0, blue: 255.0, alpha: 0.5)
        indicesView.backgroundColor = UIColor.clear
        indicesView.isHidden = true
        indicesBtn.isUserInteractionEnabled    = true
        performanceBtn.isUserInteractionEnabled   = false
        myStockBtn.isUserInteractionEnabled     = true
     default:
        let startVC = viewControllerAtIndex(tempIndex: 2)
        _ = startVC.view
        pageVC?.setViewControllers([startVC], direction: .reverse , animated: true, completion: nil)
        mystockLbl.textColor = UIColor.white
        mystockView.backgroundColor = UIColor.white
        mystockView.isHidden = false
        indicesLbl.textColor = UIColor.rgb(red: 255.0, green: 255.0, blue: 255.0, alpha: 0.5)
        indicesView.backgroundColor = UIColor.clear
        indicesView.isHidden = true
        marketLbl.textColor = UIColor.rgb(red: 255.0, green: 255.0, blue: 255.0, alpha: 0.5)
        marketView.backgroundColor = UIColor.clear
        marketView.isHidden = true
        indicesBtn.isUserInteractionEnabled    = true
        performanceBtn.isUserInteractionEnabled   = true
        myStockBtn.isUserInteractionEnabled     = false
     }
    }


    @IBAction func tapOnTabBar(_ sender: UIButton) {
        let tag = sender.tag
        navigateTopBarMenu(tag)
    }


    @IBAction func navigateController(_ sender: Any){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tapOnNotificationBtn(_ sender: Any) {
        let vc = NotificationsVC.instantiateFromAppStroyboard(appStoryboard: .home)
        self.navigationController?.pushViewController(vc, animated: true)
    }
       
    @IBAction func tapOnLoginBtn(_ sender: Any) {
        loginOption()
     }
    
    
    
}

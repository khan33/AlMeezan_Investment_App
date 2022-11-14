//
//  ProfileDetailsVC.swift
//  AlMeezan
//
//  Created by Atta khan on 04/11/2019.
//  Copyright © 2019 Atta khan. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

class ProfileDetailsVC: UIViewController {

    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var fundOFfundView: UIView!
    @IBOutlet weak var fundOFfundLbl: UILabel!
    @IBOutlet weak var fundView: UIView!
    @IBOutlet weak var fundLbl: UILabel!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var notificationBtn: UIButton!
    @IBOutlet weak var countNotificationLbl: UIButton!
    @IBOutlet weak var profileDetailsBtn: UIButton!
    @IBOutlet weak var myProfileBtn: UIButton!
    var pageVC: UIPageViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configStyle()
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
            let vc = MyDetailsVC.instantiateFromAppStroyboard(appStoryboard: .home)
            return vc
        } else  {
            let vc = MyProfileVC.instantiateFromAppStroyboard(appStoryboard: .home)
            return vc
        }
    }
    
    
    
    func navigateTopBarMenu(_ tag: Int) {
        switch tag {
        case 0:
            let startVC = viewControllerAtIndex(tempIndex: 0)
            _ = startVC.view
            pageVC?.setViewControllers([startVC], direction: .reverse , animated: true, completion: nil)
            fundLbl.textColor = UIColor.white
            fundView.backgroundColor = UIColor.white
            fundView.isHidden = false
            fundOFfundLbl.textColor = UIColor.rgb(red: 255.0, green: 255.0, blue: 255.0, alpha: 0.5)
            fundOFfundView.backgroundColor = UIColor.clear
            fundOFfundView.isHidden = true
            profileDetailsBtn.isUserInteractionEnabled    = false
            myProfileBtn.isUserInteractionEnabled   = true
        default:
            let startVC = viewControllerAtIndex(tempIndex: 1)
            _ = startVC.view
            pageVC?.setViewControllers([startVC], direction: .reverse , animated: true, completion: nil)
            fundOFfundLbl.textColor = UIColor.white
            fundOFfundView.backgroundColor = UIColor.white
            fundOFfundView.isHidden = false
            fundLbl.textColor = UIColor.rgb(red: 255.0, green: 255.0, blue: 255.0, alpha: 0.5)
            fundView.backgroundColor = UIColor.clear
            fundView.isHidden = true
            profileDetailsBtn.isUserInteractionEnabled    = true
            myProfileBtn.isUserInteractionEnabled   = false
        }
    }
    
    
    @IBAction func tapOnFOFBtn(_ sender: Any) {
        navigateTopBarMenu(1)
    }
    @IBAction func tapOnFundsBtn(_ sender: Any) {
        navigateTopBarMenu(0)
    }
    
    @IBAction func navigateController(_ sender: Any) {
        self.revealController.show(self.revealController.leftViewController)
        
        //Utility.shared.goToHomeController(vcIdentifier: "customTabBarViewController", storyboardName: "Main", navController: self.navigationController!, leftMenuIdentifier: "leftSideMenuVC")
    }
    @IBAction func tapOnNotificationBtn(_ sender: Any) {
        let vc = NotificationsVC.instantiateFromAppStroyboard(appStoryboard: .home)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func logoutBtn(_ sender: Any) {
        loginOption()
    }
    
}

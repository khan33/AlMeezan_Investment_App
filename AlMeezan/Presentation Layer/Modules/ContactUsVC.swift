//
//  ContactUsVC.swift
//  AlMeezan
//
//  Created by Atta khan on 18/09/2019.
//  Copyright © 2019 Atta khan. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

class ContactUsVC: BaseViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var notificationBtn: UIButton!
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var locateUsBtn: UIButton!
    @IBOutlet weak var investNowBtn: UIButton!
    @IBOutlet weak var emailUsBtn: UIButton!
    @IBOutlet weak var emailUsLbl: UILabel!
    @IBOutlet weak var emailUsView: UIView!
    @IBOutlet weak var locateUsLbl: UILabel!
    @IBOutlet weak var locateUsView: UIView!
    @IBOutlet weak var investLbl: UILabel!
    @IBOutlet weak var investView: UIView!
    @IBOutlet weak var countNotificationLbl: UIButton!

    
    var isFromSideMenu: Bool = false
    var selectedMenuItem: Int = 0
    
    let menuNames = ["Locate Us","Invest Now!", "Email Us"]
    var pageVC: UIPageViewController?
    override func viewDidLoad() {
        super.viewDidLoad()
        if isFromSideMenu {
            navigateToController(selectedMenuItem)
        }
        countNotificationLbl.isHidden = true
        let userAuth = KeychainWrapper.standard.string(forKey: "UserType")!
        if userAuth == "loggedInUser" {
            investLbl.text = "Complaint & \nFeeback"
            loginBtn.setImage(UIImage(named: "logout-icon-1"), for: .normal)
        } else {
            investLbl.text = "Email Us"
             loginBtn.setImage(UIImage(named: "logout-icon"), for: .normal)
        }
        configStyle()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Utility.shared.renderNotificationCount(countNotificationLbl)
        hideNavigationBar()
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
            let vc = LocateUsVC.instantiateFromAppStroyboard(appStoryboard: .main)
            return vc
            
        }
        else if tempIndex == 1 {
            let vc = InvestNowVC.instantiateFromAppStroyboard(appStoryboard: .main)
            return vc
        }
        else {
            
            let userAuth = KeychainWrapper.standard.string(forKey: "UserType")!
            if userAuth == "loggedInUser" {
                let vc = ComplaintsVC.instantiateFromAppStroyboard(appStoryboard: .main)
                return vc
            } else {
                let vc = EmailUsVC.instantiateFromAppStroyboard(appStoryboard: .main)
                return vc
            }
        }
    }
      
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let pageNumber = Int(targetContentOffset.pointee.x / view.frame.width)
        print(pageNumber)
        navigateTopBarMenu(pageNumber)
        
    }
    
    func navigateTopBarMenu(_ tag: Int) {
        switch tag {
        case 0:
            let startVC = viewControllerAtIndex(tempIndex: 0)
            _ = startVC.view
            pageVC?.setViewControllers([startVC], direction: .reverse , animated: true, completion: nil)
            emailUsLbl.textColor = UIColor.white
            emailUsView.backgroundColor = UIColor.white
            emailUsView.isHidden = false
            locateUsLbl.textColor = UIColor.rgb(red: 255.0, green: 255.0, blue: 255.0, alpha: 0.5)
            locateUsView.backgroundColor = UIColor.clear
            locateUsView.isHidden = true
            investLbl.textColor = UIColor.rgb(red: 255.0, green: 255.0, blue: 255.0, alpha: 0.5)
            investView.backgroundColor = UIColor.clear
            investView.isHidden = true
            locateUsBtn.isUserInteractionEnabled    = false
            investNowBtn.isUserInteractionEnabled   = true
            emailUsBtn.isUserInteractionEnabled     = true
        case 1:
            let startVC = viewControllerAtIndex(tempIndex: 1)
            _ = startVC.view
            pageVC?.setViewControllers([startVC], direction: .reverse , animated: true, completion: nil)
            emailUsLbl.textColor = UIColor.rgb(red: 255.0, green: 255.0, blue: 255.0, alpha: 0.5)
            emailUsView.backgroundColor = UIColor.clear
            emailUsView.isHidden = true
            locateUsLbl.textColor = UIColor.white
            locateUsView.backgroundColor = UIColor.white
            locateUsView.isHidden = false
            investLbl.textColor = UIColor.rgb(red: 255.0, green: 255.0, blue: 255.0, alpha: 0.5)
            investView.backgroundColor = UIColor.clear
            investView.isHidden = true
            locateUsBtn.isUserInteractionEnabled    = true
            investNowBtn.isUserInteractionEnabled   = false
            emailUsBtn.isUserInteractionEnabled     = true
            
        default:
            let startVC = viewControllerAtIndex(tempIndex: 2)
            _ = startVC.view
            pageVC?.setViewControllers([startVC], direction: .reverse , animated: true, completion: nil)
            emailUsLbl.textColor = UIColor.rgb(red: 255.0, green: 255.0, blue: 255.0, alpha: 0.5)
            emailUsView.backgroundColor = UIColor.clear
            emailUsView.isHidden = true
            locateUsLbl.textColor = UIColor.rgb(red: 255.0, green: 255.0, blue: 255.0, alpha: 0.5)
            locateUsView.backgroundColor = UIColor.clear
            locateUsView.isHidden = true
            investLbl.textColor = UIColor.white
            investView.backgroundColor = UIColor.white
            investView.isHidden = false
            locateUsBtn.isUserInteractionEnabled    = true
            investNowBtn.isUserInteractionEnabled   = true
            emailUsBtn.isUserInteractionEnabled     = false
        }
    }
    
    
    @IBAction func clickEmailUsBtn(_ sender: UIButton) {
        let tag = sender.tag
        navigateTopBarMenu(tag)
        
//        let selectedIndex = IndexPath(item: 0, section: 0)
//        collectionView.selectItem(at: selectedIndex, animated: true, scrollPosition: .left)
    }
    
    @IBAction func tapOnLocateUsBtn(_ sender: UIButton) {
        let tag = sender.tag
        navigateTopBarMenu(tag)
    }
    
    
    @IBAction func tapInvestBtn(_ sender: UIButton) {
        let tag = sender.tag
        navigateTopBarMenu(tag)
    }
    
    @IBAction func tapOnMenuBtn(_ sender: Any) {
        print("here is.....")
        self.revealController.show(self.revealController.leftViewController)
    }
    
    @IBAction func tapOnNotificationBtn(_ sender: Any) {
        let vc = NotificationsVC.instantiateFromAppStroyboard(appStoryboard: .home)
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    @IBAction func tapOnLoginBtn(_ sender: Any) {
       loginOption()
    }
    
}


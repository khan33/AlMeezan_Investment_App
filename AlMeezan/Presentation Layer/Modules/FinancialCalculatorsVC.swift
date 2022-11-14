//
//  FinancialCalculatorsVC.swift
//  AlMeezan
//
//  Created by Atta khan on 14/10/2019.
//  Copyright © 2019 Atta khan. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

class FinancialCalculatorsVC: UIViewController {

    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var retirmentLbl: UILabel!
    @IBOutlet weak var taxSavingLbl: UILabel!
    @IBOutlet weak var investmentLbl: UILabel!
    @IBOutlet weak var countNotificationLbl: UIButton!

    @IBOutlet weak var investmentBtn: UIButton!
    @IBOutlet weak var taxSavingBtn: UIButton!
    @IBOutlet weak var retirementBtn: UIButton!
    
    @IBOutlet weak var taxSavingBottomView: UIView!
    @IBOutlet weak var retirmentBottomView: UIView!
    @IBOutlet weak var investmentBottomView: UIView!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var notificationBtn: UIButton!
    var pageVC: UIPageViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configStyle()
        countNotificationLbl.isHidden = true
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
        
        Utility.shared.renderNotificationCount(countNotificationLbl)
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
            let vc = InvestmentCalculatorVC.instantiateFromAppStroyboard(appStoryboard: .main)
            return vc
        } else if tempIndex == 1 {
            let vc = TaxSavingCalculatorVC.instantiateFromAppStroyboard(appStoryboard: .main)
            return vc
        } else {
            let vc = RetirementCalculatorVC.instantiateFromAppStroyboard(appStoryboard: .main)
            return vc
        }
    }
    
    func navigateTopBarMenu(_ tag: Int) {
        switch tag {
        case 1:
            let startVC = viewControllerAtIndex(tempIndex: 0)
            _ = startVC.view
            pageVC?.setViewControllers([startVC], direction: .reverse , animated: true, completion: nil)
            investmentLbl.textColor = UIColor.white
            investmentBottomView.backgroundColor = UIColor.white
            investmentBottomView.isHidden = false
            taxSavingLbl.textColor = UIColor.rgb(red: 255.0, green: 255.0, blue: 255.0, alpha: 0.5)
            taxSavingBottomView.backgroundColor = UIColor.clear
            taxSavingBottomView.isHidden = true
            retirmentLbl.textColor = UIColor.rgb(red: 255.0, green: 255.0, blue: 255.0, alpha: 0.5)
            retirmentBottomView.backgroundColor = UIColor.clear
            retirmentBottomView.isHidden = true
            investmentBtn.isUserInteractionEnabled    = false
            taxSavingBtn.isUserInteractionEnabled     = true
            retirementBtn.isUserInteractionEnabled    = true
        case 2:
            let startVC = viewControllerAtIndex(tempIndex: 1)
            _ = startVC.view
            pageVC?.setViewControllers([startVC], direction: .reverse , animated: true, completion: nil)
            investmentLbl.textColor = UIColor.rgb(red: 255.0, green: 255.0, blue: 255.0, alpha: 0.5)
            investmentBottomView.backgroundColor = UIColor.clear
            investmentBottomView.isHidden = true
            taxSavingLbl.textColor = UIColor.white
            taxSavingBottomView.backgroundColor = UIColor.white
            taxSavingBottomView.isHidden = false
            retirmentLbl.textColor = UIColor.rgb(red: 255.0, green: 255.0, blue: 255.0, alpha: 0.5)
            retirmentBottomView.backgroundColor = UIColor.clear
            retirmentBottomView.isHidden = true
            investmentBtn.isUserInteractionEnabled    = true
            taxSavingBtn.isUserInteractionEnabled     = false
            retirementBtn.isUserInteractionEnabled    = true
            
        default:
            let startVC = viewControllerAtIndex(tempIndex: 2)
            _ = startVC.view
            pageVC?.setViewControllers([startVC], direction: .reverse , animated: true, completion: nil)
            investmentLbl.textColor = UIColor.rgb(red: 255.0, green: 255.0, blue: 255.0, alpha: 0.5)
            investmentBottomView.backgroundColor = UIColor.clear
            investmentBottomView.isHidden = true
            taxSavingLbl.textColor = UIColor.rgb(red: 255.0, green: 255.0, blue: 255.0, alpha: 0.5)
            taxSavingBottomView.backgroundColor = UIColor.clear
            taxSavingBottomView.isHidden = true
            retirmentLbl.textColor = UIColor.white
            retirmentBottomView.backgroundColor = UIColor.white
            retirmentBottomView.isHidden = false
            investmentBtn.isUserInteractionEnabled    = true
            taxSavingBtn.isUserInteractionEnabled     = true
            retirementBtn.isUserInteractionEnabled    = false
        }
    }
    
    @IBAction func navigateBackToVC(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func TapOnPagerBtn(_ sender: UIButton) {
        let tag = sender.tag
        navigateTopBarMenu(tag)
    }
    @IBAction func tapOnNotificationBtn(_ sender: Any) {
        let vc = NotificationsVC.instantiateFromAppStroyboard(appStoryboard: .home)
        self.navigationController?.pushViewController(vc, animated: true)
    }
       
    @IBAction func tapOnLoginBtn(_ sender: Any) {
        loginOption()
     }
}

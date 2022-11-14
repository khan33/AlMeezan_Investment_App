//
//  MainViewProtocol.swift
//  AlMeezan
//
//  Created by Atta khan on 23/09/2021.
//  Copyright © 2021 Atta khan. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper

protocol MainViewProtocol: AnyObject {
    func popViewController()
    func dismiss(animated: Bool)
    func popToRootViewController()
    func presentNav(vc: UIViewController)
    func presentTab(vc: UIViewController)
    func hasNoInternet()
    func hasServerError(message: String)
    func showRequestTimeOut()
    func navigationBarAppearance(_ appearance: Bool)
    func LogoutOption()
    func countNotificationBadge(_ btn: UIButton)
    func isUserLoggedIn() -> Bool
    func navigateThroughLeftMenu(_ page: LeftMenuPage)
    func isErrorMessage(withMessage message: String)
    
}
extension MainViewProtocol where Self: UIViewController {
    

    func popToRootViewController() {
        guard let vcs = navigationController?.viewControllers else { return }
        guard let vc = vcs.first else { return }
        navigationController?.popToViewController(vc, animated: false)
    }

    func popViewController() {
        navigationController?.popViewController(animated: true)
    }

    func pushViewController(vc: UIViewController, animated: Bool) {
        navigationController?.pushViewController(vc, animated: animated)
    }

    func dismiss(animated _: Bool) {
        dismiss(animated: true)
    }

    func presentNav(vc: UIViewController) {
        vc.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        present(vc, animated: true, completion: nil)
    }

    func presentTab(vc: UIViewController) {
        vc.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        tabBarController?.present(vc, animated: true, completion: nil)
    }
    func isErrorMessage(withMessage message: String) {
        
    }
    
    
    func hasNoInternet() {
        
    }
    func hasServerError(message: String){
        
    }
    func showRequestTimeOut(){
        
    }
    
    
    func navigationBarAppearance(_ appearance: Bool) {
        self.navigationController?.setNavigationBarHidden(!appearance, animated: true)
    }
    
    func LogoutOption() {
        
    }
    
    func countNotificationBadge(_ btn: UIButton) {
        Utility.shared.renderNotificationCount(btn)
    }
    func isUserLoggedIn() -> Bool {
        return KeychainWrapper.standard.string(forKey: "UserType") == "loggedInUser" ? true : false
    }
    
    func navigateThroughLeftMenu(_ page: LeftMenuPage) {
        switch page {
        case .login:
            if !isUserLoggedIn() {
                let vc = LoginViewController.instantiateFromAppStroyboard(appStoryboard: .home)
                navigationController?.pushViewController(vc, animated: true)
            } else {
                self.showConfirmationAlertViewWithTitle(title: "Alert", message: Message.logoutConfirmationMsg) {
                    let vc = ViewController.instantiateFromAppStroyboard(appStoryboard: .main)
                    self.navigationController?.pushViewController(vc, animated: false)
                    Utility.shared.logout()
                }
            }
            break
        case .news:
            let vc = NewsFeedVC.instantiateFromAppStroyboard(appStoryboard: .main)
            navigationController?.pushViewController(vc, animated: true)
            break
        case .userDetail:
            let vc = ProfileDetailsVC.instantiateFromAppStroyboard(appStoryboard: .home)
            navigationController?.pushViewController(vc, animated: true)
            break
        case .market:
            let vc = MarketWatchVC.instantiateFromAppStroyboard(appStoryboard: .marketWatch)
            navigationController?.pushViewController(vc, animated: true)
            break
        case .investment:
            let vc = InvestmentProductsVC.instantiateFromAppStroyboard(appStoryboard: .main)
            navigationController?.pushViewController(vc, animated: true)
            break
        case .whereInvest:
            let vc = WhereInvestVC.instantiateFromAppStroyboard(appStoryboard: .main)
            navigationController?.pushViewController(vc, animated: true)
            break
        case .fundPerformance:
            let vc = BlogsViewController.instantiateFromAppStroyboard(appStoryboard: .main)
            vc.urlStr = FUND_REPORTS
            vc.titleStr = "Fund Performance"
            navigationController?.pushViewController(vc, animated: true)
            break
        case .education:
            let vc = InvestmentEducationVC.instantiateFromAppStroyboard(appStoryboard: .main)
            navigationController?.pushViewController(vc, animated: true)
            break
        case .paymentService:
            let vc = PaymentServicesVC()
            self.navigationController?.pushViewController(vc, animated: true)
        case .defaultPage:
            break
        }
    }
    
   
}


enum LeftMenuPage {
    case news
    case userDetail
    case market
    case investment
    case whereInvest
    case paymentService
    case fundPerformance
    case education
    case login
    case defaultPage
}

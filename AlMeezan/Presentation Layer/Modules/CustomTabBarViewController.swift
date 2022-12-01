//
//  CustomTabBarViewController.swift
//  AlMeezan
//
//  Created by Atta khan on 11/09/2019.
//  Copyright © 2019 Atta khan. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

class CustomTabBarViewController: UITabBarController, UITabBarControllerDelegate {
    var selectedTabindex: Int = 2
    var isFromSideMenu: Bool = true
    
    private var viewComponents : [BottomTabBarViews] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        // Do any additional setup after loading the view.
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.logoutNotify), name: .logoutNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.notificationRecieved), name: .tabBarSwitchNotifications, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.leftmenuNotificationReceived), name: .leftMenuNotifications, object: nil)
        
        
        tabBar.barTintColor = .white
        tabBar.isTranslucent = false
        
        if #available(iOS 15.0, *) {
            let tabBarAppearance = UITabBarAppearance()
            let tabBarItemAppearance = UITabBarItemAppearance()
            tabBarAppearance.backgroundColor = .white
            tabBarItemAppearance.normal.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
            tabBarItemAppearance.selected.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.themeColor]
            tabBarAppearance.stackedLayoutAppearance = tabBarItemAppearance
            tabBar.standardAppearance = tabBarAppearance
            tabBar.scrollEdgeAppearance = tabBarAppearance
        }
    }
    
    deinit {
        //        NotificationCenter.default.removeObserver(
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    @objc func logoutNotify(notification: NSNotification) {
        selectedTabindex = 2
        isFromSideMenu = false
    }
    @objc func leftmenuNotificationReceived(notification: NSNotification) {
        selectedTabindex = self.selectedIndex
        isFromSideMenu = true
    }
    
    @objc func notificationRecieved(notification: NSNotification) {
        //        guard let userType = notification.userInfo!["UserType"] as? String else { return }
        guard let userType = KeychainWrapper.standard.string(forKey: "UserType") else { return }
        let index = notification.userInfo?["Index"] as? Int ?? 0
        let item = notification.userInfo?["item"] as? LeftMenuPage ?? .login
        let customerID = KeychainWrapper.standard.string(forKey: "CustomerId")!
        
        
        
        if userType == "loggedInUser" && customerID != "ibex" {
            updateTabBarFunction(index, item)
        } else {
            setTabBarFunction(index, item)
        }
    }
    
    private func setUIComponents() {
        viewComponents.removeAll()
        let customerID = KeychainWrapper.standard.string(forKey: "CustomerId")!
        guard let userType = KeychainWrapper.standard.string(forKey: "UserType") else { return }
        
        
        if userType == "loggedInUser" && customerID != "ibex" {
            viewComponents.append(.invest)
        } else {
            viewComponents.append(.onlineTransaction)
        }
        
        viewComponents.append(.nav)
        viewComponents.append(.home)
        viewComponents.append(.dashboard)
        viewComponents.append(.news)
        viewComponents.append(.status)
        viewComponents.append(.feedback)
    }
    
    
//    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
//        let isCorporateId = UserDefaults.standard.bool(forKey: "isCorporateId")
//                print(tabBarController.tabBar.items![0])
//                if isCorporateId && tabBarController.tabBar.selectedItem!.title! == "Transactions" {
//                    self.showAlert(title: "Alert", message: "Something went worng", controller: self) {
//
//                    }
//                    return false
//                } else {
//                    return true
//                }
//    }
    
    
    // Left Menu For Investor User
    func updateTabBarFunction(_ index: Int, _ page: LeftMenuPage) {
        let selectedColor   = UIColor.themeColor
        let unselectedColor = UIColor.lightGray
        UITabBarItem.appearance().setTitleTextAttributes(
            [NSAttributedString.Key.foregroundColor: unselectedColor, NSAttributedString.Key.font: UIFont(name: "Roboto-Regular", size: 11)!],
            for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes(
            [NSAttributedString.Key.foregroundColor: selectedColor, NSAttributedString.Key.font: UIFont(name: "Roboto-Regular", size: 11)!],
            for: .selected)
        
        
        
        
        
        
        let navSelectImage: UIImage! = UIImage(named: "nav_NAV_selected")?.withRenderingMode(.alwaysOriginal)
        let tabTwoBarItem = UITabBarItem(title: "NAV", image: UIImage(named: "nav_NAV"), selectedImage: navSelectImage)
        let vc2 = NAVViewController.instantiateFromAppStroyboard(appStoryboard: .main)
        NavConfigurator.configureModule(viewController: vc2)
        let a2 = UINavigationController(rootViewController: vc2)
        vc2.tabBarItem = tabTwoBarItem
        
        let dashboardSelectImage: UIImage! = UIImage(named: "dashboard_selected")?.withRenderingMode(.alwaysOriginal)
        let tabThreeBarItem = UITabBarItem(title: "Dashboard", image: UIImage(named: "dashboard"), selectedImage: dashboardSelectImage)
        let vc3 = DashboardViewController.instantiateFromAppStroyboard(appStoryboard: .home)
        let a3 = UINavigationController(rootViewController: vc3)
        vc3.tabBarItem = tabThreeBarItem
        
        
        let newsSelectImage: UIImage! = UIImage(named: "status_active")?.withRenderingMode(.alwaysOriginal)
        let tabFourBarItem = UITabBarItem(title: "Status", image: UIImage(named: "status_unactive"), selectedImage: newsSelectImage)
        let vc4 = StatusTransactionsVC.instantiateFromAppStroyboard(appStoryboard: .home)
        let a4 = UINavigationController(rootViewController: vc4)
        vc4.tabBarItem = tabFourBarItem
        
        let contactSelectImage: UIImage! = UIImage(named: "nav_contact_selected")?.withRenderingMode(.alwaysOriginal)
        let tabFiveBarItem = UITabBarItem(title: "Feedback", image: UIImage(named: "nav_contact"), selectedImage: contactSelectImage)
        let vc5 = ContactUsVC.instantiateFromAppStroyboard(appStoryboard: .main)
        let a5 = UINavigationController(rootViewController: vc5)
        vc5.tabBarItem = tabFiveBarItem
        
        
        let investSelectImage: UIImage! = UIImage(named: "nav_invest_selected")?.withRenderingMode(.alwaysOriginal)
        let tabOneBarItem = UITabBarItem(title: "Transactions", image: UIImage(named: "nav_invest"), selectedImage: investSelectImage)
        var vc1 = EServicesVC.instantiateFromAppStroyboard(appStoryboard: .home)
        let a1 = UINavigationController(rootViewController: vc1)
        vc1.tabBarItem = tabOneBarItem
        //        self.viewControllers = [a1,a2,a3,a4,a5]
        
        let isCorporateId = UserDefaults.standard.bool(forKey: "isCorporateId")
        
        if isCorporateId {
            if selectedTabindex == 0 {
                vc2.isFromSideMenu = isFromSideMenu
                vc2.selectedMenuItem = index
                vc2.page = page
            } else if selectedTabindex == 1 {
                vc3.isFromSideMenu = isFromSideMenu
                vc3.selectedMenuItem = index
            } else if selectedTabindex == 2 {
                vc4.isFromSideMenu = isFromSideMenu
                vc4.selectedMenuItem = index
            } else if selectedTabindex == 3 {
                vc5.isFromSideMenu = isFromSideMenu
                vc5.selectedMenuItem = index
            } else {
                vc2.isFromSideMenu = isFromSideMenu
                vc2.selectedMenuItem = index
            }
            self.viewControllers = [a2,a3,a4,a5]
            
        } else {
            if selectedTabindex == 0 {
                vc1.isFromSideMenu = isFromSideMenu
                vc1.selectedMenuItem = index
            } else if selectedTabindex == 1 {
                vc2.isFromSideMenu = isFromSideMenu
                vc2.selectedMenuItem = index
                vc2.page = page
            } else if selectedTabindex == 2 {
                vc3.isFromSideMenu = isFromSideMenu
                vc3.selectedMenuItem = index
            } else if selectedTabindex == 3 {
                vc4.isFromSideMenu = isFromSideMenu
                vc4.selectedMenuItem = index
            } else if selectedTabindex == 4 {
                vc5.isFromSideMenu = isFromSideMenu
                vc5.selectedMenuItem = index
            } else {
                vc1.isFromSideMenu = isFromSideMenu
                vc1.selectedMenuItem = index
            }
            self.viewControllers = [a1,a2,a3,a4,a5]
        }
    
        self.selectedIndex = selectedTabindex
    }
    
    
    // Left Menu For Anommymous User
    func setTabBarFunction(_ index: Int, _ page: LeftMenuPage) {
        let selectedColor   = UIColor.themeColor
        let unselectedColor = UIColor.lightGray
        UITabBarItem.appearance().setTitleTextAttributes(
            [NSAttributedString.Key.foregroundColor: unselectedColor, NSAttributedString.Key.font: UIFont(name: "Roboto-Regular", size: 11)!],
            for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes(
            [NSAttributedString.Key.foregroundColor: selectedColor, NSAttributedString.Key.font: UIFont(name: "Roboto-Regular", size: 11)!],
            for: .selected)
        
        
        let homeSelectImage: UIImage! = UIImage(named: "nav_home")?.withRenderingMode(.alwaysOriginal)
        let navSelectImage: UIImage! = UIImage(named: "nav_NAV_selected")?.withRenderingMode(.alwaysOriginal)
        let investSelectImage: UIImage! = UIImage(named: "nav_invest_selected")?.withRenderingMode(.alwaysOriginal)
        let newsSelectImage: UIImage! = UIImage(named: "nav_news_selected")?.withRenderingMode(.alwaysOriginal)
        let contactSelectImage: UIImage! = UIImage(named: "nav_contact_selected")?.withRenderingMode(.alwaysOriginal)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let tabOneBarItem = UITabBarItem(title: "Invest", image: UIImage(named: "nav_invest"), selectedImage: investSelectImage)
        let tabTwoBarItem = UITabBarItem(title: "NAV", image: UIImage(named: "nav_NAV"), selectedImage: navSelectImage)
        let tabThreeBarItem = UITabBarItem(title: "Home", image: UIImage(named: "homeIcon"), selectedImage: homeSelectImage)
        let tabFourBarItem = UITabBarItem(title: "News", image: UIImage(named: "nav_news"), selectedImage: newsSelectImage)
        let tabFiveBarItem = UITabBarItem(title: "Contact", image: UIImage(named: "nav_contact"), selectedImage: contactSelectImage)
        
        let vc3 = ViewController.instantiateFromAppStroyboard(appStoryboard: .main)
        let vc2 = NAVViewController.instantiateFromAppStroyboard(appStoryboard: .main)
        NavConfigurator.configureModule(viewController: vc2)
        let vc1 = InvestViewController.instantiateFromAppStroyboard(appStoryboard: .main)
        let vc4 = NewsFeedVC.instantiateFromAppStroyboard(appStoryboard: .main)
        let vc5 = ContactUsVC.instantiateFromAppStroyboard(appStoryboard: .main)
        
        
        let a1 = UINavigationController(rootViewController: vc1)
        let a2 = UINavigationController(rootViewController: vc2)
        let a3 = UINavigationController(rootViewController: vc3)
        let a4 = UINavigationController(rootViewController: vc4)
        let a5 = UINavigationController(rootViewController: vc5)
        
        vc1.tabBarItem = tabOneBarItem
        vc2.tabBarItem = tabTwoBarItem
        vc3.tabBarItem = tabThreeBarItem
        vc4.tabBarItem = tabFourBarItem
        vc5.tabBarItem = tabFiveBarItem
        
        
        if selectedTabindex == 0 {
            vc1.isFromSideMenu = isFromSideMenu
            vc1.selectedMenuItem = index
        } else if selectedTabindex == 1 {
            vc2.isFromSideMenu = isFromSideMenu
            vc2.selectedMenuItem = index
            vc2.page = page
        } else if selectedTabindex == 2 {
            vc3.isFromSideMenu = isFromSideMenu
            vc3.selectedMenuItem = index
        } else if selectedTabindex == 3 {
            vc4.isFromSideMenu = isFromSideMenu
            vc4.selectedMenuItem = index
        } else if selectedTabindex == 4 {
            vc5.isFromSideMenu = isFromSideMenu
            vc5.selectedMenuItem = index
        } else {
            vc1.isFromSideMenu = isFromSideMenu
            vc1.selectedMenuItem = index
        }
        
        
        
        self.viewControllers = [a1,a2,a3,a4,a5]
        self.selectedIndex = selectedTabindex
    }
    
}
extension UIImage {
    
    class func imageWithColor(color: UIColor, size: CGSize) -> UIImage {
        let rect: CGRect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage! = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    
    class func createSelectionIndicator(color: UIColor, size: CGSize, lineWidth: CGFloat) -> UIImage {
        let rect: CGRect = CGRect(x: 0, y: size.height, width: size.width, height: lineWidth)
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage! = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
        
        
    }
    
}
extension UITabBar {
    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        super.sizeThatFits(size)
        guard let window = UIApplication.shared.keyWindow else {
            return super.sizeThatFits(size)
        }
        var sizeThatFits = super.sizeThatFits(size)
        sizeThatFits.height = window.safeAreaInsets.bottom + 40
        return sizeThatFits
    }
}



enum BottomTabBarViews {
    case invest
    case onlineTransaction
    case nav
    case home
    case dashboard
    case news
    case status
    case feedback
    
    
    var name: String {
        switch self {
        case .invest:
            return "invest"
        case .onlineTransaction:
            return "transaction"
        case .nav:
            return "nav"
        case .home:
            return "home"
        case .dashboard:
            return "dashboard"
        case .news:
            return "news"
        case .status:
            return "status"
        case .feedback:
            return "feedback"
        }
    }
    
    
}

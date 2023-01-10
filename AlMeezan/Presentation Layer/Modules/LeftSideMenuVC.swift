//
//  LeftSideMenuVC.swift
//  AlMeezan
//
//  Created by Atta khan on 25/10/2019.
//  Copyright © 2019 Atta khan. All rights reserved.
//

import UIKit
import PKRevealController
import SwiftKeychainWrapper

struct MenuItems {
    var name: String
    var image: String
    var page: LeftMenuPage
}

enum LoginStatus: String {
    case login = "Investor Login"
    case logout = "Logout"
}

class LeftSideMenuVC: UIViewController, MainViewProtocol {
    @IBOutlet weak var tableView: UITableView!
    var menuItems:[MenuItems] = []
    var window: UIWindow?
    var loginStutus: LoginStatus = LoginStatus.login
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.notificationRecieved), name: .menuItemsSwitchNotifications, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideNavigationBar()
        updateLoginStatus()
        updateMenuItems()
        setUpTableView()
    }
    
    private func updateLoginStatus() {
        loginStutus = isUserLoggedIn() ? .logout : .login
    }
    
    @objc func notificationRecieved(notification: NSNotification) {
        updateLoginStatus()
        updateMenuItems()
    }
    
    private func updateMenuItems() {
        menuItems.removeAll()
        let news = MenuItems(name: "Market News", image: "nav_news", page: .news)
        let marketWatch = MenuItems(name: "Market Watch", image: "marketWatchIcon", page: .market)
        let investmentProduct = MenuItems(name: "Investment Products", image: "investmentProductsIcon", page: .investment)
        let invest = MenuItems(name: "Where to Invest?", image: "where_to_invest", page: .whereInvest)
        let payment_service = MenuItems(name: "Payment Services", image: "where_to_invest", page: .paymentService)
        
        let fundPerformance = MenuItems(name: "Fund Performance Reports", image: "fundPerformanceIcon", page: .fundPerformance)
        let education = MenuItems(name: "Investor Education", image: "investmentEducationIcon", page: .education)
        let myDetails = MenuItems(name: "My Details", image: "investorLoginIcon", page: .userDetail)
        let img = loginStutus == .login ? "investorLoginIcon" : "logout-icon-1"
        let logout = MenuItems(name: loginStutus.rawValue, image: img, page: .login)
        
        
        if loginStutus == .logout {
            menuItems.append(news)
        }
        menuItems.append(marketWatch)
        menuItems.append(investmentProduct)
        menuItems.append(invest)
        
        if loginStutus == .logout {
           // menuItems.append(payment_service)
        }
        
        
        menuItems.append(fundPerformance)
        menuItems.append(education)
        
        if loginStutus == .logout {
            menuItems.append(myDetails)
        }
        menuItems.append(logout)
    }
    
    func setUpTableView(){
        tableView.register(LeftMenuHeaderCell.nib, forCellReuseIdentifier: LeftMenuHeaderCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white
        tableView.reloadData()
    }
    
}

extension LeftSideMenuVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LeftMenuHeaderCell.identifier, for: indexPath) as! LeftMenuHeaderCell
        cell.menuTitle.text = menuItems[indexPath.row].name
        cell.imgView.image = UIImage(named: menuItems[indexPath.row].image)?.withRenderingMode(.alwaysTemplate)
        cell.imgView.tintColor = UIColor.gray
        cell.backgroundColor = .white
        cell.cellBtn.tag = indexPath.row
        cell.cellBtn.addTarget(self, action: #selector(handleExpandClose(_:)), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 66.0
    }
    @objc func handleExpandClose(_ sender: UIButton) {
        let section = sender.tag
        let page = menuItems[section].page
        self.revealController.resignPresentationModeEntirely(true, animated: true, completion: nil)
        
        NotificationCenter.default.post(name: .leftMenuNotifications, object: nil) // Observer in CustomTab Controller
        
        NotificationCenter.default.post(name: .tabBarSwitchNotifications, object: nil, userInfo: ["Index": section, "item": page])
        
        
//        let vc = MarketWatchVC.instantiateFromAppStroyboard(appStoryboard: .marketWatch)
//        Utility.shared.goToHomeController(vc: vc, navController: navigationController)
        
        
    }
    
}

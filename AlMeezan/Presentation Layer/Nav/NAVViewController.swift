//
//  NAVViewController.swift
//  AlMeezan
//
//  Created by Atta khan on 11/09/2019.
//  Copyright © 2019 Atta khan. All rights reserved.
//

import UIKit
import SVProgressHUD
import SwiftKeychainWrapper

class NAVViewController: BaseViewController, UIGestureRecognizerDelegate, MainViewProtocol {
    //MARK: - IBOutlet
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var notificationBtn: UIButton!
    @IBOutlet weak var countNotificationLbl: UIButton!

    //MARK: - Properties
    var isFromSideMenu: Bool = false
    var selectedMenuItem: Int = 0
    var page: LeftMenuPage = .defaultPage
    private let refreshControl = UIRefreshControl()
    
    
    var displayedFunds: [NavEntity.NavViewModel.DisplayedFund] = []
    var interactor: NavInteractorProtocol?
    var router: NavRouterProtocol?
    
    //MARK: - Controller Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        countNotificationLbl.isHidden = true
        
        if isFromSideMenu {
            print("navigate to following page: \(page)")
            navigateThroughLeftMenu(page)
        }
        
        tableView.registerCells([NAVHeaderCell.self])
        router?.navigationController = navigationController
        SVProgressHUD.show()
        interactor?.viewDidLoad()
        
        refreshControl.addTarget(self, action: #selector(refreshTableViewData(_:)), for: .valueChanged)
        if #available(iOS 10, *){
           tableView.refreshControl = refreshControl
        } else {
           tableView.addSubview(refreshControl)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        countNotificationBadge(countNotificationLbl)
        navigationBarAppearance(false)
        let image = isUserLoggedIn() ? "logout-icon-1" : "logout-icon"
        loginBtn.setImage(UIImage(named: image), for: .normal)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if SVProgressHUD.isVisible() {
            SVProgressHUD.dismiss()
        }
    }
    
   
    //MARK: - METHOD
    private func configTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor(red: 244.0 / 255.0, green: 246.0 / 255.0, blue: 255.0 / 255.0, alpha: 1)
        tableView.reloadData()
    }
    @objc private func refreshTableViewData(_ sender: Any) {
        interactor?.fetchNavFunds()
    }
    
    //MARK: - IBAction
    
    @IBAction func tapOnMenuBtn(_ sender: Any) {
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
extension NAVViewController: NAVViewControllerProtocol {
    func displayFetchedFund(viewModel: NavEntity.NavViewModel) {
        DispatchQueue.main.async {
            SVProgressHUD.dismiss()
            self.displayedFunds = viewModel.displayFund
            self.displayedFunds = self.displayedFunds.sorted(by: { $0.fundsort < $1.fundsort })
            self.configTableView()
        }
    }
}
// MARK:- TableView DataSource & Delegate


extension NAVViewController : UITableViewDelegate , UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return interactor?.numberOfRows ?? 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: NAVHeaderCell.self, for: indexPath)
        let data = displayedFunds[indexPath.section]
        interactor?.handleCell(section: indexPath.section, cell: cell, data: data)
        cell.didTapOnCell = { [unowned self] in
            router?.routerToNavSummery(with: indexPath.section, nav_data: displayedFunds)
        }
        cell.backgroundColor = .red
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 66.0
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor(red: 244.0 / 255.0, green: 246.0 / 255.0, blue: 255.0 / 255.0, alpha: 1)
        return view
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5.0
    }
    
}


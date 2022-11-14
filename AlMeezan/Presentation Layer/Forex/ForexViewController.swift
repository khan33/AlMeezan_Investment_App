//
//  ForexViewController.swift
//  AlMeezan
//
//  Created by Atta khan on 21/11/2019.
//  Copyright © 2019 Atta khan. All rights reserved.
//

import UIKit
import SVProgressHUD
import SwiftKeychainWrapper

class ForexViewController: BaseViewController {

    @IBOutlet weak var updatedTimeLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var notificationBtn: UIButton!
    @IBOutlet weak var countNotificationLbl: UIButton!

    var forex_data: [ForexModel]?
    
    
    private let refreshControl = UIRefreshControl()
    
    
    var interactor: ForexInteractorProtocol?
    var router: ForexRouterProtocol?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl.addTarget(self, action: #selector(refreshTableViewData(_:)), for: .valueChanged)
        if #available(iOS 10, *){
           tableView.refreshControl = refreshControl
        } else {
           tableView.addSubview(refreshControl)
        }
        countNotificationLbl.isHidden = true
        interactor?.fetchForexList()
    }
    
    
    @objc private func refreshTableViewData(_ sender: Any) {
       fetchData(false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Utility.shared.renderNotificationCount(self.countNotificationLbl)
        fetchData(true)
        if let userAuth = KeychainWrapper.standard.string(forKey: "UserType") {
            if userAuth == "loggedInUser" {
                loginBtn.setImage(UIImage(named: "logout-icon-1"), for: .normal)
            } else {
                loginBtn.setImage(UIImage(named: "logout-icon"), for: .normal)
            }
        }
        self.setUpTableView()
    }
    
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        SVProgressHUD.dismiss()
    }
    func fetchData(_ show: Bool) {
        let startDate =   Date().toString(format: "yyyyMMdd")
        let endDate     =   Date().toString(format: "yyyyMMdd")
        let bodyParam = RequestBody(StartDate: startDate, EndDate: endDate)
        let bodyRequest = bodyParam.encryptData(bodyParam)
        let url = URL(string: FOREXSPOT)!
        if show {
            SVProgressHUD.show()
        }
        WebServiceManager.sharedInstance.fetch(params: bodyRequest as Dictionary<String, AnyObject>, url: url, serviceType: "Cache Data", modelType: ForexModel.self, errorMessage: { (errorMessage) in
            errorResponse = errorMessage
            self.showErrorMsg(errorMessage)
        }, success: { (response) in
            self.forex_data = response
            
            self.forex_data = self.forex_data?.sorted(by: { ($0.symbol as! String) < ($1.symbol as! String) } )
            if self.forex_data?.count ?? 0 > 0 {
                if let date = self.forex_data?[0].entrydatetime {
                    let time = Utility.shared.converTimeString(date)
                    self.updatedTimeLbl.text = "Last updated on \(time)"
                }
            }
            
            self.setUpTableView()
            self.refreshControl.endRefreshing()
        }, fail: { (error) in
            print(error.localizedDescription)
        }, showHUD: true)
    }
    
    
    
    private func setUpTableView() {
        //tableView.backgroundColor = UIColor.white
        tableView.separatorStyle = .none
        tableView.register(ForexViewCell.nib, forCellReuseIdentifier: ForexViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }
    
    @IBAction func navigateBackScreen(_ sender: Any) {
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

extension ForexViewController: UITableViewDelegate {
    
}
extension ForexViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        var numOfSections: Int = 0
        if (NetworkState().isInternetAvailable) {
            numOfSections = 1
        } else {
            Utility.shared.emptyTableView(tableView)
        }
        return numOfSections
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forex_data?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ForexViewCell.identifier, for: indexPath) as! ForexViewCell
        cell.selectionStyle = .none
        
        if let data = forex_data?[indexPath.row] {
            cell.forexData = ForexEntity.ForexViewModel(data)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 36.0
    }
}

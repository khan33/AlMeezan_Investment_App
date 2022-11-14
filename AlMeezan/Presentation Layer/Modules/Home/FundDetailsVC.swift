//
//  FundDetailsVC.swift
//  AlMeezan
//
//  Created by Atta khan on 05/11/2019.
//  Copyright © 2019 Atta khan. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

class FundDetailsVC: UIViewController {

    
    
    @IBOutlet weak var portfolioLbl: UILabel!
    @IBOutlet weak var fundTitleLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var totalRedemptionLbl: UILabel!
    @IBOutlet weak var totalInvestmentLbl: UILabel!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var notificationBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(StatusTransactionsViewCell.nib, forCellReuseIdentifier: StatusTransactionsViewCell.identifier)
        let headerView = UINib.init(nibName: "FundHeaderCell", bundle: nil)
        tableView.register(headerView, forHeaderFooterViewReuseIdentifier: "FundHeaderCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
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
    }
    
    @IBAction func backToNavigate(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
extension FundDetailsVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = tableView.dequeueReusableHeaderFooterView(withIdentifier: "FundHeaderCell") as! FundHeaderCell
        return headerCell
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20.0
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StatusTransactionsViewCell.identifier) as! StatusTransactionsViewCell
        cell.selectionStyle = .none
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88.0
    }
    
}

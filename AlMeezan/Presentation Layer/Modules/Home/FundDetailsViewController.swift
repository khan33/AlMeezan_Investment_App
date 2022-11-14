//
//  FundDetailsViewController.swift
//  AlMeezan
//
//  Created by Atta khan on 26/11/2019.
//  Copyright © 2019 Atta khan. All rights reserved.
//

import UIKit
import SVProgressHUD
import SwiftKeychainWrapper

class FundDetailsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var portfolioId: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var totalRedemptionLbl: UILabel!
    @IBOutlet weak var totalInvestmentLbl: UILabel!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var notificationBtn: UIButton!
    @IBOutlet weak var countNotificationLbl: UIButton!

    var fund_id: String = "800100-100"
    var portfolio_id: String?
    var fund_shortname: String = ""
    var totalInvestment: Float = 0.0
    var totalRedemption: Float = 0.0
    
    var filterTransactions: [String: [TransactionDetail]] = [:]
    var uniqueTransaction: [String]?
    
    var transaction_details: [TransactionDetail]?
    override func viewDidLoad() {
        super.viewDidLoad()
        portfolioId.text = portfolio_id //UserDefaults.standard.string(forKey: "portfolioId") ?? ""
        if !(portfolio_id?.contains("-") ?? false) {
            portfolio_id = "All"
            portfolioId.text =  Message.allPortfolio
        }
         countNotificationLbl.isHidden = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Utility.shared.renderNotificationCount(countNotificationLbl)
        titleLbl.text = fund_shortname
        totalRedemptionLbl.text = "PKR \(String(describing: totalRedemption ).toCurrencyFormat(withFraction: false))"
        totalInvestmentLbl.text = "PKR \(String(describing: totalInvestment ).toCurrencyFormat(withFraction: false))"
        hideNavigationBar()
        getData()
        if let userAuth = KeychainWrapper.standard.string(forKey: "UserType") {
            if userAuth == "loggedInUser" {
                loginBtn.setImage(UIImage(named: "logout-icon-1"), for: .normal)
            } else {
                loginBtn.setImage(UIImage(named: "logout-icon"), for: .normal)
            }
        }
    }
    
     func configTableView() {
        tableView.register(StatusTransactionsViewCell.nib, forCellReuseIdentifier: StatusTransactionsViewCell.identifier)
        let headerView = UINib.init(nibName: "FundHeaderCell", bundle: nil)
        tableView.register(headerView, forHeaderFooterViewReuseIdentifier: "FundHeaderCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }
    
    private func filterFunds() {
        filterTransactions.removeAll()
        
        uniqueTransaction = self.transaction_details?.compactMap( { return $0.dealdate} ).unique()
        
        
        for(_, obj) in (uniqueTransaction?.enumerated())! {
            let trnasaction = self.transaction_details?.filter({ $0.dealdate == obj})
            filterTransactions[obj] = trnasaction
        }
        
        configTableView()
    }
    
    func getData() {
        
        
        //let paramStr = "{CustomerID':\(id),AccessToken':\(token),Portfolioid':\(portfolio_id!),Fundid':\(fund_id)}"
        
        
        let bodyParam = RequestBody(PortfolioID: portfolio_id, FundID: fund_id)
        let bodyRequest = bodyParam.encryptData(bodyParam)
        let url = URL(string: TRANSACTION_DETAILS)!
        SVProgressHUD.show()
        
        WebServiceManager.sharedInstance.fetch(params: bodyRequest as Dictionary<String, AnyObject>, url: url, serviceType: "Transaction Detail", modelType: TransactionDetail.self, errorMessage: { (errorMessage) in
            errorResponse = errorMessage
            self.showErrorMsg(errorMessage)
        }, success: { (response) in
            self.transaction_details = response
            self.filterFunds()
            
        }, fail: { (error) in
            print(error.localizedDescription)
        }, showHUD: true)

    }
    
    @IBAction func navigateBackBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func logoutBtn(_ sender: Any) {
        loginOption()
    }
    @IBAction func tapOnNotificationBtn(_ sender: Any) {
        let vc = NotificationsVC.instantiateFromAppStroyboard(appStoryboard: .home)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension FundDetailsViewController: UITableViewDelegate {
}


extension FundDetailsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return uniqueTransaction?.count ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = tableView.dequeueReusableHeaderFooterView(withIdentifier: "FundHeaderCell") as! FundHeaderCell
        
        headerCell.fundGroupName.text = ""
        if let dateStr = uniqueTransaction?[section] {
            let strDate =  dateStr.toDate(withFormat: "dd.MM.yy")
            let strValue = strDate?.toString(format: "MMM d, yyyy")
            headerCell.fundGroupName.text = strValue
        }
        
        return headerCell
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
       return 20.0
      
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterTransactions[(uniqueTransaction?[section])!]!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StatusTransactionsViewCell.identifier) as! StatusTransactionsViewCell
        cell.selectionStyle = .none
        
        cell.transaction_details = filterTransactions[(uniqueTransaction?[indexPath.section])!]![indexPath.row]
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88.0
    }
    
}

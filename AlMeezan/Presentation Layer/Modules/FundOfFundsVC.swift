//
//  FundOfFundsVC.swift
//  AlMeezan
//
//  Created by Atta khan on 04/10/2019.
//  Copyright © 2019 Atta khan. All rights reserved.
//

import UIKit
import SVProgressHUD

class FundOfFundsVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var fund_desc_model: [FundOfFund]?
    private let refreshControl = UIRefreshControl()
    override func viewDidLoad() {
        super.viewDidLoad()
        getAllFundsDescription(true)
        refreshControl.addTarget(self, action: #selector(refreshTableViewData(_:)), for: .valueChanged)
        if #available(iOS 10, *){
           tableView.refreshControl = refreshControl
        } else {
           tableView.addSubview(refreshControl)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideNavigationBar()
    }
    @objc private func refreshTableViewData(_ sender: Any) {
       getAllFundsDescription(false)
    }
    func getAllFundsDescription(_ show: Bool){
        let bodyParam = RequestBody()
        let bodyRequest = bodyParam.encryptData(bodyParam)
        let url = URL(string: FOF_DESCRIPTION)!
        if show {
            SVProgressHUD.show()
        }
        WebServiceManager.sharedInstance.fetch(params: bodyRequest as Dictionary<String, AnyObject>, url: url, serviceType: "Fund Description", modelType: FundOfFund.self, errorMessage: { (errorMessage) in
            errorResponse = errorMessage
            if let id = errorResponse?[0].errID {
                let message = showErrorMessage(id)
                self.showAlert(title: "Alert", message: message, controller: self) {
                    
                }
            }
        }, success: { (response) in
             self.fund_desc_model = response
             self.setUpTableView()
            self.refreshControl.endRefreshing()
        }, fail: { (error) in
            print(error.localizedDescription)
        }, showHUD: true)
    
    }
    
    
    func setUpTableView() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60
        tableView.register(NAVHeaderCell.nib, forCellReuseIdentifier: NAVHeaderCell.identifier)
        tableView.register(DescriptionViewCell.nib, forCellReuseIdentifier: DescriptionViewCell.identifier)
        tableView.register(FundDescriptionCell.nib, forCellReuseIdentifier: FundDescriptionCell.identifier)
        tableView.register(DescriptionTableViewCell.nib, forCellReuseIdentifier: DescriptionTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }
}
extension FundOfFundsVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return fund_desc_model?.count ?? 0 + 3
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = UIView()
        headerCell.backgroundColor = UIColor.rgb(red: 244, green: 246, blue: 250, alpha: 1)
        return headerCell
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10.0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.section == 0 {
            let cell    = tableView.dequeueReusableCell(withIdentifier: DescriptionTableViewCell.identifier, for: indexPath) as! DescriptionTableViewCell
            cell.investLbl.text = fund_desc_model?[0].whoShouldInvest
            cell.descriptionLbl.text = fund_desc_model?[0].description
            let keyBenfit =  fund_desc_model?[0].keyBenefits
                //?.replacingOccurrences(of: "•", with: "\n\n\u{2022}", options: NSString.CompareOptions.literal, range: nil)
            cell.keyBenfitsLbl.text = keyBenfit!
            
            
            
            
            
            return cell
        }
        else {
            if (fund_desc_model?[indexPath.section].isExpanded)! {
                let expandedCell    = tableView.dequeueReusableCell(withIdentifier: FundDescriptionCell.identifier, for: indexPath) as! FundDescriptionCell
                expandedCell.data   = fund_desc_model?[indexPath.section]
                return expandedCell
            } else {
                let headerCell      = tableView.dequeueReusableCell(withIdentifier: NAVHeaderCell.identifier, for: indexPath) as! NAVHeaderCell
                headerCell.fundTitleLbl.text = fund_desc_model?[indexPath.section].fundName
                headerCell.tapBtn.isHidden = true
                headerCell.indicatorBtn.setImage(UIImage(named: "unActivedownArrow"), for: .normal)
                return headerCell
            }
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return UITableView.automaticDimension
        }
        if (fund_desc_model?[indexPath.section].isExpanded)! {
            return UITableView.automaticDimension
        }
        return 60.0
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let isExpand = (fund_desc_model?[indexPath.section].isExpanded)!
        fund_desc_model?[indexPath.section].isExpanded = !isExpand
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}

//
//  FundsViewController.swift
//  AlMeezan
//
//  Created by Atta khan on 04/10/2019.
//  Copyright © 2019 Atta khan. All rights reserved.
//

import UIKit
import SVProgressHUD

class FundsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var tag: Bool = true
    private let refreshControl = UIRefreshControl()
    var fund_data: [AllFundsDescription]?
    override func viewDidLoad() {
        super.viewDidLoad()
        if (NetworkState().isInternetAvailable) {
            getAllFunds(true)
        } else {
            PersistenceServices.shared.fetch(AllFundsDescription.self) { [weak self] (data) in
                self?.fund_data = data
                self?.setUpTableView()
            }
        }
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
    
    override func viewWillDisappear(_ animated: Bool) {
        if SVProgressHUD.isVisible() {
            SVProgressHUD.dismiss()
        }
    }
    
    @objc private func refreshTableViewData(_ sender: Any) {
       getAllFunds(false)
    }
    func getAllFunds(_ show: Bool){        
        let bodyParam = RequestBody(FundType: "All")
        let bodyRequest = bodyParam.encryptData(bodyParam)
        let url = URL(string: ALL_FUND_DESCRIPTION)!
        if show {
            SVProgressHUD.show()
        }
        
        WebServiceManager.sharedInstance.fetch(params: bodyRequest as Dictionary<String, AnyObject>, url: url, serviceType: "Cache Data", modelType: AllFundsDescription.self, errorMessage: { (errorMessage) in
            errorResponse = errorMessage
            self.showErrorMsg(errorMessage)
        }, success: { (response) in
            self.fund_data = response
            self.setUpTableView()
            self.refreshControl.endRefreshing()
        }, fail: { (error) in
            print(error.localizedDescription)
        }, showHUD: true)
        
    }
    func setUpTableView() {
        let headerView = UINib.init(nibName: "FundsViewCell", bundle: nil)
        tableView.register(headerView, forHeaderFooterViewReuseIdentifier: "FundsViewCell")
        tableView.register(FundsExpandableViewCell.nib, forCellReuseIdentifier: FundsExpandableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }
    
}
extension FundsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return fund_data?.count ?? 0
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
         let headerCell = tableView.dequeueReusableHeaderFooterView(withIdentifier: "FundsViewCell") as! FundsViewCell
         headerCell.fundNameLbl.text = fund_data?[section].fundGroup
         headerCell.cellBtn.tag = section
         let isExpanded = fund_data?[section].isExpandable
         if !isExpanded! {
             headerCell.fundNameLbl.textColor = UIColor.themeColor
             headerCell.indicatorBtn.setImage(UIImage(named: "unActiveupArrow"), for: .normal)
         } else {
             headerCell.indicatorBtn.setImage(UIImage(named: "unActivedownArrow"), for: .normal)
             headerCell.fundNameLbl.textColor = UIColor.themeLblColor
         }
         headerCell.cellBtn.addTarget(self, action: #selector(handleExpandClose), for: .touchUpInside)
         return headerCell
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 66.0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (fund_data?[section].isExpandable)! {
                return 0
            }
        let data = Array(fund_data?[section].fundDescription ?? [])
        return data.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FundsExpandableViewCell.identifier, for: indexPath) as! FundsExpandableViewCell
        let data = Array(fund_data?[indexPath.section].fundDescription ?? [])
        cell.fundNameLbl.text = data[indexPath.row].fundName
        cell.fundNameLbl.textColor = UIColor.init(rgb: 0x008641)
        let totalRow = tableView.numberOfRows(inSection: indexPath.section)
        cell.bottomView.isHidden = false
        if(indexPath.row == totalRow - 1)  {
            cell.bottomView.isHidden = true
        }
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
    
    @objc func handleExpandClose(sender: UIButton) {
        
        let section = sender.tag
        let sectionHeaderView: FundsViewCell = tableView.headerView(forSection: section) as! FundsViewCell
        
        var indexPaths = [IndexPath]()
        let data = Array(fund_data?[section].fundDescription ?? [])
        for row in (data.indices) {
            print(0, row)
            let indexPath = IndexPath(row: row, section: section)
            indexPaths.append(indexPath)
        }
        
        let isExpanded = fund_data?[section].isExpandable
        fund_data?[section].isExpandable = !isExpanded!
        
        if isExpanded! {
            sectionHeaderView.fundNameLbl.textColor = UIColor.themeColor
            sectionHeaderView.indicatorBtn.setImage(UIImage(named: "unActiveupArrow"), for: .normal)
            tableView.insertRows(at: indexPaths, with: .fade)
        } else {
            sectionHeaderView.indicatorBtn.setImage(UIImage(named: "unActivedownArrow"), for: .normal)
            sectionHeaderView.fundNameLbl.textColor = UIColor.themeLblColor
            tableView.deleteRows(at: indexPaths, with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = InvestmentProductDetailVC.instantiateFromAppStroyboard(appStoryboard: .main)
        let data = Array(fund_data?[indexPath.section].fundDescription ?? [])
        vc.fund_details = data[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }

}

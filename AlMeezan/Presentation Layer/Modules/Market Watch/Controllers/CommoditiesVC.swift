//
//  CommoditiesVC.swift
//  AlMeezan
//
//  Created by Atta khan on 22/11/2019.
//  Copyright © 2019 Atta khan. All rights reserved.
//

import UIKit
import SVProgressHUD
import SwiftKeychainWrapper

class CommoditiesVC: BaseViewController {

    @IBOutlet weak var updatedTimeLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var notificationBtn: UIButton!
    @IBOutlet weak var countNotificationLbl: UIButton!

    @IBOutlet weak var goldBtn: UIButton!
    @IBOutlet weak var silverBtn: UIButton!
    @IBOutlet weak var oilBtn: UIButton!
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var goldLbl: UILabel!
    @IBOutlet weak var goldView: UIView!
    @IBOutlet weak var sliverView: UIView!
    @IBOutlet weak var sliverLbl: UILabel!
    @IBOutlet weak var oilView: UIView!
    @IBOutlet weak var oilLbl: UILabel!
    private let refreshControl = UIRefreshControl()
    var commodities: [CommoditiesModel]?
    var filter_commodities: [CommoditiesModel]?
    var current_state : CommoditiesState = CommoditiesState.gold
    override func viewDidLoad() {
        super.viewDidLoad()
        contentView.backgroundColor = UIColor(red: 244.0/255.0, green: 246.0/255.0, blue: 250.0/255.0, alpha: 1.0)
        fetchData()
        if let userAuth = KeychainWrapper.standard.string(forKey: "UserType") {
            if userAuth == "loggedInUser" {
                loginBtn.setImage(UIImage(named: "logout-icon-1"), for: .normal)
            } else {
                loginBtn.setImage(UIImage(named: "logout-icon"), for: .normal)
            }
        }
        refreshControl.addTarget(self, action: #selector(refreshTableViewData(_:)), for: .valueChanged)
        if #available(iOS 10, *){
           tableView.refreshControl = refreshControl
        } else {
           tableView.addSubview(refreshControl)
        }
        countNotificationLbl.isHidden = true
    }
    @objc private func refreshTableViewData(_ sender: Any) {
       fetchData()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.setUpTableView()
        Utility.shared.renderNotificationCount(self.countNotificationLbl)
    }

    override func viewWillDisappear(_ animated: Bool) {
        SVProgressHUD.dismiss()
    }
    private func setUpTableView() {
        tableView.backgroundColor = UIColor(red: 244.0/255.0, green: 246.0/255.0, blue: 250.0/255.0, alpha: 1.0)
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 160.0
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(CommodityViewCell.nib, forCellReuseIdentifier: CommodityViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }
    func updateUI() {
        if self.filter_commodities?.count ?? 0 > 0 {
            if let date = filter_commodities?[0].entryDate {
                let time = Utility.shared.converTimeString(date)
                updatedTimeLbl.text = "Last updated on \(time)"
            }
        }
    }
    
    func removeCommodity() {
        filter_commodities?.removeAll()
    }
    private func fetchData() {
        let bodyParam = RequestBody()
        let bodyRequest = bodyParam.encryptData(bodyParam)
        let url = URL(string: COMMODITIES)!
        SVProgressHUD.show()
        
        WebServiceManager.sharedInstance.fetch(params: bodyRequest as Dictionary<String, AnyObject>, url: url, serviceType: "PSX SECTOR TOP", modelType: CommoditiesModel.self, errorMessage: { (errorMessage) in
            errorResponse = errorMessage
            self.showErrorMsg(errorMessage)
        }, success: { (response) in
            self.commodities = response
            self.removeCommodity()
            self.filter_commodities = self.commodities?.filter( {$0.symbol == "Gold"})
            self.updateUI()
            self.setUpTableView()
            self.refreshControl.endRefreshing()
        }, fail: { (error) in
            print(error.localizedDescription)
        }, showHUD: true)
    }
    func navigateTopBarMenu(_ tag: Int) {
        switch tag {
        case 0:
            goldLbl.textColor = UIColor.white
            goldView.backgroundColor = UIColor.white
            goldView.isHidden = false
            sliverLbl.textColor = UIColor.rgb(red: 255.0, green: 255.0, blue: 255.0, alpha: 0.5)
            sliverView.backgroundColor = UIColor.clear
            sliverView.isHidden = true
            oilLbl.textColor = UIColor.rgb(red: 255.0, green: 255.0, blue: 255.0, alpha: 0.5)
            oilView.backgroundColor = UIColor.clear
            oilView.isHidden = true
            current_state = .gold
            filter_commodities = commodities?.filter( {$0.symbol == "Gold"})
            self.tableView.reloadData()
            self.updateUI()
            goldBtn.isUserInteractionEnabled    = false
            silverBtn.isUserInteractionEnabled   = true
            oilBtn.isUserInteractionEnabled     = true
         case 1:
            sliverLbl.textColor = UIColor.white
            sliverView.backgroundColor = UIColor.white
            sliverView.isHidden = false
            oilLbl.textColor = UIColor.rgb(red: 255.0, green: 255.0, blue: 255.0, alpha: 0.5)
            oilView.backgroundColor = UIColor.clear
            oilView.isHidden = true
            goldLbl.textColor = UIColor.rgb(red: 255.0, green: 255.0, blue: 255.0, alpha: 0.5)
            goldView.backgroundColor = UIColor.clear
            goldView.isHidden = true
            current_state = .sliver
            filter_commodities = commodities?.filter( {$0.symbol == "Silver"})
            UIView.transition(with: contentView, duration: 5, options: .curveLinear, animations: {
                self.tableView.reloadData()
                self.updateUI()
                
            }, completion: nil)
            goldBtn.isUserInteractionEnabled    = true
            silverBtn.isUserInteractionEnabled   = false
            oilBtn.isUserInteractionEnabled     = true
            
     default:
         oilLbl.textColor = UIColor.white
         oilView.backgroundColor = UIColor.white
         oilView.isHidden = false
         goldLbl.textColor = UIColor.rgb(red: 255.0, green: 255.0, blue: 255.0, alpha: 0.5)
         goldView.backgroundColor = UIColor.clear
         goldView.isHidden = true
         sliverLbl.textColor = UIColor.rgb(red: 255.0, green: 255.0, blue: 255.0, alpha: 0.5)
         sliverView.backgroundColor = UIColor.clear
         sliverView.isHidden = true
         current_state = .Oil
         filter_commodities = commodities?.filter( {$0.symbol == "Oil Wti"})
         UIView.transition(with: contentView, duration: 1.0, options: .curveLinear, animations: {
                self.tableView.reloadData()
            self.updateUI()
                
            }, completion: nil)
        goldBtn.isUserInteractionEnabled    = true
        silverBtn.isUserInteractionEnabled   = true
        oilBtn.isUserInteractionEnabled     = false
     }
    }
    @IBAction func tapOnTabBar(_ sender: UIButton) {
        let tag = sender.tag
        navigateTopBarMenu(tag)
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
extension CommoditiesVC: UITableViewDelegate {
    
}
extension CommoditiesVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        var numOfSections: Int = 0
        if (NetworkState().isInternetAvailable) {
            tableView.backgroundView = nil
            numOfSections = 1
        } else {
            Utility.shared.emptyTableView(tableView)
        }
        return numOfSections
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filter_commodities?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CommodityViewCell.identifier, for: indexPath) as! CommodityViewCell
        cell.commodity = filter_commodities?[indexPath.row]
        cell.trend = filter_commodities?[indexPath.row].trendWeekly
        clearAllBtnStatus(cell)
        cell.weeklyBtn.backgroundColor = UIColor.init(rgb: 0xF9EFFB)
        cell.weeklyBtn.setTitleColor(UIColor.themeColor, for: .normal)
        cell.weeklyBtn.layer.borderColor = UIColor.themeColor.cgColor
        cell.weeklyBtn.tag = indexPath.section
        cell.weeklyBtn.addTarget(self, action: #selector(tapOnweeklyBtn), for: .touchUpInside)
        
        cell.oneMonthBtn.tag = indexPath.section
        cell.oneMonthBtn.addTarget(self, action: #selector(tapOnMonthBtn), for: .touchUpInside)
        
        
        cell.threeMonthBtn.tag = indexPath.section
        cell.threeMonthBtn.addTarget(self, action: #selector(tapThreeMonthHBtn), for: .touchUpInside)
        
        cell.sixMonthBtn.tag = indexPath.section
        cell.sixMonthBtn.addTarget(self, action: #selector(tapSixMonthHBtn), for: .touchUpInside)
        
        
        cell.oneYearBtn.tag = indexPath.section
        cell.oneYearBtn.addTarget(self, action: #selector(tapYearHBtn), for: .touchUpInside)
        
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
    func clearAllBtnStatus(_ cell: CommodityViewCell?) {
        cell?.weeklyBtn.backgroundColor = UIColor.white
        cell?.weeklyBtn.setTitleColor(UIColor.init(rgb: 0x4F5A65), for: .normal)
        cell?.weeklyBtn.layer.borderColor = UIColor.init(rgb: 0x4F5A65).cgColor
        
        cell?.oneMonthBtn.backgroundColor = UIColor.white
        cell?.oneMonthBtn.setTitleColor(UIColor.init(rgb: 0x4F5A65), for: .normal)
        cell?.oneMonthBtn.layer.borderColor = UIColor.init(rgb: 0x4F5A65).cgColor
        
        cell?.threeMonthBtn.backgroundColor = UIColor.white
        cell?.threeMonthBtn.setTitleColor(UIColor.init(rgb: 0x4F5A65), for: .normal)
        cell?.threeMonthBtn.layer.borderColor = UIColor.init(rgb: 0x4F5A65).cgColor
        
        cell?.sixMonthBtn.backgroundColor = UIColor.white
        cell?.sixMonthBtn.setTitleColor(UIColor.init(rgb: 0x4F5A65), for: .normal)
        cell?.sixMonthBtn.layer.borderColor = UIColor.init(rgb: 0x4F5A65).cgColor
        
        cell?.oneYearBtn.backgroundColor = UIColor.white
        cell?.oneYearBtn.setTitleColor(UIColor.init(rgb: 0x4F5A65), for: .normal)
        cell?.oneYearBtn.layer.borderColor = UIColor.init(rgb: 0x4F5A65).cgColor
    }
    
    @objc func tapOnweeklyBtn(_ sender: UIButton) {
        let indexPath = IndexPath(row: 0, section: sender.tag)
        let cell = tableView.cellForRow(at: indexPath) as? CommodityViewCell
        clearAllBtnStatus(cell)
        cell?.weeklyBtn.backgroundColor = UIColor.init(rgb: 0xF9EFFB)
        cell?.weeklyBtn.setTitleColor(UIColor.themeColor, for: .normal)
        cell?.weeklyBtn.layer.borderColor = UIColor.themeColor.cgColor
        cell?.trend = filter_commodities?[indexPath.row].trendWeekly
        cell?.chartData = filter_commodities?[indexPath.row].trendWeekly
    }
    @objc func tapOnMonthBtn(_ sender: UIButton) {
        let indexPath = IndexPath(row: 0, section: sender.tag)
        let cell = tableView.cellForRow(at: indexPath) as? CommodityViewCell
        clearAllBtnStatus(cell)
        cell?.oneMonthBtn.backgroundColor = UIColor.init(rgb: 0xF9EFFB)
        cell?.oneMonthBtn.setTitleColor(UIColor.themeColor, for: .normal)
        cell?.oneMonthBtn.layer.borderColor = UIColor.themeColor.cgColor
        cell?.trend = filter_commodities?[indexPath.row].trend
        cell?.chartData = filter_commodities?[indexPath.row].trend
    }
    
    
    @objc func tapThreeMonthHBtn(_ sender: UIButton) {
        let indexPath = IndexPath(row: 0, section: sender.tag)
        let cell = tableView.cellForRow(at: indexPath) as? CommodityViewCell
        clearAllBtnStatus(cell)
        cell?.threeMonthBtn.backgroundColor = UIColor.init(rgb: 0xF9EFFB)
        cell?.threeMonthBtn.setTitleColor(UIColor.themeColor, for: .normal)
        cell?.threeMonthBtn.layer.borderColor = UIColor.themeColor.cgColor
        cell?.trend = filter_commodities?[indexPath.row].trendQuarterly
        cell?.chartData = filter_commodities?[indexPath.row].trendQuarterly
    }
    
    @objc func tapSixMonthHBtn(_ sender: UIButton) {
        let indexPath = IndexPath(row: 0, section: sender.tag)
        let cell = tableView.cellForRow(at: indexPath) as? CommodityViewCell
        clearAllBtnStatus(cell)
        cell?.sixMonthBtn.backgroundColor = UIColor.init(rgb: 0xF9EFFB)
        cell?.sixMonthBtn.setTitleColor(UIColor.themeColor, for: .normal)
        cell?.sixMonthBtn.layer.borderColor = UIColor.themeColor.cgColor
        cell?.trend = filter_commodities?[indexPath.row].trendHalfYearly
        cell?.chartData = filter_commodities?[indexPath.row].trendHalfYearly
    }
    @objc func tapYearHBtn(_ sender: UIButton) {
        let indexPath = IndexPath(row: 0, section: sender.tag)
        let cell = tableView.cellForRow(at: indexPath) as? CommodityViewCell
        clearAllBtnStatus(cell)
        cell?.oneYearBtn.backgroundColor = UIColor.init(rgb: 0xF9EFFB)
        cell?.oneYearBtn.setTitleColor(UIColor.themeColor, for: .normal)
        cell?.oneYearBtn.layer.borderColor = UIColor.themeColor.cgColor
        cell?.trend = filter_commodities?[indexPath.row].trendYearly
        cell?.chartData = filter_commodities?[indexPath.row].trendYearly
    }
}

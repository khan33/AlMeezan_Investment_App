//
//  MoneyMarketVC.swift
//  AlMeezan
//
//  Created by Atta khan on 21/11/2019.
//  Copyright © 2019 Atta khan. All rights reserved.
//

import UIKit
import SVProgressHUD
import SwiftKeychainWrapper

class MoneyMarketVC: BaseViewController {
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var kiborLbl: UILabel!
    @IBOutlet weak var kiborView: UIView!
    @IBOutlet weak var bidLbl: UILabel!
    @IBOutlet weak var updatedTimeLbl: UILabel!
    @IBOutlet weak var lastUpdatedTime: UILabel!
    @IBOutlet weak var askLbl: UILabel!
    @IBOutlet weak var PKRVView: UIView!
    @IBOutlet weak var PKRVLbl: UILabel!
    @IBOutlet weak var PIBView: UIView!
    @IBOutlet weak var PIBLbl: UILabel!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var notificationBtn: UIButton!
    @IBOutlet weak var countNotificationLbl: UIButton!

    @IBOutlet weak var kiborBtn: UIButton!
    @IBOutlet weak var sukakBtn: UIButton!
    @IBOutlet weak var PkrBtn: UIButton!
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerHightCell: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var kiborHeadingLbl: UILabel!
    private let refreshControl = UIRefreshControl()
    var tabIndex = 0
    var current_state : MoneyMarketState = MoneyMarketState.kibor
    var KIBOR_Model : [KIBORDelayModel]?
    var PKR_Delay_Model : [PKRVDelayModel]?
    var sukuk_data: [SukukModel]?
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchKIBOR()
        refreshControl.addTarget(self, action: #selector(refreshTableViewData(_:)), for: .valueChanged)
        if #available(iOS 10, *){
           tableView.refreshControl = refreshControl
        } else {
           tableView.addSubview(refreshControl)
        }
        countNotificationLbl.isHidden = true
    }
    @objc private func refreshTableViewData(_ sender: Any) {
       navigateTopBarMenu(tabIndex)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Utility.shared.renderNotificationCount(self.countNotificationLbl)
        hideNavigationBar()
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
    
    private func relaodTable() {
        UIView.transition(with: tableView, duration: 2.0, options: .curveLinear, animations: {
            self.tableView.reloadData()
            
        }, completion: nil)
    }
    
    func navigateTopBarMenu(_ tag: Int) {
        switch tag {
        case 0:
            kiborLbl.textColor = UIColor.white
            kiborView.backgroundColor = UIColor.white
            kiborView.isHidden = false
            PKRVLbl.textColor = UIColor.rgb(red: 255.0, green: 255.0, blue: 255.0, alpha: 0.5)
            PKRVView.backgroundColor = UIColor.clear
            PKRVView.isHidden = true
            PIBLbl.textColor = UIColor.rgb(red: 255.0, green: 255.0, blue: 255.0, alpha: 0.5)
            PIBView.backgroundColor = UIColor.clear
            PIBView.isHidden = true
            askLbl.text = "Ask"
            bidLbl.isHidden = false
            current_state = MoneyMarketState.kibor
            headerView.isHidden = false
            headerHightCell.constant = 36
            fetchKIBOR()
            kiborBtn.isUserInteractionEnabled    = false
            sukakBtn.isUserInteractionEnabled   = true
            PkrBtn.isUserInteractionEnabled     = true
         case 1:
            PKRVLbl.textColor = UIColor.white
            PKRVView.backgroundColor = UIColor.white
            PKRVView.isHidden = false
            PIBLbl.textColor = UIColor.rgb(red: 255.0, green: 255.0, blue: 255.0, alpha: 0.5)
            PIBView.backgroundColor = UIColor.clear
            PIBView.isHidden = true
            kiborLbl.textColor = UIColor.rgb(red: 255.0, green: 255.0, blue: 255.0, alpha: 0.5)
            kiborView.backgroundColor = UIColor.clear
            kiborView.isHidden = true
            askLbl.text = "Bid"
            bidLbl.isHidden = true
            current_state = MoneyMarketState.SUKUK
            headerView.isHidden = true
            headerHightCell.constant = 0
            fetchSukuk()
            kiborBtn.isUserInteractionEnabled    = true
            sukakBtn.isUserInteractionEnabled   = false
            PkrBtn.isUserInteractionEnabled     = true
            
     default:
        PIBLbl.textColor = UIColor.white
        PIBView.backgroundColor = UIColor.white
        PIBView.isHidden = false
        kiborLbl.textColor = UIColor.rgb(red: 255.0, green: 255.0, blue: 255.0, alpha: 0.5)
        kiborView.backgroundColor = UIColor.clear
        kiborView.isHidden = true
        PKRVLbl.textColor = UIColor.rgb(red: 255.0, green: 255.0, blue: 255.0, alpha: 0.5)
        PKRVView.backgroundColor = UIColor.clear
        PKRVView.isHidden = true
        kiborView.isHidden = true
        askLbl.text = "Bid"
        bidLbl.isHidden = true
        current_state = MoneyMarketState.PKRV
        headerHightCell.constant = 36
        headerView.isHidden = false
        fetchPKRDelay()
        kiborBtn.isUserInteractionEnabled    = true
        sukakBtn.isUserInteractionEnabled   = true
        PkrBtn.isUserInteractionEnabled     = false
     }
    }
    private func fetchKIBOR() {
        let startDate =   Date().toString(format: "yyyyMMdd")
        let bodyParam = RequestBody(Date: startDate)
        let bodyRequest = bodyParam.encryptData(bodyParam)
        let url = URL(string: KIBOR_DELAY)!
        SVProgressHUD.show()
        
        WebServiceManager.sharedInstance.fetch(params: bodyRequest as Dictionary<String, AnyObject>, url: url, serviceType: "Cache Data", modelType: KIBORDelayModel.self, errorMessage: { (errorMessage) in
            errorResponse = errorMessage
            self.showErrorMsg(errorMessage)
        }, success: { (response) in
            self.KIBOR_Model = response
            if self.KIBOR_Model?.count ?? 0 > 0 {
                if let date = self.KIBOR_Model?[0].entryTime {
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
    private func fetchPKRDelay() {
        let startDate =   Date().toString(format: "yyyyMMdd")
        let bodyParam = RequestBody(Date: startDate)
        let bodyRequest = bodyParam.encryptData(bodyParam)
        let url = URL(string: PKRV_PIB_LIST)!
        SVProgressHUD.show()
        
        WebServiceManager.sharedInstance.fetch(params: bodyRequest as Dictionary<String, AnyObject>, url: url, serviceType: "Cache Data", modelType: PKRVDelayModel.self, errorMessage: { (errorMessage) in
            errorResponse = errorMessage
            self.showErrorMsg(errorMessage)
        }, success: { (response) in
            self.PKR_Delay_Model = response
            if self.PKR_Delay_Model?.count ?? 0 > 0 {
                 if let date = self.PKR_Delay_Model?[0].entrydatetime {
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
    private func fetchPIBReturn() {
        let startDate =   Date().toString(format: "yyyyMMdd")
        let bodyParam = RequestBody(Date: startDate)
        let bodyRequest = bodyParam.encryptData(bodyParam)
        let url = URL(string: PKRV_PIB_LIST)!
        SVProgressHUD.show()
        
        WebServiceManager.sharedInstance.fetch(params: bodyRequest as Dictionary<String, AnyObject>, url: url, serviceType: "Cache Data", modelType: PKRVDelayModel.self, errorMessage: { (errorMessage) in
            errorResponse = errorMessage
            self.showErrorMsg(errorMessage)
        }, success: { (response) in
            self.PKR_Delay_Model = response
            if self.PKR_Delay_Model?.count ?? 0 > 0 {
                 if let date = self.PKR_Delay_Model?[0].entrydatetime {
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
    private func fetchSukuk() {
        let bodyParam = RequestBody()
        let bodyRequest = bodyParam.encryptData(bodyParam)
        let url = URL(string: SUKUK_LIST)!
        SVProgressHUD.show()
        
        WebServiceManager.sharedInstance.fetch(params: bodyRequest as Dictionary<String, AnyObject>, url: url, serviceType: "Sukuk Data", modelType: SukukModel.self, errorMessage: { (errorMessage) in
            errorResponse = errorMessage
            self.showErrorMsg(errorMessage)
        }, success: { (response) in
            self.sukuk_data = response
            if self.sukuk_data?.count ?? 0 > 0 {
                if let date = self.sukuk_data?[0].timeStamp {
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
    
    //
    @IBAction func tapOnTabBar(_ sender: UIButton) {
        tabIndex = sender.tag
        navigateTopBarMenu(tabIndex)
    }
    private func setUpTableView() {
        tableView.estimatedRowHeight = 160.0
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.register(MoneyMarketViewCell.nib, forCellReuseIdentifier: MoneyMarketViewCell.identifier)
        tableView.register(SukookViewCell.nib, forCellReuseIdentifier: SukookViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        relaodTable()
    }

    @IBAction func navigateController(_ sender: Any){
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
extension MoneyMarketVC: UITableViewDelegate {
    
}
extension MoneyMarketVC: UITableViewDataSource {
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
        var count = 0
        switch current_state {
        case .kibor:
            count = KIBOR_Model?.count ?? 0
        case .PKRV:
            count = PKR_Delay_Model?.count ?? 0
        case .SUKUK:
            count = sukuk_data?.count ?? 0
        default:
            break
        }
        return count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        switch current_state {
        case .kibor:
            let cell = tableView.dequeueReusableCell(withIdentifier: MoneyMarketViewCell.identifier, for: indexPath) as! MoneyMarketViewCell
            cell.selectionStyle = .none
            cell.data = KIBOR_Model?[indexPath.row]
            //kiborHeadingLbl.isHidden = false
            //cell.state = current_state
            return cell
        case .PKRV:
            let cell = tableView.dequeueReusableCell(withIdentifier: MoneyMarketViewCell.identifier, for: indexPath) as! MoneyMarketViewCell
            cell.selectionStyle = .none
            cell.bidLbl.isHidden = true
            
            cell.PKRdata = PKR_Delay_Model?[indexPath.row]
            return cell
//        case .PIB:
//            cell.PKRdata = PKR_Delay_Model?[indexPath.row]
//            kiborHeadingLbl.isHidden = true
        case .SUKUK:
            let sukukCell = tableView.dequeueReusableCell(withIdentifier: SukookViewCell.identifier, for: indexPath) as! SukookViewCell
            sukukCell.selectionStyle = .none
            sukukCell.sukuk = sukuk_data?[indexPath.row]
            
            return sukukCell
        default:
            break
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch current_state {
        case .SUKUK:
            return 230
        @unknown default:
            return 36.0
        }
    }
}

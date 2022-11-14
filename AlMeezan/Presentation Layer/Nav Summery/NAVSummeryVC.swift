//
//  NAVSummeryVC.swift
//  AlMeezan
//
//  Created by Atta khan on 12/09/2019.
//  Copyright © 2019 Atta khan. All rights reserved.
//

import UIKit
import Charts
import SVProgressHUD
import SwiftKeychainWrapper

class NAVSummeryVC: BaseViewController, ChartViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var fundDate: UILabel!
    @IBOutlet weak var fundGroupLbl: UILabel!
    
    
    public var fundGroup: String?
    
    var nav_model: [NavModel]?
    var navPerformance: [NavPerformance]?
    var navHistory: [FundHistoryModel]?
    var nav_history_model: [FundHistoryModel]?
    
    
    var myPickerView : UIPickerView!
    var selectedFund: Int = 0
    var indexOf: Int = 0
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var notificationBtn: UIButton!
    @IBOutlet weak var countNotificationLbl: UIButton!

    var completionHandler:((String) -> Int)?
    
    
    // MARK: PROPERTIES
    var interactor: SummeryInteractorProtocol?
    var router: SummeryRouterProtocol?
    
    
    var nav_data: [NavEntity.NavViewModel.DisplayedFund]?
    var selectedFundId: Int = 0
    var displayedHistory: [SummeryEntity.SummeryViewModel.DisplayedSummeryFund] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.viewDidLoad()
        
        if let data = nav_data {
            fundGroup = data[selectedFundId].fundGroup ?? "All Fund"
            fundGroupLbl.text = fundGroup
            //interactor?.getFundSummery(fund: fundGroup)
            getData(fundGroup!)
            //fundDate.text = interactor?.filterFundGroup(navData: data, fund: fundGroup!)
        }
        
        
//        if let fund = fundGroup {
//            getData(fund)
//            fundGroupLbl.text = fund
//        }
//        countNotificationLbl.isHidden = true
        
       
    }
    override func viewWillAppear(_ animated: Bool) {
        filterFundGroup()
//        hideNavigationBar()
//        Utility.shared.renderNotificationCount(countNotificationLbl)
//        if let userAuth = KeychainWrapper.standard.string(forKey: "UserType") {
//            if userAuth == "loggedInUser" {
//                loginBtn.setImage(UIImage(named: "logout-icon-1"), for: .normal)
//            } else {
//                loginBtn.setImage(UIImage(named: "logout-icon"), for: .normal)
//            }
//        }
//
        Utility.shared.analyticsCode("Funds Nav")
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if SVProgressHUD.isVisible() {
            SVProgressHUD.dismiss()
        }
    }
    
    func getData(_ fund: String) {
        if (NetworkState().isInternetAvailable) {
            navHistory(fund)
        } else {
//            let predicate = NSPredicate(format: "fUND_NAME == %@", fund)
//            PersistenceServices.shared.fetchWithPredicate(FundHistoryModel.self, predicate) { [weak self] (data) in
//                self?.navHistory = data
//                self?.setUpTableView()
//            }
        }
    }
    
    private func filterFundGroup() {
        indexOf = nav_data?.firstIndex(where: { $0.fundGroup == fundGroup}) ?? 0
        if fundGroup == "All Fund" { indexOf = 1}
        navPerformance = Array(nav_data?[indexOf].navPerformance ?? [])
        if let dateStr = navPerformance?[0].nAVDate {
            let strDate =  dateStr.toDate()
            let strValue = strDate?.toString(format: "MMM d, yyyy")
            if let lastUpdatedDate = strValue {
                fundDate.text = "NAV applicable date – \(lastUpdatedDate)"
            }
        }
    }
    
    func setUpTableView() {
        tableView.register(SummeryDetailCell.nib, forCellReuseIdentifier: SummeryDetailCell.identifier)
        tableView.register(NAVSummeryCell.nib, forCellReuseIdentifier: NAVSummeryCell.identifier)
        let headerView = UINib.init(nibName: "FundHeaderCell", bundle: nil)
        tableView.register(headerView, forHeaderFooterViewReuseIdentifier: "FundHeaderCell")
        
        tableView.backgroundColor = UIColor(red: 244.0 / 255.0, green: 246.0 / 255.0, blue: 255.0 / 255.0, alpha: 1)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }
    func navHistory(_ fundGroup : String) {
        let bodyParam = RequestBody(FundID: fundGroup)
        let bodyRequest = bodyParam.encryptData(bodyParam)
        let url = URL(string: NAV_HISTORY)!
        SVProgressHUD.show()
        WebServiceManager.sharedInstance.fetch(params: bodyRequest as Dictionary<String, AnyObject>, url: url, serviceType: "Cache Data1", modelType: FundHistoryModel.self, errorMessage: { (errorMessage) in
            errorResponse = errorMessage
            self.showErrorMsg(errorMessage)
        }, success: { (response) in
            self.navHistory = response
            self.setUpTableView()
        }, fail: { (error) in
            print(error.localizedDescription)
        }, showHUD: true)

    }

    @IBAction func navigateBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func onPickFundBtn(_ sender: UIButton) {
        let vc = UIViewController()
        vc.preferredContentSize = CGSize(width: 250,height: 200)
        let pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: 250, height: 200))
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.tag = 1
        pickerView.selectRow(selectedFund, inComponent:0, animated:true)
        vc.view.addSubview(pickerView)
        let editRadiusAlert = UIAlertController(title: "Choose Fund", message: "", preferredStyle: UIAlertController.Style.alert)
        editRadiusAlert.setValue(vc, forKey: "contentViewController")
        editRadiusAlert.addAction(UIAlertAction(title: "Done", style: .default, handler: { (alert: UIAlertAction!) in
            self.filterFundGroup()
            self.fundGroupLbl.text = self.fundGroup
            self.getData(self.fundGroup!)
        }))
        self.present(editRadiusAlert, animated: true)
        
    }
    
    @IBAction func tapOnNotificationBtn(_ sender: Any) {
        let vc = NotificationsVC.instantiateFromAppStroyboard(appStoryboard: .home)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func tapOnLoginBtn(_ sender: Any) {
        loginOption()
    }
    
}

extension NAVSummeryVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if fundGroup == "All Fund" {
            return nav_data?.count ?? 0
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = tableView.dequeueReusableHeaderFooterView(withIdentifier: "FundHeaderCell") as! FundHeaderCell
        headerCell.fundGroupName.text = nav_data?[section].fundGroup
        return headerCell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if fundGroup == "All Fund" {
            if section != 0 {
                return 44.0
            }
            return 0.0
        }
        return 0.0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if fundGroup == "All Fund" {
            return nav_data?[section].navPerformance.count ?? 0
        }
        return nav_data?[indexOf].navPerformance.count ?? 0
    }
    
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var index = 0
        if fundGroup == "All Fund" {
             index = indexPath.section
        } else {
            index = indexOf
        }
        let navPerformance = Array(nav_data?[index].navPerformance ?? [])
        let isExpanded = navPerformance[indexPath.row].isExpandable
        if isExpanded {
            let cell = tableView.dequeueReusableCell(withIdentifier: SummeryDetailCell.identifier) as! SummeryDetailCell
            if fundGroup != "All Fund" {
                let fund_name = navPerformance[indexPath.row].fund_name ?? ""
                let nav_history_array = navHistory?.filter{ (($0.fUND_NAME)?.contains(fund_name))! }
                if let history_list = nav_history_array {
                    if history_list.count > 0 {
                        cell.nav_history = history_list[0]
                    }
                }
                let navPerformance = Array(nav_data?[indexOf].navPerformance ?? [])
                cell.nav_performance_data = navPerformance[indexPath.row]
                cell.detailBtn.tag = indexPath.row
            } else {
                let navPerformance = Array(nav_data?[indexPath.section].navPerformance ?? [])
                
                let fund_name = navPerformance[indexPath.row].fund_name ?? ""
                let nav_history_array = navHistory?.filter{ (($0.fUND_NAME)?.contains(fund_name))! }
                if let history_list = nav_history_array {
                    if history_list.count > 0 {
                        cell.nav_history = history_list[0]
                    }
                }
                
                
                cell.nav_performance_data = navPerformance[indexPath.row]
                
            }
            cell.detailBtn.indexPath = indexPath
            cell.detailBtn.addTarget(self, action: #selector(tapOnDetailBtn), for: .touchUpInside)
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: NAVSummeryCell.identifier) as! NAVSummeryCell
            if fundGroup == "All Fund" {
                let navPerformance = Array(nav_data?[indexPath.section].navPerformance ?? [])
                cell.nav_performance_data = navPerformance[indexPath.row]
            }   
            else {
                let navPerformance = Array(nav_data?[indexOf].navPerformance ?? [])
                cell.nav_performance_data = navPerformance[indexPath.row]
            }
            cell.selectionStyle = .none
            return cell
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var index = 0
        if fundGroup == "All Fund" {
             index = indexPath.section
        } else {
            index = indexOf
        }
        let navPerformance = Array(nav_data?[index].navPerformance ?? [])
        let isExpanded = navPerformance[indexPath.row].isExpandable
        if isExpanded {
            return 580.0
        }
        
        return 60.0
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var index = 0
        if fundGroup == "All Fund" {
             index = indexPath.section
        } else {
            index = indexOf
        }
        let navPerformance = Array(nav_data?[index].navPerformance ?? [])
        let isExpanded = navPerformance[indexPath.row].isExpandable
        navPerformance[indexPath.row].isExpandable = !isExpanded
        //fundGroup = navPerformance[indexPath.row].fund_name
        
        tableView.reloadRows(at: [indexPath], with: .fade)
    }
    
    @objc func tapOnDetailBtn(_ sender: MyButton) {
        let row = sender.tag
        let vc = InvestmentProductDetailVC.instantiateFromAppStroyboard(appStoryboard: .main)
        let navPerformance = Array(nav_data?[indexOf].navPerformance ?? [])
        vc.fund_name = navPerformance[row].fund_name
        vc.fund_short_name = navPerformance[row].fundshortname
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

public class DateValueFormatter: NSObject, AxisValueFormatter {
    private let dateFormatter = DateFormatter()
    
    override init() {
        super.init()
        dateFormatter.dateFormat = "dd MMM HH:mm"
    }
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return dateFormatter.string(from: Date(timeIntervalSince1970: value))
    }
}
extension NAVSummeryVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        let count = nav_data?.count ?? 0
        return count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return nav_data?[row].fundGroup
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        fundGroup = nav_data?[row].fundGroup
        selectedFund = row
    }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var title = UILabel()
        if let titleLbl = view {
            title = titleLbl as! UILabel
        }
        title.font = UIFont(name: "Roboto-Regular", size: 15)
            title.text =  nav_data?[row].fundGroup
        
        title.textAlignment = .center
        return title
    }
}


extension NAVSummeryVC: SummeryViewContorllerProtocol {
    func displayedFundHistroyDetails(viewModel: SummeryEntity.SummeryViewModel) {
        DispatchQueue.main.async {
            SVProgressHUD.dismiss()
            self.displayedHistory = viewModel.displaySummeryFund
            self.setUpTableView()
        }
    }
}

//
//  StatusTransactionsVC.swift
//  AlMeezan
//
//  Created by Atta khan on 04/11/2019.
//  Copyright © 2019 Atta khan. All rights reserved.
//

import UIKit
import SVProgressHUD
import SwiftKeychainWrapper

class StatusTransactionsVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var portofolioIdLbl: UILabel!
    @IBOutlet weak var resultLbl: UILabel!
    @IBOutlet weak var countNotificationLbl: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var notificationBtn: UIButton!
    @IBOutlet weak var menuBtn: UIButton!
    
    var isBack: Bool = false
    var seletedId: Int = 0
    var transactionDetails: [MobileTransactions]?
    var filterTransactions: [String: [Transactions]] = [:]
    var uniqueTransaction: [String]?
    var isFromSideMenu: Bool = false
    var selectedMenuItem: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        countNotificationLbl.isHidden = true
        self.portofolioIdLbl.text = "Portfolio Id"
        self.resultLbl.text = "0 Result"
        if isFromSideMenu {
            navigateToController(selectedMenuItem)
        }
        let menuBtnImage = UIImage(named: "menu_icon")
        let backBtnImage = UIImage(named: "BackArrow")
        if isBack {
            menuBtn.setImage(backBtnImage, for: .normal)
        } else {
            menuBtn.setImage(menuBtnImage, for: .normal)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Utility.shared.renderNotificationCount(countNotificationLbl)
        hideNavigationBar()
        let portfolioId = UserDefaults.standard.string(forKey: "portfolioId") ?? ""
        getData(portfolioId)
        if let userAuth = KeychainWrapper.standard.string(forKey: "UserType") {
            if userAuth == "loggedInUser" {
                loginBtn.setImage(UIImage(named: "logout-icon-1"), for: .normal)
                //menuBtn.setImage(UIImage(named: "menu_icon"), for: .normal)
            } else {
                loginBtn.setImage(UIImage(named: "logout-icon"), for: .normal)
                //menuBtn.setImage(UIImage(named: "BackArrow"), for: .normal)
            }
        }
    }
    private func configTableView() {
        tableView.register(StatusTransactionsViewCell.nib, forCellReuseIdentifier: StatusTransactionsViewCell.identifier)
        let headerView = UINib.init(nibName: "FundHeaderCell", bundle: nil)
        tableView.register(headerView, forHeaderFooterViewReuseIdentifier: "FundHeaderCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }
    
    
    func getData(_ portfolioId: String) {
        let bodyParam = RequestBody()
        let bodyRequest = bodyParam.encryptData(bodyParam)
        let url = URL(string: MOBILE_TRANSACTION)!
        SVProgressHUD.show()
        
        WebServiceManager.sharedInstance.fetch(params: bodyRequest as Dictionary<String, AnyObject>, url: url, serviceType: "Nav Fund", modelType: MobileTransactions.self, errorMessage: { (errorMessage) in
            errorResponse = errorMessage
            self.showErrorMsg(errorMessage)
        }, success: { (response) in
            self.transactionDetails = response
            if self.transactionDetails?.count ?? 0 > 0 {
                self.portofolioIdLbl.text = self.transactionDetails?[0].portfolioID
                self.resultLbl.text = "\(self.transactionDetails?[0].transactions?.count ?? 0) Results"
            }
           
            self.filterFunds()
            
        }, fail: { (error) in
            print(error.localizedDescription)
        }, showHUD: true)

    }
    
    private func filterFunds() {
        filterTransactions.removeAll()
        uniqueTransaction = self.transactionDetails?[self.seletedId].transactions?.compactMap({ return $0.dealdate}).unique()
        
            for(_, obj) in (uniqueTransaction?.enumerated())! {
                let trnasaction = self.transactionDetails?[self.seletedId].transactions?.filter({ $0.dealdate == obj})
                filterTransactions[obj] = trnasaction
            }
        configTableView()
    }
    
    
    
    @IBAction func tapOnPortofolioBtn(_ sender: Any) {
        if uniqueTransaction?.count ?? 0 > 0 {
            let vc = UIViewController()
            vc.preferredContentSize = CGSize(width: 250,height: 200)
            let pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: 250, height: 200))
            pickerView.delegate = self
            pickerView.dataSource = self
            pickerView.tag = 0
            pickerView.selectRow(seletedId, inComponent:0, animated:true)
            vc.view.addSubview(pickerView)
            let editRadiusAlert = UIAlertController(title: "Choose Portfolio Id", message: "", preferredStyle: UIAlertController.Style.alert)
            editRadiusAlert.setValue(vc, forKey: "contentViewController")
            editRadiusAlert.addAction(UIAlertAction(title: "Done", style: .default, handler: { (alert: UIAlertAction!) in
                self.portofolioIdLbl.text = self.transactionDetails?[self.seletedId].portfolioID
                self.resultLbl.text = "\(self.transactionDetails?[self.seletedId].transactions?.count ?? 0) Results"
                self.filterFunds()
            }))
            self.present(editRadiusAlert, animated: true)
        } else {
            self.showAlert(title: "Alert", message: "No Portfolio Id Exist.", controller: self) {
                
            }
        }
        
        
    }
    
    @IBAction func tapToBackNavigate(_ sender: Any) {
        if isBack {
            self.navigationController?.popViewController(animated: true)
        } else {
            self.revealController.show(self.revealController.leftViewController)
        }
        
    }
    
    @IBAction func logoutBtn(_ sender: Any) {
        loginOption()
    }
    
    @IBAction func tapOnNotificationBtn(_ sender: Any) {
        let vc = NotificationsVC.instantiateFromAppStroyboard(appStoryboard: .home)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
extension StatusTransactionsVC: UITableViewDelegate, UITableViewDataSource {
    
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
        cell.transaction = filterTransactions[(uniqueTransaction?[indexPath.section])!]![indexPath.row]
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88.0
    }
    
}
extension StatusTransactionsVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return transactionDetails?.count ?? 0
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return transactionDetails?[row].portfolioID
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        portofolioIdLbl.text = transactionDetails?[row].portfolioID
        resultLbl.text = "\(transactionDetails?[row].transactions?.count ?? 0) Results"
        seletedId = row
    }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var title = UILabel()
        if let titleLbl = view {
            title = titleLbl as! UILabel
        }
        title.font = UIFont(name: "Roboto-Regular", size: 15)
        title.text =  transactionDetails?[row].portfolioID
        
        title.textAlignment = .center
        return title
    }
}

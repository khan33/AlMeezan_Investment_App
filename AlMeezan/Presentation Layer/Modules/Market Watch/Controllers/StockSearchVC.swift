//
//  StockSearchVC.swift
//  AlMeezan
//
//  Created by Atta khan on 09/09/2020.
//  Copyright © 2020 Atta khan. All rights reserved.
//

import UIKit
import SVProgressHUD
import SwiftKeychainWrapper

class StockSearchVC: UIViewController {
    @IBOutlet weak var subTitleLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var notificationBtn: UIButton!
    @IBOutlet weak var countNotificationLbl: UIButton!
    
    @IBOutlet weak var searchTxtField: UISearchBar!
    var dataDic : [String: Int] = [:]
    private let refreshControl = UIRefreshControl()
    var topCompanies: [PSXCompaniesModel]?
    var searchCompanies: [PSXCompaniesModel]?
    var searching: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        searchCompanies = topCompanies
        searchTxtField.delegate = self
        countNotificationLbl.isHidden = true
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
        Utility.shared.renderNotificationCount(self.countNotificationLbl)
        for (index, key) in (searchCompanies?.enumerated())! {
            let keyValue =  searchCompanies?[index].symbol
            let isAdd    =  searchCompanies?[index].isAdded
            dataDic[keyValue ?? ""] = isAdd
        }

        setUpTableView()
    }
    
    @objc private func refreshTableViewData(_ sender: Any) {
        searchCompanies = topCompanies
        self.refreshControl.endRefreshing()
    }
    private func setUpTableView() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 88
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SectorViewCell.nib, forCellReuseIdentifier: SectorViewCell.identifier)
        tableView.backgroundColor = UIColor.init(rgb: 0xF4F6FA)
        tableView.reloadData()
    }
    @IBAction func navigateBackScreen(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tapOnNotificationBtn(_ sender: Any) {
        let vc = NotificationsVC.instantiateFromAppStroyboard(appStoryboard: .home)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    @objc func addCompany(_ sender: UIButton) {
        let tag = sender.tag
        let companyTxt = searchCompanies?[tag].symbol ?? ""
        
        let resultPredicate     = NSPredicate(format: "symbol = %@", companyTxt)
        PersistenceServices.shared.fetchWithPredicate(SymbolEntity.self, resultPredicate) { [weak self] (data) in
            if data.count > 0 {
                self?.showConfirmationAlertViewWithTitle(title: "Alert", message: "Are you sure want to remoe this stock?") {
                    let obj = data[0] as! NSManagedObject
                    PersistenceServices.shared.deleteObj(SymbolEntity.self, obj)
                    self?.searchCompanies?[tag].isAdded = 0
                    let indexPath = IndexPath(row: tag, section: 0)
                    self?.tableView.reloadRows(at: [indexPath], with: .fade)
                    self?.updateCompany(companyTxt, 0)
                }
            } else {
                let stock = SymbolEntity.create(in: PersistenceServices.shared.context)
                stock.symbol = companyTxt
                PersistenceServices.shared.saveContext()
                self?.showAlert(title: "Alert", message: "Add Successfully.", controller: self) {
                    self?.searchCompanies?[tag].isAdded = 1
                    self?.updateCompany(companyTxt, 1)
                    let indexPath = IndexPath(row: tag, section: 0)
                    self?.tableView.reloadRows(at: [indexPath], with: .fade)
                }
            }
        }
    }
    func updateCompany(_ symbol: String, _ status: Int) {
        let managedContext = persistence.context
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "PSXCompaniesModel")
        fetchRequest.predicate = NSPredicate(format: "symbol = %@", symbol)
            //NSPredicate.init(format: "symbol = \(symbol)")
        do {
            let activity = try managedContext.fetch(fetchRequest)
            let objectUpdate = activity[0]
            objectUpdate.setValue(status, forKey: "isAdded")
            do {
                try managedContext.save()
            } catch {
                print(error)
            }
        }catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
}
extension StockSearchVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchCompanies?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SectorViewCell.identifier, for: indexPath) as! SectorViewCell
        cell.selectionStyle = .none
        cell.industryLbl.text   =   searchCompanies?[indexPath.row].sector
        cell.companyLbl.text    =   searchCompanies?[indexPath.row].symbol
        cell.addBtn.tag         =   indexPath.row
        let symbol = searchCompanies?[indexPath.row].symbol ?? ""
        print(searchCompanies?[indexPath.row].isAdded, searchCompanies?[indexPath.row].symbol)
        if let isAdded = searchCompanies?[indexPath.row].isAdded, isAdded == 1 {
            cell.addBtn.setTitle("REMOVE", for: .normal)
        } else {
            cell.addBtn.setTitle("ADD", for: .normal)
        }
        cell.addBtn.addTarget(self, action: #selector(addCompany), for: .touchUpInside)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
extension StockSearchVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            searchCompanies = topCompanies
            tableView.reloadData()
            return
        }
        searchCompanies = topCompanies?.filter({ company -> Bool in
            return company.sector?.lowercased().contains(searchText.lowercased()) ?? false || company.symbol?.lowercased().contains(searchText.lowercased()) ?? false
        })
        tableView.reloadData()
    }
}

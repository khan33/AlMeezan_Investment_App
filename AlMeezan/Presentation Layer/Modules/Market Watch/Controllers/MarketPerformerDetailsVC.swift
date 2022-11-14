//
//  MarketPerformerDetailsVC.swift
//  AlMeezan
//
//  Created by Atta khan on 20/11/2019.
//  Copyright © 2019 Atta khan. All rights reserved.
//

import UIKit
import SVProgressHUD
import SwiftKeychainWrapper

class MarketPerformerDetailsVC: BaseViewController {

    @IBOutlet weak var subTitleLbl: UILabel!
    @IBOutlet weak var updateTimeLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var notificationBtn: UIButton!
    @IBOutlet weak var countNotificationLbl: UIButton!
    @IBOutlet weak var indexTF: UILabel!
    @IBOutlet weak var sectorTF: UILabel!
    @IBOutlet weak var sortTF: UITextField!
    
    @IBOutlet weak var indicesTxtLbl: UILabel!
    @IBOutlet weak var sectorView: UIView!
    @IBOutlet weak var sortView: UIView!
    var selectedindicesId = 0
    var selectedsectorId = 0
    var selectedSortId = 0
    public var currentState: MarketState = MarketState.Advancers
    var companies: [PSXCompaniesTopModel]?
    var sectors: [PSXSectorTopModel]?
    var filterSector: [PSXSectorTopModel]?
    var activeCompanies: [ActiveCompanies]?
    var filterActiveCompanies: [ActiveCompanies]?
    private let refreshControl = UIRefreshControl()
    private var sortArray: [String] = []//["Sort","Gainer %","Gainer (PKR)"]
    private var activeSortArray = ["Sort", "Lowest to Highest", "Highest to Lowest"]
    var indexArray: [PSXCompaniesTopModel]?
    var sectorArray: [PSXCompaniesTopModel]?
    var filterCompanySector: [PSXCompaniesTopModel]?
    var filterCompanies: [PSXCompaniesTopModel]?
    var arrIndex: [String] = [String]()
    var arrSector: [String] = [String]()
    var index: String?
    var sector: String?
    var sortValue: String?
    var activeIndex: [PSXSectorTopModel]?
    var activeCompanyIndex: [ActiveCompanies]?
    var activeCompanySector: [ActiveCompanies]?
    var indices: PSXCompanyIndicesModel?
    var type: AdvancerType = AdvancerType.Advancers
    override func viewDidLoad() {
        super.viewDidLoad()
        let defaults = UserDefaults.standard
        indices = defaults.codable(PSXCompanyIndicesModel.self, forKey: "indices")
        checkMarketState(true)
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
        
        
    }
    @objc private func refreshTableViewData(_ sender: Any) {
       checkMarketState(false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        SVProgressHUD.dismiss()
    }
    

    private func checkMarketState(_ show: Bool) {
        switch currentState {
        case .Advancers:
            sectorView.isHidden = false
            subTitleLbl.text = "Advancers"
            self.setUpTableView()
            if indices?.indexes?.count ?? 0 > 0 {
                self.indexTF.text = indices?.indexes?[0] ?? ""
            } else {
                self.indexTF.text = ""
            }
            type = AdvancerType.Advancers
            if indices?.indexes?.count ?? 0 > 0 {
                let index = indices?.indexes?[0] ?? "All"
                fetchData(type.rawValue, show, index)
            }
            self.sortTF.text  = "Gainer (PKR)"
        
        case .Decliners:
            sectorView.isHidden = false
            subTitleLbl.text = "Decliners"
            if indices?.indexes?.count ?? 0 > 0 {
                self.indexTF.text = indices?.indexes?[0] ?? "All"
            } else {
                self.indexTF.text = ""
            }
            type = AdvancerType.Decliners
            if indices?.indexes?.count ?? 0 > 0 {
                let index = indices?.indexes?[0] ?? "All"
                fetchData(type.rawValue, show, index)
            }
            self.sortTF.text  = "Decliner (PKR)"
            
        case .ActiveSectors:
            sectorView.isHidden = true
            updateTimeLbl.text = ""
            subTitleLbl.text = "Active Sectors"
            self.indexTF.text = "All Indices"
            self.sortTF.text  = "Sort"
            fetchSector(show)
        case .ActiveCompanies:
            sectorView.isHidden = false
            subTitleLbl.text = "Active Companies"
            self.indexTF.text = "All Indices"
            self.sortTF.text  = "Sort"
            fetchActiveCompanies(show)
        default:
            break
        }
    }
    
    private func fetchActiveCompanies(_ show: Bool) {
        let date = Date().toString(format: "yyyyMMdd")
        let bodyParam = RequestBody(Date: date)
        let bodyRequest = bodyParam.encryptData(bodyParam)
        let url = URL(string: ACTIVE_COMPANIES)!
        if show {
            SVProgressHUD.show()
        }
        
        WebServiceManager.sharedInstance.fetch(params: bodyRequest as Dictionary<String, AnyObject>, url: url, serviceType: "PSXCompanies Top", modelType: ActiveCompanies.self, errorMessage: { (errorMessage) in
            errorResponse = errorMessage
            self.showErrorMsg(errorMessage)
        }, success: { (response) in
            self.activeCompanies = response
            
            if self.activeCompanies?.count ?? 0 > 0 {
                if let date = self.activeCompanies?[0].entrydatetime {
                    let time = Utility.shared.converTimeString(date)
                    self.updateTimeLbl.text = "Last updated on \(time)"
                }
            }
            self.activeCompanyIndex     = self.activeCompanies?.unique( by: { $0.index } )
            self.activeCompanySector    = self.activeCompanies?.unique(by: { $0.sector } )
            self.filterActiveCompanies  = self.activeCompanies
            self.setUpTableView()
            self.refreshControl.endRefreshing()
        }, fail: { (error) in
            print(error.localizedDescription)
            
        }, showHUD: true)
        
    }
    private func fetchSector(_ show: Bool) {
        let date = Date().toString(format: "yyyyMMdd")
        let bodyParam = RequestBody(Date: date)
        let bodyRequest = bodyParam.encryptData(bodyParam)
        let url = URL(string: PSX_SECTOR_TOP)!
        if show {
            SVProgressHUD.show()
        }
        
        WebServiceManager.sharedInstance.fetch(params: bodyRequest as Dictionary<String, AnyObject>, url: url, serviceType: "PSX SECTOR TOP", modelType: PSXSectorTopModel.self, errorMessage: { (errorMessage) in
            errorResponse = errorMessage
            self.showErrorMsg(errorMessage)
        }, success: { (response) in
            self.sectors = response
            
            if self.sectors?.count ?? 0 > 0 {
                if let date = self.sectors?[0].entrydatetime {
                    let time = Utility.shared.converTimeString(date)
                    self.updateTimeLbl.text = "Last updated on \(time)"
                }
                self.activeIndex = self.sectors?.unique( by: { $0.index } )
            }
            self.filterSector = self.sectors
            self.setUpTableView()
            self.refreshControl.endRefreshing()
        }, fail: { (error) in
            print(error.localizedDescription)
        }, showHUD: true)
        
    }
    
    private func fetchData(_ type: String, _ show: Bool, _ indexVal: String) {
        let date = Date().toString(format: "yyyyMMdd") //20191125
        let bodyParam = RequestBody(Date: date, type: type, Index: indexVal)
        let bodyRequest = bodyParam.encryptData(bodyParam)
        let url = URL(string: PSX_COMPANIES_TOP)!
        if show {
            SVProgressHUD.show()
        }
        WebServiceManager.sharedInstance.fetch(params: bodyRequest as Dictionary<String, AnyObject>, url: url, serviceType: "Cache Data", modelType: PSXCompaniesTopModel.self, errorMessage: { (errorMessage) in
            errorResponse = errorMessage
            self.showErrorMsg(errorMessage)
        }, success: { (response) in
            self.companies?.removeAll()
            self.companies = response
            //self.companies = self.fetchFromStorage()
            guard let data = self.companies else {
                return
            }
            if self.companies?.count ?? 0 > 0 {
                if let date = data[0].entrydatetime {
                    let time = Utility.shared.converTimeString(date)
                    self.updateTimeLbl.text = "Last updated on \(time)"
                }
                self.sectorArray = self.companies?.unique(by: { $0.sector } )
                self.filterCompanySector = self.sectorArray
            }
            self.filterCompanies = self.companies?.sorted(by: { $0.volume < $1.volume})
            
            
            
            self.setUpTableView()
            self.refreshControl.endRefreshing()
        }, fail: { (error) in
            print(error.localizedDescription)
            self.setUpTableView()
        }, showHUD: true)
        
    }
    func fetchFromStorage() -> [PSXCompaniesTopModel]? {
        let managedObjectContext = persistence.context
           let fetchRequest = NSFetchRequest<PSXCompaniesTopModel>(entityName: "PSXCompaniesTopModel")
           let sortDescriptor = NSSortDescriptor(key: "symbol", ascending: true)
           fetchRequest.sortDescriptors = [sortDescriptor]
           do {
               let users = try managedObjectContext.fetch(fetchRequest)
               return users
           } catch let error {
               print(error)
               return nil
           }
       }
    
    private func setUpTableView() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60
        tableView.delegate = self
        tableView.dataSource = self

        tableView.register(CompaniesViewCell.nib, forCellReuseIdentifier: CompaniesViewCell.identifier)
        tableView.register(DeclinersTableViewCell.nib, forCellReuseIdentifier: DeclinersTableViewCell.identifier)
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
       
    @IBAction func tapOnLoginBtn(_ sender: Any) {
     }

    
    @IBAction func didTapOnIndexBtn(_ sender: Any) {
        arrIndex.removeAll()
        
        switch currentState {
        case .ActiveSectors:
            activeIndex = activeIndex?.sorted(by: {(obj1, obj2) -> Bool in
                let val1 = obj1.index
                let val2 = obj2.index
                return val1 ?? "" > val2 ?? ""
            })
            arrIndex.append("All Indices")
            if activeIndex?.count ?? 0 > 0 {
                for (index, _) in (activeIndex?.enumerated())! {
                    arrIndex.append(activeIndex?[index].index ?? "")
                }
                chooseValue(1, title: "Please choose Indices", selectedindicesId)
            } else {
                self.showAlert(title: "Alert", message: "No data found", controller: self) {
                }
            }
        case .ActiveCompanies:
            activeCompanyIndex = activeCompanyIndex?.sorted(by: {(obj1, obj2) -> Bool in
                let val1 = obj1.index
                let val2 = obj2.index
                return val1 ?? "" > val2 ?? ""
            })
            arrIndex.append("All Indices")
            if activeCompanyIndex?.count ?? 0 > 0 {
                for (index, _) in (activeCompanyIndex?.enumerated())! {
                    arrIndex.append(activeCompanyIndex?[index].index ?? "")
                }
                chooseValue(1, title: "Please choose Indices", selectedindicesId)
            } else {
                self.showAlert(title: "Alert", message: "No data found", controller: self) {
                }
            }
        default:
            if indices?.indexes?.count ?? 0 > 0 {
                for (index, _) in (indices?.indexes?.enumerated())! {
                    arrIndex.append(indices?.indexes?[index] ?? "")
                }
                chooseValue(1, title: "Please choose Indices", selectedindicesId)
            } else {
                self.showAlert(title: "Alert", message: "No data found", controller: self) {
                }
            }
        }
    }
    @IBAction func didTapOnSectorBtn(_ sender: Any) {
        switch currentState {
        case .Advancers, .Decliners:
            arrSector.removeAll()
            if filterCompanySector?.count ?? 0 > 0 {
                arrSector.append("All Sectors")
                for (index, _) in (filterCompanySector?.enumerated())! {
                    arrSector.append(filterCompanySector?[index].sector ?? "")
                }
                chooseValue(2, title: "Please choose sector", selectedsectorId)
            } else {
                self.showAlert(title: "Alert", message: "No data found", controller: self) {
                }
            }
        case .ActiveSectors:
            break
        case .ActiveCompanies:
            arrSector.removeAll()
            if activeCompanySector?.count ?? 0 > 0 {
                arrSector.append("All Sectors")
                for (index, _) in (activeCompanySector?.enumerated())! {
                    arrSector.append(activeCompanySector?[index].sector ?? "")
                }
                chooseValue(2, title: "Please choose sector", selectedsectorId)
            } else {
                self.showAlert(title: "Alert", message: "No data found", controller: self) {
                }
            }
        }
        
        
    }
    
    @IBAction func didTapOnSortBtn(_ sender: Any) {
        switch currentState {
        case .ActiveSectors, .ActiveCompanies:
            sortArray = ["Sort", "Lowest to Highest", "Highest to Lowest"]
        case .Advancers :
            sortArray = ["Gainer (PKR)", "Gainer %"]
        case .Decliners:
            sortArray = ["Decliner (PKR)", "Decliner %"]
            
        }
        
        chooseValue(3, title: "Please choose Sort", selectedSortId)
    }
    
    private func chooseValue(_ tag: Int, title: String, _ selected: Int) {
        let vc = UIViewController()
        vc.preferredContentSize = CGSize(width: 250,height: 200)
        let pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: 250, height: 200))
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.tag = tag
        pickerView.selectRow(selected, inComponent:0, animated:true)
        vc.view.addSubview(pickerView)
        let editRadiusAlert = UIAlertController(title: title, message: "", preferredStyle: UIAlertController.Style.alert)
        editRadiusAlert.setValue(vc, forKey: "contentViewController")
        editRadiusAlert.addAction(UIAlertAction(title: "Done", style: .default, handler: { (alert: UIAlertAction!) in
            switch self.currentState {
            case .Advancers, .Decliners:
                if tag == 1 {
                    self.indexTF.text = self.arrIndex[self.selectedindicesId]
                    self.index = self.arrIndex[self.selectedindicesId]
                    self.indicesTxtLbl.text = "Data in this section pertains to \(self.indexTF.text ?? "")"
                    self.fetchData(self.type.rawValue, true, self.indexTF.text!)
                    self.selectedsectorId   = 0
                    self.sectorTF.text      = "All Sectors"
                    if self.type == .Advancers {
                        self.sortTF.text        = "Gainer (PKR)"
                    } else {
                        self.sortTF.text        = "Decliner (PKR)"
                    }
                    
                    self.selectedSortId     = 0
                    
                } else if pickerView.tag == 2 {
                    self.sectorTF.text = self.arrSector[self.selectedsectorId]
                    self.sector  = self.arrSector[self.selectedsectorId]
                    let indicesvalue = self.indexTF.text
                    self.filterCompanies(indicesvalue, self.sector, self.sortValue)
                } else {
                    self.sortTF.text = self.sortArray[self.selectedSortId]
                    self.sortValue  =   self.sortArray[self.selectedSortId]
                    self.sortingCompany(self.sortTF.text!, self.filterCompanies)
                }
                
            case .ActiveSectors:
                if tag == 1 {
                    self.indexTF.text = self.arrIndex[self.selectedindicesId]
                    self.index = self.arrIndex[self.selectedindicesId]
                    if self.selectedindicesId != 0 {
                        self.indicesTxtLbl.text = "Data in this section pertains to \(self.indexTF.text ?? "")"
                    } else {
                        self.indicesTxtLbl.text = "Data in this section pertains to KSE-All"
                    }
                    
                } else {
                    self.sortTF.text = self.sortArray[self.selectedSortId]
                    self.sortValue  =   self.sortArray[self.selectedSortId]
                }
                self.filterActiveSector(self.index, self.sortValue)
            case .ActiveCompanies:
                if tag == 1 {
                    self.indexTF.text = self.arrIndex[self.selectedindicesId]
                    self.index = self.arrIndex[self.selectedindicesId]
                    if self.selectedindicesId != 0 {
                        self.indicesTxtLbl.text = "Data in this section pertains to \(self.indexTF.text ?? "")"
                    } else {
                        self.indicesTxtLbl.text = "Data in this section pertains to KSE-All"
                    }
                    
                    
                } else if pickerView.tag == 2 {
                    self.sectorTF.text = self.arrSector[self.selectedsectorId]
                    self.sector  = self.arrSector[self.selectedsectorId]
                } else {
                    self.sortTF.text = self.sortArray[self.selectedSortId]
                    self.sortValue  =   self.sortArray[self.selectedSortId]
                }
                self.filterActiveCompanies(self.index, self.sector, self.sortValue)
            }
        }))
        self.present(editRadiusAlert, animated: true)
    }
    
    func filterActiveSector(_ index: String?, _ sort: String?) {
        
        if let index = index, !index.contains("All Indices"), let sort = sort, !sort.contains("sort") {
            self.filterSector = self.sectors?.filter( {  $0.index == index } )
            sortingSector(sort, filterSector)
        }
        else if let index = index, !index.contains("All Indices") {
            self.filterSector = self.sectors?.filter( {  $0.index == index })
        }
        
        else if let sort = sort {
            self.filterSector = self.sectors
            sortingSector(sort, filterSector)
        }
        else {
            self.filterSector = self.sectors
        }
        self.setUpTableView()
        
    }
     
    func filterCompanies(_ index: String?, _ sector: String?, _ sort: String?) {
        
        if let index = index, let sector = sector, !sector.contains("All Sectors") {
            self.filterCompanies = self.filterCompanySector?.filter( {  $0.sector == sector} )
        } else {
            self.filterCompanies = self.filterCompanySector
        }
        self.setUpTableView()
    }
    
    func sortingCompany(_ sort: String, _ comapniesArray: [PSXCompaniesTopModel]?) {
        if sort == "Gainer %" || sort == "Decliner %" {
            self.filterCompanies = comapniesArray?.sorted(by: { $0.changePerc < $1.changePerc})
        } else {
            self.filterCompanies = comapniesArray?.sorted(by: { $0.volume < $1.volume})
        }
        self.setUpTableView()
    }
    
    func sortingSector(_ sort: String, _ sectorArray: [PSXSectorTopModel]?) {
        if sort == "Highest to Lowest" {
            self.filterSector = sectorArray?.sorted(by: { $0.volume ?? 0.0 > $1.volume ?? 0.0 })
        } else {
            self.filterSector = sectorArray?.sorted(by: { $0.volume ?? 0.0 < $1.volume ?? 0.0 })
        }
    }
    
    func filterActiveCompanies(_ index: String?, _ sector: String?, _ sort: String?) {
        
        if let index = index, !index.contains("All Indices"), let sector = sector, !sector.contains("All Sector"), let sort = sort {
            self.filterActiveCompanies = self.activeCompanies?.filter( {  $0.index == index  && $0.sector == sector} )
            sortingActiveCompany(sort, filterActiveCompanies)
        }
        else if let index = index, !index.contains("All Indices"), let sector = sector, !sector.contains("All Sector") {
            self.filterActiveCompanies = self.activeCompanies?.filter( {  $0.index == index  && $0.sector == sector} )
        }
        else if let index = index, !index.contains("All Indices"), let sort = sort {
            self.filterActiveCompanies = self.activeCompanies?.filter( {  $0.index == index })
            sortingActiveCompany(sort, filterActiveCompanies)
        }
        else if let sector = sector, !sector.contains("All Sector"), let sort = sort {
            self.filterActiveCompanies = self.activeCompanies?.filter( {  $0.sector == sector })
            sortingCompany(sort, filterCompanies)
        }
        else if let index = index, !index.contains("All Indices") {
            self.filterActiveCompanies = self.activeCompanies?.filter( {  $0.index == index })
        }
        else if let sector = sector, !sector.contains("All Sectors") {
            self.filterActiveCompanies = self.activeCompanies?.filter( {  $0.sector == sector })
        }
        else if let sort = sort {
            sortingActiveCompany(sort,activeCompanies)
        }
        else {
            self.filterActiveCompanies = self.activeCompanies
        }
        self.setUpTableView()
    }
    
    func sortingActiveCompany(_ sort: String, _ comapniesArray: [ActiveCompanies]?) {
        if sort == "Highest to Lowest" {
            self.filterActiveCompanies = comapniesArray?.sorted(by: { $0.volume ?? 0.0 > $1.volume ?? 0.0 })
        } else {
            self.filterActiveCompanies = comapniesArray?.sorted(by: { $0.volume ?? 0.0 < $1.volume ?? 0.0 })
        }
    }
    
}

extension MarketPerformerDetailsVC: UITableViewDelegate, UITableViewDataSource {
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
        switch currentState {
            case .Advancers:
                count = filterCompanies?.count ?? 0
            case .Decliners:
                count = filterCompanies?.count ?? 0
            case .ActiveSectors:
                count = 1
            case .ActiveCompanies:
                if filterActiveCompanies?.count ?? 0 > 0 {
                    count = 1
                } else {
                    count = 0
                }
            default:
                break
            }
        if count == 0 {
            Utility.shared.emptyTableViewForMW(tableView)
        } else {
            tableView.backgroundView = nil
        }
        return count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch currentState {
        case .Advancers:
            let cell = tableView.dequeueReusableCell(withIdentifier: DeclinersTableViewCell.identifier, for: indexPath) as! DeclinersTableViewCell
            cell.data = filterCompanies?[indexPath.row]
            cell.imgView?.image = UIImage(named: "advancers-arrow")
            cell.state = "Advancers"
            cell.netChange.textColor = UIColor.init(rgb: 0x47AE0A)
            cell.changePrcLbl.textColor = UIColor.init(rgb: 0x47AE0A)
            if let netChnage = filterCompanies?[indexPath.row].netChange {
                cell.netChange.text = "\(String(describing: netChnage))"
            }
            if let changePerc = filterCompanies?[indexPath.row].changePerc, changePerc.isZero == false {
                cell.changePrcLbl.text = "\(String(describing: changePerc))%"
            } else {
                cell.changePrcLbl.text = "-"
            }
            return cell
            
        case .Decliners:
            let cell = tableView.dequeueReusableCell(withIdentifier: DeclinersTableViewCell.identifier, for: indexPath) as! DeclinersTableViewCell
            cell.data = filterCompanies?[indexPath.row]
            cell.imgView?.image = UIImage(named: "decliners-arrow")
            cell.state = "Decliners"
            cell.netChange.textColor = UIColor.init(rgb: 0xF54F4F)
            cell.changePrcLbl.textColor = UIColor.init(rgb: 0xF54F4F)
            if let netChnage = filterCompanies?[indexPath.row].netChange {
                cell.netChange.text = "\(String(describing: netChnage).toCurrencyFormat(withFraction: true))"
            }
            if let changePerc = filterCompanies?[indexPath.row].changePerc , changePerc.isZero == false{
                cell.changePrcLbl.text = "\(String(describing: changePerc))%"
            } else {
                cell.changePrcLbl.text = "-"
            }
            
            return cell
        case .ActiveSectors:
            let cell = tableView.dequeueReusableCell(withIdentifier: CompaniesViewCell.identifier, for: indexPath) as! CompaniesViewCell
            cell.sectorData = filterSector
            cell.companyLbl.text = "Sectors"
            cell.state = .ActiveSectors
            cell.innerTableView.reloadData()
            return cell
        case .ActiveCompanies:
            let cell = tableView.dequeueReusableCell(withIdentifier: CompaniesViewCell.identifier, for: indexPath) as! CompaniesViewCell
            cell.companyData = filterActiveCompanies
            cell.companyLbl.text = "Companies"
            cell.state = .ActiveCompanies
            cell.innerTableView.reloadData()
            return cell
        default:
            break
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
        
        switch indexPath.row {
        case 0:
            break
//            let vc = self.storyboard?.instantiateViewController(identifier: "MyStocksViewController") as! MyStocksViewController
//            self.navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }
    
}


class InnerTableView: UITableView {
    override var intrinsicContentSize: CGSize {
        self.layoutIfNeeded()
        return self.contentSize
    }
    
    override var contentSize: CGSize {
        didSet{
            self.invalidateIntrinsicContentSize()
        }
    }
}
extension MarketPerformerDetailsVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1 {
            return arrIndex.count
        } else if pickerView.tag == 2 {
            return arrSector.count ?? 0
        } else {
            return sortArray.count
        }
        
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1 {
            return arrIndex[row]
        } else if pickerView.tag == 2 {
            return arrSector[row]
        } else {
            return sortArray[row]
        }
        
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1 {
            indexTF.text = arrIndex[row]
            selectedindicesId = row
        } else if pickerView.tag == 2 {
            sectorTF.text = arrSector[row]
            selectedsectorId = row
        } else {
            sortTF.text = sortArray[row]
            selectedSortId = row
        }
        
    }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var title = UILabel()
        if let titleLbl = view {
            title = titleLbl as! UILabel
        }
        title.font = UIFont(name: "Roboto-Regular", size: 10)
        if pickerView.tag == 1 {
         title.text = arrIndex[row]
        } else if pickerView.tag == 2 {
            title.text =  arrSector[row]
        } else {
            title.text =  sortArray[row]
        }
        
        title.textAlignment = .center
        return title
    }
}
enum AdvancerType: String {
    case Advancers = "GAINER"
    case Decliners = "LOSER"
}

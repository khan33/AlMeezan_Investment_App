//
//  MyStocksViewController.swift
//  AlMeezan
//
//  Created by Atta khan on 20/11/2019.
//  Copyright © 2019 Atta khan. All rights reserved.
//

import UIKit
import SVProgressHUD
import CoreData

class MyStocksViewController: BaseViewController {

    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var plusImg: UIButton!
    @IBOutlet weak var removeStockView: UIView!
    @IBOutlet weak var addStockView: UIView!
    @IBOutlet weak var industryTxtField: UITextField!
    @IBOutlet weak var companyTxtField: UITextField!
    
    var topCompanies: [PSXCompaniesModel]?
    var uniqueCompanies: [PSXCompaniesModel]?
    var symbolCompanies: [PSXCompaniesModel]?
    var myStockData: [MyStockModel]?
    var state: Bool = false
    private let refreshControl = UIRefreshControl()
    var selectedSector: Int = 0
    var selectedSymobl: Int  = 0
    
    var symoblArray: [SymbolEntity]?
    var joinedString = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.topCompanies = fetchFromStorage()
        
        if self.topCompanies?.count ?? 0 == 0 {
            fetchCompanies()
        }
        self.uniqueCompanies?.removeAll()
        self.symbolCompanies?.removeAll()
        guard let data = self.topCompanies else {
           return
        }
        self.uniqueCompanies = data.unique( by: { $0.sector } )
        refreshControl.addTarget(self, action: #selector(refreshTableViewData(_:)), for: .valueChanged)
        if #available(iOS 10, *){
           tableView.refreshControl = refreshControl
        } else {
           tableView.addSubview(refreshControl)
        }
        
    }
    @objc private func refreshTableViewData(_ sender: Any) {
       getSector(false)
    }
    override func viewWillAppear(_ animated: Bool) {
        state = false
        removeStockView.alpha = 0
        heightConstraint.constant = 0
        getSector(true)
        plusImg.setImage(UIImage(named: "add_circle-24px"), for: .normal)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        SVProgressHUD.dismiss()
    }
    
    func fetchFromStorage() -> [PSXCompaniesModel]? {
        let managedObjectContext = persistence.context
        let fetchRequest = NSFetchRequest<PSXCompaniesModel>(entityName: "PSXCompaniesModel")
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
    private func getSector(_ show: Bool) {
        var array = [String]()
        PersistenceServices.shared.fetch(SymbolEntity.self) { [weak self] (data) in
            for result in data {
                print(result)
                let symobl = result.value(forKey: "symbol") as! String
                array.append(symobl)
            }
        }
        joinedString = array.joined(separator: "/")
        fetchStock(show)
    }

    
    private func clearTxtField() {
        industryTxtField.text = ""
        companyTxtField.text = ""
        selectedSymobl = 0
        selectedSector = 0
    }
    
    private func setUpTableView() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60
        tableView.delegate = self
        tableView.dataSource = self

        tableView.register(MyStockCell.nib, forCellReuseIdentifier: MyStockCell.identifier)
        tableView.backgroundColor = UIColor.init(rgb: 0xF4F6FA)
        tableView.reloadData()
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
            if tag == 1 {
                self.companyTxtField.text = self.symbolCompanies?[self.selectedSymobl].symbol
            }  else {
                self.symbolCompanies?.removeAll()
                guard let data = self.topCompanies?.filter({ $0.sector == self.uniqueCompanies?[self.selectedSector].sector}) else {
                   return
                }
                //let data = self.topCompanies?.filter({ $0.sector == self.uniqueCompanies?[self.selectedSector].sector})
                self.symbolCompanies = data.unique( by: { $0.symbol } )
                //self.symbolCompanies = self.topCompanies?.filter({ $0.sector == self.uniqueCompanies?[self.selectedSector].sector})
                self.industryTxtField.text = self.uniqueCompanies?[self.selectedSector].sector
            }
        }))
        self.present(editRadiusAlert, animated: true)
    }
    
    private func fetchCompanies() {
        
        let startDate   =   Date().toString(format: "yyyyMMdd") //"20201020"//
        let endDate     =   Date().toString(format: "yyyyMMdd")
        let bodyParam   =   RequestBody(StartDate: startDate, EndDate: endDate)
        let bodyRequest = bodyParam.encryptData(bodyParam)
        let url = URL(string: PSX_COMPANIES)!
        SVProgressHUD.show()
        
        WebServiceManager.sharedInstance.fetch(params: bodyRequest as Dictionary<String, AnyObject>, url: url, serviceType: "Cache Data", modelType: PSXCompaniesModel.self, errorMessage: { (errorMessage) in
            errorResponse = errorMessage
            self.showErrorMsg(errorMessage)
        }, success: { (response) in
            self.topCompanies = response
            self.uniqueCompanies?.removeAll()
            self.symbolCompanies?.removeAll()
            guard let data = self.topCompanies else {
                return
            }
            self.uniqueCompanies = data.unique( by: { $0.sector } )
        }, fail: { (error) in
            print(error.localizedDescription)
        }, showHUD: true)
        
    }
    
    
    private func fetchStock(_ show: Bool) {
        let date = Date().toString(format: "yyyyMMdd")
        let bodyParam = RequestBody(Date: date, Stock: joinedString)
        let bodyRequest = bodyParam.encryptData(bodyParam)
        let url = URL(string: MY_STOCK)!
        if show {
            SVProgressHUD.show()
        }
        WebServiceManager.sharedInstance.fetch(params: bodyRequest as Dictionary<String, AnyObject>, url: url, serviceType: "My Stock", modelType: MyStockModel.self, errorMessage: { (errorMessage) in
            errorResponse = errorMessage
            self.showErrorMsg(errorMessage)
        }, success: { (response) in
            self.myStockData = response
            self.setUpTableView()
            self.refreshControl.endRefreshing()
        }, fail: { (error) in
            print(error.localizedDescription)
        }, showHUD: true)
       
   }
    
    @IBAction func tapOnAddStockBtn(_ sender: UIButton) {
        state = !state
        if state == true {
            plusImg.setImage(UIImage(named: "remove_circle-24px-2"), for: .normal)
            UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseIn],
                           animations: {
                            self.heightConstraint.constant = 290
                            self.removeStockView.alpha = 1
                            
                            self.view.layoutIfNeeded()
            }, completion: nil)
            
        } else {
            clearTxtField()
            plusImg.setImage(UIImage(named: "add_circle-24px"), for: .normal)
            UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseIn],
                           animations: {
                            self.removeStockView.alpha = 0
                            self.heightConstraint.constant = 0
                            self.view.layoutIfNeeded()
            }, completion: nil)
            
        }
    }
    
    
    
    @IBAction func tapOnSearchBtn(_ sender: Any) {
        guard let data = self.topCompanies else {
            return
        }
        var companies = data.unique( by: { $0.symbol } )
        let vc = StockSearchVC.instantiateFromAppStroyboard(appStoryboard: .marketWatch)
        vc.topCompanies = companies
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func tapOnSectorBtn(_ sender: Any) {
        if self.topCompanies?.count ?? 0 > 0 {
            chooseValue(0, title: "Choose Industry", selectedSector)
        }
    }
    
    @IBAction func tapOnCompanyBtn(_ sender: Any) {
        
        guard let txtField  = industryTxtField.text, !txtField.isEmpty else {
            self.showAlert(title: "Alert", message: "Please choose first industry.", controller: self) {
            }
            return
        }
        chooseValue(1, title: "Choose Company", selectedSymobl)
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
    
    @IBAction func addBtn(_ sender: Any) {
        guard let txtField  = companyTxtField.text, !txtField.isEmpty else {
           self.showAlert(title: "Alert", message: "Please choose company.", controller: self) {
           }
           return
        }
        let resultPredicate     = NSPredicate(format: "symbol = %@", txtField)
        PersistenceServices.shared.fetchWithPredicate(SymbolEntity.self, resultPredicate) { [weak self] (data) in
            if data.count > 0 {
                self?.showConfirmationAlertViewWithTitle(title: "Alert", message: "Are you sure want to remoe this stock?") {
                    self?.showAlert(title: "Alert", message: "Already exist.", controller: self) {
                        return
                    }
                }
            } else {
                let stock = SymbolEntity.create(in: PersistenceServices.shared.context)
                stock.symbol = txtField
                PersistenceServices.shared.saveContext()
                self?.updateCompany(txtField, 1)
                self?.showAlert(title: "Alert", message: "Add Successfully.", controller: self) {
                    self?.clearTxtField()
                    self?.getSector(true)
                }
            }
        }
    }

}
extension MyStocksViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1 {
            return symbolCompanies?.count ?? 0
        } else {
            return uniqueCompanies?.count ?? 0
        }
        
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1 {
            return symbolCompanies?[row].symbol
        }  else {
            return uniqueCompanies?[row].sector
        }
        
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1 {
            companyTxtField.text = symbolCompanies?[row].symbol
            selectedSymobl = row
        } else {
            industryTxtField.text = uniqueCompanies?[row].sector
            selectedSector = row
            
        }
    }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var title = UILabel()
        if let titleLbl = view {
            title = titleLbl as! UILabel
        }
        title.font = UIFont(name: "Roboto-Regular", size: pickerTitleFontSize)
        if pickerView.tag == 1 {
            title.text =  symbolCompanies?[row].symbol
        }  else {
            title.text = uniqueCompanies?[row].sector
        }
        
        title.textAlignment = .center
        return title
    }
}
extension MyStocksViewController: UITableViewDelegate {
    
}


extension MyStocksViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myStockData?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MyStockCell.identifier, for: indexPath) as! MyStockCell
        cell.selectionStyle = .none
        cell.data = myStockData?[indexPath.row]
        cell.removeStockBtn.tag = indexPath.row
        cell.removeStockBtn.addTarget(self, action: #selector(removeStockData), for: .touchUpInside)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
   
    @objc func removeStockData(_ sender: UIButton) {
        let tag = sender.tag
        if let symbol = myStockData?[tag].symbol {
            self.showConfirmationAlertViewWithTitle(title: "Alert", message: "Are you sure want to remove this stock?") {
                let resultPredicate     = NSPredicate(format: "symbol = %@", symbol)
                PersistenceServices.shared.fetchWithPredicate(SymbolEntity.self, resultPredicate) { [weak self] (data) in
                    
                    let obj = data[0] as! NSManagedObject
                    PersistenceServices.shared.deleteObj(SymbolEntity.self, obj)
                    self?.updateCompany(symbol, 0)
                    self?.getSector(false)
                }
            }
        }
    }
}

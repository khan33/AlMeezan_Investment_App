//
//  InvestAllFundVC.swift
//  AlMeezan
//
//  Created by Atta khan on 14/10/2019.
//  Copyright © 2019 Atta khan. All rights reserved.
//

import UIKit
import SVProgressHUD
import SwiftKeychainWrapper

class InvestAllFundVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var riskLevelBtn: UIButton!
    @IBOutlet weak var fundCategoryBtn: UIButton!
    @IBOutlet weak var riskLevelfield: UITextField!
    @IBOutlet weak var fundCategoryField: UITextField!
    @IBOutlet weak var entryLoadField: UITextField!
    @IBOutlet weak var entryLoadBtn: UIButton!
    @IBOutlet weak var exitLoadField: UITextField!
    @IBOutlet weak var exitLoadBtn: UIButton!
    @IBOutlet weak var managementFeeField: UITextField!
    @IBOutlet weak var manaegmentBtn: UIButton!
    @IBOutlet weak var fundSizeField: UITextField!
    @IBOutlet weak var fundSizeBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var notificationBtn: UIButton!
    @IBOutlet weak var resetBtn: UIButton!
    @IBOutlet weak var countNotificationLbl: UIButton!

    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var data: [FundsModel]?
    var fund_list: [FundEntity]?
    var filter_fund_list: [FundEntity]?
    var riskLevel: [[String : AnyObject]]?
    var fundSize: [[String : AnyObject]]?
    var fundCategory: [[String : AnyObject]]?
    var managementFees: [[String : AnyObject]]?
    var entryLoads: [[String : AnyObject]]?
    var exitLoads: [[String : AnyObject]]?
    
    var isRiskLevel     : Int = 0
    var isFundCategory  : Int = 0
    var isFundSize      : Int = 0
    var isEntryLoad     : Int = 0
    var isExitLoad      : Int = 0
    var isManagementFee : Int = 0
    
    var riskLevelFilter: String?
    var fundCategoryFilter: String?
    var fundSizeFilter: String?
    var managementFeeFilter: String?
    var enterLoadFilter: String?
    var exitLoadFilter: String?
    var subPredicates : [NSPredicate] = []
    var filterCell: FundFilterCell = FundFilterCell()
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
         countNotificationLbl.isHidden = true
        Utility.shared.renderNotificationCount(countNotificationLbl)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideNavigationBar()
        setUpTableView()
        
        if let userAuth = KeychainWrapper.standard.string(forKey: "UserType") {
            if userAuth == "loggedInUser" {
                loginBtn.setImage(UIImage(named: "logout-icon-1"), for: .normal)
            } else {
                loginBtn.setImage(UIImage(named: "logout-icon"), for: .normal)
            }
        }
    }
    
    
    func getData() {
        let bodyParam = RequestBody()
        let bodyRequest = bodyParam.encryptData(bodyParam)
        let url = URL(string: FUND_FILTER)!
        SVProgressHUD.show()
        WebServiceManager.sharedInstance.getRequest(params: bodyRequest as Dictionary<String, AnyObject>, url: url, serviceType: "NAV", modelType: FundsModel.self, success: {(response) in
            self.data = response
            for(index, _ ) in (self.data?.enumerated())! {
                for(_, objCheck) in (self.data?[index].fundsList?.enumerated())! {
                    let fund_gruoup  =   objCheck.FundGroup ?? ""
                    let name    =   objCheck.fund ?? ""
                    
                    
                    let arrayOfProgram  = FundEntity.fetchAll() as NSArray?
                    let resultPredicate = NSPredicate(format: "fund_group = %@ AND fund_name = %@", fund_gruoup, name)
                    let arrayOfFilter   =   arrayOfProgram?.filtered(using: resultPredicate)
                    if ((arrayOfFilter?.count)! > 0) {
                        let obj = arrayOfFilter?[0] as? FundEntity
                        obj?.fund_group        =   objCheck.FundGroup
                        obj?.fund_name         =   objCheck.fund
                        obj?.fundCategory      =   objCheck.FundCategory
                        obj?.fund_size         =   objCheck.FundSize
                        obj?.management_fee    =   objCheck.ManagementFee
                        obj?.risk_level        =   objCheck.RiskLevel
                        obj?.entryLoad         =   objCheck.EntryLoad
                        obj?.exitLoad          =   objCheck.ExitLoad
                        FundEntity.save()
                    } else {
                        let fundEntity = FundEntity.create() as? FundEntity
                        fundEntity?.fund_group        =   objCheck.FundGroup
                        fundEntity?.fund_name         =   objCheck.fund
                        fundEntity?.fundCategory      =   objCheck.FundCategory
                        fundEntity?.fund_size         =   objCheck.FundSize
                        fundEntity?.management_fee    =   objCheck.ManagementFee
                        fundEntity?.risk_level        =   objCheck.RiskLevel
                        fundEntity?.entryLoad         =   objCheck.EntryLoad
                        fundEntity?.exitLoad          =   objCheck.ExitLoad
                        FundEntity.save()
                    }
                }
            }
            self.fund_list = FundEntity.fetchAll() as! [FundEntity]
            
            self.filter_fund_list = self.fund_list
            
            }, fail: { (error) in
                print("abcdef")
        }, showHUD: true)
    }
    
    func setUpTableView() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60
        tableView.registerCells([NAVHeaderCell.self])
        tableView.register(FundFilterCell.nib, forCellReuseIdentifier: FundFilterCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
        tableView.reloadData()
    }
    
    @IBAction func navigateToBackVC(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    func aggregateProductsInContext(_ context:NSManagedObjectContext, _ colum: String) -> [[String:AnyObject]]? {
        var expressionDescriptions = [AnyObject]()
        expressionDescriptions.append(colum as AnyObject)
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "FundEntity")
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: subPredicates)
        request.propertiesToGroupBy = [colum]
        request.resultType = .dictionaryResultType
        request.sortDescriptors = [NSSortDescriptor(key: colum, ascending: true)]
        request.propertiesToFetch = expressionDescriptions
        var results:[[String:AnyObject]]?
        do {
            results = try context.fetch(request) as? [[String:AnyObject]]
        } catch _ {
            results = nil
        }
        return results
    }
    
    func aggregateRiskInContext(_ context:NSManagedObjectContext, _ colum: String) -> [[String:AnyObject]]? {
        var expressionDescriptions = [AnyObject]()
        expressionDescriptions.append(colum as AnyObject)
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "FundEntity")
        request.propertiesToGroupBy = [colum]
        request.resultType = .dictionaryResultType
        request.sortDescriptors = [NSSortDescriptor(key: colum, ascending: true)]
        request.propertiesToFetch = expressionDescriptions
        var results:[[String:AnyObject]]?
        do {
            results = try context.fetch(request) as? [[String:AnyObject]]
        } catch _ {
            results = nil
        }
        return results
    }
   
    
    
    func onPickFundBtn(_ tag : Int, _ title: String, _ isSelected: Int) {
        let vc = UIViewController()
        vc.preferredContentSize = CGSize(width: 250,height: 200)
        let pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: 250, height: 200))
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.tag = tag
        pickerView.selectRow(isSelected, inComponent:0, animated:true)
        vc.view.addSubview(pickerView)
        let editRadiusAlert = UIAlertController(title: title, message: "", preferredStyle: UIAlertController.Style.alert)
        editRadiusAlert.setValue(vc, forKey: "contentViewController")
        editRadiusAlert.addAction(UIAlertAction(title: "Done", style: .default, handler: { (alert: UIAlertAction!) in
            self.setUpTableView()
            //self.scrollView.scrollToView(view: self.tableView, animated: true)
            let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! FundFilterCell
            
            if tag == 2 {
                self.fundCategoryFilter = self.fundCategory?[self.isFundCategory]["fundCategory"] as? String ?? ""
                cell.fundCategoryField.text = self.fundCategoryFilter
                
                
                cell.entryLoadView.isHidden = true
                
                self.fundSizeFilter                  =   nil
                self.managementFeeFilter             =   nil
                self.enterLoadFilter                 =   nil
                self.exitLoadFilter                  =   nil
                cell.fundSizeField.text              =   ""
                cell.entryLoadField.text             =   ""
                cell.exitLoadField.text              =   ""
                self.reloadTableViewSection()
                
                self.fundSize = self.aggregateProductsInContext(FundEntity.managedObjectContext(), "fund_size")
                if self.fundSize?.count ?? 0 > 1 {
                    cell.fundSizeHeightConstraint.constant = 66.0
                    cell.fundSizeStackView.isHidden = false
                    
                } else {
                    cell.fundSizeHeightConstraint.constant = 0
                    cell.fundSizeStackView.isHidden = true
                }
                cell.exitLoadHeightConstraint.constant = 0
                cell.exitStackView.isHidden  = true
            }
            else if tag == 3 {
                self.fundSizeFilter = self.fundSize?[self.isFundSize]["fund_size"] as? String
                cell.fundSizeField.text = self.fundSizeFilter

                self.enterLoadFilter                    =   nil
                self.exitLoadFilter                     =   nil
                cell.entryLoadField.text                =   ""
                cell.exitLoadField.text                 =   ""
                
                self.reloadTableViewSection()
                self.entryLoads = self.aggregateProductsInContext(FundEntity.managedObjectContext(), "entryLoad")
                if self.entryLoads?.count ?? 0 > 1 {
                    cell.entryLoadView.isHidden = false
                } else {
                   cell.entryLoadView.isHidden = true
                }
                cell.exitLoadHeightConstraint.constant = 0
                cell.exitStackView.isHidden  = true
            }
            else if tag == 4 {
                self.managementFeeFilter  = self.managementFees?[self.isManagementFee]["management_fee"] as? String
                cell.managementFeeField.text = self.managementFeeFilter
                self.reloadTableViewSection()
            }
            else if tag == 5 {
                self.enterLoadFilter = self.entryLoads?[self.isEntryLoad]["entryLoad"] as? String
                cell.entryLoadField.text = self.enterLoadFilter
                self.exitLoadFilter                     =   nil
                self.reloadTableViewSection()
                self.exitLoads = self.aggregateProductsInContext(FundEntity.managedObjectContext(), "exitLoad")
                if self.exitLoads?.count ?? 0 > 1 {
                    cell.exitLoadHeightConstraint.constant = 66.0
                    cell.exitStackView.isHidden = false
                } else {
                   cell.exitLoadHeightConstraint.constant = 0
                   cell.exitStackView.isHidden  = true
                }
                
                cell.exitLoadField.text = ""
            }
            else if tag == 6 {
                self.exitLoadFilter = self.exitLoads?[self.isExitLoad]["exitLoad"] as? String
                cell.exitLoadField.text = self.exitLoadFilter
                self.reloadTableViewSection()
            }
            else {
                UIView.animate(withDuration: 1.0, delay: 0, options: [.transitionCurlUp],
                               animations: {
                                cell.fundSizeHeightConstraint.constant = 0
                                cell.exitLoadHeightConstraint.constant = 0
                                cell.exitStackView.isHidden  = true
                                cell.fundSizeStackView.isHidden = true
                                self.view.layoutIfNeeded()
                }, completion: nil)
                self.riskLevelFilter = self.riskLevel?[self.isRiskLevel]["risk_level"] as? String ?? ""
                cell.riskLevelfield.text = self.riskLevelFilter
                
                cell.fundCategoryField.text = ""
                cell.fundSizeField.text = ""
                cell.entryLoadField.text = ""
                cell.exitLoadField.text = ""
                self.fundCategoryFilter              =   nil
                self.fundSizeFilter                  =   nil
                self.managementFeeFilter             =   nil
                self.enterLoadFilter                 =   nil
                self.exitLoadFilter                  =   nil
                self.isFundCategory                  =   0
                
                self.reloadTableViewSection()
                self.fundCategory = self.aggregateProductsInContext(FundEntity.managedObjectContext(), "fundCategory")
                if self.fundCategory?.count ?? 0 > 1 {
                    cell.fundCategoryView.isHidden = false
                } else {
                    cell.fundCategoryView.isHidden = true
                }
            }
            let count = self.filter_fund_list?.count ?? 0
            cell.fundCountLbl.text = "\(count)"
        }))
        self.present(editRadiusAlert, animated: true)
    }
    
    private func reloadTableViewSection( ) {
        if let risk_level = riskLevelFilter {
            subPredicates.removeAll()
            let subPredicate = NSPredicate(format: "%K == %@", "risk_level", risk_level)
            if !subPredicates.contains(subPredicate) {
                if subPredicates.count > 0 {
                    subPredicates.remove(at: 0)
                }
                subPredicates.append(subPredicate)
            }
        }
        if let fundCategory = fundCategoryFilter {
            let subPredicate = NSPredicate(format: "%K == %@", "fundCategory", fundCategory)
            if !subPredicates.contains(subPredicate) {
                if subPredicates.count > 1 {
                    subPredicates.remove(at: 1)
                }
                subPredicates.append(subPredicate)
            }
        }
        if let fund_size = fundSizeFilter {
            let subPredicate = NSPredicate(format: "%K == %@", "fund_size", fund_size)
            subPredicates.append(subPredicate)
        }
        if let management_fee = managementFeeFilter {
            let subPredicate = NSPredicate(format: "%K == %@", "management_fee", management_fee)
            subPredicates.append(subPredicate)
        }
        if let entery_load = enterLoadFilter {
            let subPredicate = NSPredicate(format: "%K == %@", "entryLoad", entery_load)
            subPredicates.append(subPredicate)
        }
        if let exit_load = exitLoadFilter {
            let subPredicate = NSPredicate(format: "%K == %@", "exitLoad", exit_load)
            subPredicates.append(subPredicate)
        }
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FundEntity")
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: subPredicates)
        do {
            filter_fund_list = try FundEntity.managedObjectContext().fetch(fetchRequest) as! [FundEntity]
        } catch {
            let fetchError = error as NSError
        }
        if filter_fund_list?.count ?? 0 > 1 {
            print("abc")
            //tableView.scrollToRow(at: IndexPath(row: 0, section: 1), at: .bottom, animated: true)
        } else {
            print("def")
        }
        tableView.reloadData()
    }
    
    @IBAction func tapOnNotificationBtn(_ sender: Any) {
        let vc = NotificationsVC.instantiateFromAppStroyboard(appStoryboard: .home)
        self.navigationController?.pushViewController(vc, animated: true)
    }
       
    @IBAction func tapOnLoginBtn(_ sender: Any) {
        loginOption()
     }
}
extension InvestAllFundVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        let count = filter_fund_list?.count ?? 0
        return count + 1
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor(red: 244.0 / 255.0, green: 246.0 / 255.0, blue: 255.0 / 255.0, alpha: 1)
        return view
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10.0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell    = tableView.dequeueReusableCell(withIdentifier: FundFilterCell.identifier, for: indexPath) as! FundFilterCell
            if cell.riskLevelfield.text == "" {
                cell.fundCategoryView.isHidden = true
                cell.fundSizeHeightConstraint.constant = 0
                cell.exitLoadHeightConstraint.constant = 0
                cell.exitStackView.isHidden  = true
                cell.fundSizeStackView.isHidden = true
            }
            
            cell.riskLevelBtn.addTarget(self, action: #selector(tapOnRiskBtn), for: .touchUpInside)
            cell.fundCategoryBtn.addTarget(self, action: #selector(tapOnFundBtn), for: .touchUpInside)
            cell.fundSizeBtn.addTarget(self, action: #selector(tapOnFundSizeBtn), for: .touchUpInside)
            cell.entryLoadBtn.addTarget(self, action: #selector(tapOnEntryBtn), for: .touchUpInside)
            cell.exitLoadBtn.addTarget(self, action: #selector(tapOnExitBtn), for: .touchUpInside)
            cell.resetBtn.addTarget(self, action: #selector(tapOnResetBtn), for: .touchUpInside)
            return cell
        } else {
            let cell    = tableView.dequeueReusableCell(withIdentifier: NAVHeaderCell.identifier, for: indexPath) as! NAVHeaderCell
            let randomFloat = Float.random(in: 0.6..<1)
            cell.cellView.backgroundColor = UIColor.rgb(red: 138.0, green: 38.0, blue: 155.0, alpha: CGFloat(randomFloat))
            cell.fundTitleLbl.textColor = UIColor.white
            cell.fundTitleLbl.text = filter_fund_list?[indexPath.section - 1].fund_name
            cell.tapBtn.tag = indexPath.section - 1
            cell.tapBtn.addTarget(self, action: #selector(tapOnCell), for: .touchUpInside)
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return UITableView.automaticDimension
        }
        return 55.0
    }
    
    @objc func tapOnRiskBtn(_ sender: UIButton) {
        riskLevel = aggregateRiskInContext(FundEntity.managedObjectContext(), "risk_level")
        
        onPickFundBtn(1, "Choose Risk Level", isRiskLevel)
    }
    @objc func tapOnFundBtn(_ sender: UIButton) {
        
        onPickFundBtn(2, "Choose Fund Category", isFundCategory)
    }
    @objc func tapOnFundSizeBtn(_ sender: UIButton) {
        
        onPickFundBtn(3, "Choose Fund Size", isFundSize)
    }
    
    @objc func tapOnManagementBtn(_ sender: UIButton) {
//        managementFees = aggregateProductsInContext(FundEntity.managedObjectContext(), "management_fee")
//        onPickFundBtn(4, "Choose Management Fee", isManagementFee)
    }
    
    @objc func tapOnEntryBtn(_ sender: UIButton) {
        
        onPickFundBtn(5, "Choose Entry Load", isEntryLoad)
    }
    @objc func tapOnExitBtn(_ sender: UIButton) {
        
        onPickFundBtn(6, "Choose Exit Load", isExitLoad)
    }
    @objc func tapOnCell(_ sender: UIButton) {
        let section = sender.tag
        let vc = InvestmentProductDetailVC.instantiateFromAppStroyboard(appStoryboard: .main)
        vc.fund_name = filter_fund_list?[section].fund_name
//        vc.fund_short_name = filter_fund_list?[section].fund
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func tapOnResetBtn(_ sender: UIButton) {
        let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! FundFilterCell
        cell.riskLevelfield.text        =   ""
        cell.fundCategoryField.text     =   ""
        cell.fundSizeField.text         =   ""
        cell.entryLoadField.text        =   ""
        cell.exitLoadField.text         =   ""
        //cell.managementFeeField.text    =   ""
        isRiskLevel                     =   0
        isFundCategory                  =   0
        isFundSize                      =   0
        isManagementFee                 =   0
        isEntryLoad                     =   0
        isExitLoad                      =   0
        riskLevelFilter                 =   nil
        fundCategoryFilter              =   nil
        fundSizeFilter                  =   nil
        managementFeeFilter             =   nil
        enterLoadFilter                 =   nil
        exitLoadFilter                  =   nil
        subPredicates.removeAll()
        filter_fund_list?.removeAll()
        cell.fundCountLbl.text = "0"
        UIView.animate(withDuration: 1.0, delay: 0, options: [.transitionCurlUp],
                       animations: {
                        self.tableView.reloadData()
                        cell.fundCategoryView.isHidden = true
                        cell.fundSizeHeightConstraint.constant = 0
                        cell.exitLoadHeightConstraint.constant = 0
                        cell.exitStackView.isHidden  = true
                        cell.fundSizeStackView.isHidden = true
                        self.view.layoutIfNeeded()
        }, completion: nil)
        
        
        
        
    }
}
extension InvestAllFundVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1 {
            return riskLevel?.count ?? 0
        } else if pickerView.tag == 2 {
            return fundCategory?.count ?? 0
        }else if pickerView.tag == 3 {
            return fundSize?.count ?? 0
        }else if pickerView.tag == 4 {
            return managementFees?.count ?? 0
        }else if pickerView.tag == 5 {
            return entryLoads?.count ?? 0
        }else if pickerView.tag == 6 {
            return exitLoads?.count ?? 0
        } else {
            return 0
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 2 {
            return fundCategory?[row]["fundCategory"] as? String
        } else if pickerView.tag == 3 {
            return fundSize?[row]["fund_size"] as? String
        }else if pickerView.tag == 4 {
            return managementFees?[row]["management_fee"] as? String
        }else if pickerView.tag == 5 {
            return entryLoads?[row]["entryLoad"] as? String
        }else if pickerView.tag == 6 {
            return exitLoads?[row]["exitLoad"] as? String
        }else {
            return riskLevel?[row]["risk_level"] as? String
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! FundFilterCell

        if pickerView.tag == 2 {
            isFundCategory = row
            fundCategoryFilter = fundCategory?[row]["fundCategory"] as? String
            cell.fundCategoryField.text = fundCategoryFilter
        } else if pickerView.tag == 3 {
            fundSizeFilter = fundSize?[row]["fund_size"] as? String
            cell.fundSizeField.text = fundSizeFilter
            isFundSize = row
        }else if pickerView.tag == 4 {
            managementFeeFilter = managementFees?[row]["management_fee"] as? String
            cell.managementFeeField.text = managementFeeFilter
            isManagementFee = row
        }else if pickerView.tag == 5 {
            enterLoadFilter = entryLoads?[row]["entryLoad"] as? String
            cell.entryLoadField.text = enterLoadFilter
            isEntryLoad = row
        }else if pickerView.tag == 6 {
            exitLoadFilter = exitLoads?[row]["exitLoad"] as? String
            cell.exitLoadField.text = exitLoadFilter
            isExitLoad = row
        }else {
            riskLevelFilter = riskLevel?[row]["risk_level"] as? String
            cell.riskLevelfield.text = riskLevelFilter
            isRiskLevel = row
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var title = UILabel()
        if let titleLbl = view {
            title = titleLbl as! UILabel
        }
        title.font = UIFont(name: "Roboto-Regular", size: pickerTitleFontSize)
        
        if pickerView.tag == 2 {
            title.text =  fundCategory?[row]["fundCategory"] as? String
        } else if pickerView.tag == 3 {
            title.text =  fundSize?[row]["fund_size"] as? String
        }else if pickerView.tag == 4 {
            title.text =  managementFees?[row]["management_fee"] as? String
        }else if pickerView.tag == 5 {
            title.text =  entryLoads?[row]["entryLoad"] as? String
        }else if pickerView.tag == 6 {
            title.text = exitLoads?[row]["exitLoad"] as? String
        }else {
            title.text = riskLevel?[row]["risk_level"] as? String
        }
        
        
        
        title.textAlignment = .center
        
        return title
    }
}
extension UIScrollView {
    
    // Scroll to a specific view so that it's top is at the top our scrollview
    func scrollToView(view:UIView, animated: Bool) {
        if let origin = view.superview {
            // Get the Y position of your child view
            
            let childStartPoint = origin.convert(view.frame.origin, to: self)
            // Scroll to a rectangle starting at the Y of your subview, with a height of the scrollview
            self.scrollRectToVisible(CGRect(x:0, y:childStartPoint.y,width: 1,height: self.frame.height), animated: animated)
        }
    }
    // Bonus: Scroll to top
    func scrollToTop(animated: Bool) {
        let topOffset = CGPoint(x: 0, y: -contentInset.top)
        setContentOffset(topOffset, animated: animated)
    }
    
    // Bonus: Scroll to bottom
    func scrollToBottom() {
        let bottomOffset = CGPoint(x: 0, y: contentSize.height - bounds.size.height + contentInset.bottom)
        if(bottomOffset.y > 0) {
            setContentOffset(bottomOffset, animated: true)
        }
    }
}

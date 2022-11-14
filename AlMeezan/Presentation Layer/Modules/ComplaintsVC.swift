//
//  ComplaintsVC.swift
//  AlMeezan
//
//  Created by Atta khan on 26/11/2019.
//  Copyright © 2019 Atta khan. All rights reserved.
//

import UIKit
import SVProgressHUD

class ComplaintsVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var complain_list: [ComplaintModel]?
    var portfolioid_list: [CustomerInvestment]?
    var complain_des: [ComplainDescriptionModel]?
    private var complaintArray = ["All", "Service Request", "Complaint"]
    private var statusArray = ["All", "In Progress", "Closed"]
    private var statusArrayVal = ["0", "2", "4"]
    
    private var selectedPortfolioId: Int = 0
    private var selectedTypeId: Int = 0
    private var selectedRequestTypeId: Int = 0
    private var selectedStatusId: Int = 0
    var create_complain: [CreateComplaint]?
    private let refreshControl = UIRefreshControl()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        portfolioid_list = Utility.shared.filterIdAscending()
        
        setUpTableView()
        refreshControl.addTarget(self, action: #selector(refreshTableViewData(_:)), for: .valueChanged)
        if #available(iOS 10, *){
           tableView.refreshControl = refreshControl
        } else {
           tableView.addSubview(refreshControl)
        }
    }
    
    private func setUpTableView() {
        tableView.backgroundColor = UIColor(red: 244.0/255.0, green: 246.0/255.0, blue: 250.0/255.0, alpha: 1.0)
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 160.0
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(EmailUsViewCell.nib, forCellReuseIdentifier: EmailUsViewCell.identifier)
        tableView.register(ComplaintRequestCell.nib, forCellReuseIdentifier: ComplaintRequestCell.identifier)
        tableView.register(ComplainNoCell.nib, forCellReuseIdentifier: ComplainNoCell.identifier)
        tableView.register(CompalinNoExpandCell.nib, forCellReuseIdentifier: CompalinNoExpandCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }
    
    @objc private func refreshTableViewData(_ sender: Any) {
       getComplainList(false)
    }
    func getComplainList(_ show: Bool) {
        let cell = self.tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as! ComplaintRequestCell
        let typeText = cell.typeTxtField.text!
        let statusVal = statusArrayVal[selectedStatusId]
        let bodyParam = RequestBody(type: typeText, Status: statusVal )
        let bodyRequest = bodyParam.encryptData(bodyParam)
        
        let url = URL(string: COMPLAIN_LIST)!
        if show {
            SVProgressHUD.show()
        }
        
        WebServiceManager.sharedInstance.fetch(params: bodyRequest as Dictionary<String, AnyObject>, url: url, serviceType: "Complain list", modelType: ComplaintModel.self, errorMessage: { (errorMessage) in
            errorResponse = errorMessage
            self.showErrorMsg(errorMessage)
        }, success: { (response) in
            self.complain_list = response
            self.setUpTableView()
            self.refreshControl.endRefreshing()
        }, fail: { (error) in
            print(error.localizedDescription)
        }, showHUD: true)
    }
    
    private func choosePlanValue(_ tag : Int, _ title: String, _ selectedOption: Int) {
        let vc = UIViewController()
        vc.preferredContentSize = CGSize(width: 250,height: 200)
        let pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: 250, height: 200))
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.tag = tag
        pickerView.selectRow(selectedOption, inComponent:0, animated:true)
        vc.view.addSubview(pickerView)
        let editRadiusAlert = UIAlertController(title: title, message: "", preferredStyle: UIAlertController.Style.alert)
        editRadiusAlert.setValue(vc, forKey: "contentViewController")
        editRadiusAlert.addAction(UIAlertAction(title: "Done", style: .default, handler: { (alert: UIAlertAction!) in
            let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! EmailUsViewCell
            let complainCell = self.tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as! ComplaintRequestCell
            if tag == 0 {
                cell.nameTxtField.text = self.portfolioid_list?[self.selectedPortfolioId].portfolioID
            } else if tag == 1 {
                cell.emailTxtField.text = self.complaintArray[self.selectedTypeId]
            } else if tag == 2 {
                complainCell.typeTxtField.text = self.complaintArray[self.selectedRequestTypeId]
            } else if tag == 3 {
                complainCell.statusTxtField.text = self.statusArray[self.selectedStatusId]
                self.getComplainList(true)
            }
            
            
            
        }))
        self.present(editRadiusAlert, animated: true)
        
    }
}
extension ComplaintsVC: UITableViewDelegate {
    
}
extension ComplaintsVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = complain_list?.count ?? 0
        return  2 + count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: EmailUsViewCell.identifier, for: indexPath) as! EmailUsViewCell
            cell.selectionStyle = .none
            cell.portfolioIdBtn.addTarget(self, action: #selector(tapOnPortfolioBtn), for: .touchUpInside)
            cell.complainTypeBtn.addTarget(self, action: #selector(tapOnComplainTypeBtn), for: .touchUpInside)
            cell.submitBtn.addTarget(self, action: #selector(tapOnSubmitBtn), for: .touchUpInside)
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: ComplaintRequestCell.identifier, for: indexPath) as! ComplaintRequestCell
            cell.selectionStyle = .none
            cell.typeBtn.addTarget(self, action: #selector(tapTypeBtn), for: .touchUpInside)
            cell.statusBtn.addTarget(self, action: #selector(tapStatusBtn), for: .touchUpInside)
            return cell
        }  else {
            let isExpanded = (complain_list?[indexPath.row - 2].isExpandable)!
            if isExpanded {
                let cell = tableView.dequeueReusableCell(withIdentifier: CompalinNoExpandCell.identifier, for: indexPath) as! CompalinNoExpandCell
                cell.selectionStyle = .none
                cell.data = complain_list?[indexPath.row - 2]
                getComplainDescription(indexPath)
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: ComplainNoCell.identifier, for: indexPath) as! ComplainNoCell
                cell.selectionStyle = .none
                cell.data = complain_list?[indexPath.row - 2]
                return cell
            }
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 340
        } else if indexPath.row == 1 {
            return 240
        }
        let isExpanded = (complain_list?[indexPath.row - 2].isExpandable)!
        if isExpanded {
            return UITableView.automaticDimension
        }
        return 70.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row >= 2 {
            let isExpanded =  (complain_list?[indexPath.row - 2].isExpandable)!
            complain_list?[indexPath.row - 2].isExpandable = !isExpanded
            self.tableView.reloadRows(at: [indexPath], with: .fade)
//            getComplainDescription(indexPath)
        }
    }
    
    func getComplainDescription(_ indexPath: IndexPath) {
        let complain_id = complain_list?[indexPath.row - 2].complaint_Number
//        let customer_id = UserDefaults.standard.string(forKey: "CustomerId")!
//        let token = UserDefaults.standard.string(forKey: "AccessToken")!
//        var loginPAram  =    [ : ] as [String : Any]
//        let paramStr = "{CustomerID':\(customer_id),AccessToken':\(token),ComplainID':\(complain_id!)}"
//        loginPAram = ["KeyValue": "\(paramStr)"]
        
        let bodyParam = RequestBody(ComplainID: complain_id)
        let bodyRequest = bodyParam.encryptData(bodyParam)
        
        let url = URL(string: COMPLAIN_VIEW)!
        SVProgressHUD.show()
        
        WebServiceManager.sharedInstance.fetch(params: bodyRequest as Dictionary<String, AnyObject>, url: url, serviceType: "Complain list", modelType: ComplainDescriptionModel.self, errorMessage: { (errorMessage) in
            errorResponse = errorMessage
            self.showErrorMsg(errorMessage)
        }, success: { (response) in
            self.complain_des = response
            if self.complain_des?.count ?? 0 > 0 {
                let complainCell = self.tableView.cellForRow(at: indexPath) as! CompalinNoExpandCell
                complainCell.commentLbl.text = self.complain_des?[0].resolutionComment
                complainCell.descLbl.text = self.complain_des?[0].descriptionStr
            }
            

        }, fail: { (error) in
            print(error.localizedDescription)
        }, showHUD: true)
    }
    
    
    
    @objc func tapOnPortfolioBtn(_ sender: UIButton) {
        choosePlanValue(0, "Choose Portfolio Id", selectedPortfolioId)
    }
    @objc func tapOnComplainTypeBtn(_ sender: UIButton) {
        choosePlanValue(1, "Choose Complaint Type", selectedTypeId)
    }
    @objc func tapTypeBtn(_ sender: UIButton) {
        choosePlanValue(2, "Choose Type", selectedRequestTypeId)
    }
    @objc func tapStatusBtn(_ sender: UIButton) {
       choosePlanValue(3, "Choose Complaint Status", selectedStatusId)
    }
    @objc func tapOnSubmitBtn(_ sender: UIButton) {
        let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! EmailUsViewCell
        guard let portfolioTxt  = cell.nameTxtField.text, !portfolioTxt.isEmpty else {
           self.showAlert(title: "Alert", message: "Please select your portfolio Id.", controller: self) {
           }
           return
       }
       guard let complainTypeTxt  = cell.emailTxtField.text, !complainTypeTxt.isEmpty else {
           self.showAlert(title: "Alert", message: "Please select complain type.", controller: self) {
           }
           return
       }
        guard let detailTxt  = cell.detailsTxtView.text, !detailTxt.isEmpty else {
          self.showAlert(title: "Alert", message: "Please enter description.", controller: self) {
          }
          return
      }
//        let customer_id = UserDefaults.standard.string(forKey: "CustomerId")!
//        let token = UserDefaults.standard.string(forKey: "AccessToken")!
//        var loginPAram  =    [ : ] as [String : Any]
//        let paramStr = "{CustomerID':\(customer_id),AccessToken':\(token),Portfolioid':\(portfolioTxt),ComplainType':\(complainTypeTxt)}"
//        loginPAram = ["KeyValue": "\(paramStr)", "ComplainMessage": "\(detailTxt)"]
        
        
        
        
        let bodyParam = RequestBody(PortfolioID: portfolioTxt, ComplainType: complainTypeTxt)
        let bodyRequest = bodyParam.encryptComplainData(bodyParam, detailTxt)
       
        let url = URL(string: COMPLAINT)!
        SVProgressHUD.show()
        
        WebServiceManager.sharedInstance.fetch(params: bodyRequest as Dictionary<String, AnyObject>, url: url, serviceType: "Complain list", modelType: CreateComplaint.self, errorMessage: { (errorMessage) in
            errorResponse = errorMessage
            self.showErrorMsg(errorMessage)
        }, success: { (response) in
            self.create_complain = response
            self.showAlert(title: "Alert", message: "Successfully added", controller: self) {
                cell.emailTxtField.text = ""
                cell.detailsTxtView.text = ""
                cell.nameTxtField.text = ""
            }

        }, fail: { (error) in
            print(error.localizedDescription)
        }, showHUD: true)
        
        
        
    }
    
    
}
extension ComplaintsVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 0 {
            return portfolioid_list?.count ?? 0
        } else {
            return complaintArray.count
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
       if pickerView.tag == 0 {
           return portfolioid_list?[row].portfolioID
       } else if pickerView.tag == 3 {
           return statusArray[row]
       } else {
           return complaintArray[row]
       }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! EmailUsViewCell
        let complainCell = tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as! ComplaintRequestCell
        if pickerView.tag == 0 {
            cell.nameTxtField.text = portfolioid_list?[row].portfolioID
            selectedPortfolioId = row
        } else if pickerView.tag == 1 {
            cell.emailTxtField.text = complaintArray[row]
            selectedTypeId = row
        } else if pickerView.tag == 2 {
            complainCell.typeTxtField.text = complaintArray[row]
            selectedRequestTypeId = row
        } else {
            complainCell.statusTxtField.text = statusArray[row]
            selectedStatusId = row
        }
    }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var title = UILabel()
        if let titleLbl = view {
            title = titleLbl as! UILabel
        }
        title.font = UIFont(name: "Roboto-Regular", size: pickerTitleFontSize)
        if pickerView.tag == 0 {
            title.text =  portfolioid_list?[row].portfolioID
        } else if pickerView.tag == 3 {
            title.text =  statusArray[row]
        } else {
            title.text =  complaintArray[row]
        }
        title.textAlignment = .center
        return title
    }
}

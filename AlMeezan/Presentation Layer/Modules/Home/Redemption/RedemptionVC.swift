//
//  RedemptionVC.swift
//  AlMeezan
//
//  Created by Atta khan on 04/11/2019.
//  Copyright © 2019 Atta khan. All rights reserved.
//

import UIKit
import SVProgressHUD
import EasyTipView
import SwiftKeychainWrapper
import Photos

class RedemptionVC: UIViewController, UIDocumentMenuDelegate {
    
    
    @IBOutlet weak var portfolioIdLbl: UILabel!
    @IBOutlet weak var portfolioTxtField: UITextField!
    @IBOutlet weak var portfolioBottomView: UIView!
    @IBOutlet weak var fundFromLbl: UILabel!
    @IBOutlet weak var fundFromTxtField: UITextField!
    @IBOutlet weak var fundFromBottomView: UIView!
    @IBOutlet weak var unitLbl: UILabel!
    @IBOutlet weak var valueLbl: UILabel!
    @IBOutlet weak var transactionTxtField: UITextField!
    @IBOutlet weak var valueView: UIView!
    @IBOutlet weak var valueAmount: UILabel!
    @IBOutlet weak var plusBtn: UIButton!
    @IBOutlet weak var minusBtn: UIButton!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var valueBtn: UIButton!
    @IBOutlet weak var wordAmountLbl: UILabel!
    @IBOutlet weak var checkBoxBtn: UIButton!
    @IBOutlet weak var transactionDetailLbl: UILabel!
    
    @IBOutlet weak var proceedView: UIView!
    @IBOutlet weak var continueView: UIView!
    @IBOutlet weak var formView: UIView!
    @IBOutlet weak var successView: UIView!
    @IBOutlet weak var idPortfolioLbl: UILabel!
    @IBOutlet weak var categoryLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var amountLbl: UILabel!
    @IBOutlet weak var transactionLbl: UILabel!
    @IBOutlet weak var referenceIdLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var okBtn: UIButton!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var copyBtn: UIButton!
    
    @IBOutlet weak var checkBoxLabel: UILabel!
    @IBOutlet weak var viewOfValue: UIView!
    @IBOutlet weak var unitView: UIView!
    @IBOutlet weak var amountType: UILabel!
    
    @IBOutlet weak var segmentControllerHeight: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    var selectedPortfolioId: Int = 0
    var selectedFundFromId: Int = 0
    var isSelectedFund: Bool = false
    var selectedFundToId: Int = 0
    var selectedSegmentIndex: Int = 2
    var marketValue = 0
    var balanceUnit = 0.0
    var expectedAmount: Any = 0
    var fundFromId : String = "0"
    var transactionType = "Unit"
    var portfolioid_list: [CustomerInvestment]?
    var funds_list: [Summary]?
    var transaction: [TransactionSubmission]?
    var cashTxt: [EasyCashModel]?
    var vpsTax: [VpsTaxDocument] = [VpsTaxDocument]()
    var redemptionMTPF: [VpsRedemptionModel]?
    var redemptionSubmission: [RedemptionSubmission]?
    var transactionDescription = "Redemption"
    var initialFieldString = ""
    var fileName: String = ""
    var isAbove900: Bool = false
    var isTaxable: Bool?
    var transactionText: String = ""
    
    var documentUniqueId: String = ""
    
    @IBOutlet weak var fileNameLbl: UILabel!
    @IBOutlet weak var fundPlanBtn: UIButton!
    let tipView = EasyTipView(text: "Tap to copy")
    var rowHeight: CGFloat = 66.0
    
    var imagePicker: UIImagePickerController!
    var image: UIImage? = UIImage()
    
    var imageUploading: String = ""
    var uploadingImgArr = [String : UIImage]()
    var media: [Media] = []
    var document: DocuemntUploadingCell?
    let randomfileName = UUID().uuidString + ".jpg"
    
    var tax1Year = "Tax1-Year"
    var tax2Year = "Tax2-Year"
    var tax3Year = "Tax3-Year"
    var imageUploadingIndex = 0
    
    let container = DependencyContainer()
    override func viewDidLoad() {
        super.viewDidLoad()
        transactionTxtField.delegate = self
        transactionTxtField.isUserInteractionEnabled = false
        successView.isHidden = true
        proceedView.isHidden = true
        valueView.isHidden = true
        valueView.backgroundColor = UIColor.init(rgb: 0xF4F6FA)
        valueAmount.textColor = UIColor.init(rgb: 0x8A269B)
        document?.uplaodingView.isHidden = true
        
        tableViewHeightConstraint.constant = 0
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        portfolioid_list = Utility.shared.filterIdAscending()
        //transactionTxtField.text = "0.0"
        transactionTxtField.textColor = UIColor.themeColor
        scrollView.delegate = self
//        scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: 1000)
        minusBtn.isUserInteractionEnabled = false
        segmentControl.defaultConfiguration()
        segmentControl.selectedConfiguration()
        hideNavigationBar()
        Utility.shared.analyticsCode("E-services (Redemption)")
        plusBtn.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        plusBtn.layer.cornerRadius = 4
        minusBtn.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
        minusBtn.layer.cornerRadius = 4
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        tipView.dismiss()
    }
    
    private func tableReload() {
        tableViewHeightConstraint.constant = CGFloat(vpsTax.count) * rowHeight
        tableView.dataSource = self
        tableView.delegate = self
        tableView.reloadData()
    }
    
    
    private func portfolioFunds(_ id: String) {
        funds_list?.removeAll()
        fundFromTxtField.text = ""
        selectedFundFromId = 0
        self.portfolioTxtField.text = id
        let resultPredicate     = NSPredicate(format: "portfolioID = %@", id)
        let sort = NSSortDescriptor(key: "agentName", ascending: false)
        PersistenceServices.shared.fetchWithPredicate(Summary.self, resultPredicate) { [weak self] (data) in
            var data1 = data.filter( {$0.balunits > 0} )
            self?.funds_list = data1
        }
    }
    
    func getRedemptionData() {
        let portId = portfolioid_list?[self.selectedPortfolioId].portfolioID
        let customerID  :   String? = KeychainWrapper.standard.string(forKey: "CustomerId")
        let accessToken :   String? = KeychainWrapper.standard.string(forKey: "AccessToken")
        
        let bodyParam = RequestBody(CustomerID: customerID, AccessToken: accessToken, PortfolioID: portId)
        let bodyRequest = bodyParam.encryptData(bodyParam)
        let url = URL(string: VPS_REDEMPTION)!
        SVProgressHUD.show()
        
        WebServiceManager.sharedInstance.fetch(params: bodyRequest as Dictionary<String, AnyObject>, url: url, serviceType: "Easy Txt", modelType: VpsRedemptionModel.self, errorMessage: { (errorMessage) in
            errorResponse = errorMessage
            //self.showErrorMsg(errorMessage)
        }, success: { (response) in
            self.redemptionMTPF = response
            
            if self.redemptionMTPF?.count ?? 0 > 0 {
                self.valueAmount.text = "PKR \(Double(self.redemptionMTPF?[0].bal ?? 0.0))"
                self.fundFromTxtField.text = self.redemptionMTPF?[0].description
                self.fundPlanBtn.isEnabled = false
                self.transactionText = self.redemptionMTPF?[0].description ?? ""
                self.expectedAmount = Double(self.redemptionMTPF?[0].bal ?? 0.0)
                self.updatetransactionTxtField()
                if let isTaxable = self.redemptionMTPF?[0].isTaxabale , isTaxable == true {
                    self.getTaxDocument()
                } else {
                    self.tableViewHeightConstraint.constant = 0
                }
            }
        }
                                               , fail: { (error) in
            print(error.localizedDescription)
        }, showHUD: true)
    }
    
    func getTaxDocument() {
        let portId = portfolioid_list?[self.selectedPortfolioId].portfolioID
        let customerID  :   String? = KeychainWrapper.standard.string(forKey: "CustomerId")
        let accessToken :   String? = KeychainWrapper.standard.string(forKey: "AccessToken")
        
        let bodyParam = RequestBody(CustomerID: customerID, AccessToken: accessToken, PortfolioID: portId)
        let bodyRequest = bodyParam.encryptData(bodyParam)
        let url = URL(string: VPS_TAX)!
        SVProgressHUD.show()
        
        WebServiceManager.sharedInstance.fetch(params: bodyRequest as Dictionary<String, AnyObject>, url: url, serviceType: "Easy Txt", modelType: VpsTaxDocument.self, errorMessage: { (errorMessage) in
            errorResponse = errorMessage
            //self.showErrorMsg(errorMessage)
        }, success: { (response) in
            self.vpsTax = response
            
            self.tableReload()
        }
                                               , fail: { (error) in
            print(error.localizedDescription)
        }, showHUD: true)
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
                self.isSelectedFund = true
                self.fundFromTxtField.text = self.funds_list?[self.selectedFundFromId].fundAgentName
                self.fundFromId = self.funds_list?[self.selectedFundFromId].fundAgentId ?? "0"
                
                if let balance_unit = self.funds_list?[self.selectedFundFromId].balunits {
                    self.expectedAmount = Double(balance_unit)
                    self.unitLbl.text = "\(String(describing: balance_unit))"
                    self.updatetransactionTxtField()
                }
                self.segmentControl.selectedSegmentIndex = 2
                self.disableBtn(false)
                let marketValue = self.funds_list?[self.selectedFundFromId].marketValue ?? 0.0
                self.valueLbl.text = "PKR \(String(describing: marketValue).toCurrencyFormat(withFraction: false))"
                
                self.marketValue = Int(self.funds_list?[self.selectedFundFromId].marketValue ?? 0.0)
                self.balanceUnit = Double(self.funds_list?[self.selectedFundFromId].balunits ?? 0.0)
            }  else {
                self.portfolioTxtField.text = self.portfolioid_list?[self.selectedPortfolioId].portfolioID
                UserDefaults.standard.set(self.portfolioid_list?[self.selectedPortfolioId].portfolioID, forKey: "portfolioId")
                if let id = self.portfolioid_list?[self.selectedPortfolioId].portfolioID {
                    
                    if let lastId = id.components(separatedBy: "-").last, let num = Int(lastId) {
                        print(num)
                        if !(900...999).contains(num) {
                            self.portfolioFunds(id)
                            self.isAbove900 = false
                            self.showTransactionDetails()
                        } else {
                            self.getRedemptionData()
                            self.hideTransactionDetails()
                            self.isAbove900 = true
                            self.refreshFrom()
                        }
                        self.media.removeAll()
                    }
                }
            }
        }))
        self.present(editRadiusAlert, animated: true)
    }
    
    func hideTransactionDetails() {
        self.valueView.isHidden = false
        self.checkBoxBtn.isHidden = true
        self.unitLbl.isHidden = true
        self.valueLbl.isHidden = true
        self.unitView.isHidden = true
        self.viewOfValue.isHidden = true
        self.checkBoxLabel.isHidden = true
        self.segmentControl.isHidden = true
        self.segmentControllerHeight.constant = 0
    }
    
    func showTransactionDetails() {
        self.valueView.isHidden = true
        self.segmentControl.isHidden = false
        self.checkBoxBtn.isHidden = false
        self.unitLbl.isHidden = false
        self.valueLbl.isHidden = false
        self.unitView.isHidden = false
        self.viewOfValue.isHidden = false
        self.checkBoxLabel.isHidden = false
        self.fundPlanBtn.isEnabled = true
        self.tableViewHeightConstraint.constant = 0
        self.segmentControllerHeight.constant = 40
    }
    
    func getEasyCashTxt() {
        let bodyParam = RequestBody()
        let bodyRequest = bodyParam.encryptData(bodyParam)
        let url = URL(string: MECTEXT)!
        SVProgressHUD.show()
        
        WebServiceManager.sharedInstance.fetch(params: bodyRequest as Dictionary<String, AnyObject>, url: url, serviceType: "Easy Txt", modelType: EasyCashModel.self, errorMessage: { (errorMessage) in
            errorResponse = errorMessage
            //self.showErrorMsg(errorMessage)
        }, success: { (response) in
            self.cashTxt = response
            
            if self.cashTxt?.count ?? 0 > 0 {
                if let txt = self.cashTxt?[0].text {
                    self.transactionDetailLbl.text = txt
                }
            }
        }, fail: { (error) in
            print(error.localizedDescription)
        }, showHUD: true)
    }
    
    
    func transactionSubmissionVPS() {
        
        let customerID  :   String? = KeychainWrapper.standard.string(forKey: "CustomerId")
        let accessToken :   String? = KeychainWrapper.standard.string(forKey: "AccessToken")
        let portId = portfolioid_list?[self.selectedPortfolioId].portfolioID
        
        var trancationAmount = transactionTxtField.text!
        trancationAmount = trancationAmount.replacingOccurrences(of: ",", with: "", options: NSString.CompareOptions.literal, range: nil)
        
        let bodyParam = RedemptionSubmissionRequestBody(customerId: customerID, AccessToken: accessToken, portfolioId: portId ,amount: trancationAmount, fundId: self.redemptionMTPF?[0].fundID ?? "", agentId: self.redemptionMTPF?[0].aGENT_ID ?? "", FundIdTo: "", AgentTo: "", transactionType: "MTPFREDEMPTION", documentId: self.documentUniqueId , isTaxable: true )
        
        let bodyRequest = bodyParam.encryptData(bodyParam)
        let url = URL(string: TRANSACTION_SUBMISSION_VPS)!
        SVProgressHUD.show()
        
        WebServiceManager.sharedInstance.fetch(params: bodyRequest as Dictionary<String, AnyObject>, url: url, serviceType: "Nav Fund", modelType: RedemptionSubmission.self, errorMessage: { (errorMessage) in
            errorResponse = errorMessage
            self.showErrorMsg(errorMessage)
        }, success: { (response) in
            self.redemptionSubmission = response
            if self.redemptionSubmission?.count ?? 0 > 0  {
                if let id = self.redemptionSubmission?[0].OrdId {
                    self.updateSuccessUI(id)
                }
            }
            //self.configTableView()
        }, fail: { (error) in
            print(error.localizedDescription)
        }, showHUD: true)
    }
    
    
    private func disableBtn(_ enable: Bool) {
        minusBtn.isUserInteractionEnabled = enable
        plusBtn.isUserInteractionEnabled  = enable
    }
    
    func checkUploadedImage() {
        if self.redemptionMTPF?.count ?? 0 > 0 {
            if let isTaxable = self.redemptionMTPF?[0].isTaxabale , isTaxable == true {
                if vpsTax.count == media.count {
                    self.uploadImageToServer()
                } else {
                    self.showAlert(title: "Image Not Selected!", message: "Please select images", controller: self) {
                    }
                    return
                }
            }
        }
    }
    
    private func refreshFrom() {
        fundFromTxtField.text = ""
        unitLbl.text = "0"
        valueLbl.text = "0"
        transactionTxtField.text = "0.0"
        segmentControl.selectedSegmentIndex = 2
        transactionTxtField.isUserInteractionEnabled = false
        isSelectedFund = false
        disableBtn(false)
    }
    
    @IBAction func switchSegmentBtn(_ sender: UISegmentedControl) {
        selectedSegmentIndex = sender.selectedSegmentIndex
        switch sender.selectedSegmentIndex {
        case 0:
            transactionType = "Amount"
            if isSelectedFund {
                expectedAmount = Int(funds_list?[selectedFundFromId].marketValue ?? 0.0)
                updatetransactionTxtField()
            } else {
                transactionTxtField.text = "0"
            }
            
            transactionTxtField.isUserInteractionEnabled = true
            disableBtn(true)
        case 1:
            transactionType = "Unit"
            if isSelectedFund {
                expectedAmount = Double(funds_list?[selectedFundFromId].balunits ?? 0.0)
                updatetransactionTxtField()
            } else {
                transactionTxtField.text = "0.0"
            }
            transactionTxtField.isUserInteractionEnabled = true
            disableBtn(true)
        case 2:
            transactionType = "Unit"
            if isSelectedFund {
                expectedAmount = Double(funds_list?[selectedFundFromId].balunits ?? 0.0)
                updatetransactionTxtField()
            } else {
                transactionTxtField.text = "0.0"
            }
            transactionTxtField.isUserInteractionEnabled = false
            disableBtn(false)
        default:
            break
        }
    }
    
    
    @IBAction func tapOnPortfolioIdBtn(_ sender: Any) {
        if portfolioid_list?.count ?? 0 > 0 {
            chooseValue(0, title: "Choose Portfolio Id", selectedPortfolioId)
        } else {
            self.showAlert(title: "Alert", message: Message.MTPFPMessage, controller: self) {
            }
        }
    }
    
    @IBAction func tapOnFundFromBtn(_ sender: Any) {
        if funds_list?.count ?? 0 > 0 {
            chooseValue(1, title: "Choose Fund", selectedFundFromId)
        } else {
            self.showAlert(title: "Alert", message: Message.fundNotAvaliable, controller: self) {
            }
        }
        
    }
    
    @IBAction func tapOnPlusBtn(_ sender: Any) {
        if selectedSegmentIndex == 0 {
            let actualValue = self.funds_list?[self.selectedFundFromId].marketValue ?? 0.0
            let string = transactionTxtField.text ?? "0"
            let resultStr = string.filter("0123456789.".contains)
            let amount: Double? = Double(resultStr)
            
            if var value = amount {
                if value < actualValue {
                    let diff = actualValue - value
                    if diff < Double(minimumAmount) {
                        value = value + diff
                    } else {
                        value = value + Double(minimumAmount)
                    }
                    
                }
                expectedAmount = value
                updatetransactionTxtField()
                
            }
            
        }
        else if selectedSegmentIndex == 1 {
            let string = transactionTxtField.text ?? "0"
            let resultStr = string.filter("0123456789.".contains)
            let amount: Double? = Double(resultStr)?.rounded(toPlaces: 4)
            if let actualUnit = self.funds_list?[self.selectedFundFromId].balunits {
                if var value = amount {
                    if value < actualUnit {
                        let diff = actualUnit - value
                        if diff < minimumUnit {
                            value = value + diff
                        } else {
                            value = value + minimumUnit
                        }
                        
                    }
                    expectedAmount = value.rounded(toPlaces: 4)
                    updatetransactionTxtField()
                    
                }
            }
            
        }
        else {
            //disableBtn(false)
        }
        
        
    }
    
    @IBAction func tapOnMinusBtn(_ sender: Any) {
        if selectedSegmentIndex == 0 {
            let actualValue = self.funds_list?[self.selectedFundFromId].marketValue ?? 0.0
            let string = transactionTxtField.text ?? "0"
            let resultStr = string.filter("0123456789.".contains)
            let amount: Double? = Double(resultStr)
            
            if var value = amount {
                if value <= actualValue && value > Double(minimumAmount) {
                    value = value - Double(minimumAmount)
                } else if value <= Double(minimumAmount) {
                    value = 0
                }
                expectedAmount = value
                updatetransactionTxtField()
            }
        }
        else if selectedSegmentIndex == 1{
            let string = transactionTxtField.text ?? "0"
            let resultStr = string.filter("0123456789.".contains)
            let amount = Double(resultStr)?.rounded(toPlaces: 4)
            if let actualUnit = self.funds_list?[self.selectedFundFromId].balunits {
                if var value = amount {
                    if value <= actualUnit && value > minimumUnit {
                        value = value - minimumUnit
                    } else if value <= minimumUnit {
                        value = 0.0
                    }
                    expectedAmount = value.rounded(toPlaces: 4)
                    updatetransactionTxtField()
                    
                }
            }
        }
        else {
            //disableBtn(false)
        }
    }
    private func updatetransactionTxtField() {
        if selectedSegmentIndex == 0 {
            transactionTxtField.text = "\(String(describing: expectedAmount))"
        } else {
            transactionTxtField.text = "\(String(describing: expectedAmount))"
        }
        convertCurrencyIntoWord(transactionTxtField.text!)
    }
    
    @IBAction func tapOnCheckBox(_ sender: UIButton) {
        if fundFromTxtField.text != "" {
            sender.isSelected = !sender.isSelected
            selectedSegmentIndex = 2
            if sender.isSelected {
                selectedSegmentIndex = 0
                transactionType = "Amount"
                plusBtn.isHidden = true
                minusBtn.isHidden = true
                valueBtn.isHidden = false
                transactionTxtField.isUserInteractionEnabled = true
                segmentControl.isHidden = true
                getEasyCashTxt()
                transactionDescription = "MEC REDEMPTION"
                expectedAmount = Int(self.funds_list?[self.selectedFundFromId].marketValue ?? 0.0)
                updatetransactionTxtField()
            } else {
                transactionDescription = "Redemption"
                plusBtn.isHidden = false
                minusBtn.isHidden = false
                segmentControl.isHidden = false
                valueBtn.isHidden = true
                transactionDetailLbl.text = "Transaction Detail"
                expectedAmount = Double(self.funds_list?[self.selectedFundFromId].balunits ?? 0.0)
                updatetransactionTxtField()
            }
        } else {
            self.showAlert(title: "Alert", message: "Please select your Fund.", controller: self) {
            }
            return
        }
    }
    
    
    @IBAction func tapOnTermsBtn(_ sender: Any) {
        let vc = BlogsViewController.instantiateFromAppStroyboard(appStoryboard: .main)
        vc.urlStr = TERMS_CONDITIONS
        vc.titleStr = "Terms & Conditions"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func tapOnResetBtn(_ sender: Any) {
        refreshFrom()
    }
    
    @IBAction func tapOnContinueBtn(_ sender: Any) {
   
        guard let portfolioTxt  = portfolioTxtField.text, !portfolioTxt.isEmpty else {
            self.showAlert(title: "Alert", message: "Please select your portfolio Id.", controller: self) {
            }
            return
        }
        guard let fundFromTxt  = fundFromTxtField.text, !fundFromTxt.isEmpty else {
            self.showAlert(title: "Alert", message: "Please select fund.", controller: self) {
            }
            return
        }
        
        guard let transaction_amount  = transactionTxtField.text, !transaction_amount.isEmpty else {
            self.showAlert(title: "Alert", message: "Please enter transaction amount.", controller: self) {
            }
            return
        }
        if transaction_amount == "0" || transaction_amount == "0.0" || transaction_amount == "0.00"{
            self.showAlert(title: "Alert", message: "Insufficient balance in \n \(fundFromTxt).", controller: self) {
            }
            return
        }
        
        
        if !isAbove900 {
            transactionLbl.text = "Redemption"
            var message = ""
            var actualValue = 0.0
            if selectedSegmentIndex == 0 {
                message = "Amount Exceeds the available amount."
                actualValue = self.funds_list?[self.selectedFundFromId].marketValue ?? 0.0
            } else {
                message = "Units Exceeds the available units."
                actualValue = Double(self.funds_list?[self.selectedFundFromId].balunits ?? 0.0)
            }
            let amount = transaction_amount.doubleValue
            if let value = amount {
                if value > actualValue {
                    self.showAlert(title: "Alert", message: message, controller: self) {
                        //return false
                    }
                    return
                }
            }
            
            if checkBoxBtn.isSelected {
                let value = transaction_amount.replacingOccurrences(of: ",", with: "", options: NSString.CompareOptions.literal, range: nil)
                let amount = Int(value) ?? 0
                if amount < 1000 {
                    self.showAlert(title: "Alert", message: "Sorry, Your transaction amount shoud be greater than or equal to PKR 1000.", controller: self) {
                    }
                    return
                }
            }
        } else {
            if self.redemptionMTPF?.count ?? 0 > 0 {
                if let isTaxable = self.redemptionMTPF?[0].isTaxabale , isTaxable == true {
                    if vpsTax.count == media.count {
                        self.uploadImageToServer()
                    } else {
                        self.showAlert(title: "Image Not Selected!", message: "Please select images", controller: self) {
                        }
                        return
                    }
                }
            }
            transactionLbl.text = self.transactionText
        }
 
        let portfolioId = UserDefaults.standard.string(forKey: "portfolioId")!
        idPortfolioLbl.text = portfolioId
        categoryLbl.text = fundFromTxt
        if transactionType == "Amount" {
            amountLbl.text = "PKR \(transaction_amount.toCurrencyFormat(withFraction: false))"
        } else {
            if transaction_amount.contains(",") {
                amountLbl.text = "\(transaction_amount.toCurrencyFormat(withFraction: false)) Units"
            } else {
                amountLbl.text = "\(transaction_amount.toCurrencyFormat(withFraction: false)) Units"
            }
        }
        formView.isHidden = true
        proceedView.isHidden = false
        continueView.isHidden = true
        let point = CGPoint(x: 0, y: 0)
        scrollView.setContentOffset(point, animated: true)
    }
    
    @IBAction func tapONTransactionsBtn(_ sender: Any) {
        let vc = StatusTransactionsVC.instantiateFromAppStroyboard(appStoryboard: .home)
        navigationController?.pushViewController(vc, animated: true)
    }
    func formatCurrency(string: String, textField: UITextField) {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        let resultStr = string.filter("0123456789.".contains)
        if resultStr.contains(".") {
            let numberFromField = Double(resultStr)
            if let number = numberFromField {
                expectedAmount = NSNumber(value: number).stringValue
            } else {
                expectedAmount = 0
            }
            transactionTxtField.text = "\(String(describing: expectedAmount).toCurrencyFormat(withFraction: false))"
        } else {
            let numberFromField = Int(resultStr)
            if let number = numberFromField {
                expectedAmount = number
            } else {
                expectedAmount = 0
            }
            transactionTxtField.text = "\(String(describing: expectedAmount).toCurrencyFormat(withFraction: false))"
        }
    }
    func convertCurrencyIntoWord(_ amount: String) {
        let dataType = type(of: expectedAmount)
        if dataType == Int.self {
            amountType.text = "PKR :"
            wordAmountLbl.text = Utility.shared.formatCurrencyInWords(string: amount)
        } else {
            if dataType == String.self {
                expectedAmount = (expectedAmount as! NSString).doubleValue
            }
            amountType.text = "Units :"
            wordAmountLbl.text = Utility.shared.formatCurrencyInWords(string: amount)
        }
    }
    
    func documentMenu(_ documentMenu: UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
        documentMenu.delegate = self
        present(documentMenu, animated: true, completion: nil)
    }
    
    @IBAction func didTapOnProceedBtn(_ sender: Any) {
        
        if !isAbove900 {
            submitInvestment()
        } else {
            if self.redemptionMTPF?.count ?? 0 > 0 {
                if let isTaxable = self.redemptionMTPF?[0].isTaxabale , ( isTaxable == true && self.documentUniqueId == "" ) {
                    self.showAlert(title: "Alert!", message: "Image not uploaded yet! please try again.", controller: self) {
                    }
                    return
                }
            }
            self.transactionSubmissionVPS()
        }
        
    }
    @IBAction func didTapOnCopyBtn(_ sender: Any) {
        UIPasteboard.general.string = referenceIdLbl.text
        
        if let string = UIPasteboard.general.string {
            print(string)
        }
        self.showToast(message: "Successfully reference id copied. ", font: .systemFont(ofSize: 12.0))
    }
    @IBAction func didTapOnGalleryBtn(_ sender: Any) {
        saveBtn.isHidden = true
        okBtn.isHidden = true
        copyBtn.isHidden = true
        tipView.dismiss()
        let screenshotImage = successView.image()
        
        if let image = screenshotImage {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            self.showToast(message: "Successfully saved to gallery.", font: .systemFont(ofSize: 12.0))
            saveBtn.isHidden = false
            okBtn.isHidden = false
            copyBtn.isHidden = false
        }
        //Utility.shared.takeScreenshot(true)
    }
    @IBAction func didTapOnOKBtn(_ sender: Any) {
        self.refreshFrom()
        self.showTransactionDetails()
        tableViewHeightConstraint.constant = 0
        self.portfolioTxtField.text = ""
        formView.isHidden = false
        continueView.isHidden = false
        proceedView.isHidden = true
        successView.isHidden = true
        tipView.dismiss()
    }
    @IBAction func didTapOnCancelBtn(_ sender: Any) {
        proceedView.isHidden = true
        formView.isHidden = false
        continueView.isHidden = false
    }
    
    private func copyIndicator() {
        tipView.show(forView: self.copyBtn, withinSuperview: self.navigationController?.view)
    }
    func updateSuccessUI(_ id: String) {
        let dateStr = Date().dateAndTimetoString(format: "EEEE, MMM d, YYYY")
        let timeStr = Date().dateAndTimetoString(format: "h:mm a")
        dateLbl.text = dateStr
        timeLbl.text = timeStr
        referenceIdLbl.text = id
        proceedView.isHidden = true
        successView.isHidden = false
        formView.isHidden = true
        self.refreshFrom()
        Utility.shared.playAudioSunod()
        self.copyIndicator()
    }
    func submitInvestment() {
        let portfolioId = UserDefaults.standard.string(forKey: "portfolioId")!
        let date = Date().toString(format: "yyyy-MM-dd HH:mm:ss.SSS")
        var trancationAmount = transactionTxtField.text!
        trancationAmount        =   trancationAmount.replacingOccurrences(of: ",", with: "", options: NSString.CompareOptions.literal, range: nil)
        let bodyParam = RequestBody(PortfolioID: portfolioId, FromFundAgentID: self.fundFromId, ToFundAgentID: "NULL", TransactionType: self.transactionType, TransactionDescription: transactionDescription, ExpectedAmount: trancationAmount, TransactionDate: date)
        let bodyRequest = bodyParam.encryptData(bodyParam)
        let url = URL(string: TRANSACTION_SUBMISSION)!
        SVProgressHUD.show()
        
        WebServiceManager.sharedInstance.fetch(params: bodyRequest as Dictionary<String, AnyObject>, url: url, serviceType: "Nav Fund", modelType: TransactionSubmission.self, errorMessage: { (errorMessage) in
            errorResponse = errorMessage
            self.showErrorMsg(errorMessage)
        }, success: { (response) in
            self.transaction = response
            if self.transaction?.count ?? 0 > 0 {
                if self.transaction?.count ?? 0 > 0 {
                    if let id = self.transaction?[0].iD {
                        self.updateSuccessUI(id)
                    } else {
                        
                    }
                }
            }
            
            
            //self.configTableView()
        }, fail: { (error) in
            print(error.localizedDescription)
        }, showHUD: true)
    }
    
    
    @objc func didTapOnUploadBtn(_ sender: UIButton) {
        imageUploadingIndex = sender.tag
        uploadSheet()
    }
    
    @objc func didTapOnCloseBtn(_ sender: UIButton) {
        let tag = sender.tag
        vpsTax[tag].isExpandable = false
        media.remove(at: tag)
        let indexPath = IndexPath(row: tag, section: 0)
        let cell = tableView.cellForRow(at: indexPath) as? DocuemntUploadingCell
        cell?.uplaodingView.isHidden = true
        tableView.reloadRows(at: [indexPath], with: .automatic)
        let count = vpsTax.filter{ $0.isExpandable == true }.count
        tableViewHeightConstraint.constant = (CGFloat(vpsTax.count) * rowHeight ) + (CGFloat( count ) * rowHeight)
        
    }
}

//
//  InvestmentVC.swift
//  AlMeezan
//
//  Created by Atta khan on 04/11/2019.
//  Copyright © 2019 Atta khan. All rights reserved.
//

import UIKit
import SVProgressHUD
import AVFoundation
import EasyTipView
import SwiftKeychainWrapper

class InvestmentVC: UIViewController {
    @IBOutlet weak var portfolioIdLbl: UILabel!
    @IBOutlet weak var portfolioTxtField: UITextField!
    @IBOutlet weak var portfolioBottomView: UIView!
    @IBOutlet weak var fundCategoryLbl: UILabel!
    @IBOutlet weak var fundCategoryTxtField: UITextField!
    @IBOutlet weak var fundCategoryBottomView: UIView!
    @IBOutlet weak var fundLbl: UILabel!
    @IBOutlet weak var fundTxtField: UITextField!
    @IBOutlet weak var fundBotttomView: UIView!
    @IBOutlet weak var fundValueTxtField: UITextField!
    @IBOutlet weak var bankLstTxtField: UITextField!
    @IBOutlet weak var plusBtn: UIButton!
    @IBOutlet weak var minusBtn: UIButton!
    @IBOutlet weak var wordAmountLbl: UILabel!
    @IBOutlet weak var proceedView: UIView!
    @IBOutlet weak var continueView: UIView!
    @IBOutlet weak var formView: UIView!
    @IBOutlet weak var successView: UIView!
    @IBOutlet weak var idPortfolioLbl: UILabel!
    @IBOutlet weak var categoryLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var amountLbl: UILabel!
    @IBOutlet weak var bankLbl: UILabel!
    @IBOutlet weak var transactionLbl: UILabel!
    @IBOutlet weak var referenceIdLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var okBtn: UIButton!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var copyBtn: UIButton!
    
    
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var portfolio2View: UIView!
    @IBOutlet weak var portfolio1View: UIView!
    var initialFieldString = ""
    var selectedPortfolioId: Int = 0
    var selectedFundCategoryId: Int = 0
    var selectedFundId: Int = 0
    var selectedBankId = 0
    var bankID = ""
    var fund_id: String = "0"
    var agent_id: String =  "0"
    
    var portfolioid_list: [CustomerInvestment]?
    
    var investemnt_fund: [InvestmentFunds]?
    var mobile_invesment: [MobileInvestment]?
    var restrict_Ids: RestrictSeries?
    var bank_list: [BankList]?
    var fundCategory: VpsInvestment?
    var marketValue = 1000
    
    
    @IBOutlet weak var checkedBtn: UIButton!
    var preferences = EasyTipView.globalPreferences
    let tipView = EasyTipView(text: "Tap to copy")
    var isTerms: Bool = false
    //var tipView = EasyTipView(text: "")
    override func viewDidLoad() {
        super.viewDidLoad()
        minusBtn.isUserInteractionEnabled = false
        fundValueTxtField.delegate = self
        successView.isHidden = true
        proceedView.isHidden = true
        scrollView.delegate = self
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        popupView.addGestureRecognizer(tap)
        
        
        preferences.drawing.foregroundColor = UIColor.white
        preferences.drawing.backgroundColor = UIColor.themeColor
        preferences.drawing.font = UIFont(name: "Roboto-Regular", size: 14)!
        preferences.drawing.textAlignment = NSTextAlignment.justified
        
        preferences.animating.dismissTransform = CGAffineTransform(translationX: 0, y: -15)
        preferences.animating.showInitialTransform = CGAffineTransform(translationX: 0, y: 15)
        preferences.animating.showInitialAlpha = 0
        preferences.animating.showDuration = 1
        preferences.drawing.arrowPosition = .top
        preferences.animating.dismissDuration = 0.5
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        portfolioid_list = Utility.shared.filterIdAscending()
        getBankData()
        getData()
   //     getFundData()
        getRestrictedIDs()
        hideNavigationBar()
        updateMarketValue()
       // showFundData()
        Utility.shared.analyticsCode("E-services (Investment)")
        //view7.roundCorners([.layerMinXMinYCorner,.layerMaxXMinYCorner], radius: 50, borderColor: .lightGray, borderWidth: 0.5)
        
        plusBtn.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        plusBtn.layer.cornerRadius = 4
        minusBtn.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
        minusBtn.layer.cornerRadius = 4
        popupView.isHidden = true
        portfolio2View.isHidden = true
        portfolio1View.isHidden = true
        
        
        let termsAndConditionView = TermsAndConditionView(heading: "I do hereby confirm that the investment being made is solely my own funds and that the funds beneficially owned by other person(s) will not be used.", selectedCheckboxCloser: { isSelect in
            self.isTerms = isSelect
        })
        termsAndConditionView.translatesAutoresizingMaskIntoConstraints = false
        if !termsAndConditionView.isDescendant(of: proceedView) {
            proceedView.addSubview(termsAndConditionView)
        }
        
        
        termsAndConditionView.leadingAnchor.constraint(equalTo: proceedView.leadingAnchor, constant: 0).isActive = true
        termsAndConditionView.trailingAnchor.constraint(equalTo: proceedView.trailingAnchor, constant: -16).isActive = true
        termsAndConditionView.topAnchor.constraint(equalTo: amountLbl.bottomAnchor, constant: 16).isActive = true
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        tipView.dismiss()
    }
    
    @IBAction func didTapOnCheckBtn(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    @objc func handleTap() {
        popupView.isHidden = true
        portfolio2View.isHidden = true
        portfolio1View.isHidden = true
    }
    private func copyIndicator() {
        tipView.show(forView: self.copyBtn, withinSuperview: self.navigationController?.view)
    }
    
    
    func getBankData() {
        
        let bodyParam = RequestBody()
        let bodyRequest = bodyParam.encryptData(bodyParam)
        let url = URL(string: BANK_LIST)!
        SVProgressHUD.show()
        
        WebServiceManager.sharedInstance.fetch(params: bodyRequest as Dictionary<String, AnyObject>, url: url, serviceType: "Nav Fund", modelType: BankList.self, errorMessage: { (errorMessage) in
            errorResponse = errorMessage
            self.showErrorMsg(errorMessage)
            
        }, success: { (response) in
            self.bank_list = response
            //self.configTableView()
        }, fail: { (error) in
            print(error.localizedDescription)
        }, showHUD: true)
        
    }

    
    func filterRestrictedIds() {
         if portfolioid_list?.count ?? 0 > 0 {
             portfolioid_list = portfolioid_list?.filter { element in
                 if let num = element.portfolioID?.components(separatedBy: "-").last {
                     return !(((self.restrict_Ids?.restrictedSeries.contains(where: { $0.id == num })) ?? true))
                 }
                 else { return true }
             }
         }
     }
    
    
    func getFundData() {
        
//        let portId = UserDefaults.standard.string(forKey: "portfolioId")
        let portId = portfolioid_list?[self.selectedPortfolioId].portfolioID
        let customerID  :   String? = KeychainWrapper.standard.string(forKey: "CustomerId")
        let accessToken :   String? = KeychainWrapper.standard.string(forKey: "AccessToken")
        
        let bodyParam = RequestBody(CustomerID: customerID, AccessToken: accessToken, PortfolioID: portId)
        let bodyRequest = bodyParam.encryptData(bodyParam)
        let url = URL(string: "https://members.almeezangroup.com/Webapitest/api/vpsinvestmentseries")!
        SVProgressHUD.show()
        
        WebServiceManager.sharedInstance.fetchObject(params: bodyRequest as Dictionary<String, AnyObject>, url: url, serviceType: "Nav Fund", modelType: VpsInvestment.self, errorMessage: { (errorMessage) in
            errorResponse = errorMessage
            self.showErrorMsg(errorMessage)
            
        }, success: { (response) in
            self.fundCategory = response
            self.fundCategoryTxtField.isUserInteractionEnabled = false
            self.fundTxtField.isUserInteractionEnabled = false
            self.fundCategoryTxtField.text = self.fundCategory?.funds?[0].category
            self.fundTxtField.text = self.fundCategory?.funds?[0].fundName
            self.agent_id = self.fundCategory?.funds?[0].agentID ?? ""
            self.fund_id = self.fundCategory?.funds?[0].fundID ?? ""
            self.fundCategory?.funds?[0].isHighRisk = 0
            
            
            //self.configTableView()
        }, fail: { (error) in
            print(error.localizedDescription)
        }, showHUD: true)
    }
    
    func getRestrictedIDs() {
        let bodyParam = RequestBody()
        let bodyRequest = bodyParam.encryptData(bodyParam)
        let url = URL(string: "https://members.almeezangroup.com/Webapitest/api/vpsinvestmentrestrictedseries")!
        SVProgressHUD.show()
        
        WebServiceManager.sharedInstance.fetchObject(params: bodyRequest as Dictionary<String, AnyObject>, url: url, serviceType: "Nav Fund", modelType: RestrictSeries.self, errorMessage: { (errorMessage) in
            errorResponse = errorMessage
            self.showErrorMsg(errorMessage)
            
        }, success: { (response) in
            self.restrict_Ids = response
            self.filterRestrictedIds()
            //self.configTableView()
        }, fail: { (error) in
            print(error.localizedDescription)
        }, showHUD: true)
    }
    
    
    func getData() {
        
        let bodyParam = RequestBody()
        let bodyRequest = bodyParam.encryptData(bodyParam)
        let url = URL(string: INVESTMENT_FUND)!
        SVProgressHUD.show()
        
        WebServiceManager.sharedInstance.fetch(params: bodyRequest as Dictionary<String, AnyObject>, url: url, serviceType: "Nav Fund", modelType: InvestmentFunds.self, errorMessage: { (errorMessage) in
            errorResponse = errorMessage
            self.showErrorMsg(errorMessage)
            
        }, success: { (response) in
            self.investemnt_fund = response
            
            //self.configTableView()
        }, fail: { (error) in
            print(error.localizedDescription)
        }, showHUD: true)
        
    }
    
    func showFilterFundData() {
        if let portId = portfolioid_list?[self.selectedPortfolioId].portfolioID {
            if portId.contains("-9") {
                fundCategoryTxtField.isUserInteractionEnabled = false
                fundTxtField.isUserInteractionEnabled = false
                fundCategoryTxtField.text = fundCategory?.funds?[0].category
                fundTxtField.text = fundCategory?.funds?[0].fundName
            
            }
//            else {
//                fundCategoryTxtField.isUserInteractionEnabled = true
//                fundTxtField.isUserInteractionEnabled = true
//            }
        }
    
    }
    
    private func chooseValue(_ tag: Int, title: String, _ selected: Int) {
        let vc = UIViewController()
        vc.preferredContentSize = CGSize(width: 250,height: 200)
        let pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: 250 , height: 200))
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.tag = tag
        pickerView.selectRow(selected, inComponent:0, animated:true)
        vc.view.addSubview(pickerView)
        let editRadiusAlert = UIAlertController(title: title, message: "", preferredStyle: UIAlertController.Style.alert)
        editRadiusAlert.setValue(vc, forKey: "contentViewController")
        
        editRadiusAlert.addAction(UIAlertAction(title: "Done", style: .default, handler: { (alert: UIAlertAction!) in
            if tag == 1 {
                self.fundCategoryTxtField.text = self.investemnt_fund?[self.selectedFundCategoryId].fundCategory
                self.selectedFundId = 0
                self.fundTxtField.text = ""
            } else if pickerView.tag == 2 {
                self.fundTxtField.text = self.investemnt_fund?[self.selectedFundCategoryId].funds?[self.selectedFundId].fundName
                self.fund_id = self.investemnt_fund?[self.selectedFundCategoryId].funds?[self.selectedFundId].fundID ?? "0"
                self.agent_id = self.investemnt_fund?[self.selectedFundCategoryId].funds?[self.selectedFundId].agentID ?? "0"
            } else if pickerView.tag == 3 {
                self.bankLstTxtField.text = self.bank_list?[self.selectedBankId].bankName
                self.bankID = self.bank_list?[self.selectedBankId].BankID ?? ""
            } else {
           
                if let portId = self.portfolioid_list?[self.selectedPortfolioId].portfolioID {
                    self.portfolioTxtField.text = portId
                   
                        if portId.contains("-9") {
                            self.fundCategoryTxtField.isEnabled = false
                            self.fundTxtField.isUserInteractionEnabled = false
                            pickerView.isUserInteractionEnabled = false
                            pickerView.isHidden = true
                        
                            self.getFundData()

                        } else {
                            self.fundCategoryTxtField.isUserInteractionEnabled = true
                            self.fundTxtField.isUserInteractionEnabled = true
                            self.fundCategoryTxtField.text = ""
                            self.fundTxtField.text = ""
                        }
                    
                    UserDefaults.standard.set(portId, forKey: "portfolioId")
                    }
                //
                //self.showFilterFundData()
            
                
            }
        }))
        self.present(editRadiusAlert, animated: true)
    }
    
    private func updateMarketValue() {
        if marketValue > 999 {
            minusBtn.isUserInteractionEnabled = true
        } else {
            minusBtn.isUserInteractionEnabled = false
            marketValue = 1000
        }
        fundValueTxtField.text = "\(String(describing: marketValue))"
        convertCurrencyIntoWord((String(describing: marketValue)))
    }
    
    
    @IBAction func tapOnPortfolioIdBtn(_ sender: Any) {
        if portfolioid_list?.count ?? 0 > 0 {
            chooseValue(0, title: "Choose Portfolio Id", selectedPortfolioId)
        } else {
            showAlert(title: "Alert", message: Message.MTPFPMessage, controller: self) {
            }
        }
    }
    
    @IBAction func tapOnFundCategoryBtn(_ sender: Any) {
        
        var disable = sender as? UIButton
        disable?.isEnabled = false
        
        if investemnt_fund?.count ?? 0 > 0{
            chooseValue(1, title: "Choose Fund Category", selectedFundCategoryId)
        } else {
            showAlert(title: "Alert", message: "No fund avaliable for selected category.", controller: self) {
            }
        }
    }
    
    
    @IBAction func tapOnFundBtn(_ sender: Any) {
        guard let fundsCount = self.investemnt_fund?[self.selectedFundCategoryId].funds?.count else { return }
        if fundCategoryTxtField.text != "" && fundsCount > 0 {
            chooseValue(2, title: "Choose Fund", selectedFundId)
        } else {
            self.showAlert(title: "Alert", message: "Please choose fund category.", controller: self) {
            }
        }
    }
    @IBAction func didTapOnCopyBtn(_ sender: UIButton) {
        UIPasteboard.general.string = referenceIdLbl.text
        
        if let string = UIPasteboard.general.string {
            print(string)
        }
        self.showToast(message: "Successfully reference id copied. ", font: .systemFont(ofSize: 12.0))
        
        
    }
    
    func attributedString() -> NSAttributedString {
        let attributedString =
        NSMutableAttributedString(string: "Tap to copy",
                                  attributes: [.font: UIFont.systemFont(ofSize: 15)])
        
        return attributedString
    }
    @IBAction func tapOnBankListBtn(_ sender: Any) {
        if portfolioid_list?.count ?? 0 > 0 {
            if bank_list?.count ?? 0 > 0 {
                chooseValue(3, title: "Choose your bank", selectedBankId)
            } else {
                self.showAlert(title: "Alert", message: "No Bank available.", controller: self) {
                }
            }
        } else {
            //            showAlert(title: "Alert", message: Message.MTPFPMessage, controller: self) {
            //            }
        }
    }
    
    @IBAction func didTapOnProceedBtn(_ sender: Any) {
        if isTerms == false {
            self.showAlert(title: "Alert", message: "Please accept the disclaimer before proceeding.", controller: self) {
                
            }
            return
        } else {
            submitInvestment()
        }
    }
    
    
    @IBAction func didTapOnGalleryBtn(_ sender: Any) {
        saveBtn.isHidden = true
        okBtn.isHidden = true
        copyBtn.isHidden = true
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
    
    
    @IBAction func tapOnValueBtn(_ sender: Any) {
    }
    
    @IBAction func tapOnPlusBtn(_ sender: Any) {
        marketValue += minimumAmount
        if marketValue > minimumAmount {
            minusBtn.isUserInteractionEnabled = true
        }
        updateMarketValue()
        
    }
    
    @IBAction func tapOnMinusBtn(_ sender: Any) {
        marketValue -= minimumAmount
        if marketValue <= minimumAmount {
            minusBtn.isUserInteractionEnabled = false
        } else {
            //minusBtn.isUserInteractionEnabled = true
        }
        updateMarketValue()
    }
    
    @IBAction func tapOnTermsBtn(_ sender: Any) {
        let vc = BlogsViewController.instantiateFromAppStroyboard(appStoryboard: .main)
        vc.urlStr = TERMS_CONDITIONS
        vc.titleStr = "Terms & Conditions"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func tapOnResetBtn(_ sender: Any) {
        self.refreshFrom()
    }
    
    
    @IBAction func didTapOnPortfolioOKBtn(_ sender: Any) {
        self.popupView.isHidden = true
        self.portfolio2View.isHidden = true
        self.portfolio1View.isHidden = true
    }
    @IBAction func didTapOnFundOnlineBtn(_ sender: Any) {
        self.popupView.isHidden = true
        self.portfolio2View.isHidden = true
        self.portfolio1View.isHidden = true
        
        let vc = BlogsViewController.instantiateFromAppStroyboard(appStoryboard: .main)
        vc.urlStr = "https://members.almeezangroup.com"
        vc.titleStr = "Meezan Funds Online"
        vc.isTransition = false
        navigationController?.pushViewController(vc, animated: true)
        //
    }
    
    
    
    func refreshFrom() {
        bankID = ""
        bankLstTxtField.text = ""
        selectedPortfolioId = 0
        selectedFundCategoryId = 0
        selectedFundId = 0
        fund_id = "0"
        agent_id = "0"
        fundCategoryTxtField.text = ""
        fundTxtField.text = ""
        fundValueTxtField.text = ""
        marketValue = 1000
        updateMarketValue()
    }
    
    @IBAction func tapOnContinueBtn(_ sender: Any) {
        guard let portfolioTxt  = portfolioTxtField.text, !portfolioTxt.isEmpty else {
            self.showAlert(title: "Alert", message: "Please select your portfolio Id.", controller: self) {
            }
            return
        }
        guard let fundFromTxt  = fundCategoryTxtField.text, !fundFromTxt.isEmpty else {
            self.showAlert(title: "Alert", message: "Please select fund category.", controller: self) {
            }
            return
        }
        
        guard let fundTxt  = fundTxtField.text, !fundTxt.isEmpty else {
            self.showAlert(title: "Alert", message: "Please select fund.", controller: self) {
            }
            return
        }
        
        if fund_id == "0" || agent_id == "0" {
            self.showAlert(title: "Alert", message: "Please select fund category.", controller: self) {
            }
            return
        }
        guard let bankTxt  = bankLstTxtField.text, !fundTxt.isEmpty else {
            self.showAlert(title: "Alert", message: "Please select bank.", controller: self) {
            }
            return
        }
        
        
        
        let amount = fundValueTxtField.text ?? "0"
        if amount.integerValue ?? 0 < 1000 {
            self.showAlert(title: "Alert", message: "Amount can't be less than PKR 1000.", controller: self) {
                self.fundValueTxtField.becomeFirstResponder()
            }
            return
        }
        
        let portfolioId = UserDefaults.standard.string(forKey: "portfolioId")!
        
        
        let ids = portfolioId.components(separatedBy: "-")
        let id = Int(ids[1] ?? "0")!
        let isExist = (202...299).contains(id)
        
        if isExist {
            self.popupView.isHidden = false
            self.portfolio2View.isHidden = false
            self.portfolio1View.isHidden = true
        }
        else if id == 201 {
            self.popupView.isHidden = false
            self.portfolio2View.isHidden = true
            self.portfolio1View.isHidden = false
        }
        else {
            idPortfolioLbl.text = portfolioId
            categoryLbl.text = fundFromTxt
            nameLbl.text = fundTxt
            amountLbl.text = "PKR \(amount.toCurrencyFormat(withFraction: false))"
            
            //\(String(describing: marketValue).toCurrencyFormat(withFraction: false))"
            bankLbl.text = bankTxt
            transactionLbl.text = "Investment"
            
            var highRisk: Int?
            
            if let portId = self.portfolioid_list?[self.selectedPortfolioId].portfolioID {
                if portId.contains("-9") {
                    highRisk = fundCategory?.funds?[0].isHighRisk
                } else {
                    highRisk = self.investemnt_fund?[selectedFundCategoryId].funds?[selectedFundId].IsHighRisk
                }
            }
            
          //  let isHighRisk = self.investemnt_fund?[selectedFundCategoryId].funds?[selectedFundId].IsHighRisk
            if highRisk == 1 {
                let vc = ETransactionWebViewVC.instantiateFromAppStroyboard(appStoryboard: .home)
                if #available(iOS 10.0, *) {
                    vc.modalPresentationStyle = .overCurrentContext
                } else {
                    vc.modalPresentationStyle = .currentContext
                }
                vc.providesPresentationContextTransitionStyle = true
                vc.delegate = self
                vc.fundTxt = fundTxt
                present(vc, animated: true, completion: {() -> Void in
                    print("abc")
                })
            } else {
                conituneFundTransaction(fundTxt)
            }
        }
        
    }
    func updateSuccessUI(_ id: String?) {
        let dateStr = Date().dateAndTimetoString(format: "EEEE, MMM d, YYYY")
        let timeStr = Date().dateAndTimetoString(format: "h:mm a")
        dateLbl.text = dateStr
        timeLbl.text = timeStr
        referenceIdLbl.text = id ?? ""
        proceedView.isHidden = true
        successView.isHidden = false
        formView.isHidden = true
        self.refreshFrom()
        Utility.shared.playAudioSunod()
        
        self.copyIndicator()
    }
    func submitInvestment() {
        let portfolioId = UserDefaults.standard.string(forKey: "portfolioId")!
        var transactionAmount = fundValueTxtField.text!
        let bodyParam = RequestBody(PortfolioID: portfolioId, FundID: self.fund_id, AgentID: self.agent_id, Amount: transactionAmount, Bank: bankID)
        let bodyRequest = bodyParam.encryptData(bodyParam)
        let url = URL(string: MOBILE_INVESTMENT)!
        print(url)
        SVProgressHUD.show()
        
        WebServiceManager.sharedInstance.fetch(params: bodyRequest as Dictionary<String, AnyObject>, url: url, serviceType: "Nav Fund", modelType: MobileInvestment.self, errorMessage: { (errorMessage) in
            errorResponse = errorMessage
            self.showErrorMsg(errorMessage)
        }, success: { (response) in
            self.mobile_invesment = response
            if self.mobile_invesment?.count ?? 0 > 0 {
                if let id = self.mobile_invesment?[0].referenceID , let customerID = self.mobile_invesment?[0].customerID {
                    self.updateSuccessUI(id)
                }
            }
        }, fail: { (error) in
            print(error.localizedDescription)
        }, showHUD: true)
    }
    private func conituneFundTransaction(_ fundTxt: String) {
        proceedView.isHidden = false
        formView.isHidden = true
        continueView.isHidden = true
        let point = CGPoint(x: 0, y: 0)
        scrollView.setContentOffset(point, animated: true)
        
    }
    
    
    @IBAction func tapONTransactionsBtn(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "statusTransactionsVC") as! StatusTransactionsVC
        vc.isBack = true
        navigationController?.pushViewController(vc, animated: true)
    }
    func formatCurrency(string: String, textField: UITextField) {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        let resultStr = string.filter("0123456789.".contains)
        let numberFromField = Int(resultStr)
        if let number = numberFromField {
            marketValue = number
        } else {
            marketValue = 0
        }
        if marketValue > 1000 {
            minusBtn.isUserInteractionEnabled = true
        }
        fundValueTxtField.text = "PKR \(String(describing: marketValue).toCurrencyFormat(withFraction: false))"
        ///updateMarketValue()
    }
    func convertCurrencyIntoWord(_ amount: String) {
        wordAmountLbl.text = Utility.shared.formatCurrencyInWords(string: amount)
    }
    
}
extension InvestmentVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1 {
            return investemnt_fund?.count ?? 0
        } else if pickerView.tag == 2 {
            return investemnt_fund?[selectedFundCategoryId].funds?.count ?? 0
        } else if pickerView.tag == 3 {
            return bank_list?.count ?? 0
        } else {
            return portfolioid_list?.count ?? 0
        }
        
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1 {
            return investemnt_fund?[row].fundCategory
        } else if pickerView.tag == 2 {
            return investemnt_fund?[selectedFundCategoryId].funds?[row].fundName
        } else if pickerView.tag == 3 {
            return bank_list?[selectedBankId].bankName
        } else {
            return portfolioid_list?[row].portfolioID
        }
        
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1 {
            fundCategoryTxtField.text = investemnt_fund?[row].fundCategory
            selectedFundCategoryId = row
        } else if pickerView.tag == 2 {
            fundTxtField.text = investemnt_fund?[selectedFundCategoryId].funds?[row].fundName
            selectedFundId = row
        } else if pickerView.tag == 3 {
            print(bank_list?[row].bankName)
            bankLstTxtField.text = bank_list?[row].bankName
            selectedBankId = row
            bankID = bank_list?[row].BankID ?? ""
        }else {
            portfolioTxtField.text = portfolioid_list?[row].portfolioID
            selectedPortfolioId = row
            
        }
        
    }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var title = UILabel()
        if let titleLbl = view {
            title = titleLbl as! UILabel
        }
        title.font = UIFont(name: "Roboto-Regular", size: pickerTitleFontSize)
        if pickerView.tag == 1 {
            title.text = investemnt_fund?[row].fundCategory
        } else if pickerView.tag == 2 {
            title.text =  investemnt_fund?[selectedFundCategoryId].funds?[row].fundName
        } else if pickerView.tag == 3 {
            title.text =  bank_list?[row].bankName
        }
        else {
            title.text =  portfolioid_list?[row].portfolioID
        }
        
        title.textAlignment = .center
        return title
    }
}

extension InvestmentVC: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        //formatCurrency(string: textField.text!, textField: textField)
        convertCurrencyIntoWord(textField.text!)
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 12
        let currentString: NSString = (textField.text ?? "") as NSString
        let newString: NSString =
        currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
}
extension InvestmentVC: Transaction {
    func continueTransaction(_ fundTxt: String?, _ amount: String?) {
        conituneFundTransaction(fundTxt!)
    }
}
extension NSMutableAttributedString {
    
    func highlight(text: String, with attributes: [NSAttributedString.Key: Any]) {
        let range = (string as NSString).range(of: text)
        setAttributes(attributes,
                      range: range)
    }
}

extension InvestmentVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        tipView.dismiss()
    }
}

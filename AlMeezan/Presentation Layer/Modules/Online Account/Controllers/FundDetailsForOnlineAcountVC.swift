//
//  FundDetailsVC.swift
//  AlMeezan
//
//  Created by Atta khan on 02/11/2020.
//  Copyright © 2020 Atta khan. All rights reserved.
//

import UIKit
import SVProgressHUD
import FirebaseAnalytics
class FundDetailsForOnlineAcountVC: UIViewController {
    @IBOutlet weak var CircularProgress: CircularProgressView!
    @IBOutlet weak var fundCategoryTf: UITextField!
    @IBOutlet weak var fundPlanTf: UITextField!
    @IBOutlet weak var fundAmountTf: UITextField!
    @IBOutlet weak var progressBarTitleLbl: UILabel!
    @IBOutlet weak var resetBtn: UIButton!
    @IBOutlet weak var wordAmountLbl: UILabel!
    var selectedFundId = 0
    var selectedCategoryId = 0
    var response_data: [AccountOpeningFunds]?
    var filter_data: [AccountOpeningFunds]?
    var filterCategory: [AccountOpeningFunds]?
    var fund_id: String?
    var agent_id: String?
    var isSelected: Bool = false
    private let validation: ValidationService
    
    init(validation: ValidationService) {
        self.validation = validation
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.validation = ValidationService()
        super.init(coder: coder)
    }
    
    
    var category = ""
    var fundPlan = ""
    var cnic_id: String?
    var amount = ""
    var bank_name: String?
    var amount_value = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        progressBarTitleLbl.text = "6 of 6"
        CircularProgress.trackColor = UIColor.progressBarinActiveColor
        CircularProgress.progressColor = UIColor.progressBarActiveColor
        CircularProgress.setProgressWithAnimation(duration: 1.0, value: 6 * 1/6)
        getFundList()
        fundAmountTf.delegate = self
        fundAmountTf.keyboardType = .asciiCapableNumberPad
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Utility.shared.googleAnalyticsEvent(OnlineAccountEnums.STEP_SIX.index, OnlineAccountEnums.STEP_SIX.value, OnlineAccountEnums.STEP_SIX.screenName, String(describing: type(of: self)))
    }
    func getFundList() {
        let bodyParam = RequestBody()
        let bodyRequest = bodyParam.encryptData(bodyParam)
        let url = URL(string: ACCOUNT_OPENING_FUNDS)!
        SVProgressHUD.show()
        
        WebServiceManager.sharedInstance.fetch(params: bodyRequest as Dictionary<String, AnyObject>, url: url, serviceType: "Nav Fund", modelType: AccountOpeningFunds.self, errorMessage: { (errorMessage) in
            errorResponse = errorMessage
            self.showErrorMsg(errorMessage)

        }, success: { (response) in
            self.response_data = response
            self.filterCategory = self.response_data?.unique( by: { $0.category } )
        }, fail: { (error) in
            print(error.localizedDescription)
        }, showHUD: true)
    }

    private func chooseValue(_ tag: Int, _ title: String, _ selected: Int) {
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
            if tag == PickerOption.fund.rawValue {
                self.fundPlanTf.text = self.filter_data?[self.selectedFundId].fundName
            } else {
                self.fundPlanTf.text = ""
                self.selectedFundId = 0
                self.filter_data?.removeAll()
                self.fundCategoryTf.text = self.filterCategory?[self.selectedCategoryId].category
                self.fund_id = self.filterCategory?[self.selectedCategoryId].fundID
                self.agent_id = self.filterCategory?[self.selectedCategoryId].agentID
                if let category = self.filterCategory?[self.selectedCategoryId].category {
                    self.filter_data = self.response_data?.filter {( $0.category == category )}
                }
            }
        }))
        self.present(editRadiusAlert, animated: true)
    }

    

    @IBAction func didTapResetButton(_ sender: Any) {
        fundAmountTf.text = ""
        wordAmountLbl.text = ""
    }
    
    @IBAction func didTapFundCategoryButton(_ sender: Any) {
        chooseValue(PickerOption.category.rawValue, "Choose fund Category", selectedCategoryId)
    }
    @IBAction func didTapFundPlanButton(_ sender: Any) {
        chooseValue(PickerOption.fund.rawValue, "Choose Fund / Plan", selectedFundId)
    }
    
    
    @IBAction func didTapNextButton(_ sender: Any) {
       
        do {
            category        =   try validation.validateTxtField(fundCategoryTf.text, ValidationError.emptyFundCategory)
            fundPlan        =   try validation.validateTxtField(fundPlanTf.text, ValidationError.emptyFundPlan)
            amount          =   try validation.validateTxtField(fundAmountTf.text, ValidationError.emptyAmount)
            cnic_id         =   defaults.string(forKey: "CNIC_Id")
            bank_name       =   defaults.string(forKey: "Bank_Name")
            amount_value    =   amount.replacingOccurrences(of: ",", with: "", options: NSString.CompareOptions.literal, range: nil)
            let _               =   try validation.checkTransactionAmount(Int(amount_value) ?? 0)
            let _               =   try validation.validateCheckbox(isSelected, ValidationError.checkBoxMsg)
            
            let isHighRisk = 1 //self.filter_data?[self.selectedFundId].isHighRisk
            if isHighRisk == 1 {
                let vc = ETransactionWebViewVC.instantiateFromAppStroyboard(appStoryboard: .home)
                if #available(iOS 10.0, *) {
                    vc.modalPresentationStyle = .overCurrentContext
                } else {
                    vc.modalPresentationStyle = .currentContext
                }
                vc.delegate = self
                vc.providesPresentationContextTransitionStyle = true
                present(vc, animated: true, completion: {() -> Void in
                    print("abc")
                })
            } else {
                conituneFundTransaction()
            }
            
            
        } catch {
            print(error)
            self.showAlert(title: "Alert", message: error.localizedDescription, controller: self) {
            }
        }
        
        
        
        
        
        
        
        
        
    }
    @IBAction func didTapPreviousButton(_ sender: Any) {
        let vc = LoginViewController.instantiateFromAppStroyboard(appStoryboard: .home)
        navigationController?.pushViewController(vc, animated: false)
    }
    
    @IBAction func didTapOnCheckBox(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        isSelected = sender.isSelected
    }
    
    @IBAction func didTapBackButton(_ sender: Any) {
        let vc = LoginViewController.instantiateFromAppStroyboard(appStoryboard: .home)
        navigationController?.pushViewController(vc, animated: false)
    }
    
    func formatCurrencyInWords(string: String) {
        let formatter = NumberFormatter()
        formatter.numberStyle = .spellOut
        let num = Int(string) ?? 0
        let resultStr = formatter.string(from: NSNumber(value: num))
        wordAmountLbl.text = resultStr?.capitalized
    }
    func formatCurrency(string: String) {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        let numberFromField = Int(string)
        if let number = numberFromField {
            fundAmountTf.text = formatter.string(from: NSNumber(value: number))
        } else {
            fundAmountTf.text = ""
        }
    }
    
    @IBAction func didTapOnTermsBtn(_ sender: Any) {
        let vc = BlogsViewController.instantiateFromAppStroyboard(appStoryboard: .main)
        vc.urlStr = TERMS_CONDITIONS
        vc.titleStr = "Terms & Conditions"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func conituneFundTransaction() {
        
            let bodyParam       =   RequestBody(Fundid: fund_id, AgentID: agent_id, Amount: amount_value, Bank: bank_name, CNIC: cnic_id)
            let bodyRequest     =   bodyParam.encryptData(bodyParam)
            let url             =   URL(string: ACCOUNT_OPENING_INVESTMENT)!
            SVProgressHUD.show()
            
            WebServiceManager.sharedInstance.fetch(params: bodyRequest as Dictionary<String, AnyObject>, url: url, serviceType: "Online Account", modelType: AccountOpening.self, errorMessage: { (errorMessage) in
                errorResponse = errorMessage
                //self.showErrorMsg(errorMessage)

            }, success: { (response) in
                let apiResponse = response
                self.showAlert(title: "Alert", message: apiResponse[0].errMsg ?? "Please try again!", controller: self) {
                    let vc = FinishViewController.instantiateFromAppStroyboard(appStoryboard: .onlineAccount)
                    vc.fundPlan = self.fundPlan
                    vc.fundCategory = self.category
                    vc.amount = self.amount
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }, fail: { (error) in
                print(error.localizedDescription)
            }, showHUD: true)
            
            
           
    }
    
}
extension FundDetailsForOnlineAcountVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == PickerOption.fund.rawValue {
            return filter_data?.count ?? 0
        } else {
            return filterCategory?.count ?? 0
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == PickerOption.fund.rawValue {
            return filter_data?[row].fundName
        } else {
            return filterCategory?[row].category
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == PickerOption.fund.rawValue {
            fundPlanTf.text = filter_data?[row].fundName
            selectedFundId = row
        } else {
            fundCategoryTf.text = filterCategory?[row].category
            selectedCategoryId = row
        }
    }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var title = UILabel()
        if let titleLbl = view {
            title = titleLbl as! UILabel
        }
        title.font = UIFont(name: "Roboto-Regular", size: pickerTitleFontSize)
        if pickerView.tag == PickerOption.fund.rawValue {
            title.text = filter_data?[row].fundName
        } else {
            title.text =  filterCategory?[row].category
        }
        title.textAlignment = .center
        return title
    }
}


extension FundDetailsForOnlineAcountVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if range.location == 0 && ( string == " " || string == "0" ) { // prevent space on first character
            return false
        }
        if textField.text?.last == " " && string == " " { // allowed only single space
            return false
        }
        if string == " " { return true } // now allowing space between name
        let currentCharacterCount = textField.text?.count ?? 0
        if range.length + range.location > currentCharacterCount {
            return false
        }
        let newLength = currentCharacterCount + string.count - range.length
        if newLength > 6 {
            return false
        }
        var initialFieldString = textField.text!
        initialFieldString = initialFieldString.filter("0123456789.".contains)
        switch string {
        case "0","1","2","3","4","5","6","7","8","9":
            initialFieldString += string
            formatCurrencyInWords(string: initialFieldString)
            formatCurrency(string: initialFieldString)
        default:
            let array = Array(string)
            var currentStringArray = Array(initialFieldString)
            if array.count == 0 && currentStringArray.count != 0 {
                currentStringArray.removeLast()
                initialFieldString = ""
                for character in currentStringArray {
                    initialFieldString += String(character)
                }
                formatCurrencyInWords(string: initialFieldString)
                formatCurrency(string: initialFieldString)
            }
        }
        
        return false
    }
}
extension FundDetailsForOnlineAcountVC: Transaction {
    func continueTransaction(_ fundTxt: String?, _ amount: String?) {
        conituneFundTransaction()
    }
}

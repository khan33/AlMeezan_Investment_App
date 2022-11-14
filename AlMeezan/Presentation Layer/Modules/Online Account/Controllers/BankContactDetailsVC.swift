//
//  BankContactDetailsVC.swift
//  AlMeezan
//
//  Created by Atta khan on 02/11/2020.
//  Copyright © 2020 Atta khan. All rights reserved.
//

import UIKit
import SVProgressHUD
import FirebaseAnalytics
class BankContactDetailsVC: UIViewController {

    @IBOutlet weak var CircularProgress: CircularProgressView!
    @IBOutlet weak var bankNameTextField: UITextField!
    @IBOutlet weak var branchNameTextField: UITextField!
    @IBOutlet weak var bankAccountTitleTextField: UITextField!
    @IBOutlet weak var bankAccountNoTextField: UITextField!
    @IBOutlet weak var address1TextField: UITextField!
    @IBOutlet weak var address2TextField: UITextField!
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var progressBarTitleLbl: UILabel!
    
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var previousBtn: UIButton!
    var selectedCityId = 0
    var selectedCountryId = 0
    var selectedBankId = 0
    var bank_list: [BankList]?
    var response_data: CountryModel?
    var response_country: [Country]?
    var response_city: [CityModel]?
    private let validation: ValidationService
    var cityCode: String?
    var bankID: String?
    var country_short_code: String?
    
    var bank_detail: BankDelatils?
    init(validation: ValidationService) {
        self.validation = validation
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.validation = ValidationService()
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        progressBarTitleLbl.text = "4 of 6"
        CircularProgress.trackColor = UIColor.progressBarinActiveColor
        CircularProgress.progressColor = UIColor.progressBarActiveColor
        CircularProgress.setProgressWithAnimation(duration: 1.0, value: 4 * 1/6)
        branchNameTextField.delegate = self
        bankAccountTitleTextField.delegate = self
        bankAccountNoTextField.delegate = self
        address1TextField.delegate = self
        address2TextField.delegate = self
        getBankName()
        getCountry()
        
        bankNameTextField.autocapitalizationType = .allCharacters
        branchNameTextField.autocapitalizationType = .allCharacters
        bankAccountTitleTextField.autocapitalizationType = .allCharacters
        bankAccountNoTextField.autocapitalizationType = .allCharacters
        
        address1TextField.autocapitalizationType = .allCharacters
        address2TextField.autocapitalizationType = .allCharacters
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        Utility.shared.getUserdefaultValues(OnlineOperationStatus.bank.rawValue, modelType: BankDelatils.self) { (result) in
            let response = result
            self.bank_detail = response
            self.populateBankDetails(response)
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Utility.shared.googleAnalyticsEvent(OnlineAccountEnums.STEP_FOUR.index, OnlineAccountEnums.STEP_FOUR.value, OnlineAccountEnums.STEP_FOUR.screenName, String(describing: type(of: self)))
    }
    
    func populateBankDetails(_ values: BankDelatils) {
        bankNameTextField.text = values.bankName
        branchNameTextField.text = values.branchName
        bankAccountTitleTextField.text = values.bankTitle
        bankAccountNoTextField.text = values.accountNo
        address1TextField.text = values.address1
        address2TextField.text = values.address2
        cityTextField.text = values.city
        countryTextField.text = values.country
        cityCode = values.cityCode
        bankID = values.bankID
        country_short_code = values.country_short_code
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
            if tag == PickerOption.country.rawValue {
                self.countryTextField.text = self.response_country?[self.selectedCountryId].cOUNTRY
                self.country_short_code = self.response_country?[self.selectedCountryId].cOUNTRY_SHORT_NAME
            } else if tag == PickerOption.city.rawValue {
                self.cityTextField.text = self.response_city?[self.selectedCityId].cITY
                self.cityCode = self.response_city?[self.selectedCityId].cITYCODE
            } else {
                self.bankNameTextField.text = self.bank_list?[self.selectedBankId].bankName
                self.bankID = self.bank_list?[self.selectedBankId].BankID
            }
        }))
        self.present(editRadiusAlert, animated: true)
    }
    
    
    
    private func getBankName() {
        let bodyParam = RequestBody()
        let bodyRequest = bodyParam.encryptData(bodyParam)
        let url = URL(string: BANK_LIST)!
        SVProgressHUD.show()
        
        WebServiceManager.sharedInstance.fetch(params: bodyRequest as Dictionary<String, AnyObject>, url: url, serviceType: "Nav Fund", modelType: BankList.self, errorMessage: { (errorMessage) in
            errorResponse = errorMessage
            self.showErrorMsg(errorMessage)

        }, success: { (response) in
            self.bank_list = response
            let bankDetail =  self.bank_list?.filter( { ($0.BankID == self.bank_detail?.bankID)})
            if bankDetail?.count == 1 {
                self.bankNameTextField.text = bankDetail?[0].bankName
            }
        }, fail: { (error) in
            print(error.localizedDescription)
        }, showHUD: true)
    }
    
    private func getCountry() {
        let bodyParam = RequestBody()
        let bodyRequest = bodyParam.encryptData(bodyParam)
        let url = URL(string: COUNTRY_CITY)!
        SVProgressHUD.show()
        WebServiceManager.sharedInstance.fetchObject(params: bodyRequest as Dictionary<String, AnyObject>, url: url, serviceType: "Country List", modelType: CountryModel.self, errorMessage: { (errorMessage) in
            errorResponse = errorMessage
            if errorResponse?[0].errID != "00" {
                self.showErrorMsg(errorMessage)
            }
        }, success: { (response) in
            self.response_data = response
            self.response_country = self.response_data?.country
            self.response_city = self.response_data?.city
            
            let countryDetail =  self.response_country?.filter( { ($0.cOUNTRY_SHORT_NAME == self.bank_detail?.country_short_code)})
            if countryDetail?.count == 1 {
                self.countryTextField.text = countryDetail?[0].cOUNTRY
            }
            let cityDetail =  self.response_city?.filter( { ($0.cITYCODE == self.bank_detail?.cityCode)})
            if cityDetail?.count == 1 {
                self.cityTextField.text = cityDetail?[0].cITY
            }
        }, fail: { (error) in
            print(error.localizedDescription)
            self.showAlert(title: "Alert", message: "The Internet connection appears to be offline.", controller: self) {
                
            }
            
        }, showHUD: true)
    }
    
    @IBAction func didTapBankNameButton(_ sender: Any) {
        if bank_list?.count ?? 0 > 0 {
            chooseValue(PickerOption.bankName.rawValue, "Choose bank name", selectedBankId)
        } else {
            self.showAlert(title: "Alert", message: "No Bank available.", controller: self) {
            }
        }
    
    }
    
    @IBAction func didTapCountryButton(_ sender: Any) {
        if self.response_country?.count ?? 0 > 0 {
            chooseValue(PickerOption.country.rawValue, "Choose country name", selectedCountryId)
        } else {
            self.showAlert(title: "Alert", message: "No Data Found.", controller: self) {
                self.getCountry()
            }
        }
    }
    
    @IBAction func didTapCityButton(_ sender: Any) {
        if  self.response_city?.count ?? 0 > 0 {
            chooseValue(PickerOption.city.rawValue, "Choose city name", selectedCityId)
        } else {
            self.showAlert(title: "Alert", message: "No Data Found.", controller: self) {
                self.getCountry()
            }
        }
    }
    
    @IBAction func didTapNextButton(_ sender: Any) {
        do {
            let bankName            =   try validation.validateTxtField(bankNameTextField.text, ValidationError.emptyBankName)
            let branchName          =   try validation.validateTxtField(branchNameTextField.text, ValidationError.emptyBranchName)
            
            let accountNo           =   try validation.validateAccountNo(bankAccountNoTextField.text)
            let address1            =   try validation.validateTxtField(address1TextField.text, ValidationError.emptyAddress1)
            let country             =   try validation.validateTxtField(countryTextField.text, ValidationError.emptyCountry)
            let city                =   try validation.validateTxtField(cityTextField.text, ValidationError.emptyCity)
            let adderss2            =   address2TextField.text ?? ""
            let accountTitle        =   bankAccountTitleTextField.text ?? ""
            
            let bank = BankDelatils(bankName: bankName, bankID: bankID, branchName: branchName, bankTitle: accountTitle, accountNo: accountNo, address1: address1, address2: adderss2, country: country, country_short_code: country_short_code, city: city, cityCode: cityCode)
            
            let encoder = JSONEncoder()
            if let encodedUser = try? encoder.encode(bank) {
                defaults.set(encodedUser, forKey: OnlineOperationStatus.bank.rawValue)
            }
            defaults.setValue(bankName, forKey: "Bank_Name")
            let vc = ConfirmDetailsVC.instantiateFromAppStroyboard(appStoryboard: .onlineAccount)
            self.navigationController?.pushViewController(vc, animated: true)
        } catch {
            self.showAlert(title: "Alert", message: error.localizedDescription, controller: self) {
            }
        }
    }

    @IBAction func didTapPreviousButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func didTapBackButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
extension BankContactDetailsVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == PickerOption.country.rawValue {
            return response_country?.count ?? 0
        } else if pickerView.tag == PickerOption.city.rawValue {
            return response_city?.count ?? 0
        } else {
            return bank_list?.count ?? 0
        }
        
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == PickerOption.country.rawValue {
            return response_country?[row].cOUNTRY
        } else if pickerView.tag == PickerOption.city.rawValue {
            return response_city?[row].cITY
        } else {
            return bank_list?[row].bankName
        }
        
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == PickerOption.country.rawValue {
            countryTextField.text = response_country?[row].cOUNTRY
            selectedCountryId = row
        } else if pickerView.tag == PickerOption.city.rawValue {
            cityTextField.text = response_city?[row].cITY
            selectedCityId = row
        } else {
            bankNameTextField.text = bank_list?[row].bankName
            selectedBankId = row
        }
        
    }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var title = UILabel()
        if let titleLbl = view {
            title = titleLbl as! UILabel
        }
        title.font = UIFont(name: "Roboto-Regular", size: pickerTitleFontSize)
        if pickerView.tag == PickerOption.country.rawValue {
         title.text = response_country?[row].cOUNTRY
        } else if pickerView.tag == PickerOption.city.rawValue {
            title.text =  response_city?[row].cITY
        } else {
            title.text =  bank_list?[row].bankName
        }
        
        title.textAlignment = .center
        return title
    }
}
extension BankContactDetailsVC: UITextFieldDelegate {

    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == bankAccountNoTextField {
            if range.location == 0 && string == " " { // prevent space on first character
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
            
            if string != "" {
                if newLength < 24 {
                    textField.text = (textField.text! as NSString).replacingCharacters(in: range, with: string.uppercased())
                    return false
                }
            }
            return newLength <= 24
        }
        
        if textField == branchNameTextField || textField == bankAccountTitleTextField {
            if range.location == 0 && string == " " { // prevent space on first character
                return false
            }

            if textField.text?.last == " " && string == " " { // allowed only single space
                return false
            }

            if string == " " { return true } // now allowing space between name
            if string.rangeOfCharacter(from: CharacterSet.letters.inverted) != nil {
                return false
            }
            
            let currentCharacterCount = textField.text?.count ?? 0
            //let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            if range.length + range.location > currentCharacterCount {
                return false
            }
            if string != "" {
                textField.text = (textField.text! as NSString).replacingCharacters(in: range, with: string.uppercased())
                return false
            }
            
            return true
        }
        
        if textField == address2TextField || textField == address1TextField {
            if range.location == 0 && string == " " { // prevent space on first character
                return false
            }

            if textField.text?.last == " " && string == " " { // allowed only single space
                return false
            }

            if string == " " { return true } // now allowing space between name
            
            
            let currentCharacterCount = textField.text?.count ?? 0
            //let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            if range.length + range.location > currentCharacterCount {
                return false
            }
            if string != "" {
                textField.text = (textField.text! as NSString).replacingCharacters(in: range, with: string.uppercased())
                return false
            }
            
            return true
        }
        
        return true
    }
    
    
}

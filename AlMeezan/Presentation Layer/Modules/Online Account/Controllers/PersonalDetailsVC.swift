//
//  PersonalDetailsVC.swift
//  AlMeezan
//
//  Created by Atta khan on 02/11/2020.
//  Copyright © 2020 Atta khan. All rights reserved.
//

import UIKit
import DatePickerDialog
import SVProgressHUD
import FirebaseAnalytics
class PersonalDetailsVC: UIViewController {

    @IBOutlet weak var CircularProgress: CircularProgressView!
    @IBOutlet weak var CNICTextField: UITextField!
    @IBOutlet weak var fatherNameTextField: UITextField!
    @IBOutlet weak var dobTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var incomeTextField: UITextField!
    @IBOutlet weak var occupationTextField: UITextField!
    @IBOutlet weak var cnicIssueTextField: UITextField!
    @IBOutlet weak var cnicExpiryTextField: UITextField!
    
    @IBOutlet weak var otherSourceTxtField: UITextField!
    @IBOutlet weak var checkBoxBtn: UIButton!
    @IBOutlet weak var progressBarTitleLbl: UILabel!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var previousBtn: UIButton!
    @IBOutlet weak var CNICExpiryView: UIView!
    @IBOutlet weak var CNICExpiryViewHeighConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var otherView: UIView!
    @IBOutlet weak var otherViewHeighConstraint: NSLayoutConstraint!
    
    var selectedOccupationId: Int = 0
    var selectedIncomeId: Int = 0
    var occupation : [Occupation]?
    var isChecked: Bool = false
    var isOtherSource: Bool = false
    var sourceOfFund : [SourceOfFund]?
    private var cnic: String?
    private var mobile: String?
    private var email: String?
    private let validation: ValidationService
    var response_data: OccupationModel?
    init(validation: ValidationService) {
        self.validation = validation
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.validation = ValidationService()
        super.init(coder: coder)
    }
    var gender: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        progressBarTitleLbl.text = "3 of 6"
        CircularProgress.trackColor = UIColor.progressBarinActiveColor
        CircularProgress.progressColor = UIColor.progressBarActiveColor
        CircularProgress.setProgressWithAnimation(duration: 1.0, value: 3 * 1/6)
        CNICTextField.delegate = self
        fatherNameTextField.delegate = self
        CNICTextField.autocapitalizationType = .allCharacters
        fatherNameTextField.autocapitalizationType = .allCharacters
        
        self.otherView.isHidden = true
        self.otherViewHeighConstraint.constant = 0.0
        getSourceOfIncome()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        Utility.shared.getUserdefaultValues(OnlineOperationStatus.user.rawValue, modelType: UserDetails.self) { (result) in
            let response = result
            self.cnic = response.CNIC
            self.email = response.email
            self.mobile = response.mobileNO

            
            if let last =  response.CNIC?.suffix(1) {
                if let lastDigit = Int(last) {
                    if lastDigit % 2 == 0 {
                        self.gender = "FEMALE"
                    } else {
                        self.gender = "MALE"
                    }
                }
            }
            
            
            
            self.populateValues(response)
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Utility.shared.googleAnalyticsEvent(OnlineAccountEnums.STEP_THREE.index, OnlineAccountEnums.STEP_THREE.value, OnlineAccountEnums.STEP_THREE.screenName, String(describing: type(of: self)))
    }
    func populateValues(_ values: UserDetails) {
        CNICTextField.text = values.name
        fatherNameTextField.text = values.fName
        dobTextField.text = values.dob
        ageTextField.text = values.age
        incomeTextField.text = values.income
        occupationTextField.text = values.occupation
        cnicIssueTextField.text = values.cnicIssue
        cnicExpiryTextField.text = values.cnicExpire
        checkBoxBtn.isSelected = values.cnicValid
        otherSourceTxtField.text = values.otherSource
        validCNIC(values.cnicValid)
        otherSourceTxtField(values.income ?? "")
    }
    func calcualteAge(_ dob: Date) {
        let age = dob.age
        self.ageTextField.text = String(describing: age)
        
    }
    func otherSourceTxtField(_ value: String) {
        
        if value == "Others" {
            isOtherSource = true
            UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseIn],
                           animations: {
                            self.otherView.isHidden = false
                            self.otherViewHeighConstraint.constant = 70.0
                            self.view.layoutIfNeeded()
            }, completion: nil)
        }
        else {
            isOtherSource = false
            UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseIn],
                           animations: {
                            self.otherView.isHidden = true
                            self.otherViewHeighConstraint.constant = 0.0
                            //self.isChecked = true
                            
                            self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
    func getSourceOfIncome() {
        let bodyParam = RequestBody()
        let bodyRequest = bodyParam.encryptData(bodyParam)
        let url = URL(string: OCCUPATION)!
        SVProgressHUD.show()
        WebServiceManager.sharedInstance.fetchObject(params: bodyRequest as Dictionary<String, AnyObject>, url: url, serviceType: "OTP Send", modelType: OccupationModel.self, errorMessage: { (errorMessage) in
            errorResponse = errorMessage
            if errorResponse?[0].errID != "00" {
                self.showErrorMsg(errorMessage)
            }
        }, success: { (response) in
            self.response_data = response
            self.occupation = self.response_data?.occupation
            self.sourceOfFund = self.response_data?.sourceOfFund
        }, fail: { (error) in
            print(error.localizedDescription)
            self.showAlert(title: "Alert", message: "The Internet connection appears to be offline.", controller: self) {
            }
            
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
            if tag == PickerOption.occupatonOption.rawValue {
                self.occupationTextField.text = self.occupation?[self.selectedOccupationId].name
            } else {
                self.incomeTextField.text = self.sourceOfFund?[self.selectedIncomeId].name
                self.otherSourceTxtField(self.sourceOfFund?[self.selectedIncomeId].name ?? "")
            }
        }))
        self.present(editRadiusAlert, animated: true)
    }
    
    
    @IBAction func didTapDobButton(_ sender: Any) {
        var currentDate = Date()
        if self.dobTextField.text  == "" {
            currentDate = Date()
        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            dateFormatter.timeZone = TimeZone.current
            dateFormatter.locale = Locale.current
            if let selectedDate = self.dobTextField.text {
                currentDate = dateFormatter.date(from: selectedDate) ?? Date()
            }
        }
        var dateComponents = DateComponents()
        dateComponents.year = -75
        let minDate = Calendar.current.date(byAdding: dateComponents, to: Date())
        dateComponents.year = -18
        let maxDate = Calendar.current.date(byAdding: dateComponents, to: Date())
        let datePicker = DatePickerDialog(textColor: .black,
                                          buttonColor: .black,
                                          font: UIFont.boldSystemFont(ofSize: 14),
                                          showCancelButton: true)
        datePicker.show("Date Picker",
                        doneButtonTitle: "Done",
                        cancelButtonTitle: "Cancel",
                        defaultDate: currentDate,
                        minimumDate: minDate,
                        maximumDate: maxDate,
                        datePickerMode: .date) { (date) in
                            if let dt = date {
                                //self.isSelect = true
                                let formatter = DateFormatter()
                                formatter.dateFormat = "dd/MM/yyyy"
                                let dateValue = formatter.string(from: dt)
                                self.dobTextField.text = dateValue
                                self.calcualteAge(dt)
                            } else {
                                self.dobTextField.text = ""
                            }
        }
    }
    
    
    
    @IBAction func didTapIncomeButton(_ sender: Any) {
        if sourceOfFund?.count ?? 0 > 0 {
            chooseValue(PickerOption.incomeOption.rawValue, "Choose Income Source", selectedIncomeId)
        } else {
            self.showAlert(title: "Alert", message: "No Income Found!", controller: self) {
            }
        }
    }
    
    
    @IBAction func didTapOccupationButton(_ sender: Any) {
        if occupation?.count ?? 0 > 0 {
            chooseValue(PickerOption.occupatonOption.rawValue, "Choose Occupation", selectedOccupationId)
        } else {
            self.showAlert(title: "Alert", message: "No Occupation Found!", controller: self) {
            }
        }
    }
    
    
    @IBAction func didTapCNICIssueButton(_ sender: Any) {
        var currentDate = Date()
        if self.cnicIssueTextField.text  == "" {
            currentDate = Date()
        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            dateFormatter.timeZone = TimeZone.current
            dateFormatter.locale = Locale.current
            if let selectedDate = self.cnicIssueTextField.text {
                currentDate = dateFormatter.date(from: selectedDate) ?? Date()
            }
        }
        var dateComponents = DateComponents()
        dateComponents.year = -75
        let minDate = Calendar.current.date(byAdding: dateComponents, to: Date() )
        dateComponents.year = 0
        let maxDate = Calendar.current.date(byAdding: dateComponents, to: Date())
        let datePicker = DatePickerDialog(textColor: .black,
                                          buttonColor: .black,
                                          font: UIFont.boldSystemFont(ofSize: 14),
                                          showCancelButton: true)
        datePicker.show("Date Picker",
                        doneButtonTitle: "Done",
                        cancelButtonTitle: "Cancel",
                        defaultDate: currentDate,
                        minimumDate: minDate,
                        maximumDate: maxDate,
                        datePickerMode: .date) { (date) in
                            if let dt = date {
                                //self.isSelect = true
                                let formatter = DateFormatter()
                                formatter.dateFormat = "dd/MM/yyyy"
                                let dateValue = formatter.string(from: dt)
                                self.cnicIssueTextField.text = dateValue
                            } else {
                                self.cnicIssueTextField.text = ""
                            }
        }
    }
    
    
    @IBAction func didTapCNICExpiryButton(_ sender: Any) {
        var currentDate = Date()
        if self.cnicExpiryTextField.text  == ""{
            currentDate = Date()
        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            dateFormatter.timeZone = TimeZone.current
            dateFormatter.locale = Locale.current
            if let selectedDate = self.cnicExpiryTextField.text {
                currentDate = dateFormatter.date(from: selectedDate) ?? Date()
            }
        }
        var dateComponents = DateComponents()
        dateComponents.year = 0
        dateComponents.day = +1
        let minDate = Calendar.current.date(byAdding: dateComponents, to: Date())
        dateComponents.year = 75
        let maxDate = Calendar.current.date(byAdding: dateComponents, to: Date())
        let datePicker = DatePickerDialog(textColor: .black,
                                          buttonColor: .black,
                                          font: UIFont.boldSystemFont(ofSize: 14),
                                          showCancelButton: true)
        datePicker.show("Date Picker",
                        doneButtonTitle: "Done",
                        cancelButtonTitle: "Cancel",
                        defaultDate: currentDate,
                        minimumDate: minDate,
                        maximumDate: maxDate,
                        datePickerMode: .date) { (date) in
                            if let dt = date {
                                //self.isSelect = true
                                let formatter = DateFormatter()
                                formatter.dateFormat = "dd/MM/yyyy"
                                let dateValue = formatter.string(from: dt)
                                self.cnicExpiryTextField.text = dateValue
                            } else {
                                self.cnicExpiryTextField.text = ""
                            }
        }
    }
    
    
    
    
    @IBAction func didTapNextButton(_ sender: Any) {
        do {
            var cnicExpire: String?
            var incomeSource: String?
            let cnicName        =   try validation.validateTxtField(CNICTextField.text, ValidationError.emptyCNICName)
            let fName           =   try validation.validateTxtField(fatherNameTextField.text, ValidationError.emptyFName)
            let dob             =   try validation.validateTxtField(dobTextField.text, ValidationError.emptydob)
            //let gender          =   ""//try validation.validateTxtField(genderTextField.text, ValidationError.emptyGender)
            let age             =   try validation.validateTxtField(ageTextField.text, ValidationError.emptyAge)
            if isOtherSource {
                incomeSource     =   try validation.validateTxtField(otherSourceTxtField.text, ValidationError.emptyOtherIncome)
            } else {
                incomeSource     =   try validation.validateTxtField(incomeTextField.text, ValidationError.emptyIncome)
            }
            let occupation      =   try validation.validateTxtField(occupationTextField.text, ValidationError.emptyOccupation)
            let cnicIssue       =   try validation.validateTxtField(cnicIssueTextField.text, ValidationError.emptyCNICIssue)
            if !isChecked {
                cnicExpire      =   try validation.validateTxtField(cnicExpiryTextField.text, ValidationError.emptyExpireCNIC)
            } else {
                cnicExpire      =   "01/01/2100"
            }
            
            
            let user    =   UserDetails(CNIC: cnic, email: email, mobileNO: mobile, name: cnicName, fName: fName, occupation: occupation, income: incomeSource, otherSource: incomeSource, cnicIssue: cnicIssue, cnicExpire: cnicExpire, age: age, gender: gender, dob: dob, cnicValid: isChecked)
            
            Utility.shared.saveUserObject(user)
            defaults.setValue(cnicName, forKey: "CNIC_Name")
            let vc = BankContactDetailsVC.instantiateFromAppStroyboard(appStoryboard: .onlineAccount)
            self.navigationController?.pushViewController(vc, animated: true)
        } catch {
            print(error)
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
    
    @IBAction func didTapCheckboxBtn(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        cnicExpiryTextField.text = ""
        validCNIC(sender.isSelected)
    }
    
    
    func validCNIC(_ isValid: Bool = false) {
        if !isValid {
            UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseIn],
                           animations: {
                            self.CNICExpiryView.isHidden = false
                            self.CNICExpiryViewHeighConstraint.constant = 70.0
                            self.isChecked = false
                            
                            self.view.layoutIfNeeded()
            }, completion: nil)
            
            
        }
        else {
            UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseIn],
                           animations: {
                            self.CNICExpiryView.isHidden = true
                            self.CNICExpiryViewHeighConstraint.constant = 0.0
                            self.isChecked = true
                            
                            self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
    
}
extension PersonalDetailsVC: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == CNICTextField || textField == fatherNameTextField || textField == otherSourceTxtField{
            
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
            if string != "" {
                textField.text = (textField.text! as NSString).replacingCharacters(in: range, with: string.uppercased())
                return false
            }
            return true
        }
        return true
    }
    
    
}
extension PersonalDetailsVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == PickerOption.occupatonOption.rawValue {
            return occupation?.count ?? 0
        } else {
            return sourceOfFund?.count ?? 0
        }
        
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == PickerOption.occupatonOption.rawValue {
            return occupation?[row].name
        } else {
            return sourceOfFund?[row].name
        }
        
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == PickerOption.occupatonOption.rawValue {
            occupationTextField.text = occupation?[row].name
            selectedOccupationId = row
        } else {
            incomeTextField.text = sourceOfFund?[row].name
            selectedIncomeId = row
        }
        
    }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var title = UILabel()
        if let titleLbl = view {
            title = titleLbl as! UILabel
        }
        title.font = UIFont(name: "Roboto-Regular", size: pickerTitleFontSize)
        if pickerView.tag == PickerOption.occupatonOption.rawValue {
         title.text = occupation?[row].name
        } else {
            title.text =  sourceOfFund?[row].name
        }
        
        title.textAlignment = .center
        return title
    }
}
enum PickerOption: Int {
    case occupatonOption = 1
    case incomeOption = 2
    case bankName = 3
    case country = 4
    case city = 5
    case fund = 6
    case category = 7
}

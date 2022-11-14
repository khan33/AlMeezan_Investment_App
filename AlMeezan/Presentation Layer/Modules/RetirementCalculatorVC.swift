//
//  RetirementCalculatorVC.swift
//  AlMeezan
//
//  Created by Atta khan on 14/10/2019.
//  Copyright © 2019 Atta khan. All rights reserved.
//

import UIKit
import SVProgressHUD
import SwiftKeychainWrapper

class RetirementCalculatorVC: UIViewController {
    
    @IBOutlet weak var ageLbl: UILabel!
    @IBOutlet weak var retirementAgeLbl: UILabel!
    @IBOutlet weak var monthlyIncomeLbl: UILabel!
    @IBOutlet weak var annualIncomeLbl: UILabel!
    @IBOutlet weak var grossSalaryLbl: UILabel!
    @IBOutlet weak var durationMAIPLbl: UILabel!
    @IBOutlet weak var MPTFLbl: UILabel!
    @IBOutlet weak var IPPLbl: UILabel!
    
    
    @IBOutlet weak var ageTxtField: UITextField!
    @IBOutlet weak var retirementAgeTxtField: UITextField!
    @IBOutlet weak var monthlyIncomeTxtField: UITextField!
    @IBOutlet weak var annualIncomeTxtField: UITextField!
    @IBOutlet weak var grossSalaryTxtField: UITextField!
    @IBOutlet weak var durationTxtField: UITextField!
    @IBOutlet weak var IPPTxtField: UITextField!
    @IBOutlet weak var MTPFTxtField: UITextField!
    
    
    
    @IBOutlet weak var workingHoursLbl: UILabel!
    @IBOutlet weak var highVolLbl: UILabel!
    @IBOutlet weak var totalContributionLbl: UILabel!
    @IBOutlet weak var accumlatedBalanceLbl: UILabel!
    @IBOutlet weak var ammountWithdrawnLbl: UILabel!
    @IBOutlet weak var totalAmountInvestLbl: UILabel!
    @IBOutlet weak var IPPmonthlyLbl: UILabel!
    
    @IBOutlet weak var ageBottomView: UIView!
    @IBOutlet weak var retirementAgeView: UIView!
    @IBOutlet weak var monthlyIncomeView: UIView!
    @IBOutlet weak var annualIncomeView: UIView!
    @IBOutlet weak var grossSalaryView: UIView!
    @IBOutlet weak var durationBottomView: UIView!
    @IBOutlet weak var MTPFBottomView: UIView!
    @IBOutlet weak var IPPBottomView: UIView!
    
    var currentString = ""
    var montlyIncomeString = ""
    var annualIncomeString = ""
    var grossSalaryString = ""
    var durationString = ""
    
    
    private var selectedIPP: Int = 0
    private var selectedMTPF: Int = 0
    private var selectedAge: Int = 0
    private var selectedDurationMiPP: Int = 0
    private var planArray = ["High Volatility","Medium Volatility","Low Volatility","Lower Volatility","Variable Equity","Variable Debt","Variable Money Market", "Variable Gold"]
    
    private var planArray2 = ["Medium Volatility","Low Volatility","Lower Volatility"]

    
    
    private var retirementAgeArray = ["+25","60","61","62","63","64","65","66","67","68","69","70"]
    
    private var durationMIPP = ["10","11","12","13","14","15"]
    
    var calculator_response: [RetirementCalculator]?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ageTxtField.delegate = self
        retirementAgeTxtField.delegate = self
        monthlyIncomeTxtField.delegate = self
        annualIncomeTxtField.delegate = self
        grossSalaryTxtField.delegate = self
        durationTxtField.delegate = self
        IPPTxtField.delegate = self
        MTPFTxtField.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideNavigationBar()
        resetValue()
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
            if tag == 3 {
                self.retirementAgeTxtField.text = self.retirementAgeArray[self.selectedAge]
            } else if tag == 2 {
                self.IPPTxtField.text = self.planArray2[self.selectedIPP]
            } else if tag == 4 {
                self.durationTxtField.text = self.durationMIPP[self.selectedDurationMiPP]
            } else {
                self.MTPFTxtField.text = self.planArray[self.selectedMTPF]
            }
        }))
        self.present(editRadiusAlert, animated: true)
        
    }
    
    func formatCurrency(string: String, textField: UITextField) {
        let formatter = NumberFormatter()
        if textField == grossSalaryTxtField || textField == annualIncomeTxtField {
            formatter.numberStyle = .percent
            formatter.multiplier = 1
            formatter.maximumFractionDigits = 0
        } else {
            formatter.numberStyle = .decimal
        }
        let numberFromField = Int(string)
        if let number = numberFromField {
            textField.text = formatter.string(from: NSNumber(value: number))
        } else {
            textField.text = ""
        }
    }
    
    func percentageFormate(string: String, textField: UITextField) {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.multiplier = 1
        formatter.maximumFractionDigits = 0
        
        let numberFromField = NSString(string: string).intValue
        textField.text = formatter.string(from: NSNumber(value: numberFromField))
    }
    
    
    func resetValue() {
        ageTxtField.text = ""
        retirementAgeTxtField.text = ""
        monthlyIncomeTxtField.text = ""
        annualIncomeTxtField.text = ""
        grossSalaryTxtField.text = ""
        durationTxtField.text = ""
        IPPTxtField.text = ""
        MTPFTxtField.text = ""
        annualIncomeString = ""
        grossSalaryString = ""
        montlyIncomeString = ""
        workingHoursLbl.text = "-"
        highVolLbl.text = "-"
        totalContributionLbl.text = "-"
        accumlatedBalanceLbl.text = "-"
        ammountWithdrawnLbl.text = "-"
        totalAmountInvestLbl.text = "-"
        IPPmonthlyLbl.text = "-"
    }
    
    @IBAction func tapOnRetirementAge(_ sender: Any) {
        choosePlanValue(3, "Choose Retirement", selectedAge)
    }
    
    @IBAction func tapOnIPPBtn(_ sender: Any) {
        choosePlanValue(2, "Choose IPP Value", selectedIPP)
    }
    
    @IBAction func tapOnMTPFBtn(_ sender: Any) {
        choosePlanValue(1, "Choose MTPF Value", selectedMTPF)
    }
    @IBAction func tapOnResetBtn(_ sender: Any) {
        resetValue()
    }
    
    
    @IBAction func tapOnDurationBtn(_ sender: Any) {
        choosePlanValue(4, "Choose Duration of MIPP", selectedDurationMiPP)
    }
    
    @IBAction func tapOnCalcuateBtn(_ sender: Any) {
        
        guard let ageTxt  = ageTxtField.text, !ageTxt.isEmpty else {
            self.showAlert(title: "Alert", message: "Please enter age.", controller: self) {
                self.ageTxtField.becomeFirstResponder()
            }
            return
        }
        
        guard let retirementTxt  = retirementAgeTxtField.text, !retirementTxt.isEmpty else {
            self.showAlert(title: "Alert", message: "Please enter your retirement age.", controller: self) {
                self.retirementAgeTxtField.becomeFirstResponder()
            }
            return
        }
        
        
        guard var monthlyTxt  = monthlyIncomeTxtField.text, !monthlyTxt.isEmpty else {
            self.showAlert(title: "Alert", message: "Please enter your montly income.", controller: self) {
                self.monthlyIncomeTxtField.becomeFirstResponder()
            }
            return
        }
        
        guard let annualTxt  = annualIncomeTxtField.text, !annualTxt.isEmpty else {
           self.showAlert(title: "Alert", message: "Please enter your annual income.", controller: self) {
               self.annualIncomeTxtField.becomeFirstResponder()
           }
           return
        }
        guard let grossTxt  = grossSalaryTxtField.text, !grossTxt.isEmpty else {
           self.showAlert(title: "Alert", message: "Please enter your annual income.", controller: self) {
               self.grossSalaryTxtField.becomeFirstResponder()
           }
           return
        }
        guard var durationTxt  = durationTxtField.text, !durationTxt.isEmpty else {
           self.showAlert(title: "Alert", message: "Please enter your annual income.", controller: self) {
               self.durationTxtField.becomeFirstResponder()
           }
           return
        }
        
        
        
        guard let MTPFTxt  = MTPFTxtField.text, !MTPFTxt.isEmpty else {
           self.showAlert(title: "Alert", message: "Please select MTPF value.", controller: self) {
               self.MTPFTxtField.becomeFirstResponder()
           }
           return
        }
        guard let IPPTxt  = IPPTxtField.text, !IPPTxt.isEmpty else {
           self.showAlert(title: "Alert", message: "Please select IPP value.", controller: self) {
               self.IPPTxtField.becomeFirstResponder()
           }
           return
        }
        
        var percentageMTPF: Double = 0.0
        if grossTxt != "" {
            let truncated = String(grossTxt.dropLast())
            let string     =   truncated.replacingOccurrences(of: ",", with: "", options: NSString.CompareOptions.literal, range: nil)
            let value = Double(string)!
            percentageMTPF = Double ( value / 100 )
        }
        var annualIncomPercentage = 0.0
        if annualTxt != "" {
            let truncated = String(annualTxt.dropLast())
            let string     =   truncated.replacingOccurrences(of: ",", with: "", options: NSString.CompareOptions.literal, range: nil)
            let value = Double(string)!
            annualIncomPercentage = Double ( value / 100 )
        }
        var retirementAge = Int(retirementTxt)!
        if retirementTxt == "+25" {
            let currentAge = Int(ageTxt)!
            if currentAge > 44 {
                self.showAlert(title: "Alert", message: "Your retirement age exceed to limit.", controller: self) {
                    self.ageTxtField.becomeFirstResponder()
                }
                return
            }
            retirementAge = retirementAge + currentAge
        }
        monthlyTxt     =    monthlyTxt.replacingOccurrences(of: ",", with: "", options: NSString.CompareOptions.literal, range: nil)
        durationTxt    =    durationTxt.replacingOccurrences(of: ",", with: "", options: NSString.CompareOptions.literal, range: nil)
        
        SVProgressHUD.show()
        let Username  = KeychainWrapper.standard.string(forKey: "CustomerId")
        let Password = KeychainWrapper.standard.string(forKey: "AccessToken")
        let bodyParam = RequestBody(Username: Username, Password: Password, Plan1:MTPFTxt, Plan2: IPPTxt, CurrentAge: ageTxt,DurationOfMIPP: durationTxt, MonthlyIncome: monthlyTxt, AnnualIncomeInc: String(annualIncomPercentage), ToBeInvestInMTPF: String(percentageMTPF), retirementAge: String(retirementAge) )
        let bodyRequest = bodyParam.encryptData(bodyParam)
        
        let url = URL(string: RETIREMENT_CALCULATOR)!
        
        WebServiceManager.sharedInstance.fetch(params: bodyRequest as Dictionary<String, AnyObject>, url: url, serviceType: "Tax SAving Calculator", modelType: RetirementCalculator.self, errorMessage: { (errorMessage) in
            errorResponse = errorMessage
            self.showErrorMsg(errorMessage)
        }, success: { (response) in
            self.calculator_response = response
            self.resetValue()
            self.updateUI()
        }, fail: { (error) in
            print(error.localizedDescription)
        }, showHUD: true)
    }
    
    private func updateUI() {
        if let data = calculator_response {
            let response = data[0]
            
            highVolLbl.text = response.allocationScheme
            if let workignHours = response.workingYear {
                 workingHoursLbl.text = "\(String(describing: workignHours))"
            }
            if let total_contribution = response.totalContribution {
                totalContributionLbl.text = "\(String(describing: total_contribution).toCurrencyFormat(withFraction: false))"
            }
            if let balance_retirement = response.balanceAtRetirement {
                accumlatedBalanceLbl.text = "\(String(describing: balance_retirement).toCurrencyFormat(withFraction: false))"
            }
            if let ammountWithdrawn = response.balanceAtRetirement {
                ammountWithdrawnLbl.text = "\(String(describing: ammountWithdrawn).toCurrencyFormat(withFraction: false))"
            }
            if let totalAmountInvest = response.balanceAtRetirement {
                totalAmountInvestLbl.text = "\(String(describing: totalAmountInvest).toCurrencyFormat(withFraction: false))"
            }
            if let IPPmonthly = response.balanceAtRetirement {
                IPPmonthlyLbl.text = "\(String(describing: IPPmonthly).toCurrencyFormat(withFraction: false))"
            }
            
        }
    }
    @IBAction func navigateToInvestNow(_ sender: Any) {
        let vc = InvestViewController.instantiateFromAppStroyboard(appStoryboard: .main)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}


extension RetirementCalculatorVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 3 {
            return retirementAgeArray.count
        } else if pickerView.tag == 4 {
            return durationMIPP.count
        } else if pickerView.tag == 2 {
            return planArray2.count
        }
        return planArray.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 3 {
            return retirementAgeArray[row]
        } else if pickerView.tag == 4 {
            return durationMIPP[row]
        } else if pickerView.tag == 2 {
            return planArray2[row]
        }
        return planArray[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 3 {
            retirementAgeTxtField.text = retirementAgeArray[row]
            selectedAge = row
        } else if pickerView.tag == 1 {
            MTPFTxtField.text = planArray[row]
            selectedMTPF = row
        }else if pickerView.tag == 4 {
            durationTxtField.text = durationMIPP[row]
            selectedDurationMiPP = row
        } else {
            IPPTxtField.text = planArray2[row]
            selectedIPP = row
        }
        
    }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var title = UILabel()
        if let titleLbl = view {
            title = titleLbl as! UILabel
        }
        title.font = UIFont(name: "Roboto-Regular", size: pickerTitleFontSize)
        if pickerView.tag == 3 {
            title.text =  retirementAgeArray[row]
        } else if pickerView.tag == 4 {
            title.text =  durationMIPP[row]
        } else if pickerView.tag == 1 {
            title.text =  planArray[row]
        } else {
            title.text =  planArray2[row]
        }
        
        title.textAlignment = .center
        return title
    }
}

extension RetirementCalculatorVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == monthlyIncomeTxtField {
            switch string {
               case "0","1","2","3","4","5","6","7","8","9":
                   montlyIncomeString += string
                   formatCurrency(string: montlyIncomeString, textField: textField)
               default:
                   let array = Array(string)
                   var currentStringArray = Array(montlyIncomeString)
                   if array.count == 0 && currentStringArray.count != 0 {
                       currentStringArray.removeLast()
                       montlyIncomeString = ""
                       for character in currentStringArray {
                           montlyIncomeString += String(character)
                       }
                       formatCurrency(string: montlyIncomeString, textField: textField)
                   }
               }
        }
        else if textField == durationTxtField {
            switch string {
            case "0","1","2","3","4","5","6","7","8","9":
                durationString += string
                formatCurrency(string: durationString, textField: textField)
            default:
                let array = Array(string)
                var currentStringArray = Array(durationString)
                if array.count == 0 && currentStringArray.count != 0 {
                    currentStringArray.removeLast()
                    durationString = ""
                    for character in currentStringArray {
                        durationString += String(character)
                    }
                    formatCurrency(string: durationString, textField: textField)
                }
            }
        }
        else if textField == annualIncomeTxtField {
            switch string {
            case "0","1","2","3","4","5","6","7","8","9":
                annualIncomeString += string
                formatCurrency(string: annualIncomeString, textField: textField)
            default:
                let array = Array(string)
                var currentStringArray = Array(annualIncomeString)
                if array.count == 0 && currentStringArray.count != 0 {
                    currentStringArray.removeLast()
                    annualIncomeString = ""
                    for character in currentStringArray {
                        annualIncomeString += String(character)
                    }
                    formatCurrency(string: annualIncomeString, textField: textField)
                }
            }
        }
        else if textField == grossSalaryTxtField {
            switch string {
            case "0","1","2","3","4","5","6","7","8","9":
                grossSalaryString += string
                formatCurrency(string: grossSalaryString, textField: textField)
            default:
                let array = Array(string)
                var currentStringArray = Array(grossSalaryString)
                if array.count == 0 && currentStringArray.count != 0 {
                    currentStringArray.removeLast()
                    grossSalaryString = ""
                    for character in currentStringArray {
                        grossSalaryString += String(character)
                    }
                    formatCurrency(string: grossSalaryString, textField: textField)
                }
            }
        }
        else if textField == ageTxtField {
            let numberFiltered = string.components(separatedBy: NSCharacterSet(charactersIn: "0123456789").inverted).joined(separator: "")
            guard string == numberFiltered, range.location < 2 else {
                return false
            }
            if let newValue = Int(textField.text!), let currentValue = Int(string) {
                let totalValue = newValue*10 + currentValue
                
                switch totalValue {
                case 18..<60:
                    return true
                default:
                    textField.text = ""
                    self.showAlert(title: "Alert", message: "Please enter a value between 18 & 59", controller: self) {
                                            }
                    return false
                }
            }
            return true
        }
        return false
    }
    
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case ageTxtField:
            ageTxtField.leftViewMode = .always
            ageTxtField.textColor = UIColor.themeColor
            ageBottomView.backgroundColor = UIColor.themeColor
            ageLbl.transform = CGAffineTransform(scaleX: 1.2, y: 1.2).concatenating(CGAffineTransform(translationX: 0, y: -4))
            ageLbl.textColor = UIColor.themeColor
        case retirementAgeTxtField:
            retirementAgeTxtField.textColor = UIColor.themeColor
            retirementAgeView.backgroundColor = UIColor.themeColor
            retirementAgeLbl.transform = CGAffineTransform(scaleX: 1.2, y: 1.2).concatenating(CGAffineTransform(translationX: 0, y: -4))
            retirementAgeLbl.textColor = UIColor.themeColor
        case monthlyIncomeTxtField:
            monthlyIncomeTxtField.textColor = UIColor.themeColor
            monthlyIncomeView.backgroundColor = UIColor.themeColor
            monthlyIncomeLbl.transform = CGAffineTransform(scaleX: 1.2, y: 1.2).concatenating(CGAffineTransform(translationX: 0, y: -4))
            monthlyIncomeLbl.textColor = UIColor.themeColor
        case annualIncomeTxtField:
            annualIncomeTxtField.textColor = UIColor.themeColor
            annualIncomeView.backgroundColor = UIColor.themeColor
            annualIncomeLbl.transform = CGAffineTransform(scaleX: 1.2, y: 1.2).concatenating(CGAffineTransform(translationX: 0, y: -4))
            annualIncomeLbl.textColor = UIColor.themeColor
            
        case grossSalaryTxtField:
            grossSalaryTxtField.textColor = UIColor.themeColor
            grossSalaryView.backgroundColor = UIColor.themeColor
            grossSalaryLbl.transform = CGAffineTransform(scaleX: 1.2, y: 1.2).concatenating(CGAffineTransform(translationX: 0, y: -4))
            grossSalaryLbl.textColor = UIColor.themeColor
        case durationTxtField:
            durationTxtField.textColor = UIColor.themeColor
            durationBottomView.backgroundColor = UIColor.themeColor
            durationMAIPLbl.transform = CGAffineTransform(scaleX: 1.2, y: 1.2).concatenating(CGAffineTransform(translationX: 0, y: -4))
            durationMAIPLbl.textColor = UIColor.themeColor
        case MTPFTxtField:
            MTPFTxtField.textColor = UIColor.themeColor
            MTPFBottomView.backgroundColor = UIColor.themeColor
            MPTFLbl.transform = CGAffineTransform(scaleX: 1.2, y: 1.2).concatenating(CGAffineTransform(translationX: 0, y: -4))
            MPTFLbl.textColor = UIColor.themeColor
        case IPPTxtField:
            IPPTxtField.textColor = UIColor.themeColor
            IPPBottomView.backgroundColor = UIColor.themeColor
            IPPLbl.transform = CGAffineTransform(scaleX: 1.2, y: 1.2).concatenating(CGAffineTransform(translationX: 0, y: -4))
            IPPLbl.textColor = UIColor.themeColor
            
        default:
            break
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        currentString = ""
        switch textField {
        case ageTxtField:
            ageTxtField.textColor = UIColor.black
            ageBottomView.backgroundColor = UIColor.lightGray
            ageLbl.transform = CGAffineTransform(scaleX: 1.0, y: 1.0).concatenating(CGAffineTransform(translationX: 0, y: 0))
            ageLbl.textColor = UIColor.themeLblColor
        case retirementAgeTxtField:
            retirementAgeTxtField.textColor = UIColor.black
            retirementAgeView.backgroundColor = UIColor.lightGray
            retirementAgeLbl.transform = CGAffineTransform(scaleX: 1.0, y: 1.0).concatenating(CGAffineTransform(translationX: 0, y: 0))
            retirementAgeLbl.textColor = UIColor.themeLblColor
        case monthlyIncomeTxtField:
            monthlyIncomeTxtField.textColor = UIColor.black
            monthlyIncomeView.backgroundColor = UIColor.lightGray
            monthlyIncomeLbl.transform = CGAffineTransform(scaleX: 1.0, y: 1.0).concatenating(CGAffineTransform(translationX: 0, y: 0))
            monthlyIncomeLbl.textColor = UIColor.themeLblColor
        case annualIncomeTxtField:
            annualIncomeTxtField.textColor = UIColor.black
            annualIncomeView.backgroundColor = UIColor.lightGray
            annualIncomeLbl.transform = CGAffineTransform(scaleX: 1.0, y: 1.0).concatenating(CGAffineTransform(translationX: 0, y: 0))
            annualIncomeLbl.textColor = UIColor.themeLblColor
        case grossSalaryTxtField:
            grossSalaryTxtField.textColor = UIColor.black
            grossSalaryView.backgroundColor = UIColor.lightGray
            grossSalaryLbl.transform = CGAffineTransform(scaleX: 1.0, y: 1.0).concatenating(CGAffineTransform(translationX: 0, y: 0))
            grossSalaryLbl.textColor = UIColor.themeLblColor
        case durationTxtField:
            durationTxtField.textColor = UIColor.black
            durationBottomView.backgroundColor = UIColor.lightGray
            durationMAIPLbl.transform = CGAffineTransform(scaleX: 1.0, y: 1.0).concatenating(CGAffineTransform(translationX: 0, y: 0))
            durationMAIPLbl.textColor = UIColor.themeLblColor
        case IPPTxtField:
            IPPTxtField.textColor = UIColor.black
            IPPBottomView.backgroundColor = UIColor.lightGray
            IPPLbl.transform = CGAffineTransform(scaleX: 1.0, y: 1.0).concatenating(CGAffineTransform(translationX: 0, y: 0))
            IPPLbl.textColor = UIColor.themeLblColor
        case MTPFTxtField:
            MTPFTxtField.textColor = UIColor.black
            MTPFBottomView.backgroundColor = UIColor.lightGray
            MPTFLbl.transform = CGAffineTransform(scaleX: 1.0, y: 1.0).concatenating(CGAffineTransform(translationX: 0, y: 0))
            MPTFLbl.textColor = UIColor.themeLblColor
        default:
            break
        }
    }
}

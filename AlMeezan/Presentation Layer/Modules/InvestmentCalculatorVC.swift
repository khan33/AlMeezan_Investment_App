//
//  InvestmentCalculatorVC.swift
//  AlMeezan
//
//  Created by Atta khan on 14/10/2019.
//  Copyright © 2019 Atta khan. All rights reserved.
//

import UIKit
import SVProgressHUD

class InvestmentCalculatorVC: UIViewController {

    @IBOutlet weak var initialInvestTxtField: UITextField!
    
    @IBOutlet weak var initialInvestBottomView: UIView!
    @IBOutlet weak var regularInvestmentTxtField: UITextField!
    @IBOutlet weak var regularInvestmentView: UIView!
    @IBOutlet weak var monthlyBtn: UIButton!
    @IBOutlet weak var quarterlyBtn: UIButton!
    @IBOutlet weak var semiAnnuallyBtn: UIButton!
    @IBOutlet weak var annualBtn: UIButton!
    @IBOutlet weak var yearsOfGrowthTxtField: UITextField!
    @IBOutlet weak var yearsOfGrowthView: UIView!
    @IBOutlet weak var rateOfReturnTxtField: UITextField!
    @IBOutlet weak var rateOfReturnView: UIView!
    @IBOutlet weak var resetBtn: UIButton!
    @IBOutlet weak var calculateBtn: UIButton!
    @IBOutlet weak var pensionFundTaxLbl: UILabel!
    @IBOutlet weak var mutualFundTaxLbl: UILabel!
    
    
    @IBOutlet weak var initialInvestmentLbl: UILabel!
    @IBOutlet weak var regularInestmentLbl: UILabel!
    @IBOutlet weak var returnLbl: UILabel!
    @IBOutlet weak var growthLbl: UILabel!
    
    
    @IBOutlet weak var resultViewHeighConstraint: NSLayoutConstraint!
    @IBOutlet weak var resultView: UIView!
    var currentString = ""
    var regularFieldString = ""
    var initialFieldString = ""
    var returnFieldString = ""
    var isSelected: Bool = false
    var periodic: Double = 0.0
    override func viewDidLoad() {
        super.viewDidLoad()
        resultView.alpha = 0
        resultViewHeighConstraint.constant = 0
        initialInvestTxtField.delegate = self
        regularInvestmentTxtField.delegate = self
        yearsOfGrowthTxtField.delegate = self
        rateOfReturnTxtField.delegate = self
        
        
        let lblAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.init(rgb: 0x232746),
            NSAttributedString.Key.font: UIFont(name: "Roboto-Regular", size: 12)
        ]
        let pKRAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.init(rgb: 0xB9BBC6),
            NSAttributedString.Key.font: UIFont(name: "Roboto-Regular", size: 12)
        ]

        let partOne = NSMutableAttributedString(string: "Initial Investment ", attributes: lblAttributes as [NSAttributedString.Key : Any])
        let partTwo = NSMutableAttributedString(string: "(PKR)", attributes: pKRAttributes as [NSAttributedString.Key : Any])
        let annualIncomeStr = NSMutableAttributedString()
        annualIncomeStr.append(partOne)
        annualIncomeStr.append(partTwo)
        initialInvestmentLbl.attributedText = annualIncomeStr
        
        
        let pensionFundStr = NSMutableAttributedString()
        let strOne = NSMutableAttributedString(string: "Regular Investment ", attributes: lblAttributes as [NSAttributedString.Key : Any])
        pensionFundStr.append(strOne)
        pensionFundStr.append(partTwo)
        regularInestmentLbl.attributedText = pensionFundStr
    }
    
    override func viewWillAppear(_ animated: Bool) {
        isSelected = false
        hideNavigationBar()
    }
    
    
    func clearAllBtn() {
        semiAnnuallyBtn.isSelected = false
        monthlyBtn.isSelected = false
        quarterlyBtn.isSelected = false
        annualBtn.isSelected = false
    }
    func clearAllTextFields() {
        initialInvestTxtField.text = ""
        regularInvestmentTxtField.text = ""
        yearsOfGrowthTxtField.text = ""
        rateOfReturnTxtField.text = ""
        pensionFundTaxLbl.text = " - "
        mutualFundTaxLbl.text = " - "
        currentString = ""
        regularFieldString = ""
        initialFieldString = ""
        returnFieldString = ""
    }
    
    func findLocaleByCurrencyCode(_ currencyCode: String) -> Locale? {
        let locales = Locale.availableIdentifiers
        var locale: Locale?
        for   localeId in locales {
            locale = Locale(identifier: localeId)
            if let code = (locale! as NSLocale).object(forKey: NSLocale.Key.currencyCode) as? String {
                if code == currencyCode {
                    return locale
                }
            }
        }
        return locale
    }
    
    func formatCurrency(string: String, textField: UITextField) {
        let formatter = NumberFormatter()
        if textField == rateOfReturnTxtField {
            formatter.numberStyle = .percent
            formatter.multiplier = 1
            formatter.maximumFractionDigits = 0
        } else {
            formatter.numberStyle = .decimal
        }
        //let numberFromField = NSString(string: string).intValue
        let numberFromField = Int(string)
        if let number = numberFromField {
            textField.text = formatter.string(from: NSNumber(value: number))
        } else {
            textField.text = ""
        }
    }
    
    @IBAction func tapOnTimePeriodBtn(_ sender: UIButton) {
        clearAllBtn()
        sender.isSelected = true
        if sender.tag == 1 {
            periodic = 12.0
        } else if sender.tag == 2 {
            periodic = 2.0
        } else if sender.tag == 3 {
            periodic = 4.0
        } else if sender.tag == 4 {
            periodic = 1.0
        }
        isSelected = true
    }
    @IBAction func tapOnResetBtn(_ sender: UIButton) {
        clearAllBtn()
        clearAllTextFields()
        initialInvestTxtField.becomeFirstResponder()
        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseIn],
                       animations: {
                        self.resultView.alpha = 0
                        self.resultViewHeighConstraint.constant = 0
                        
                        self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    @IBAction func tapOnCalculateBtn(_ sender: Any) {
        guard var initialInvestTxt  = initialInvestTxtField.text, !initialInvestTxt.isEmpty else {
            self.showAlert(title: "Alert", message: "Please enter initial Investment.", controller: self) {
                self.initialInvestTxtField.becomeFirstResponder()
            }
            return
        }
        guard var regularInvestmentTxt  = regularInvestmentTxtField.text, !regularInvestmentTxt.isEmpty else {
            self.showAlert(title: "Alert", message: "Please enter Regular Investment.", controller: self) {
                self.regularInvestmentTxtField.becomeFirstResponder()
            }
            return
        }
        guard let yearsOfGrowthTxt  = yearsOfGrowthTxtField.text, !yearsOfGrowthTxt.isEmpty else {
            self.showAlert(title: "Alert", message: "Please enter year of growth", controller: self) {
                self.yearsOfGrowthTxtField.becomeFirstResponder()
            }
            return
        }
        guard var rateOfReturnTxt  = rateOfReturnTxtField.text, !rateOfReturnTxt.isEmpty else {
            self.showAlert(title: "Alert", message: "Please enter rate of return", controller: self) {
                self.rateOfReturnTxtField.becomeFirstResponder()
            }
            return
        }
        
        if isSelected == false {
            self.showAlert(title: "Alert", message: "Please select time period option", controller: self) {
                
            }
            return
        }
        
        initialInvestTxt        =   initialInvestTxt.replacingOccurrences(of: ",", with: "", options: NSString.CompareOptions.literal, range: nil)
        regularInvestmentTxt    =   regularInvestmentTxt.replacingOccurrences(of: ",", with: "", options: NSString.CompareOptions.literal, range: nil)
        rateOfReturnTxt         =   rateOfReturnTxt.replacingOccurrences(of: "%", with: "", options: NSString.CompareOptions.literal, range: nil)
        rateOfReturnTxt         =   rateOfReturnTxt.replacingOccurrences(of: ",", with: "", options: NSString.CompareOptions.literal, range: nil)
        
        let initial_investment: Double     =   Double(initialInvestTxt)!
        let regular_invesetment: Double    =   Double(regularInvestmentTxt)!
        let rateOfRetrun: Double           =   Double(rateOfReturnTxt)!
        let year_growth: Double            =   Double(yearsOfGrowthTxt)!
        let percentage: Double = Double(rateOfRetrun / 100)
        let value = 1 + percentage
        let powerVal: Double = Double(1 / periodic)
        
        let power = pow(value,powerVal)
        let ROR = power - 1
        
        let principle_investmetn = initial_investment + (regular_invesetment * periodic * year_growth)
        
        
        let expected_amount = initial_investment * (pow((1 + percentage), year_growth)) + regular_invesetment * ((pow((1 + ROR), (year_growth * periodic)) - 1) / ROR)
        
    
        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseIn],
                       animations: {
                        self.resultView.alpha = 1
                        self.resultViewHeighConstraint.constant = 220
                        
                        self.view.layoutIfNeeded()
        }, completion: nil)
        
        
        pensionFundTaxLbl.text = "PKR. \(String(describing: principle_investmetn.rounded(toPlaces: 0)).toCurrencyFormat(withFraction: false))"
        mutualFundTaxLbl.text = "PKR. \(String(describing: expected_amount.rounded(toPlaces: 0)).toCurrencyFormat(withFraction: false))"
        
    }
    
    @IBAction func navigateToInvestVC(_ sender: Any) {
        let vc = InvestViewController.instantiateFromAppStroyboard(appStoryboard: .main)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension InvestmentCalculatorVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == yearsOfGrowthTxtField {
            guard CharacterSet(charactersIn: "0123456789").isSuperset(of: CharacterSet(charactersIn: string)) else {
                return false
            }
            return true
        }
        print(string)
        if textField == initialInvestTxtField {
            switch string {
                
            case "0","1","2","3","4","5","6","7","8","9":
                initialFieldString += string
                formatCurrency(string: initialFieldString, textField: textField)  
            default:
                let array = Array(string)
                var currentStringArray = Array(initialFieldString)
                if array.count == 0 && currentStringArray.count != 0 {
                    currentStringArray.removeLast()
                    initialFieldString = ""
                    for character in currentStringArray {
                        initialFieldString += String(character)
                    }
                    formatCurrency(string: initialFieldString, textField: textField)
                }
            }
        }
        else if textField == regularInvestmentTxtField {
            
            switch string {
            case "0","1","2","3","4","5","6","7","8","9":
                regularFieldString += string
                formatCurrency(string: regularFieldString, textField: textField)
            default:
                let array = Array(string)
                var currentStringArray = Array(regularFieldString)
                if array.count == 0 && currentStringArray.count != 0 {
                    currentStringArray.removeLast()
                    regularFieldString = ""
                    for character in currentStringArray {
                        regularFieldString += String(character)
                    }
                    formatCurrency(string: regularFieldString, textField: textField)
                }
            }
        } else if textField == rateOfReturnTxtField {
            switch string {
            case "0","1","2","3","4","5","6","7","8","9":
                returnFieldString += string
                formatCurrency(string: returnFieldString, textField: textField)
            default:
                let array = Array(string)
                var currentStringArray = Array(returnFieldString)
                if array.count == 0 && currentStringArray.count != 0 {
                    currentStringArray.removeLast()
                    returnFieldString = ""
                    for character in currentStringArray {
                        returnFieldString += String(character)
                    }
                    formatCurrency(string: returnFieldString, textField: textField)
                }
            }
        }
        return false
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        switch textField {
        case initialInvestTxtField:
            //initialFieldString = ""
            initialInvestTxtField.textColor = UIColor.black
            initialInvestBottomView.backgroundColor = UIColor.lightGray
            initialInvestmentLbl.transform = CGAffineTransform(scaleX: 1.0, y: 1.0).concatenating(CGAffineTransform(translationX: 0, y: 0))
            initialInvestmentLbl.textColor = UIColor.themeLblColor
        case regularInvestmentTxtField:
            //regularFieldString = ""
            regularInvestmentTxtField.textColor = UIColor.black
            regularInvestmentView.backgroundColor = UIColor.lightGray
            regularInestmentLbl.transform = CGAffineTransform(scaleX: 1.0, y: 1.0).concatenating(CGAffineTransform(translationX: 0, y: 0))
            regularInestmentLbl.textColor = UIColor.themeLblColor
        case yearsOfGrowthTxtField:
            yearsOfGrowthTxtField.textColor = UIColor.black
            yearsOfGrowthView.backgroundColor = UIColor.lightGray
            growthLbl.transform = CGAffineTransform(scaleX: 1.0, y: 1.0).concatenating(CGAffineTransform(translationX: 0, y: 0))
            growthLbl.textColor = UIColor.themeLblColor
        case rateOfReturnTxtField:
            //returnFieldString = ""
            rateOfReturnTxtField.textColor = UIColor.black
            rateOfReturnView.backgroundColor = UIColor.lightGray
            returnLbl.transform = CGAffineTransform(scaleX: 1.0, y: 1.0).concatenating(CGAffineTransform(translationX: 0, y: 0))
            returnLbl.textColor = UIColor.themeLblColor
        
        default:
            break
        }
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case initialInvestTxtField:
            initialInvestTxtField.textColor = UIColor.themeColor
            initialInvestBottomView.backgroundColor = UIColor.themeColor
            initialInvestmentLbl.transform = CGAffineTransform(scaleX: 1.2, y: 1.2).concatenating(CGAffineTransform(translationX: 0, y: -4))
            initialInvestmentLbl.textColor = UIColor.themeColor
        case regularInvestmentTxtField:
            regularInvestmentTxtField.textColor = UIColor.themeColor
            regularInvestmentView.backgroundColor = UIColor.themeColor
            regularInestmentLbl.transform = CGAffineTransform(scaleX: 1.2, y: 1.2).concatenating(CGAffineTransform(translationX: 0, y: -4))
            regularInestmentLbl.textColor = UIColor.themeColor
        case yearsOfGrowthTxtField:
            yearsOfGrowthTxtField.textColor = UIColor.themeColor
            yearsOfGrowthView.backgroundColor = UIColor.themeColor
            growthLbl.transform = CGAffineTransform(scaleX: 1.2, y: 1.2).concatenating(CGAffineTransform(translationX: 0, y: -4))
            growthLbl.textColor = UIColor.themeColor
        case rateOfReturnTxtField:
            rateOfReturnTxtField.textColor = UIColor.themeColor
            rateOfReturnView.backgroundColor = UIColor.themeColor
            returnLbl.transform = CGAffineTransform(scaleX: 1.2, y: 1.2).concatenating(CGAffineTransform(translationX: 0, y: -4))
            returnLbl.textColor = UIColor.themeColor
        default:
            break
        }
    }
}

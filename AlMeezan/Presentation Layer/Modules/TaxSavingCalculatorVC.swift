//
//  TaxSavingCalculatorVC.swift
//  AlMeezan
//
//  Created by Atta khan on 14/10/2019.
//  Copyright © 2019 Atta khan. All rights reserved.
//

import UIKit
import SVProgressHUD

class TaxSavingCalculatorVC: UIViewController {

    @IBOutlet weak var ageTxtField: UITextField!
    
    
    @IBOutlet weak var annualIncomeTxtField: UITextField!
    @IBOutlet weak var pensionTxtField: UITextField!
    @IBOutlet weak var mutualFundTxtField: UITextField!
    @IBOutlet weak var resetBtn: UIButton!
    @IBOutlet weak var calculateBtn: UIButton!
    @IBOutlet weak var pensionFundLbl: UILabel!
    @IBOutlet weak var mutualFundLbl: UILabel!
    @IBOutlet weak var taxRateLbl: UILabel!
    
    @IBOutlet weak var ageView: UIView!
    @IBOutlet weak var annualIncomeView: UIView!
    @IBOutlet weak var pensionFundView: UIView!
    @IBOutlet weak var mutualFundView: UIView!
    
    @IBOutlet weak var selectLbl: UILabel!
    @IBOutlet weak var annualIncomeLbl: UILabel!
    @IBOutlet weak var pensionLbl: UILabel!
    @IBOutlet weak var mutualLbl: UILabel!
    @IBOutlet weak var resultView: UIView!
    @IBOutlet weak var resultHeightConstraint: NSLayoutConstraint!
    
    
    var currentString = ""
    var annualIncomeString = ""
    var pensionFundString = ""
    var mutualFundString = ""
    
    
    var ageArray = ["Salaried individual","Self-Employed"]
    var ageArrayValue =  [1,2]
    var selectedAge: Int = 1
    var selected: Int = 0
    var calculator_model : TaxSavingCalculator?
    override func viewDidLoad() {
        super.viewDidLoad()
        resultView.alpha = 0
        resultHeightConstraint.constant = 0
        ageTxtField.text = ageArray[0]
        annualIncomeTxtField.delegate = self
        pensionTxtField.delegate = self
        mutualFundTxtField.delegate = self
        
        
        let lblAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.init(rgb: 0x232746),
            NSAttributedString.Key.font: UIFont(name: "Roboto-Regular", size: 12)
        ]
        let pKRAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.init(rgb: 0xB9BBC6),
            NSAttributedString.Key.font: UIFont(name: "Roboto-Regular", size: 12)
        ]

        let partOne = NSMutableAttributedString(string: "Annual Income ", attributes: lblAttributes as [NSAttributedString.Key : Any])
        let partTwo = NSMutableAttributedString(string: "(PKR)", attributes: pKRAttributes as [NSAttributedString.Key : Any])
        let annualIncomeStr = NSMutableAttributedString()
        annualIncomeStr.append(partOne)
        annualIncomeStr.append(partTwo)
        annualIncomeLbl.attributedText = annualIncomeStr
        
        
        let pensionFundStr = NSMutableAttributedString()
        let strOne = NSMutableAttributedString(string: "Pension Fund ", attributes: lblAttributes as [NSAttributedString.Key : Any])
        pensionFundStr.append(strOne)
        pensionFundStr.append(partTwo)
        mutualLbl.attributedText = pensionFundStr
        
        
        let mutualFundStr = NSMutableAttributedString()
        let str1 = NSMutableAttributedString(string: "Mutual Fund ", attributes: lblAttributes as [NSAttributedString.Key : Any])
        mutualFundStr.append(str1)
        mutualFundStr.append(partTwo)
        pensionLbl.attributedText = mutualFundStr
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideNavigationBar()
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
        formatter.numberStyle = .decimal
        let numberFromField = Int(string)
        if let number = numberFromField {
            textField.text = formatter.string(from: NSNumber(value: number))
        } else {
            textField.text = ""
        }
    }
    
    @IBAction func tapOnResetBtn(_ sender: Any) {
        annualIncomeTxtField.text = ""
        pensionTxtField.text = ""
        ageTxtField.text = ageArray[0]
        selectedAge = 1
        selected = 0
        mutualFundTxtField.text = ""
        pensionFundLbl.text = "-"
        mutualFundLbl.text = "-"
        taxRateLbl.text = "-"
        annualIncomeString = ""
        pensionFundString = ""
        mutualFundString = ""
        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseIn],
                       animations: {
                        self.resultView.alpha = 0
                        self.resultHeightConstraint.constant = 0
                        
                        self.view.layoutIfNeeded()
        }, completion: nil)
        
    }
    

    @IBAction func tapOnAgeBtn(_ sender: UIButton) {
        let vc = UIViewController()
        vc.preferredContentSize = CGSize(width: 250,height: 200)
        let pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: 250, height: 200))
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.selectRow(selected, inComponent:0, animated:true)
        vc.view.addSubview(pickerView)
        let editRadiusAlert = UIAlertController(title: "Choose Option", message: "", preferredStyle: UIAlertController.Style.alert)
        editRadiusAlert.setValue(vc, forKey: "contentViewController")
        editRadiusAlert.addAction(UIAlertAction(title: "Done", style: .default, handler: { (alert: UIAlertAction!) in
             self.ageTxtField.text = self.ageArray[self.selected]
        }))
        self.present(editRadiusAlert, animated: true)
        
        
    }
    @IBAction func tapOnCalculateBtn(_ sender: UIButton) {
        guard var annualIncomeTxt  = annualIncomeTxtField.text, !annualIncomeTxt.isEmpty else {
            self.showAlert(title: "Alert", message: "Please enter your annual income.", controller: self) {
                self.annualIncomeTxtField.becomeFirstResponder()
            }
            return
        }
        guard var pensionFundTxt  = pensionTxtField.text, !pensionFundTxt.isEmpty else {
            self.showAlert(title: "Alert", message: "Please enter your pension fund.", controller: self) {
                self.pensionTxtField.becomeFirstResponder()
            }
            return
        }
        guard var mutualFundTxt  = mutualFundTxtField.text, !mutualFundTxt.isEmpty else {
            self.showAlert(title: "Alert", message: "Please enter your mutual fund.", controller: self) {
                self.mutualFundTxtField.becomeFirstResponder()
            }
            return
        }
        let ageTxt = selectedAge
        annualIncomeTxt     =   annualIncomeTxt.replacingOccurrences(of: ",", with: "", options: NSString.CompareOptions.literal, range: nil)
        pensionFundTxt      =   pensionFundTxt.replacingOccurrences(of: ",", with: "", options: NSString.CompareOptions.literal, range: nil)
        mutualFundTxt       =   mutualFundTxt.replacingOccurrences(of: ",", with: "", options: NSString.CompareOptions.literal, range: nil)
        
        let bodyParam = RequestBody(Age: String(ageTxt), AnnualIncome: annualIncomeTxt, VPSAmount: pensionFundTxt, FundsAmount: mutualFundTxt)
        let bodyRequest = bodyParam.encryptData(bodyParam)
        let url = URL(string: TAX_CALCULATOR)!
        SVProgressHUD.show()
        WebServiceManager.sharedInstance.fetchObject(params: bodyRequest as Dictionary<String, AnyObject>, url: url, serviceType: "Tax SAving Calculator", modelType: TaxSavingCalculator.self, errorMessage: { (errorMessage) in
            errorResponse = errorMessage
            if let id = errorResponse?[0].errID {
                let message = showErrorMessage(id)
                self.showAlert(title: "Alert", message: message, controller: self) {
                    
                }
            }
        }, success: { (response) in
            self.calculator_model = response
            if self.calculator_model?.calculator?.count ?? 0 > 0 {
                self.mutualFundLbl.text    =   self.calculator_model?.calculator?[0].mFTTaxCredit?.toCurrencyFormat(withFraction: false)
                self.pensionFundLbl.text   =   self.calculator_model?.calculator?[0].vPSTaxCredit?.toCurrencyFormat(withFraction: false)
                if let vpsTaxRate = self.calculator_model?.calculator?[0].vPSTaxRate {
                    self.taxRateLbl.text  =   "\(vpsTaxRate)%"
                }
                UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseIn],
                               animations: {
                                self.resultView.alpha = 1
                                self.resultHeightConstraint.constant = 190
                                
                                self.view.layoutIfNeeded()
                }, completion: nil)
            }
            
        }, fail: { (error) in
            print(error.localizedDescription)
        }, showHUD: true)
        
        
        
        
    }
    
    
    @IBAction func navigateToInvestNow(_ sender: Any) {
        let vc = InvestViewController.instantiateFromAppStroyboard(appStoryboard: .main)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
   
}

extension TaxSavingCalculatorVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        let newLength = textField.text?.count + string.count - range.length
        
        let newLength = textField.text?.count ?? 0

        if textField == annualIncomeTxtField {
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
        } else if textField == mutualFundTxtField {
            switch string {
            case "0","1","2","3","4","5","6","7","8","9":
                mutualFundString += string
                formatCurrency(string: mutualFundString, textField: textField)
            default:
                let array = Array(string)
                var currentStringArray = Array(mutualFundString)
                if array.count == 0 && currentStringArray.count != 0 {
                    currentStringArray.removeLast()
                    mutualFundString = ""
                    for character in currentStringArray {
                        mutualFundString += String(character)
                    }
                    formatCurrency(string: mutualFundString, textField: textField)
                }
            }
        }else if textField == pensionTxtField {
            switch string {
            case "0","1","2","3","4","5","6","7","8","9":
                pensionFundString += string
                formatCurrency(string: pensionFundString, textField: textField)
            default:
                let array = Array(string)
                var currentStringArray = Array(pensionFundString)
                if array.count == 0 && currentStringArray.count != 0 {
                    currentStringArray.removeLast()
                    pensionFundString = ""
                    for character in currentStringArray {
                        pensionFundString += String(character)
                    }
                    formatCurrency(string: pensionFundString, textField: textField)
                }
            }
        }
        
        
        return false
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        switch textField {
        case annualIncomeTxtField:
            annualIncomeTxtField.textColor = UIColor.black
            annualIncomeView.backgroundColor = UIColor.lightGray
            annualIncomeLbl.transform = CGAffineTransform(scaleX: 1.0, y: 1.0).concatenating(CGAffineTransform(translationX: 0, y: 0))
            annualIncomeLbl.textColor = UIColor.themeLblColor
        case mutualFundTxtField:
            mutualFundTxtField.textColor = UIColor.black
            mutualFundView.backgroundColor = UIColor.lightGray
            mutualLbl.transform = CGAffineTransform(scaleX: 1.0, y: 1.0).concatenating(CGAffineTransform(translationX: 0, y: 0))
            mutualLbl.textColor = UIColor.themeLblColor
        case pensionTxtField:
            pensionTxtField.textColor = UIColor.black
            pensionFundView.backgroundColor = UIColor.lightGray
            pensionLbl.transform = CGAffineTransform(scaleX: 1.0, y: 1.0).concatenating(CGAffineTransform(translationX: 0, y: 0))
            pensionLbl.textColor = UIColor.themeLblColor
        
            
        default:
            break
        }
        
        
        currentString = ""
        textField.textColor = UIColor.themeLblColor
        annualIncomeView.backgroundColor = UIColor.themeLblColor
        mutualFundView.backgroundColor = UIColor.themeLblColor
        pensionFundView.backgroundColor = UIColor.themeLblColor
        
        
       
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        switch textField {
        case annualIncomeTxtField:
            annualIncomeTxtField.textColor = UIColor.themeColor
            annualIncomeView.backgroundColor = UIColor.themeColor
            annualIncomeLbl.transform = CGAffineTransform(scaleX: 1.2, y: 1.2).concatenating(CGAffineTransform(translationX: 0, y: -4))
            annualIncomeLbl.textColor = UIColor.themeColor
        case mutualFundTxtField:
            mutualFundTxtField.textColor = UIColor.themeColor
            mutualFundView.backgroundColor = UIColor.themeColor
            mutualLbl.transform = CGAffineTransform(scaleX: 1.2, y: 1.2).concatenating(CGAffineTransform(translationX: 0, y: -4))
            mutualLbl.textColor = UIColor.themeColor
        case pensionTxtField:
            pensionTxtField.textColor = UIColor.themeColor
            pensionFundView.backgroundColor = UIColor.themeColor
            pensionLbl.transform = CGAffineTransform(scaleX: 1.2, y: 1.2).concatenating(CGAffineTransform(translationX: 0, y: -4))
            pensionLbl.textColor = UIColor.themeColor
        
        default:
            break
        }
        
    }
}
extension TaxSavingCalculatorVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return ageArray.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return ageArray[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        ageTxtField.text = ageArray[row]
        selectedAge = ageArrayValue[row]
        selected = row
    }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var title = UILabel()
        if let titleLbl = view {
            title = titleLbl as! UILabel
        }
        title.font = UIFont(name: "Roboto-Regular", size: pickerTitleFontSize)
        title.text =  ageArray[row]
        title.textAlignment = .center
        return title
    }
}

//
//  SignUpViewController.swift
//  AlMeezan
//
//  Created by Atta khan on 04/11/2019.
//  Copyright © 2019 Atta khan. All rights reserved.
//

import UIKit
import DatePickerDialog
import SVProgressHUD
class SignUpViewController: UIViewController {

    
    @IBOutlet weak var customerIdTxtField: UITextField!
    @IBOutlet weak var dobTxtField: UITextField!
    @IBOutlet weak var phoneNoTxtField: UITextField!
    @IBOutlet weak var emailTxtField: UITextField!

    @IBOutlet weak var customerBottomLine: UIView!
    @IBOutlet weak var dobBottomLine: UIView!
    @IBOutlet weak var phoneBottomLine: UIView!
    @IBOutlet weak var emailBottomView: UIView!
    @IBOutlet weak var submitBtn: UIButton!
    
    @IBOutlet weak var countNotificationLbl: UIButton!
    var responseModel: [ErrorResponse]?
    
    var isValidLength : Bool = false
    var isValidMobileLength : Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        phoneNoTxtField.delegate = self
        customerIdTxtField.delegate = self
        countNotificationLbl.isHidden = true
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideNavigationBar()
        Utility.shared.renderNotificationCount(countNotificationLbl)
    }
    
    
    
    @IBAction func tapOnBirthDateBtn(_ sender: UIButton) {
        var currentDate = Date()
        if self.dobTxtField.text  == ""{
            currentDate = Date()
        } else {
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            dateFormatter.timeZone = TimeZone.current
            dateFormatter.locale = Locale.current
            if let selectedDate = self.dobTxtField.text {
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
                                self.dobTxtField.text = dateValue
                            } else {
                                self.dobTxtField.text = ""
                            }
        }
    }
    
    @IBAction func tapOnBackNavigateBtn(_ sender: Any) {
         self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func tapOnNotificationBtn(_ sender: Any) {
        let vc = NotificationsVC.instantiateFromAppStroyboard(appStoryboard: .home)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func tapOnSubmitBtn(_ sender: Any) {
        guard let customerId  = customerIdTxtField.text, !customerId.isEmpty else {
            self.showAlert(title: "Alert", message: "Please enter your customer Id.", controller: self) {
                self.customerIdTxtField.becomeFirstResponder()
            }
            return
        }
        if isValidLength == false{
            self.showAlert(title: "Alert", message: "Please enter minimum 6 digits.", controller: self) {
                self.customerIdTxtField.becomeFirstResponder()
            }
            return
        }
        
        guard let dobTxt  = dobTxtField.text, !dobTxt.isEmpty else {
            self.showAlert(title: "Alert", message: "Please enter your date of birth.", controller: self) {
                self.dobTxtField.becomeFirstResponder()
            }
            return
        }
        
        guard let phoneTxt  = phoneNoTxtField.text, !phoneTxt.isEmpty else {
            self.showAlert(title: "Alert", message: "Please enter your mobile number.", controller: self) {
                self.phoneNoTxtField.becomeFirstResponder()
            }
            return
        }
        
        if isValidMobileLength == false {
            self.showAlert(title: "Alert", message: "Please enter valid mobile number.", controller: self) {
                self.phoneNoTxtField.becomeFirstResponder()
            }
            return
        }
        
        guard let emailTxt  = emailTxtField.text, !emailTxt.isEmpty else {
            self.showAlert(title: "Alert", message: "Please enter your email.", controller: self) {
                self.emailTxtField.becomeFirstResponder()
            }
            return
        }
        if isValidEmailAddress(emailTxt) == false {
            self.showAlert(title: "Alert", message: "Please enter valid email address", controller: self) {
                self.emailTxtField.becomeFirstResponder()
            }
            return
        }
        
        let dobDate = dobTxt.toDate(withFormat: "dd/MM/yyyy")?.toString(format: "yyyyMMdd") ?? ""

        
//        var bodyRequest  =    [ : ] as [String : Any]
//        let paramStr = "{CustomerID':\(customerId),Mobile':\(phoneTxt),Email':\(emailTxt),DOB': \(dobDate)}"
//        bodyRequest = ["KeyValue": "\(paramStr)"]
        
        let bodyParam = RequestBody(CustomerID: customerId, Mobile: phoneTxt, Email: emailTxt, DOB: dobDate)
        let bodyRequest = bodyParam.encryptData(bodyParam)
        
        let url = URL(string: REQUEST_LOGIN)!
        //SVProgressHUD.show()
        WebServiceManager.sharedInstance.fetch(params: bodyRequest as Dictionary<String, AnyObject>, url: url, serviceType: "SIGN UP", modelType: ErrorResponse.self, errorMessage: { (errorMessage) in
            errorResponse = errorMessage
            self.showErrorMsg(errorMessage)
        }, success: { (response) in
            self.responseModel = response

        }, fail: { (error) in
            print(error.localizedDescription)
        }, showHUD: true)
        
        
        
    }
}
extension SignUpViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == phoneNoTxtField {
            let currentCharacterCount = textField.text?.count ?? 0
            let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            print(newString.count)

//            if newString.count <= 1 {
//                return false
//            }
            if range.length + range.location > currentCharacterCount {
                return false
            }
            let newLength = currentCharacterCount + string.count - range.length
            return newLength <= 15
        }
        
        
        return true
    }
    
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField == phoneNoTxtField {
            let fieldTextLength = textField.text!.count
            if  fieldTextLength > 7 && fieldTextLength < 15 {
                isValidMobileLength = true
            } else {
                isValidMobileLength = false
            }
           
            return true
        }
        if textField == customerIdTxtField {
            let fieldTextLength = textField.text!.count
            if  fieldTextLength > 5 {
                isValidLength = true
            } else {
                isValidLength = false
            }
           
            return true
        }
        return true
    }
}

//
//  ForgotPasswordVC.swift
//  AlMeezan
//
//  Created by Atta khan on 26/11/2019.
//  Copyright © 2019 Atta khan. All rights reserved.
//

import UIKit
import SVProgressHUD

class ForgotPasswordVC: UIViewController {
    @IBOutlet weak var customerIdTxtField: UITextField!
    @IBOutlet weak var dobTxtField: UITextField!
    @IBOutlet weak var phoneNoTxtField: UITextField!
    @IBOutlet weak var emailTxtField: UITextField!

    @IBOutlet weak var customerBottomLine: UIView!
    @IBOutlet weak var dobBottomLine: UIView!
    @IBOutlet weak var phoneBottomLine: UIView!
    @IBOutlet weak var emailBottomView: UIView!
    
    @IBOutlet weak var countNotificationLbl: UIButton!
    @IBOutlet weak var submitBtn: UIButton!
    var responseModel: [ErrorResponse]?
    var isValidLength : Bool = false
    var isValidMobileLength : Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        phoneNoTxtField.delegate = self
        customerIdTxtField.delegate = self
         countNotificationLbl.isHidden = true
        Utility.shared.renderNotificationCount(countNotificationLbl)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideNavigationBar()
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
           self.showAlert(title: "Alert", message: "Please enter valid customer id.", controller: self) {
               self.customerIdTxtField.becomeFirstResponder()
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
        let bodyParam = RequestBody(CustomerID: customerId, Mobile:phoneTxt,Email: emailTxt)
        let bodyRequest = bodyParam.encryptData(bodyParam)
        
        let url = URL(string: FORGOT_PASSWORD)!
        SVProgressHUD.show()
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
extension ForgotPasswordVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == phoneNoTxtField {
            let currentCharacterCount = textField.text?.count ?? 0
            let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
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

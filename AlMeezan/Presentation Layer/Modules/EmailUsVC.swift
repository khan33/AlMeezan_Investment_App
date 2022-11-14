//
//  EmailUsVC.swift
//  AlMeezan
//
//  Created by Atta khan on 24/09/2019.
//  Copyright © 2019 Atta khan. All rights reserved.
//

import UIKit
import SVProgressHUD

class EmailUsVC: UIViewController {

    @IBOutlet weak var nameTxtField: UITextField!
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var subjectView: UIView!
    @IBOutlet weak var subjectTxtField: UITextField!
    @IBOutlet weak var detailsTxtView: UITextView!
    @IBOutlet weak var detailsView: UIView!
    @IBOutlet weak var totalTxtCount: UILabel!
    @IBOutlet weak var phoneFormateLbl: UILabel!
    @IBOutlet weak var phoneTxtField: UITextField!
    @IBOutlet weak var phoneView: UIView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var detailsLbl: UILabel!
    @IBOutlet weak var subjectLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    
    var isValidMobileLength : Bool = false
    @IBOutlet weak var scrollView: UIScrollView!
    
    var responseModel: [ContactUs]?
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTxtField.delegate       = self
        emailTxtField.delegate      = self
        subjectTxtField.delegate    = self
        detailsTxtView.delegate     = self
        phoneTxtField.delegate      = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideNavigationBar()
    }
    
    @IBAction func tapOnSubmitBtn(_ sender: UIButton) {
        guard let nameTxt  = nameTxtField.text, !nameTxt.isEmpty else {
            self.showAlert(title: "Alert", message: "Please enter your name.", controller: self) {
                self.nameTxtField.becomeFirstResponder()
            }
            return
        }
        guard let emailTxt  = emailTxtField.text, !emailTxt.isEmpty else {
            self.showAlert(title: "Alert", message: "Please enter your email.", controller: self) {
                self.emailTxtField.becomeFirstResponder()
            }
            return
        }
        if emailTxt.isValidEmail == false {
            self.showAlert(title: "Alert", message: "Please enter valid email address", controller: self) {
                self.emailTxtField.becomeFirstResponder()
            }
            return
        }
        guard let phoneTxt  = phoneTxtField.text, !phoneTxt.isEmpty else {
            self.showAlert(title: "Alert", message: "Please enter your phone number.", controller: self) {
                self.phoneTxtField.becomeFirstResponder()
            }
            return
        }
        if isValidMobileLength == false {
            self.showAlert(title: "Alert", message: "Please enter valid mobile number.", controller: self) {
                self.phoneTxtField.becomeFirstResponder()
            }
            return
        }
        
        guard let subjectTxt  = subjectTxtField.text, !subjectTxt.isEmpty else {
            self.showAlert(title: "Alert", message: "Please enter subject.", controller: self) {
                self.subjectTxtField.becomeFirstResponder()
            }
            return
        }
        guard let detailTxt  = detailsTxtView.text, !detailTxt.isEmpty else {
            self.showAlert(title: "Alert", message: "Please enter details.", controller: self) {
                self.detailsTxtView.becomeFirstResponder()
            }
            return
        }
        
        let bodyParam = RequestBody(Name:nameTxt, EmailID: emailTxt, MobileNo: phoneTxt, Subject: subjectTxt)
        let bodyRequest = bodyParam.encryptMsgData(bodyParam, detailTxt)
        let url = URL(string: CONTACT_US)!
        SVProgressHUD.show()
        WebServiceManager.sharedInstance.fetch(params: bodyRequest as Dictionary<String, AnyObject>, url: url, serviceType: "Send Email", modelType: ContactUs.self, errorMessage: { (errorMessage) in
            errorResponse = errorMessage
            self.showErrorMsg(errorMessage)
        }, success: { (response) in
            self.responseModel = response
            self.showAlert(title: "Alert", message: "Your email has been received by info@almeezangroup.com. \n Our customer service teams will soon be in touch with you.", controller: self) {
                self.nameTxtField.text  = ""
                self.emailTxtField.text = ""
                self.subjectTxtField.text = ""
                self.detailsTxtView.text = ""
                self.phoneTxtField.text = ""
                self.totalTxtCount.text = "(0 / 500)"
                self.detailsTxtView.resignFirstResponder()
                self.phoneTxtField.resignFirstResponder()
            }
        }, fail: { (error) in
            print(error.localizedDescription)
        }, showHUD: true)
        
    }
    
    @IBAction func tabOnCallUsBtn(_ sender: Any) {
        
        Utility.shared.phoneCall()
        
    }
    
    
}
extension EmailUsVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameView.backgroundColor = UIColor.themeColor
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == phoneTxtField {
            if range.location == 0 && string == " " { // prevent space on first character
                return false
            }
            let currentCharacterCount = textField.text?.count ?? 0
            //let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            if range.length + range.location > currentCharacterCount {
                return false
            }
            let newLength = currentCharacterCount + string.count - range.length
            return newLength <= 12
        }
        if textField == nameTxtField {
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
            return true
        }
        if textField == subjectTxtField || textField == emailTxtField {
            if range.location == 0 && string == " " { // prevent space on first character
                return false
            }
        }
        return true
    }
   
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case nameTxtField:
            //nameTxtField.textColor = UIColor.themeColor
            nameView.backgroundColor = UIColor.themeColor
            nameLbl.transform = CGAffineTransform(scaleX: 1.2, y: 1.2).concatenating(CGAffineTransform(translationX: 0, y: -4))
            nameLbl.textColor = UIColor.themeColor
        case emailTxtField:
            emailView.backgroundColor = UIColor.themeColor
            emailLbl.transform = CGAffineTransform(scaleX: 1.2, y: 1.2).concatenating(CGAffineTransform(translationX: 0, y: -4))
            emailLbl.textColor = UIColor.themeColor
        case phoneTxtField:
            phoneView.backgroundColor = UIColor.themeColor
            phoneFormateLbl.transform = CGAffineTransform(scaleX: 1.2, y: 1.2).concatenating(CGAffineTransform(translationX: 0, y: -4))
            phoneFormateLbl.textColor = UIColor.themeColor
        case subjectTxtField:
            subjectView.backgroundColor = UIColor.themeColor
            subjectLbl.transform = CGAffineTransform(scaleX: 1.2, y: 1.2).concatenating(CGAffineTransform(translationX: 0, y: -4))
            subjectLbl.textColor = UIColor.themeColor
        default:
            break
        }
        
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case nameTxtField:
            nameView.backgroundColor = UIColor.lightGray
            nameLbl.transform = CGAffineTransform(scaleX: 1.0, y: 1.0).concatenating(CGAffineTransform(translationX: 0, y: 0))
            nameLbl.textColor = UIColor.themeLblColor
        case emailTxtField:
            emailView.backgroundColor = UIColor.lightGray
            emailLbl.transform = CGAffineTransform(scaleX: 1.0, y: 1.0).concatenating(CGAffineTransform(translationX: 0, y: 0))
            emailLbl.textColor = UIColor.themeLblColor
        case phoneTxtField:
            phoneView.backgroundColor = UIColor.lightGray
            phoneFormateLbl.transform = CGAffineTransform(scaleX: 1.0, y: 1.0).concatenating(CGAffineTransform(translationX: 0, y: 0))
            phoneFormateLbl.textColor = UIColor.themeLblColor
        case subjectTxtField:
            subjectView.backgroundColor = UIColor.lightGray
            subjectLbl.transform = CGAffineTransform(scaleX: 1.0, y: 1.0).concatenating(CGAffineTransform(translationX: 0, y: 0))
            subjectLbl.textColor = UIColor.themeLblColor
        default:
            break
        }
    }
}
extension EmailUsVC: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if range.location == 0 && text == " " {
            return false
        }
        let newLength = textView.text.count + text.count - range.length
        totalTxtCount.text =  "(\(newLength) / 500)"
        if newLength > 500 {
            totalTxtCount.textColor = UIColor.red
        } else {
            totalTxtCount.textColor = UIColor.black
        }
        return newLength <= 499
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        detailsView.backgroundColor = UIColor.themeColor
        detailsLbl.transform = CGAffineTransform(scaleX: 1.2, y: 1.2).concatenating(CGAffineTransform(translationX: 0, y: -4))
        detailsLbl.textColor = UIColor.themeColor
       	
        let point = CGPoint(x: 0, y: textView.frame.size.height + 80)
        scrollView.setContentOffset(point, animated: true)
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        detailsView.backgroundColor = UIColor.lightGray
        detailsLbl.transform = CGAffineTransform(scaleX: 1.0, y: 1.0).concatenating(CGAffineTransform(translationX: 0, y: 0))
        detailsLbl.textColor = UIColor.themeLblColor
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField == phoneTxtField {
            let fieldTextLength = textField.text!.count
            if  fieldTextLength > 11 {
                isValidMobileLength = true
            } else {
                isValidMobileLength = false
            }
            return true
        }
        return true
    }
}

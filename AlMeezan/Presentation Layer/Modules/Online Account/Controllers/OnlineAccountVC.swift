//
//  OnlineAccountVC.swift
//  AlMeezan
//
//  Created by Atta khan on 20/10/2020.
//  Copyright © 2020 Atta khan. All rights reserved.
//

import UIKit
import SVProgressHUD
import FirebaseAnalytics
import SwiftKeychainWrapper

class OnlineAccountVC: UIViewController {

    @IBOutlet weak var CircularProgress: CircularProgressView!
    @IBOutlet weak var CNICTextField: UITextField!
    @IBOutlet weak var mobileNoTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var progressBarTitleLbl: UILabel!
    
    
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var blurView: UIView!
    @IBOutlet weak var descLbl: UILabel!
    
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var previousBtn: UIButton!
    private let validation: ValidationService
    
    init(validation: ValidationService) {
        self.validation = validation
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.validation = ValidationService()
        super.init(coder: coder)
    }
    
    var name: String?
    var fName: String?
    var occupation: String?
    var income: String?
    var otherSource: String?
    var cnicIssue: String?
    var cnicExpire: String?
    var age: String?
    var gender: String?
    var dob: String?
    var cnicValid: Bool = false
    var otp_response_data: [OTPModel]?
    override func viewDidLoad() {
        super.viewDidLoad()
        descLbl.text = "\u{2022} Basic investment account with the option to invest in Income and Money Market Funds Only. \n\u{2022} Maximum Investment Amount: \nRs. 100,000 at any point. \n\u{2022} Single investment amount should not exceed Rs. 25,000"
        progressBarTitleLbl.text = "1 of 6"
        // Do any additional setup after loading the view.
        CircularProgress.trackColor = UIColor.progressBarinActiveColor
        CircularProgress.progressColor = UIColor.progressBarActiveColor
        CircularProgress.setProgressWithAnimation(duration: 1.0, value: 1/6)
        previousBtn.isHidden = true
        CNICTextField.delegate = self
        mobileNoTextField.delegate = self
        emailTextField.keyboardType = .emailAddress
        CNICTextField.keyboardType = .asciiCapableNumberPad
        mobileNoTextField.keyboardType = .asciiCapableNumberPad
        
        Utility.shared.getUserdefaultValues(OnlineOperationStatus.user.rawValue, modelType: UserDetails.self) { (result) in
            let response = result
            if let cnic = response.CNIC {
                self.CNICTextField.text = cnic
            }
            if let email = response.email {
                self.emailTextField.text = email
            }
            if let mobileNo = response.mobileNO {
                self.mobileNoTextField.text = mobileNo
            }
            self.name = response.name
            self.fName = response.fName
            self.dob = response.dob
            self.age = response.age
            self.gender = response.gender
            self.income = response.income
            self.occupation = response.occupation
            self.otherSource = response.otherSource
            self.cnicValid = response.cnicValid
            self.cnicIssue  = response.cnicIssue
            self.cnicExpire = response.cnicExpire
            self.cnicValid = response.cnicValid
        }
            
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Utility.shared.googleAnalyticsEvent(OnlineAccountEnums.STEP_ONE.index, OnlineAccountEnums.STEP_ONE.value, OnlineAccountEnums.STEP_ONE.screenName, String(describing: type(of: self)))
    }
    
    @IBAction func didTapNextButton(_ sender: Any) {
//        let vc = OTPViewController1.instantiateFromAppStroyboard(appStoryboard: .onlineAccount)
//        self.navigationController?.pushViewController(vc, animated: true)
        print(emailTextField.text)
        
        do {
            let cnic        = try validation.validateCNIC(CNICTextField.text)
            let mobile      =   try validation.validateMobileNo(mobileNoTextField.text)
            let email       =   try validation.validateAccountNo(emailTextField.text)
            let user    =   UserDetails(CNIC: cnic, email: email, mobileNO: mobile, name: name, fName: fName, occupation: occupation, income: income, otherSource: otherSource, cnicIssue: cnicIssue, cnicExpire: cnicExpire, age: age, gender: gender, dob: dob, cnicValid: cnicValid)
            let encoder = JSONEncoder()
            if let encodedUser = try? encoder.encode(user) {
                defaults.set(encodedUser, forKey: OnlineOperationStatus.user.rawValue)
            }
            defaults.setValue(cnic, forKey: "CNIC_Id")
            generateOTP(cnic, mobile, email)
            
        } catch {
            print(error)
            self.showAlert(title: "Alert", message: error.localizedDescription, controller: self) {
            }
        }
    }
    
    @IBAction func didTapBackButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didTapOnAcknowledgedBtn(_ sender: Any) {
        blurView.isHidden = true
        popupView.isHidden = true
    }
    private func generateOTP(_ cnic: String, _ mobile: String, _ email: String) {
        
        
        let bodyParam = RequestBody(CNIC: cnic, Mobile: mobile, Email: email)
        let bodyRequest = bodyParam.encryptData(bodyParam)
        let url = URL(string: OTP_SEND)!
        SVProgressHUD.show()
        WebServiceManager.sharedInstance.fetch(params: bodyRequest as Dictionary<String, AnyObject>, url: url, serviceType: "OTP Send", modelType: OTPModel.self, errorMessage: { (errorMessage) in
            errorResponse = errorMessage
            if errorResponse?[0].errID != "00" {
                self.showErrorMsg(errorMessage)
            }
        }, success: { (response) in
            self.otp_response_data = response
            if let sMSPin = self.otp_response_data?[0].sMSPin, let emailPin = self.otp_response_data?[0].emailPin {
                KeychainWrapper.standard.set(sMSPin, forKey: "sMSPin")
                KeychainWrapper.standard.set(emailPin, forKey: "emailPin")
                self.showAlert(title: "Alert", message: "OTP is sent to Your Email & Mobile Number.", controller: self) {
                    let vc = OTPViewController1.instantiateFromAppStroyboard(appStoryboard: .onlineAccount)
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
            
            
        }, fail: { (error) in
            print(error.localizedDescription)
            self.showAlert(title: "Alert", message: "The Internet connection appears to be offline.", controller: self) {
            }
            
        }, showHUD: true)
    }
    
}


extension OnlineAccountVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if range.location == 0 && string == " " { // prevent space on first character
            return false
        }
        if textField.text?.last == " " && string == " " { // allowed only single space
            return false
        }
        if string == " " { return true } // now allowing space between name
//        if string.rangeOfCharacter(from: CharacterSet.letters.inverted) != nil {
//            return false
//        }
        let currentCharacterCount = textField.text?.count ?? 0
        //let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        if range.length + range.location > currentCharacterCount {
            return false
        }
        let newLength = currentCharacterCount + string.count - range.length
        if textField == CNICTextField {
            return newLength <= 13
        } else if textField == mobileNoTextField {
            return newLength < 16
        }
        return true
    }
}

struct UserDetails: Codable {
    let CNIC: String?
    let email: String?
    let mobileNO: String?
    let name : String?
    let fName: String?
    let occupation: String?
    let income: String?
    let otherSource: String?
    let cnicIssue: String?
    let cnicExpire: String?
    let age: String?
    let gender: String?
    let dob: String?
    var cnicValid: Bool = false
}
struct BankDelatils: Codable {
    let bankName: String?
    let bankID: String?
    let branchName: String?
    let bankTitle: String?
    let accountNo: String?
    let address1: String?
    let address2: String?
    let country: String?
    let country_short_code: String?
    let city: String?
    let cityCode: String?
}



enum OnlineOperationStatus: String {
    case user = "user"
    case bank = "bank"
}

extension CaseIterable where Self: Equatable {

    var index: Self.AllCases.Index? {
        return Self.allCases.firstIndex { self == $0 }
    }
}

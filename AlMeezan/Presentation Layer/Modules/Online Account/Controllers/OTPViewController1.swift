//
//  OTPViewController.swift
//  AlMeezan
//
//  Created by Atta khan on 02/11/2020.
//  Copyright © 2020 Atta khan. All rights reserved.
//

import UIKit
import SVProgressHUD
import SwiftKeychainWrapper
import FirebaseAnalytics
class OTPViewController1: UIViewController {

    @IBOutlet weak var CircularProgress: CircularProgressView!
    @IBOutlet weak var emilOTPTextField: UITextField!
    @IBOutlet weak var mobileNoOTPTextField: UITextField!
    @IBOutlet weak var generateOTPBtn: UIButton!
    @IBOutlet weak var resendBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var previousBtn: UIButton!
    @IBOutlet weak var expireOTPLbl: UILabel!
    @IBOutlet weak var timerWatch: UIImageView!
    @IBOutlet weak var timerLbl: UILabel!
    @IBOutlet weak var progressBarTitleLbl: UILabel!
    @IBOutlet weak var topConstraintlayout: NSLayoutConstraint!
    
    // timer
    var timer : Timer!
    var totalSecondsCountDown = counter
    
    private let validation: ValidationService
    private var cnic: String?
    private var mobile: String?
    private var email: String?
    var otp_response_data: [OTPModel]?
    var verify_response_data: OTPVerificationModel?
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
        progressBarTitleLbl.text = "2 of 6"
        CircularProgress.trackColor = UIColor.progressBarinActiveColor
        CircularProgress.progressColor = UIColor.progressBarActiveColor
        CircularProgress.setProgressWithAnimation(duration: 1.0, value: 2 * 1/6)
        self.generateOTPBtn.isHidden = true
        self.expireOTPLbl.isHidden = true
        self.timerWatch.isHidden = true
        self.timerLbl.isHidden = true
        resendBtn.isUserInteractionEnabled = false
        
        Utility.shared.getUserdefaultValues(OnlineOperationStatus.user.rawValue, modelType: UserDetails.self) { (result) in
            let response = result
            self.cnic = response.CNIC
            self.email = response.email
            self.mobile = response.mobileNO
        }
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Utility.shared.googleAnalyticsEvent(OnlineAccountEnums.STEP_TWO.index, OnlineAccountEnums.STEP_TWO.value, OnlineAccountEnums.STEP_TWO.screenName, String(describing: type(of: self)))
        self.generateOTPBtn.isHidden = true
        self.expireOTPLbl.isHidden = false
        self.timerWatch.isHidden = false
        self.timerLbl.isHidden = false
        self.topConstraintlayout.constant = 16.0
        self.startCountDownTimer()
        //generateOTP()
    }
    func startCountDownTimer() {
        if self.timer != nil {
            self.timer.invalidate()
            self.timer = nil
        }
        if self.totalSecondsCountDown > 0 {
            self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
            RunLoop.current.add(self.timer, forMode: RunLoop.Mode.common)
            self.timer.fire()
        }

    }
    func stopCountDownTimer() {
        if self.timer != nil {
            resendBtn.isUserInteractionEnabled = true
            self.timer.invalidate()
            self.timer = nil
        }
    }
    
    @objc func updateTimer() {
        if self.totalSecondsCountDown > 0 {
            self.totalSecondsCountDown = self.totalSecondsCountDown - 1
            let minutes = (totalSecondsCountDown % 3600) / 60
            let seconds = (totalSecondsCountDown % 3600) % 60
            timerLbl.text = String(format: "%02d:%02d", minutes, seconds)
        }
        else {
            self.stopCountDownTimer();
            emilOTPTextField.isUserInteractionEnabled       =   false
            mobileNoOTPTextField.isUserInteractionEnabled   =   false
        }
    }
    
    
    private func generateOTP() {
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
                    self.generateOTPBtn.isHidden = true
                    self.expireOTPLbl.isHidden = false
                    self.timerWatch.isHidden = false
                    self.timerLbl.isHidden = false
                    self.topConstraintlayout.constant = 16.0
                    self.startCountDownTimer()
                }
            }
            
            
        }, fail: { (error) in
            print(error.localizedDescription)
            self.showAlert(title: "Alert", message: "The Internet connection appears to be offline.", controller: self) {
            }
            
        }, showHUD: true)
    }
    @IBAction func didTapGenerateOTPButton(_ sender: Any) {
        //generateOTP()
    }
    @IBAction func didTapResendOTPButton(_ sender: Any) {
        emilOTPTextField.isUserInteractionEnabled       =   true
        mobileNoOTPTextField.isUserInteractionEnabled   =   true
        totalSecondsCountDown = counter
        generateOTP()
    }
    
    @IBAction func didTapNextButton(_ sender: Any) {
        let vc = PersonalDetailsVC.instantiateFromAppStroyboard(appStoryboard: .onlineAccount)
        self.navigationController?.pushViewController(vc, animated: true)
//        do {
//            let emailOTP        = try validation.validateEmailOTPTxtFields(emilOTPTextField.text)
//            let mobileOTP       =   try validation.validateMobileOTPTxtFields(mobileNoOTPTextField.text)
//            let bodyParam = RequestBody(CNIC: cnic, SMSPin: mobileOTP, EmailPin: emailOTP)
//            let bodyRequest = bodyParam.encryptData(bodyParam)
//            let url = URL(string: VERIFY_OTP)!
//            SVProgressHUD.show()
//            WebServiceManager.sharedInstance.fetchObject(params: bodyRequest as Dictionary<String, AnyObject>, url: url, serviceType: "Verify OTP", modelType: OTPVerificationModel.self, errorMessage: { (errorMessage) in
//                errorResponse = errorMessage
//                self.showErrorMsg(errorMessage)
//            }, success: { (response) in
//                self.verify_response_data = response
//
//                KeychainWrapper.standard.removeObject(forKey: "sMSPin")
//                KeychainWrapper.standard.removeObject(forKey: "emailPin")
//
////                self.emilOTPTextField.text = ""
////                self.mobileNoOTPTextField.text = ""
//
//                if self.verify_response_data?.cNICData?.count == 1 {
//                    let data = self.verify_response_data?.cNICData?[0]
//                    let dob = data?.dob?.toDate(withFormat: "yyyy-MM-dd")?.toString(format: "dd/MM/yyyy")
//                    let cnicIssue = data?.cnicIssueDate?.toDate(withFormat: "yyyy-MM-dd'T'HH:mm:ss")?.toString(format: "dd/MM/yyyy")
//                    var cnicExpireDate = ""
//                    var isCnicValid: Bool = false
//                    if let expireDate = data?.cnicExpiryDate {
//                        cnicExpireDate = expireDate.toDate(withFormat: "yyyy-MM-dd'T'HH:mm:ss")?.toString(format: "dd/MM/yyyy") ?? ""
//                    } else {
//                        isCnicValid = true
//                    }
//
//
//                    let user    =   UserDetails(CNIC: data?.cNIC, email: data?.email, mobileNO: data?.mobile, name: data?.fullName, fName: data?.fullName, occupation: data?.occupation, income: data?.sourceofFund, otherSource: "", cnicIssue: cnicIssue, cnicExpire: cnicExpireDate, age: data?.age, gender: data?.gender, dob: dob, cnicValid : isCnicValid)
//
//                    Utility.shared.saveUserObject(user)
//
//                    let address1 = data?.address
//                    //var address1 = ""
//                    var address2 = ""
////                    if address?.count ?? 0 > 35 {
////                        let components = address?.components(withLength: 35)
////                        address1 = components?[0] ?? ""
////                        address2 = components?[1] ?? ""
////
////                    } else {
////                        address1 = address ?? ""
////                    }
//                    let bank = BankDelatils(bankName: data?.bankName, bankID: data?.bankName, branchName: data?.bankBranch, bankTitle: "", accountNo: data?.bankAccNo, address1: address1, address2: address2, country: data?.country, country_short_code: data?.country, city: data?.city, cityCode: data?.city)
//
//                    let encoder = JSONEncoder()
//                    if let encodedUser = try? encoder.encode(bank) {
//                        defaults.set(encodedUser, forKey: OnlineOperationStatus.bank.rawValue)
//                    }
//
//
//
//                }
////                else {
////                    self.showAlert(title: "Alert", message: "An account is already registered against this CNIC. For more details contact 0800-42525 (HALAL).", controller: self) {
////                        let vc = LoginViewController.instantiateFromAppStroyboard(appStoryboard: .home)
////                        self.navigationController?.pushViewController(vc, animated: false)
////                    }
////                }
//
//                let vc = PersonalDetailsVC.instantiateFromAppStroyboard(appStoryboard: .onlineAccount)
//                self.navigationController?.pushViewController(vc, animated: true)
//
//
//            }, fail: { (error) in
//                print(error.localizedDescription)
//                self.showAlert(title: "Alert", message: "The Internet connection appears to be offline.", controller: self) {
//                }
//
//            }, showHUD: true)
//
//        } catch {
//            print(error)
//            self.showAlert(title: "Alert", message: error.localizedDescription, controller: self) {
//            }
//        }
        
        
    }
    @IBAction func didTapPreviousButton(_ sender: Any) {
        KeychainWrapper.standard.removeObject(forKey: "sMSPin")
        KeychainWrapper.standard.removeObject(forKey: "emailPin")
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didTapBackButton(_ sender: Any) {
        KeychainWrapper.standard.removeObject(forKey: "sMSPin")
        KeychainWrapper.standard.removeObject(forKey: "emailPin")
        self.navigationController?.popViewController(animated: true)
    }

}

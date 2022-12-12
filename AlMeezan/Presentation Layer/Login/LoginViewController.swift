//
//  LoginViewController.swift
//  AlMeezan
//
//  Created by Atta khan on 30/10/2019.
//  Copyright © 2019 Atta khan. All rights reserved.
//

import UIKit
import SVProgressHUD
import SwiftKeychainWrapper
import FirebaseCrashlytics
import LocalAuthentication


extension LoginViewController: LoginPresenterOutput {
    
    func successfulLogin(viewModel: [LoginEntity.LoginViewModel]) {
        DispatchQueue.main.async {
            SVProgressHUD.dismiss()
            
            self.router?.routeToDashboard()
        }
    }
    
    func presenter(didFailValidation message: String) {
        DispatchQueue.main.async {
            SVProgressHUD.dismiss()
            self.showAlert(title: "Alert", message: message, controller: self) {
            }
        }
    }
    
}
class LoginViewController: UIViewController {
    @IBOutlet weak var customerIdTxtField: UITextField!
    @IBOutlet weak var cust_bottom_line: UIView!
    @IBOutlet weak var passwordTxtField: UITextField!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var joinNowBtn: UIButton!
    @IBOutlet weak var FaqsBtn: UIButton!
    @IBOutlet weak var forogotPasswordBtn: UIButton!
    @IBOutlet weak var termsBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var circleTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var lockBtn: UIButton!
    @IBOutlet weak var lockLbl: UILabel!
    
    let context = LAContext()
    var error: NSError?
    
    var responseModel: [LoginEntity.LoginResponseModel]?
    var isComingState: Bool = false
    var isTransition: Bool = false
    let isBiometricLogin = UserDefaults.standard.bool(forKey: "isBiometricLogin")
    private var loginViewModel = LoginViewModel()
    
    var interactor: LoginInteractorProtocol?
    var router: LoginRouterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        router?.navigationController = navigationController
        interactor?.viewDidLoad()
        
        customerIdTxtField.text = "130734"
        passwordTxtField.text = "Today999"

        
        // 100132
        // 176399
        // 186506
        // 138374
        
        updatePlaceHolder()
        checkBiometricStatus()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideNavigationBar()
        NotificationCenter.default.addObserver(self, selector: #selector(checkBiometricStatus), name: .checkBiometricStatus, object: nil)
        let isBiometricLogin = UserDefaults.standard.bool(forKey: "isBiometricLogin")
        autoBiometricLogin(isBiometricLogin)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Utility.shared.googleAnalyticsEvent(HomeScreenEnums.INVESTOR_LOGIN.index, HomeScreenEnums.INVESTOR_LOGIN.value, HomeScreenEnums.INVESTOR_LOGIN.screenName, String(describing: type(of: self)))
    }
    override func viewWillDisappear(_ animated: Bool) {
        isComingState = false
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .checkBiometricStatus, object: nil)
    }
    
    func updatePlaceHolder() {
        customerIdTxtField.attributedPlaceholder = NSAttributedString(string: "Enter Customer ID",
                                                                      attributes: [NSAttributedString.Key.foregroundColor: UIColor.placeHolderColor])
        passwordTxtField.attributedPlaceholder = NSAttributedString(string: "Enter Password",
        attributes: [NSAttributedString.Key.foregroundColor: UIColor.placeHolderColor])
    }
    
    @objc func checkBiometricStatus() {
        let isBiometricLogin = UserDefaults.standard.bool(forKey: "isBiometricLogin")
        switch loginViewModel.biometricType {
        case .faceID:
            lockBtn.isHidden = false
            
            if let image = UIImage(named: "faceIcon") {
                lockBtn.setImage(image, for: .normal)
            }
            
            if isBiometricLogin {
                lockLbl.text = "Face ID"
            } else {
                lockLbl.text = "Enable Face Login"
            }
            
        case .touchID:
            lockBtn.isHidden = false
            if let image = UIImage(named: "fingerprintIcon") {
                lockBtn.setImage(image, for: .normal)
            }
            lockLbl.text = "Login with Touch ID"
//            if isBiometricLogin {
//                lockLbl.text = "Login with Touch ID"
//            } else {
//                lockLbl.text = "Enable Finger Print Login"
//            }
            
        default:
            lockBtn.isHidden = true
            lockLbl.text = ""
        }
    }
    
    func autoBiometricLogin(_ isLogin: Bool = false) {
        if isLogin {
            loginViewModel.biometricAuth { (success) in
                let passTxt     =   KeychainWrapper.standard.string(forKey: "BioMetricAccessToken") ?? ""
                let customerId  =   KeychainWrapper.standard.string(forKey: "BioMetricCustomerId") ?? ""
                var loginType   =   LoginType.manual.rawValue
                switch self.loginViewModel.biometricType {
                case .faceID:
                    loginType = LoginType.faceId.rawValue; break
                case .touchID:
                    loginType = LoginType.touchId.rawValue; break
                default:
                    break
                }
                
                self.userAuth(customerId, passTxt, loginType )
                
            } fail: { (error) in
                print(error.localizedDescription)
               
                
            }
        }
    }
    
    @IBAction func didTapOnBiometricBtn(_ sender: Any) {
        
        let isBiometricLogin = UserDefaults.standard.bool(forKey: "isBiometricLogin")
        
        if isBiometricLogin {
            autoBiometricLogin(isBiometricLogin)
        } else {
            let vc = BioAuthViewController.instantiateFromAppStroyboard(appStoryboard: .home)
            navigationController?.pushViewController(vc, animated: false)
        }
    }
    
    
    
    
    
    @IBAction func tapOnJoinNowBtn(_ sender: Any) {
        let vc = SignUpViewController.instantiateFromAppStroyboard(appStoryboard: .home)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func tapOnFAQBtn(_ sender: Any) {
        let vc = BlogsViewController.instantiateFromAppStroyboard(appStoryboard: .main)
        vc.urlStr = FAQS
        vc.titleStr = "FAQ's"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func tapOnForgotPassBtn(_ sender: Any) {
        let vc = ForgotPasswordVC.instantiateFromAppStroyboard(appStoryboard: .home)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func tapOnTermsBtn(_ sender: Any) {
        let vc = BlogsViewController.instantiateFromAppStroyboard(appStoryboard: .main)
        vc.urlStr = TERMS_CONDITIONS
        vc.titleStr = "Terms & Conditions"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func userAuth( _ customerId: String, _ passwordTxt: String, _ loginType: String) {
        
        let device_id = UserDefaults.standard.string(forKey: "device_id") ?? "fdsjfkdsflsdfceeasewese"
        var guest_key = ""
        if let key = UserDefaults.standard.string(forKey: "guestkey") {
            guest_key = key
        }
        let bodyParam = RequestBody(CustomerID: customerId, Password: passwordTxt, DeviceID: device_id, GuestID: guest_key, LoginType: loginType)
        let bodyRequest = bodyParam.encryptData(bodyParam)
        
        
        let url = URL(string: CUSTOMER_LOGIN)!
        SVProgressHUD.show()
        WebServiceManager.sharedInstance.fetch(params: bodyRequest as Dictionary<String, AnyObject>, url: url, serviceType: "Login", modelType: LoginEntity.LoginResponseModel.self, errorMessage: { (errorMessage) in
            errorResponse = errorMessage
            self.showErrorMsg(errorMessage)
        }, success: { (response) in
            self.responseModel = response
            if let customer_id = self.responseModel?[0].customerid {
                //UserDefaults.standard.set(customer_id, forKey: "CustomerId")
                KeychainWrapper.standard.set(customer_id, forKey: "CustomerId")
                Crashlytics.crashlytics().setUserID(customer_id)
            }
            if let token = self.responseModel?[0].tokenID {
//                UserDefaults.standard.set(token, forKey: "AccessToken")
//                UserDefaults.standard.set("loggedInUser", forKey: "UserType")
                print("logged In user token is = ", token)
                
                KeychainWrapper.standard.set(token, forKey: "AccessToken")
                KeychainWrapper.standard.set("loggedInUser", forKey: "UserType")
                
                if let isNPSShow = self.responseModel?[0].IsNPSShow {
                    UserDefaults.standard.set(isNPSShow, forKey: "isSurveyShow")
                }
                
                UserDefaults.standard.set(false, forKey: "isCorporateId")
                
                
                
                NotificationCenter.default.post(name: .tabBarSwitchNotifications, object: nil, userInfo: ["Index": 8])
                NotificationCenter.default.post(name: .menuItemsSwitchNotifications, object: nil)
                
                
                let vc = DashboardViewController.instantiateFromAppStroyboard(appStoryboard: .home)
                vc.isSurveyShow = 4 //self.responseModel?[0].IsNPSShow ?? 0
                self.navigationController?.pushViewController(vc, animated: true)
            }

        }, fail: { (error) in
            print(error.localizedDescription)
            self.showAlert(title: "Alert", message: "The Internet connection appears to be offline.", controller: self) {
            }
            
        }, showHUD: true)
    }
    
    
    @IBAction func tapOnLoginBtn(_ sender: Any) {
        guard let customerId  = customerIdTxtField.text, !customerId.isEmpty else {
            self.showAlert(title: "Alert", message: "Please enter your customer Id.", controller: self) {
                self.customerIdTxtField.becomeFirstResponder()
            }
            return
        }
        guard let passTxt  = passwordTxtField.text, !passTxt.isEmpty else {
            self.showAlert(title: "Alert", message: "Please enter your password.", controller: self) {
                self.passwordTxtField.becomeFirstResponder()
            }
            return
        }
        userAuth(customerId, passTxt, LoginType.manual.rawValue )
        
        
        //SVProgressHUD.show()
        //interactor?.didTapOnLoginBtn(customer_id: customerIdTxtField.text ?? "", password: passwordTxtField.text ?? "")
    }
    
    
    @IBAction func navigateBackAction(_ sender: Any) {
        if isTransition == false {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = ViewController.instantiateFromAppStroyboard(appStoryboard: .main)
            self.navigationController?.pushViewController(vc, animated: false)
        } else {
            let transition:CATransition = CATransition()
            transition.duration = 0.5
            transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
            transition.type = CATransitionType.push
            transition.subtype = CATransitionSubtype.fromBottom
            self.navigationController!.view.layer.add(transition, forKey: kCATransition)
            self.navigationController?.popViewController(animated: false)
        }
        
    }
}



extension LoginViewController: LoginViewModelDelegate {
    func notifyUser(_ msg: String, err: String?) {
        let alert = UIAlertController(title: msg,
            message: err,
            preferredStyle: .alert)

        let cancelAction = UIAlertAction(title: "OK",
            style: .cancel, handler: nil)

        alert.addAction(cancelAction)

        self.present(alert, animated: true,
                            completion: nil)
    }
    func didReceiveLoginSuccessResponse(loginResponse: [BiometricResponse]){
        if let userId = loginResponse[0].userID, let passToken = loginResponse[0].passToken {
            KeychainWrapper.standard.set(userId, forKey: "BioMetricCustomerId")
            Crashlytics.crashlytics().setUserID(userId)
            UserDefaults.standard.setValue(true, forKey: "isBiometricLogin")
            
            KeychainWrapper.standard.set(passToken, forKey: "BioMetricAccessToken")
            KeychainWrapper.standard.set("loggedInUser", forKey: "UserType")
            
            NotificationCenter.default.post(name: .tabBarSwitchNotifications, object: nil, userInfo: ["Index": 8])
            NotificationCenter.default.post(name: .menuItemsSwitchNotifications, object: nil)
            let vc = DashboardViewController.instantiateFromAppStroyboard(appStoryboard: .home)
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    func didReceiveLoginErrorResponse(errorResponse: [ErrorResponse]?) {
        if let error = errorResponse {
            self.showErrorMsg(error)
        }
    }
}

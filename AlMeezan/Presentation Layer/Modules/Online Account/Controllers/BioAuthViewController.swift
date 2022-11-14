//
//  BioAuthViewController.swift
//  AlMeezan
//
//  Created by Atta khan on 30/11/2020.
//  Copyright © 2020 Atta khan. All rights reserved.
//

import UIKit

class BioAuthViewController: UIViewController  {
    @IBOutlet weak var lockIcon: UIImageView!
    @IBOutlet weak var lockLbl: UILabel!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var customerIdTxt: UITextField!
    var isTransition: Bool = false
    @IBOutlet weak var termBtn: UIButton!
    @IBOutlet weak var touchBtn: UIButton!
    var loginViewModel = LoginViewModel()
    private let validation: ValidationService
    
    init(validation: ValidationService) {
        self.validation = validation
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.validation = ValidationService()
        super.init(coder: coder)
    }
    
    
    var isSelectedTerms = false
    var isSelectedTouch = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginViewModel.delegate = self
        customerIdTxt.attributedPlaceholder = NSAttributedString(string: "Enter Customer ID",
                                                                      attributes: [NSAttributedString.Key.foregroundColor: UIColor.placeHolderColor])
        passwordTxt.attributedPlaceholder = NSAttributedString(string: "Enter Password",
        attributes: [NSAttributedString.Key.foregroundColor: UIColor.placeHolderColor])

    }
    
    func navigateBackScreen() {
        if isTransition == false {
            self.navigationController?.popViewController(animated: false)
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

    @IBAction func didTapTouchCheckedBtn(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            isSelectedTouch = true
        } else {
            isSelectedTouch = false
        }
    }
    @IBAction func didTapTermsCheckedBtn(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            isSelectedTerms = true
        } else {
            isSelectedTerms = false
        }
    }
    
    @IBAction func didTapCancelBtn(_ sender: Any) {
        navigateBackScreen()
    }
    
    @IBAction func didTapNextdBtn(_ sender: Any) {
        do {
            let userId       =  try validation.validateTxtField(customerIdTxt.text, ValidationError.emptyUserId)
            let password     =  try validation.validateTxtField(passwordTxt.text, ValidationError.emptyPassword)
            let _ = try validation.validateCheckbox(termBtn.isSelected, ValidationError.checkBoxMsg)
            let _ = try validation.validateCheckbox(touchBtn.isSelected, ValidationError.checkBoxMsg)
            
            loginViewModel.biometricAuth { (success) in
                if success {
                    self.customerIdTxt.text = ""
                    self.passwordTxt.text = ""
                    
                    let device_id   = UserDefaults.standard.string(forKey: "device_id") ?? "fdsjfkdsflsdfceeasewese"
                    let device_name = UIDevice.modelName
                    let type = self.loginViewModel.getBiometricType(biometricType: self.loginViewModel.biometricType)
                    self.loginViewModel.login(userId, password, device_id, device_name, type)
                }
                
            } fail: { (error) in
                print(error.localizedDescription)
            }

        } catch {
            print(error)
            self.showAlert(title: "Alert", message: error.localizedDescription, controller: self) {
            }
        }
        
        
        
        

        
        
        
    }
    
    @IBAction func didTapBackBtn(_ sender: Any) {
        navigateBackScreen()
    }
    
    
    @IBAction func didTapTermsConditions(_ sender: Any) {
        let vc = BlogsViewController.instantiateFromAppStroyboard(appStoryboard: .main)
        vc.urlStr = BIO_LOGIN_TERMS_CONDITIONS
        vc.titleStr = "Terms and Conditions"
        vc.isTransition = false
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

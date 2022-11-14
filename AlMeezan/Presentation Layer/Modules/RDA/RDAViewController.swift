//
//  RDAViewController.swift
//  AlMeezan
//
//  Created by Atta Khan on 08/04/2021.
//  Copyright © 2021 Atta khan. All rights reserved.
//

import UIKit
import SVProgressHUD

class RDAViewController: UIViewController {

    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var CNICTxtfield: UITextField!
    @IBOutlet weak var contactNumberTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var personTF: UITextField!
    
    
    @IBOutlet weak var openNewAccountBTn: UIButton!
    @IBOutlet weak var existingAccountBtn: UIButton!
    
    
    private let validation: ValidationService
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
        nameTF.delegate = self
        CNICTxtfield.keyboardType = .asciiCapableNumberPad
        contactNumberTF.keyboardType = .asciiCapableNumberPad
        nameTF.autocapitalizationType = .allCharacters
        
        contactNumberTF.delegate = self
        CNICTxtfield.delegate = self
        
        existingAccountBtn.titleLabel?.adjustsFontSizeToFitWidth = true
        openNewAccountBTn.titleLabel?.adjustsFontSizeToFitWidth = true
    }
    

    @IBAction func didTapOnExistingAccountBtn(_ sender: Any) {
        openRoshanAccount(RoshanAccountType.old, EXISTING_ACCOUNT_RDA)
    }
    
    
    @IBAction func didTapOnNewAccountBtn(_ sender: Any) {
        openRoshanAccount(RoshanAccountType.new, NEW_ACCOUNT_RDS)
    }

    
    
    func openRoshanAccount(_ type: RoshanAccountType = .new, _ link: String) {
        
        do {
            let cnicName       =   try validation.validateCNIC(CNICTxtfield.text)
            let name           =   try validation.validateTxtField(nameTF.text, ValidationError.emptyTxtfieldMsg)
            let contactNumber  =   try validation.validateContactNo(contactNumberTF.text)
            let email             =   try validation.validateEmail(emailTF.text)
            
            let salePersion =  ""
            
            let bodyParam = RequestBody(CNIC: cnicName, Name: name, Mobile: contactNumber , Email: email, AccountType: type.rawValue,  DaoID: salePersion)
            let bodyRequest = bodyParam.encryptData(bodyParam)
            let url = URL(string: ROSHAN_ACCOUNT)!
            SVProgressHUD.show()
            
            WebServiceManager.sharedInstance.fetch(params: bodyRequest as Dictionary<String, AnyObject>, url: url, serviceType: "Online Account", modelType: AccountOpening.self, errorMessage: { (errorMessage) in
                errorResponse = errorMessage
                //self.showErrorMsg(errorMessage)

            }, success: { (response) in
                let apiResponse = response
                self.openWebView(link)
                
            }, fail: { (error) in
                print(error.localizedDescription)
            }, showHUD: true)
            
            
        } catch {
            print(error)
            self.showAlert(title: "Alert", message: error.localizedDescription, controller: self) {
            }
        }
        
    }
    
    func openWebView(_ link: String) {
        let vc = BlogsViewController.instantiateFromAppStroyboard(appStoryboard: .main)
        vc.urlStr = link
        vc.titleStr = "Roshan Digital Account"
        vc.isTransition = false
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func didTapOnBackBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
}

enum RoshanAccountType: String {
    case new = "New"
    case old = "Old"
}
extension RDAViewController: UITextFieldDelegate {
    
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
        if textField == contactNumberTF && range.location == 0{
            textField.text = "+"
        }
        
        
        let newLength = currentCharacterCount + string.count - range.length
        if textField == CNICTxtfield {
            return newLength <= 13
        } else if textField == contactNumberTF {
            return newLength < 18
        } else if textField == nameTF {
            textField.text = (textField.text! as NSString).replacingCharacters(in: range, with: string.uppercased())

            return false

        }
        return true
    }
}

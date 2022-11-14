//
//  InvestViewController.swift
//  AlMeezan
//
//  Created by Atta khan on 21/10/2019.
//  Copyright © 2019 Atta khan. All rights reserved.
//

import UIKit
import SVProgressHUD
import SwiftKeychainWrapper


class InvestViewController: BaseViewController {

    @IBOutlet weak var nameTxtField: UITextField!
    @IBOutlet weak var countryTxtField: UITextField!
    @IBOutlet weak var cityTxtField: UITextField!
    @IBOutlet weak var phoneNumberTxtField: UITextField!
    @IBOutlet weak var contactTopView: UIView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var cityLbl: UILabel!
    @IBOutlet weak var phoneNumberLbl: UILabel!
    @IBOutlet weak var nameBorderLine: UIView!
    @IBOutlet weak var phoneNumberLine: UIView!
    @IBOutlet weak var cityIndicatorBtn: UIButton!
    @IBOutlet weak var cityBottomLine: UIView!
    @IBOutlet weak var locationBottomView: UIView!
    @IBOutlet weak var cityView: UIView!
    @IBOutlet weak var phoneTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var notificationBtn: UIButton!
    @IBOutlet weak var countNotificationLbl: UIButton!

    let locationArray = ["Pakistan", "International"]
    var selectedLocation: Int = 0
    var selectedCity: Int = 0
    var responseModel: [CRMLead]?
    var isValidMobileLength : Bool = false
    var isInternational = ""
    var isFromSideMenu: Bool = false
    var selectedMenuItem: Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        if isFromSideMenu {
            navigateToController(selectedMenuItem)
        }
        
        contactTopView.roundCorners([.layerMinXMinYCorner,.layerMaxXMinYCorner], radius: 10, borderColor: UIColor.themeColor, borderWidth: 0)
         countNotificationLbl.isHidden = true
        nameTxtField.delegate = self
        countryTxtField.delegate = self
        cityTxtField.delegate = self
        phoneNumberTxtField.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        Utility.shared.renderNotificationCount(countNotificationLbl)
        hideNavigationBar()
        if let userAuth = KeychainWrapper.standard.string(forKey: "UserType") {
            if userAuth == "loggedInUser" {
                loginBtn.setImage(UIImage(named: "logout-icon-1"), for: .normal)
            } else {
                loginBtn.setImage(UIImage(named: "logout-icon"), for: .normal)
            }
        }
    }
    
    @IBAction func tapOnLocationBtn(_ sender: Any) {
        chooseLocation(1, "Choose Location")
    }
    
    
    @IBAction func tapOnCityBtn(_ sender: Any) {
        guard let locationTxt  = countryTxtField.text, !locationTxt.isEmpty else {
            self.showAlert(title: "Alert", message: "Please first choose Location.", controller: self) {
               
            }
             return
        }
        chooseLocation(2, "Choose City")
    }
    
    func toggleCityView(_ isHidden: Bool) {
        UIView.transition(with: view, duration: 0.5, options: .transitionCrossDissolve, animations: {
            self.cityView.isHidden   =   isHidden
        })
        
    }
    
    @IBAction func tapOnSubmitBtn(_ sender: Any) {
        guard let nameTxt  = nameTxtField.text, !nameTxt.isEmpty else {
            self.showAlert(title: "Alert", message: "Please enter your name.", controller: self) {
                self.nameTxtField.becomeFirstResponder()
            }
            return
        }
        guard let locationTxt  = countryTxtField.text, !locationTxt.isEmpty else {
            self.showAlert(title: "Alert", message: "Please choose Location.", controller: self) {
                self.countryTxtField.becomeFirstResponder()
            }
            return
        }
        
        
        
        var city    = ""
        if locationTxt == "Pakistan" {
            isInternational = "Y"
            guard let cityTxt  = cityTxtField.text, !cityTxt.isEmpty else {
                self.showAlert(title: "Alert", message: "Please choose city.", controller: self) {
                    self.cityTxtField.becomeFirstResponder()
                }
                return
            }
            city = cityTxt
            
        } else {
            isInternational = "N"
        }
        guard let mobileTxt  = phoneNumberTxtField.text else {
            self.showAlert(title: "Alert", message: "Please enter your mobile number.", controller: self) {
                self.phoneNumberTxtField.becomeFirstResponder()
            }
            return
        }
        if isValidMobileLength == false {
            self.showAlert(title: "Alert", message: "Please enter valid mobile number.", controller: self) {
                self.phoneNumberTxtField.becomeFirstResponder()
            }
            return
        }
        
        let Username  = KeychainWrapper.standard.string(forKey: "CustomerId")
        let Password = KeychainWrapper.standard.string(forKey: "AccessToken")
        let bodyParam = RequestBody(City: city, IsInternational: isInternational, Username: Username, Password: Password, Name: nameTxt, Mobile: mobileTxt)
        let bodyRequest = bodyParam.encryptData(bodyParam)
        let url = URL(string: CRM_LEAD)!
        
        SVProgressHUD.show()
        WebServiceManager.sharedInstance.fetch(params: bodyRequest as Dictionary<String, AnyObject>, url: url, serviceType: "Invest Now", modelType: CRMLead.self, errorMessage: { (errorMessage) in
            errorResponse = errorMessage
            self.showErrorMsg(errorMessage)
        }, success: { (response) in
            self.responseModel = response
            self.showAlert(title: "Alert", message: "We have received your contact details. Our relevant investment advisor will call you within 2 business days. For urgent queries call us on our Toll Free #0800-42525(Halal)", controller: self) {
                self.phoneNumberTxtField.text = ""
                self.nameTxtField.text  = ""
                self.cityTxtField.text = ""
                self.countryTxtField.text = ""
                self.phoneNumberTxtField.text = ""
                self.phoneNumberTxtField.resignFirstResponder()
                self.toggleCityView(false)
                self.phoneTopConstraint.constant = 0
                self.isValidMobileLength = false
            }
        }, fail: { (error) in
            print(error.localizedDescription)
        }, showHUD: true)
        
    }
    
    @IBAction func tapOnMenuBtn(_ sender: Any) {
        self.revealController.show(self.revealController.leftViewController)
    }
    @IBAction func tapOnPhoneBtn(_ sender: Any) {
    }
    func chooseLocation(_ tag : Int, _ title: String) {
        let vc = UIViewController()
        vc.preferredContentSize = CGSize(width: 250,height: 200)
        let pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: 250, height: 200))
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.tag = tag
        pickerView.selectRow(selectedLocation, inComponent:0, animated:true)
        vc.view.addSubview(pickerView)
        let editRadiusAlert = UIAlertController(title: title, message: "", preferredStyle: UIAlertController.Style.alert)
        editRadiusAlert.setValue(vc, forKey: "contentViewController")
        editRadiusAlert.addAction(UIAlertAction(title: "Done", style: .default, handler: { (alert: UIAlertAction!) in
            if tag == 2 {
                self.cityTxtField.text = citiesArray[self.selectedCity]
            } else {
                self.countryTxtField.text = self.locationArray[self.selectedLocation]
                let height = self.cityView.frame.size.height
                if self.selectedLocation == 1 {
                    self.phoneNumberTxtField.text = ""
                    self.toggleCityView(true)
                    self.phoneTopConstraint.constant = -height
                } else {
                    self.toggleCityView(false)
                    self.phoneTopConstraint.constant = 0
                    //self.phoneNumberTxtField.text = "92"
                }
            } 
        }))
        self.present(editRadiusAlert, animated: true)
        
    }
    
    @IBAction func tapOnNotificationBtn(_ sender: Any) {
        let vc = NotificationsVC.instantiateFromAppStroyboard(appStoryboard: .home)
        self.navigationController?.pushViewController(vc, animated: true)
    }
       
    @IBAction func tapOnLoginBtn(_ sender: Any) {
        loginOption()
     }
}
extension InvestViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 2 {
            return citiesArray.count
        }
        return locationArray.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 2 {
            return citiesArray[row]
        }
        return locationArray[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 2 {
            cityTxtField.text = citiesArray[row]
            selectedCity = row
        } else {
            countryTxtField.text = locationArray[row]
            selectedLocation = row
        }
       
    }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var title = UILabel()
        if let titleLbl = view {
            title = titleLbl as! UILabel
        }
        title.font = UIFont(name: "Roboto-Regular", size: pickerTitleFontSize)
        if pickerView.tag == 2 {
            title.text =  citiesArray[row]
        } else {
            title.text =  locationArray[row]
        }
        
        title.textAlignment = .center
        return title
    }
}
extension InvestViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == phoneNumberTxtField {
            
            let currentCharacterCount = textField.text?.count ?? 0
            let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)

//            if self.selectedLocation == 0 {
//                if newString.count <= 1 {
//                    return false
//                }
//            }
            
            if range.length + range.location > currentCharacterCount {
                return false
            }
            let newLength = currentCharacterCount + string.count - range.length
            if  newLength > 11 {
                isValidMobileLength = true
            } else {
                isValidMobileLength = false
            }
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
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case nameTxtField:
            nameTxtField.textColor = UIColor.themeColor
            nameBorderLine.backgroundColor = UIColor.themeColor
            nameLbl.transform = CGAffineTransform(scaleX: 1.2, y: 1.2).concatenating(CGAffineTransform(translationX: 0, y: -4))
            nameLbl.textColor = UIColor.themeColor
        case countryTxtField:
            locationBottomView.backgroundColor = UIColor.themeColor
            locationLbl.transform = CGAffineTransform(scaleX: 1.2, y: 1.2).concatenating(CGAffineTransform(translationX: 0, y: -4))
            locationLbl.textColor = UIColor.themeColor
        case cityTxtField:
            cityView.backgroundColor = UIColor.themeColor
            cityLbl.transform = CGAffineTransform(scaleX: 1.2, y: 1.2).concatenating(CGAffineTransform(translationX: 0, y: -4))
            cityLbl.textColor = UIColor.themeColor
        case phoneNumberTxtField:
            phoneNumberLine.backgroundColor = UIColor.themeColor
            phoneNumberLbl.transform = CGAffineTransform(scaleX: 1.2, y: 1.2).concatenating(CGAffineTransform(translationX: 0, y: -4))
            phoneNumberLbl.textColor = UIColor.themeColor
        default:
            break
        }
        
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case nameTxtField:
            nameBorderLine.backgroundColor = UIColor.lightGray
            nameLbl.transform = CGAffineTransform(scaleX: 1.0, y: 1.0).concatenating(CGAffineTransform(translationX: 0, y: 0))
            nameLbl.textColor = UIColor.themeLblColor
            nameTxtField.textColor = UIColor.themeLblColor
        case countryTxtField:
            locationBottomView.backgroundColor = UIColor.lightGray
            locationLbl.transform = CGAffineTransform(scaleX: 1.0, y: 1.0).concatenating(CGAffineTransform(translationX: 0, y: 0))
            locationLbl.textColor = UIColor.themeLblColor
        case cityTxtField:
            cityView.backgroundColor = UIColor.lightGray
            cityLbl.transform = CGAffineTransform(scaleX: 1.0, y: 1.0).concatenating(CGAffineTransform(translationX: 0, y: 0))
            cityLbl.textColor = UIColor.themeLblColor
        case phoneNumberTxtField:
            phoneNumberLine.backgroundColor = UIColor.lightGray
            phoneNumberLbl.transform = CGAffineTransform(scaleX: 1.0, y: 1.0).concatenating(CGAffineTransform(translationX: 0, y: 0))
            phoneNumberLbl.textColor = UIColor.themeLblColor
        default:
            break
        }
    }
}

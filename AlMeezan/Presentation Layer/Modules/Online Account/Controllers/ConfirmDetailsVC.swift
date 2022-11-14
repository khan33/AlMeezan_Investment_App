//
//  ConfirmDetailsVC.swift
//  AlMeezan
//
//  Created by Atta khan on 02/11/2020.
//  Copyright © 2020 Atta khan. All rights reserved.
//

import UIKit
import SVProgressHUD
import FirebaseAnalytics
class ConfirmDetailsVC: UIViewController {
    @IBOutlet weak var CircularProgress: CircularProgressView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var fNameLbl: UILabel!
    @IBOutlet weak var dobLbl: UILabel!
    @IBOutlet weak var genderLbl: UILabel!
    @IBOutlet weak var ageLbl: UILabel!
    @IBOutlet weak var incomLbl: UILabel!
    @IBOutlet weak var occupationLbl: UILabel!
    @IBOutlet weak var issueLbl: UILabel!
    @IBOutlet weak var expireLbl: UILabel!
    @IBOutlet weak var lifetimeLbl: UILabel!
    @IBOutlet weak var progressBarTitleLbl: UILabel!
    
    @IBOutlet weak var expireDateLbl: UILabel!
    @IBOutlet weak var bankNameLbl: UILabel!
    @IBOutlet weak var branchNameLbl: UILabel!
    @IBOutlet weak var bankAccounTitleLbl: UILabel!
    @IBOutlet weak var backAccountNOLbl: UILabel!
    @IBOutlet weak var address1Lbl: UILabel!
    @IBOutlet weak var address2Lbl: UILabel!
    @IBOutlet weak var cityLbl: UILabel!
    @IBOutlet weak var countryLbl: UILabel!
    
    var bank_details: BankDelatils?
    var user_details: UserDetails?
    var apiResponse: [AccountOpening]?
    override func viewDidLoad() {
        super.viewDidLoad()
        progressBarTitleLbl.text = "5 of 6"
        CircularProgress.trackColor = UIColor.progressBarinActiveColor
        CircularProgress.progressColor = UIColor.progressBarActiveColor
        CircularProgress.setProgressWithAnimation(duration: 1.0, value: 5 * 1/6)
        
        
        
        Utility.shared.getUserdefaultValues(OnlineOperationStatus.user.rawValue, modelType: UserDetails.self) { (result) in
            self.user_details = result
            self.populateUserDetails(result)
        }
        Utility.shared.getUserdefaultValues(OnlineOperationStatus.bank.rawValue, modelType: BankDelatils.self) { (result) in
            self.bank_details = result
            self.populateBankDetails(result)
        }
    }
    func populateUserDetails(_ values: UserDetails) {
        nameLbl.text = values.name
        fNameLbl.text = values.fName
        dobLbl.text = values.dob
        ageLbl.text = values.age
        if values.income == "Others" {
            incomLbl.text = values.otherSource
        } else {
            incomLbl.text = values.income
        }
        
        occupationLbl.text = values.occupation
        issueLbl.text = values.cnicIssue
        if values.cnicValid {
            expireDateLbl.text = "CNIC Life Time Validity"
            expireLbl.text = "Yes"
        } else {
            expireDateLbl.text = "CNIC Expiry Date"
            expireLbl.text = values.cnicExpire
        }
        genderLbl.text = values.gender?.uppercased()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Utility.shared.googleAnalyticsEvent(OnlineAccountEnums.STEP_FIVE.index, OnlineAccountEnums.STEP_FIVE.value, OnlineAccountEnums.STEP_FIVE.screenName, String(describing: type(of: self)))
    }
    func populateBankDetails(_ values: BankDelatils) {
        bankNameLbl.text = values.bankName?.uppercased()
        branchNameLbl.text = values.branchName?.uppercased()
        bankAccounTitleLbl.text = values.bankTitle?.uppercased()
        backAccountNOLbl.text = values.accountNo?.uppercased()
        address1Lbl.text = values.address1?.uppercased()
        address2Lbl.text = values.address2?.uppercased()
        cityLbl.text = values.city
        countryLbl.text = values.country
    }
    
    func submitAccount() {
        
        let city_id = bank_details?.cityCode?.trimmingCharacters(in: .whitespacesAndNewlines)
        var device_id = ""
        if let fcm_key = UserDefaults.standard.string(forKey: "device_id") {
            device_id = fcm_key
        }
        var guest_key = ""
        if let key = UserDefaults.standard.string(forKey: "guestkey") {
            guest_key = key
        }
        
        let bodyParam = RequestBody(City: city_id, Age: user_details?.age, Mobile: user_details?.mobileNO, Email: user_details?.email, DeviceID: device_id , GuestID: guest_key, FullName: user_details?.name, FHusbandName: user_details?.fName, Gender: user_details?.gender, Country: bank_details?.country_short_code, Dob: user_details?.dob, Cnic: user_details?.CNIC, CnicIssueDate: user_details?.cnicIssue, CnicExpiryDate: user_details?.cnicExpire, Occupation: user_details?.occupation, SourceOfFund: user_details?.income, Address: bank_details?.address1, BankName: bank_details?.bankID, BankAccNo: bank_details?.accountNo, BankBranch: bank_details?.branchName, BankCity: city_id)
        
        let bodyRequest = bodyParam.encryptData(bodyParam)
        let url = URL(string: ACCOUNT_OPENING)!
        SVProgressHUD.show()
        
        WebServiceManager.sharedInstance.fetch(params: bodyRequest as Dictionary<String, AnyObject>, url: url, serviceType: "Online Account", modelType: AccountOpening.self, errorMessage: { (errorMessage) in
            errorResponse = errorMessage
            //self.showErrorMsg(errorMessage)

        }, success: { (response) in
            let apiResponse = response
            self.showAlert(title: "Alert", message: apiResponse[0].errMsg ?? "Please try again!", controller: self) {
                defaults.removeObject(forKey: OnlineOperationStatus.bank.rawValue)
                defaults.removeObject(forKey: OnlineOperationStatus.user.rawValue)
                let vc = FundDetailsForOnlineAcountVC.instantiateFromAppStroyboard(appStoryboard: .onlineAccount)
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }, fail: { (error) in
            print(error.localizedDescription)
        }, showHUD: true)
    }
    
    
    
    
    @IBAction func didTapNextButton(_ sender: Any) {
        submitAccount()
//        let vc = FundDetailsForOnlineAcountVC.instantiateFromAppStroyboard(appStoryboard: .onlineAccount)
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func didTapPreviousButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didTapBackButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    
    
    
    
}

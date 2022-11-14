//
//  MyProfileVC.swift
//  AlMeezan
//
//  Created by Atta khan on 04/11/2019.
//  Copyright © 2019 Atta khan. All rights reserved.
//

import UIKit
import SVProgressHUD
class MyProfileVC: UIViewController {

    
    @IBOutlet weak var customerName: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var phoneNbLbl: UILabel!
    @IBOutlet weak var zakatStatus: UILabel!
    @IBOutlet weak var branchLbl: UILabel!
    @IBOutlet weak var investorAdvisorName: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var mobileNbLbl: UILabel!
    
    var customer_details: [CustomerDetail]?
    override func viewDidLoad() {
        super.viewDidLoad()
        customerName.text = "-"
        mobileNbLbl.text = "-"
        phoneNbLbl.text = "-"
        addressLbl.text = "-"
        emailLbl.text = "-"
        branchLbl.text = "-"
        zakatStatus.text = "-"
        investorAdvisorName.text = "-"
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideNavigationBar()
        getData()
    }
    
    private func UpdateUI(_ customer: CustomerDetail?) {
        guard let data = customer else { return }
        customerName.text = data.customer_Name
        mobileNbLbl.text = data.mobile
        phoneNbLbl.text = data.mobile
        addressLbl.text = data.address
        emailLbl.text = data.email
        branchLbl.text = data.bANK_NAME
        zakatStatus.text = data.iS_ZAKAT_EXEMPT == "Y" ? "Exempted" : "Not-Exempted"
        investorAdvisorName.text = data.oPERATIN_INSTRUCTIONS
        
    }
        
    
    func getData() {
        let bodyParam = RequestBody()
        let bodyRequest = bodyParam.encryptData(bodyParam)
        let url = URL(string: CUSTOMER_DETAILS)!
        SVProgressHUD.show()
        
        WebServiceManager.sharedInstance.fetch(params: bodyRequest as Dictionary<String, AnyObject>, url: url, serviceType: "Nav Fund", modelType: CustomerDetail.self, errorMessage: { (errorMessage) in
            errorResponse = errorMessage
            self.showErrorMsg(errorMessage)
        }, success: { (response) in
            self.customer_details = response
            if self.customer_details?.count ?? 0 > 0 {
                self.UpdateUI(self.customer_details?[0])
            }

        }, fail: { (error) in
            print(error.localizedDescription)
        }, showHUD: true)
    }
}

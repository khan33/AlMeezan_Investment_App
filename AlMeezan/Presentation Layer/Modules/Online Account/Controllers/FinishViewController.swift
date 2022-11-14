//
//  FinishViewController.swift
//  AlMeezan
//
//  Created by Atta khan on 02/11/2020.
//  Copyright © 2020 Atta khan. All rights reserved.
//

import UIKit
import Photos
import FirebaseAnalytics
class FinishViewController: UIViewController {
    @IBOutlet weak var CircularProgress: CircularProgressView!
    @IBOutlet weak var fundCategoryLbl: UILabel!
    @IBOutlet weak var fundPlanLbl: UILabel!
    @IBOutlet weak var profileNameLbl: UILabel!
    @IBOutlet weak var amountLbl: UILabel!
    @IBOutlet weak var progressBarTitleLbl: UILabel!
    @IBOutlet weak var galleryBtn: UIButton!
    @IBOutlet weak var okBtn: UIButton!
    @IBOutlet weak var successView: UIView!
    
    @IBOutlet weak var amountTxtLbl: UILabel!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var planLbl: UILabel!
    @IBOutlet weak var categoryLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    var fundCategory: String?
    var fundPlan: String?
    var amount: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        successView.isHidden = true
        if let profile_name = defaults.string(forKey: "CNIC_Name") {
            profileNameLbl.text = profile_name
            userNameLbl.text = profile_name
        } else {
            profileNameLbl.text = ""
            userNameLbl.text = ""
        }
        if let category = fundCategory {
            fundCategoryLbl.text = category.uppercased()
            categoryLbl.text = category.uppercased()
        } else {
            fundCategoryLbl.text = ""
            categoryLbl.text = ""
        }
        
        if let plan = fundPlan {
            fundPlanLbl.text = plan.uppercased()
            planLbl.text = plan.uppercased()
        } else {
            fundPlanLbl.text = ""
            planLbl.text = ""
        }
        
        if let amount = amount {
            amountLbl.text = amount + " Rupees"
            amountTxtLbl.text = amount + " Rupees"
        }
        let dateStr = Date().dateAndTimetoString(format: "dd-MMM-YYYY")
        dateLbl.text = dateStr
        // Do any additional setup after loading the view.
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Utility.shared.googleAnalyticsEvent(OnlineAccountEnums.STEP_SEVEN.index, OnlineAccountEnums.STEP_SEVEN.value, OnlineAccountEnums.STEP_SEVEN.screenName, String(describing: type(of: self)))
    }
    
    @IBAction func didTapOkButton(_ sender: Any) {
        let vc = SuccessViewController.instantiateFromAppStroyboard(appStoryboard: .onlineAccount)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func didTapSaveGalleryButton(_ sender: Any) {
        
        
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized:
            DispatchQueue.main.async {
                self.takeScreenShot()
            }
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { status in
                            switch status {
                            case .authorized:
                                DispatchQueue.main.async {
                                    self.takeScreenShot()
                                }
                            case .denied, .restricted, .notDetermined, .limited:
                                break
                            }
                        }
        case .limited, .denied, .restricted:
            permissionRequired()
            break
        }
        
        //self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didTapBackButton(_ sender: Any) {
        //self.navigationController?.popViewController(animated: true)
    }

    
    func takeScreenShot() {
        UIView.animate(withDuration: 1) {
            self.successView.isHidden = false
        } completion: { (true) in
            let screenshotImage = self.successView.image()
            if let image = screenshotImage {
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                self.successView.isHidden = true
                self.showToast(message: "Successfully capatured screenshot.", font: .systemFont(ofSize: 12.0))
            }
        }
    }
    
    func permissionRequired() {
        self.showAlert(title: "Alert", message: "Please enable Photo permissions in settings.", controller: self) {
            UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!)
        }
    }
}

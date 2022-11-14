//
//  InvestmentProductDetailVC.swift
//  AlMeezan
//
//  Created by Atta khan on 08/10/2019.
//  Copyright © 2019 Atta khan. All rights reserved.
//

import UIKit
import SVProgressHUD
import SDWebImage
import SwiftKeychainWrapper

struct ExpandablesItems {
    var isExpandable: Bool
    let names: String
}

class InvestmentProductDetailVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var notificationBtn: UIButton!
    @IBOutlet weak var countNotificationLbl: UIButton!


    var expandCell = [
        ExpandablesItems(isExpandable: false, names: "Objective"),
        ExpandablesItems(isExpandable: false, names: "Who Should Invest"),
        ExpandablesItems(isExpandable: false, names: "Key Benefits"),
        ExpandablesItems(isExpandable: false, names: "Key Features")
    ]
    
    
    @IBOutlet weak var fundTitleLbl: UILabel!
    var fund_details: FundDescription?
    var fund_data: [AllFundsDescription]?
    var fund_name: String?
    var fund_short_name: String?
    
    @IBOutlet weak var fundShortNameLbl: UILabel!
    var labelHight: CGFloat = 16.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
         countNotificationLbl.isHidden = true
        Utility.shared.renderNotificationCount(countNotificationLbl)
        if fund_details != nil {
            fundTitleLbl.text = fund_details?.fundName
            fundShortNameLbl.text = fund_details?.mnemonic
            setUpTableView()
        } else {
            fundTitleLbl.text = fund_name!
            if let shortName = fund_short_name {
                fundShortNameLbl.text = shortName
            } else {
                fundShortNameLbl.text = ""
            }
            getFundList()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideNavigationBar()
        if let userAuth = KeychainWrapper.standard.string(forKey: "UserType") {
            if userAuth == "loggedInUser" {
                loginBtn.setImage(UIImage(named: "logout-icon-1"), for: .normal)
            } else {
                loginBtn.setImage(UIImage(named: "logout-icon"), for: .normal)
            }
        }
    }
    
    func setUpTableView() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60
        tableView.register(DetailBoxCell.nib, forCellReuseIdentifier: DetailBoxCell.identifier)
        tableView.register(NAVHeaderCell.nib, forCellReuseIdentifier: NAVHeaderCell.identifier)
        tableView.register(ExtraFeatureCell.nib, forCellReuseIdentifier: ExtraFeatureCell.identifier)
        tableView.register(GraphCell.nib, forCellReuseIdentifier: GraphCell.identifier)
        tableView.register(DescriptionViewCell.nib, forCellReuseIdentifier: DescriptionViewCell.identifier)
        tableView.register(KeyFeatureCell.nib, forCellReuseIdentifier: KeyFeatureCell.identifier)
        tableView.register(DescriptionTableViewCell.nib, forCellReuseIdentifier: DescriptionTableViewCell.identifier)
        tableView.register(VideoViewCell.nib, forCellReuseIdentifier: VideoViewCell.identifier)
        tableView.register(DisclaimerViewCell.nib, forCellReuseIdentifier: DisclaimerViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }
    
    
    func getFundList() {
        let bodyParam = RequestBody(FundType: fund_name)
        let bodyRequest = bodyParam.encryptData(bodyParam)
        let url = URL(string: ALL_FUND_DESCRIPTION)!
        SVProgressHUD.show()
        
        WebServiceManager.sharedInstance.fetch(params: bodyRequest as Dictionary<String, AnyObject>, url: url, serviceType: "Cache Data", modelType: AllFundsDescription.self, errorMessage: { (errorMessage) in
            errorResponse = errorMessage
            self.showErrorMsg(errorMessage)
            
        }, success: { (response) in
           self.fund_data = response
            if self.fund_data?.count ?? 0 > 0 {
                let data = Array(self.fund_data?[0].fundDescription ?? [])
                self.fund_details = data[0]
                self.fundShortNameLbl.text = data[0].mnemonic
            }
            self.setUpTableView()
        }, fail: { (error) in
            print(error.localizedDescription)
        }, showHUD: true)
        
        
        
    }
    
    @IBAction func navigateController(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func tapOnNotificationBtn(_ sender: Any) {
        let vc = NotificationsVC.instantiateFromAppStroyboard(appStoryboard: .home)
        self.navigationController?.pushViewController(vc, animated: true)
    }
       
    @IBAction func tapOnLoginBtn(_ sender: Any) {
        loginOption()
    }

}
extension InvestmentProductDetailVC: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        var count = 6
        if let youtube_link = fund_details?.youtubeLink {
            count = count + 1
        }
        return count
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = UIView()
        headerCell.backgroundColor = UIColor.rgb(red: 244, green: 246, blue: 250, alpha: 1)
        return headerCell
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5.0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    fileprivate func detailBoxView(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DetailBoxCell.identifier, for: indexPath) as! DetailBoxCell
        cell.investmentAmountLbl.text   =   fund_details?.minimumInvestmentAmount ?? "Not Available"
        cell.inceptionDateLbl.text      =   fund_details?.dateOfInception ?? "Not Available"
        let width = cell.inceptionView.frame.width
        
        let investmentAmountHeight = fund_details?.minimumInvestmentAmount?.height(withConstrainedWidth: width, font: UIFont(name: "Roboto-Medium", size: 11)!) ?? 16.0
        let inceptionDateHeight = fund_details?.dateOfInception?.height(withConstrainedWidth: width, font: UIFont(name: "Roboto-Medium", size: 11)!) ?? 16.0
        
        let minimumInvestLbl = cell.minimumInvestmentLbl.text!
        let minInvestHeight = minimumInvestLbl.height(withConstrainedWidth: width, font: UIFont(name: "Roboto-Regular", size: 11)!)
        
        if investmentAmountHeight.isLess(than: inceptionDateHeight) {
            cell.stackViewHeightConstriant.constant = 66.0 + inceptionDateHeight + minInvestHeight
        } else {
            cell.stackViewHeightConstriant.constant = 66.0 + investmentAmountHeight + minInvestHeight
        }
        
        return cell
    }
    
    fileprivate func descriptionCellView(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DescriptionTableViewCell.identifier, for: indexPath) as! DescriptionTableViewCell
        cell.heading1.text = "Objective"
        cell.heading2.text = "Who Should Invest"
        cell.heading3.text = "Key Benefits"
        cell.investLbl.text = fund_details?.whoShouldInvest
        cell.descriptionLbl.text = fund_details?.objective
        let keyBenfit =  fund_details?.keyBenefits
            //?.replacingOccurrences(of: "•", with: "\n\n\u{2022}", options: NSString.CompareOptions.literal, range: nil)
        if let keyBenfit_value = keyBenfit {
            cell.keyBenfitsLbl.text = keyBenfit_value
        }
        return cell
    }
    
    fileprivate func keyFeatureCellView(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: KeyFeatureCell.identifier, for: indexPath) as! KeyFeatureCell
        if let risk_profile = fund_details?.investorRiskProfile {
            cell.investorRiskLbl.text = risk_profile.filter( { !$0.isNewline} )
        }
        cell.entryLoadLbl.text  =   fund_details?.entryLoad
        cell.exitLoadLbl.text   =   fund_details?.exitLoad
        cell.managementLbl.text =   fund_details?.managementFee
        cell.fundNameLbl.text   =   "Key Features"
        if let bench_mark = fund_details?.benchmark {
            cell.benchmarkLbl.text = bench_mark.filter( { !$0.isNewline} )
        }
        return cell
    }
    
    fileprivate func extraFeatureCellView(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ExtraFeatureCell.identifier, for: indexPath) as! ExtraFeatureCell
        cell.lockInPeriodLbl.text   =   fund_details?.lockInPeriod ?? "Not Available"
        cell.payoutPolicyLbl.text   =   fund_details?.payoutPolicy ?? "Not Available"
        if fund_details?.payoutPolicy == "" {
            cell.payoutPolicyLbl.text   = "Not Available"
        }
        if fund_details?.lockInPeriod == "" {
            cell.lockInPeriodLbl.text   = "Not Available"
        }
        
        let width = cell.payoutView.frame.width
        let payoutPolicyLblHeight = fund_details?.payoutPolicy?.height(withConstrainedWidth: width, font: UIFont(name: "Roboto-Regular", size: 12)!) ?? 16.0
        let lockInPeriodLblHeight = fund_details?.lockInPeriod?.height(withConstrainedWidth: width, font: UIFont(name: "Roboto-Regular", size: 12)!) ?? 16.0
        
        if payoutPolicyLblHeight.isLess(than: lockInPeriodLblHeight) {
            cell.stackViewHeight.constant = 88.0 + lockInPeriodLblHeight
        } else {
            cell.stackViewHeight.constant = 88.0 + payoutPolicyLblHeight
        }
        return cell
    }
    
    fileprivate func graphCellView(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: GraphCell.identifier, for: indexPath) as! GraphCell
        cell.data = fund_details
        return cell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let imgURL = fund_details?.thumbnail {
            if indexPath.section == 0 {
                return detailBoxView(tableView, indexPath)
            } else if indexPath.section == 1 {
                return descriptionCellView(tableView, indexPath)
            }
            else if indexPath.section == 2 {
                return keyFeatureCellView(tableView, indexPath)
            }
            else if indexPath.section == 3 {
                return extraFeatureCellView(tableView, indexPath)
            } else if indexPath.section == 4 {
                return graphCellView(tableView, indexPath)
            } else if indexPath.section == 5 {
                let cell = tableView.dequeueReusableCell(withIdentifier: VideoViewCell.identifier, for: indexPath) as! VideoViewCell
                if let imgURL = fund_details?.thumbnail {
                    cell.imgView.sd_setImage(with: URL(string: imgURL), placeholderImage: UIImage(named: "logo.png"))
                }
                return cell
            } else {
                let disclaimerCell = tableView.dequeueReusableCell(withIdentifier: DisclaimerViewCell.identifier, for: indexPath) as! DisclaimerViewCell
                disclaimerCell.disclaimerLbl.text =  fund_details?.disclaimer ?? "Not Available"
                return disclaimerCell
            }
        } else {
            if indexPath.section == 0 {
                return detailBoxView(tableView, indexPath)
            } else if indexPath.section == 1 {
                return descriptionCellView(tableView, indexPath)
            }
            else if indexPath.section == 2 {
                return keyFeatureCellView(tableView, indexPath)
            }
            else if indexPath.section == 3 {
                return extraFeatureCellView(tableView, indexPath)
            } else if indexPath.section == 4 {
                return graphCellView(tableView, indexPath)
            } else {
                let disclaimerCell = tableView.dequeueReusableCell(withIdentifier: DisclaimerViewCell.identifier, for: indexPath) as! DisclaimerViewCell
                disclaimerCell.disclaimerLbl.text =  fund_details?.disclaimer ?? "Not Available"
                return disclaimerCell
            }
        }
        
        
        
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.section
        if let imgURL = fund_details?.thumbnail {
            if index == 5  {
                let vc = BlogsViewController.instantiateFromAppStroyboard(appStoryboard: .main)
                vc.urlStr = fund_details?.youtubeLink ?? ""
                vc.titleStr = "Awareness Videos"
                navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}

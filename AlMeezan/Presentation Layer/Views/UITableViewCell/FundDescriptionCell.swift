//
//  FundDescriptionCell.swift
//  AlMeezan
//
//  Created by Atta khan on 07/10/2019.
//  Copyright © 2019 Atta khan. All rights reserved.
//

import UIKit

class FundDescriptionCell: UITableViewCell {

    
    @IBOutlet weak var fundNameLbl: UILabel!
    @IBOutlet weak var riskProfileLbl: UILabel!
    @IBOutlet weak var launchdateLbl: UILabel!
    @IBOutlet weak var keyBenefitLbl: UILabel!
    @IBOutlet weak var backendLoadLbl: UILabel!
    @IBOutlet weak var frontEndLoadLbl: UILabel!
    @IBOutlet weak var managementFeeLbl: UILabel!
    @IBOutlet weak var tenureLbl: UILabel!
    @IBOutlet weak var maturityDateLbl: UILabel!
    static var identifier: String{
        return String(describing: self)
    }
    static var nib: UINib{
        return UINib(nibName: identifier, bundle: nil)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    var data: FundOfFund? {
        didSet {
            guard let data = data else { return }
            
            if let maturityDate = data.maturityDate {
                maturityDateLbl.text        =   maturityDate
            } else {
                maturityDateLbl.text        =   "Not Available"
            }
            
            if let fundCategory = data.fundName {
                fundNameLbl.text        =   fundCategory
            } else {
                fundNameLbl.text        =   "Not Available"
            }
            
            if let investorRiskProfile = data.investorRiskProfile {
                riskProfileLbl.text     =   investorRiskProfile
            } else {
                riskProfileLbl.text     =   "Not Available"
            }
            if let launchDate = data.launchDate {
                launchdateLbl.text     =   launchDate
            } else {
                launchdateLbl.text     =   "Not Available"
            }
            if let uniqueBenefit = data.uniqueBenefit {
                keyBenefitLbl.text     =   uniqueBenefit
            } else {
                keyBenefitLbl.text     =   "Not Available"
            }
            if let backEndLoad = data.backEndLoad {
                backendLoadLbl.text     =   backEndLoad
            } else {
                backendLoadLbl.text     =   "Not Available"
            }
            if let frontEndLoad = data.frontEndLoad {
                frontEndLoadLbl.text     =   frontEndLoad
            } else {
                frontEndLoadLbl.text     =   "Not Available"
            }
            
            if let managementFee = data.managementFee {
                managementFeeLbl.text     =   managementFee
            } else {
                managementFeeLbl.text     =   "Not Available"
            }
        }
    }
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

//
//  PortfolioViewCell.swift
//  AlMeezan
//
//  Created by Atta khan on 04/11/2019.
//  Copyright © 2019 Atta khan. All rights reserved.
//

import UIKit

class PortfolioViewCell: UICollectionViewCell {

    @IBOutlet weak var portfolioIdLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var contactNbLbl: UILabel!
    @IBOutlet weak var pageController: UIPageControl!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var bankName: UILabel!
    @IBOutlet weak var dividendLbl: UILabel!
    @IBOutlet weak var accountNbLbl: UILabel!
    @IBOutlet weak var zakatStatus: UILabel!
    @IBOutlet weak var operationalLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    var customer: CustomerDetail? {
           didSet {
            guard let data = customer else { return }
            nameLbl.text = data.customer_Name
            contactNbLbl.text = data.mobile
            addressLbl.text = data.address
            email.text = data.email
            bankName.text = data.bANK_NAME
            dividendLbl.text = data.dIVIDEND_MANADATE
            accountNbLbl.text = data.bANK_ACCOUNT_NO
            zakatStatus.text = data.iS_ZAKAT_EXEMPT == "Y" ? "Exempted" : "Not-Exempted"
            operationalLbl.text = data.oPERATIN_INSTRUCTIONS
            portfolioIdLbl.text = data.portfolio_ID
        }
           
       }
    
    
}

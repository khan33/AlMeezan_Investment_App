//
//  ActiveCompanyViewCell.swift
//  AlMeezan
//
//  Created by Atta khan on 20/11/2019.
//  Copyright © 2019 Atta khan. All rights reserved.
//

import UIKit

class ActiveCompanyViewCell: UITableViewCell {
    
    @IBOutlet weak var sectorLbl: UILabel!
    @IBOutlet weak var volumeLbl: UILabel!
    
    static var identifier: String {
        return String(describing: self)
    }
    static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    var sectorData: PSXSectorTopModel? {
        didSet {
            guard let list = sectorData else {
                return
            }
            sectorLbl.text = list.sector
            volumeLbl.text = "\(String(describing:list.volume ?? 0).toCurrencyFormat(withFraction: false))"
            
        }
    }
    var companyData: ActiveCompanies? {
        didSet {
            guard let list = companyData else {
                return
            }
            sectorLbl.text = list.symbol
            volumeLbl.text = "\(String(describing:list.volume ?? 0).toCurrencyFormat(withFraction: false))"
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

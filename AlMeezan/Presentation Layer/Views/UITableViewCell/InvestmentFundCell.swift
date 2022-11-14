//
//  InvestmentFundCell.swift
//  AlMeezan
//
//  Created by Atta khan on 14/11/2019.
//  Copyright © 2019 Atta khan. All rights reserved.
//

import UIKit

class InvestmentFundCell: UITableViewCell {

    @IBOutlet weak var lossLbl: UILabel!
    @IBOutlet weak var gainLbl: UILabel!
    @IBOutlet weak var valueLbl: UILabel!
    @IBOutlet weak var NAVLbl: UILabel!
    @IBOutlet weak var unitsLbl: UILabel!
    @IBOutlet weak var fundLbl: UILabel!
    
    @IBOutlet weak var fundBtn: UIButton!
    static var identifier: String{
        return String(describing: self)
    }
    static var nib: UINib{
        return UINib(nibName: identifier, bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        lossLbl.textColor = UIColor.themeLblColor
//        gainLbl.textColor = UIColor.themeLblColor
//        valueLbl.textColor = UIColor.themeLblColor
//        NAVLbl.textColor = UIColor.themeLblColor
//        unitsLbl.textColor = UIColor.themeLblColor

    }
 
    var investmentFund: Summary? {
        didSet {
            guard let data = investmentFund else {
                return
            }
            fundLbl.text = data.fundShortName
            let balance_unit = data.balunits
            if balance_unit.isZero {
                unitsLbl.text = "-"
            } else {
                unitsLbl.text = String(format: "%.2f", balance_unit).toCurrencyFormat(withFraction: true)
            }
            let nav_value = data.nav
            if nav_value.isZero {
                NAVLbl.text = "-"
            } else {
                NAVLbl.text = String(format: "%.2f", nav_value).toCurrencyFormat(withFraction: true)
            }
            let market_value = data.marketValue
            if market_value.isZero {
                valueLbl.text = "-"
            } else {
                valueLbl.text = String(describing: market_value).toCurrencyFormat(withFraction: false)
            }
            let fYGain_value = data.fYGain
            if fYGain_value.isZero {
                gainLbl.text = "-"
            } else {
                gainLbl.text = String(describing: fYGain_value).toCurrencyFormat(withFraction: false)
                    //String(format: "%.2f", fYGain_value).toCurrencyFormat()
            }
            
            let gain_value = data.sinceInceptionGain
            if gain_value.isZero {
                lossLbl.text = "-"
            } else {
                lossLbl.text = String(describing: gain_value).toCurrencyFormat(withFraction: false)
                    //String(format: "%.2f", gain_value).toCurrencyFormat()
            }
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

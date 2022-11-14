//
//  DeclinersTableViewCell.swift
//  AlMeezan
//
//  Created by Atta khan on 20/11/2019.
//  Copyright © 2019 Atta khan. All rights reserved.
//

import UIKit

class DeclinersTableViewCell: UITableViewCell {
    
    @IBOutlet weak var netChange: UILabel!
    @IBOutlet weak var lastLbl: UILabel!
    @IBOutlet weak var companyNameLbl: UILabel!
    @IBOutlet weak var highLbl: UILabel!
    @IBOutlet weak var lowLbl: UILabel!
    @IBOutlet weak var sectorLbl: UILabel!
    @IBOutlet weak var closeValueLbl: UILabel!
    @IBOutlet weak var openLbl: UILabel!
    @IBOutlet weak var volumeLbl: UILabel!
    @IBOutlet weak var changePrcLbl: UILabel!
    
    @IBOutlet weak var imgView: UIImageView!
    
    
    var state: String?
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

    
    var data: PSXCompaniesTopModel? {
        didSet {
            guard let list = data else {
                return
            }
            lastLbl.text = "\(String(describing: list.last).toCurrencyFormat(withFraction: true))"
            companyNameLbl.text = list.symbol
            sectorLbl.text = list.sector
            closeValueLbl.text = String(format: "%.2f", Float(list.lDCP)).toCurrencyFormat(withFraction: true)
                //String(format: "%.2f", Float(list.lastTradeVolume)).toCurrencyFormat()
            openLbl.text = "\(String(describing: list.open))"
            highLbl.text = "\(String(describing: list.high ))"
            lowLbl.text = "\(String(describing: list.low ))"
            volumeLbl.text = "\(String(describing: list.volume).toCurrencyFormat(withFraction: false))"
            
        }
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

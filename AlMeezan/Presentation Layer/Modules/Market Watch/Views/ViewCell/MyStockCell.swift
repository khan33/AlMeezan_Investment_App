//
//  MyStockCell.swift
//  AlMeezan
//
//  Created by Atta khan on 25/11/2019.
//  Copyright © 2019 Atta khan. All rights reserved.
//

import UIKit

class MyStockCell: UITableViewCell {

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
    
    @IBOutlet weak var removeStockBtn: UIButton!
    
    
    static var identifier: String {
        return String(describing: self)
    }
    static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    var data: MyStockModel? {
        didSet {
            guard let list = data else {
                return
            }
            
            if let direction = list.direction {
                if direction == "-" {
                    imgView.image =  UIImage(named: "redArrow")
                } else {
                    imgView.image = UIImage(named: "upArrow")
                }
            }
            if let lastValue = list.last, lastValue != 0.0 {
                lastLbl.text = String(describing: lastValue).numberFormatter()
            } else {
                lastLbl.text = "-"
            }
            
            
            if let netValue = list.netChange?.rounded(toPlaces: 2), netValue != 0.0 {
                if netValue.isLess(than: 0) {
                    netChange.textColor = UIColor.init(rgb: 0xF54F4F)
                } else {
                    netChange.textColor = UIColor.init(rgb: 0x47AE0A)
                }
                netChange.text = String(describing: netValue)
            } else {
                netChange.text = "-"
            }

            if let changePercValue = list.changePerc?.rounded(toPlaces: 2), changePercValue != 0.0 {
                if changePercValue.isLess(than: 0) {
                    changePrcLbl.textColor = UIColor.init(rgb: 0xF54F4F)
                } else {
                    changePrcLbl.textColor = UIColor.init(rgb: 0x47AE0A)
                }
                changePrcLbl.text =  "\(String(describing: changePercValue))%"
            } else {
                changePrcLbl.text = "-"
            }
            companyNameLbl.text = list.symbol
            sectorLbl.text = list.sector

            if let tradeValue = list.lDCP, tradeValue != 0.0 {
                closeValueLbl.text =  String(format: "%.2f", tradeValue).toCurrencyFormat(withFraction: true)

            } else {
                closeValueLbl.text = "-"
            }

            if let openValue = list.open, openValue != 0.0 {
                openLbl.text = String(describing: openValue).numberFormatter()
                    //String(format: "%.2f", openValue)

            } else {
                openLbl.text = "-"
            }

            if let highValue = list.high, highValue != 0.0 {
                highLbl.text = String(describing: highValue).numberFormatter()
                    //String(format: "%.2f", highValue)

            } else {
                highLbl.text = "-"
            }

            if let lowValue = list.low, lowValue != 0.0 {
                lowLbl.text = String(describing: lowValue).numberFormatter()
                    //String(format: "%.2f", lowValue)


            } else {
                lowLbl.text = "-"
            }

            if let volumeValue = list.volume, volumeValue != 0.0 {
                volumeLbl.text =  String(format: "%.2f", volumeValue).toCurrencyFormat(withFraction: false)

            } else {
                volumeLbl.text = "-"
            }

            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

//
//  IndicesHeaderCell.swift
//  AlMeezan
//
//  Created by Atta khan on 23/11/2019.
//  Copyright © 2019 Atta khan. All rights reserved.
//

import UIKit

class IndicesHeaderCell: UITableViewCell {

    @IBOutlet weak var KSELbl: UILabel!
    @IBOutlet weak var valueLbl1: UILabel!
    @IBOutlet weak var valueLbl2: UILabel!
    @IBOutlet weak var valueLbl3: UILabel!
    
    @IBOutlet weak var previousLbl: UILabel!
    @IBOutlet weak var highLbl: UILabel!
    @IBOutlet weak var volumePKRLbl: UILabel!
    @IBOutlet weak var volumeShareLbl: UILabel!
    @IBOutlet weak var lowLbl: UILabel!

    @IBOutlet weak var expandBtn: UIButton!
    
    static var identifier: String {
        return String(describing: self)
    }
    static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        valueLbl1.textColor = UIColor.themeColor
    }

    var data: PSXIndixesModel? {
        didSet {
            guard let list = data else {
                return
            }
            KSELbl.text = list.symbol
            if let currentIndex = list.currentIndex {
                valueLbl1.text = String(format: "%.2f", Float(currentIndex)).toCurrencyFormat(withFraction: true)
            } else {
                valueLbl1.text = "-"
            }
            
            if let netChange = list.netChange {
                if netChange.isLess(than: 0) {
                    valueLbl2.textColor = UIColor.init(rgb: 0xF54F4F)
                } else {
                    valueLbl2.textColor = UIColor.init(rgb: 0x47AE0A)
                }
                valueLbl2.text = String(format: "%.2f", Float(netChange)).toCurrencyFormat(withFraction: true)
            } else {
                valueLbl2.text = "-"
            }
            
            
            if let pNetChange = list.pNetChange {
                if pNetChange.isLess(than: 0) {
                    valueLbl3.textColor = UIColor.init(rgb: 0xF54F4F)
                } else {
                    valueLbl3.textColor = UIColor.init(rgb: 0x47AE0A)
                }
                let netValue = String(format: "%.2f", Float(pNetChange)).toCurrencyFormat(withFraction: true)
                valueLbl3.text = "\(netValue)%"
            } else {
                valueLbl3.text = "-"
            }
            
            if let previousIndex = list.previousIndex {
                previousLbl.text = String(format: "%.2f", Float(previousIndex)).toCurrencyFormat(withFraction: true)
            } else {
                previousLbl.text = "-"
            }
            
            if let highVal = list.high {
                highLbl.text = String(format: "%.2f", Float(highVal)).toCurrencyFormat(withFraction: true)
            } else {
                highLbl.text = "-"
            }
            
            if let lowVal = list.low {
                lowLbl.text = String(describing: lowVal).toCurrencyFormat(withFraction: true)
            } else {
                lowLbl.text = "-"
            }
            volumeShareLbl.text = "\(String(describing:  Utility.shared.formatPoints(num: list.volume ?? 0.0) ?? "0"))"
            volumePKRLbl.text = "\(String(describing: Utility.shared.formatPoints(num: list.value ?? 0.0) ?? "0"))"
        }
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

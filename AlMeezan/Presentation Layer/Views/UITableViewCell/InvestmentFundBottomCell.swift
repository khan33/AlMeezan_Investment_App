//
//  InvestmentFundHeaderCell.swift
//  AlMeezan
//
//  Created by Atta khan on 14/11/2019.
//  Copyright © 2019 Atta khan. All rights reserved.
//

import UIKit

class InvestmentFundBottomCell
: UITableViewCell {

    @IBOutlet weak var lossLbl: UILabel!
    @IBOutlet weak var gainLbl: UILabel!
    @IBOutlet weak var valueLbl: UILabel!
    @IBOutlet weak var NAVLbl: UILabel!
    @IBOutlet weak var unitsLbl: UILabel!
    @IBOutlet weak var fundLbl: UILabel!
    
    @IBOutlet weak var totalLbl: UILabel!
    @IBOutlet weak var ficalYearLbl: UILabel!
    @IBOutlet weak var sinceInceptionLbl: UILabel!
    static var identifier: String{
        return String(describing: self)
    }
    static var nib: UINib{
        return UINib(nibName: identifier, bundle: nil)
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        lossLbl.textColor = UIColor.themeColor
        gainLbl.textColor = UIColor.themeColor
        valueLbl.textColor = UIColor.themeColor
        //totalLbl.textColor = UIColor.themeColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

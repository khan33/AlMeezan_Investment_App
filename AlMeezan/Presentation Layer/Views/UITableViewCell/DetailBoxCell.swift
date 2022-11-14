//
//  DetailBoxCell.swift
//  AlMeezan
//
//  Created by Atta khan on 08/10/2019.
//  Copyright © 2019 Atta khan. All rights reserved.
//

import UIKit

class DetailBoxCell: UITableViewCell {

    @IBOutlet weak var inceptionDateLbl: UILabel!
    @IBOutlet weak var investmentAmountLbl: UILabel!
    
    @IBOutlet weak var dateOfInceptionLbl: UILabel!
    
    @IBOutlet weak var minimumInvestmentLbl: UILabel!
    @IBOutlet weak var inceptionView: UIView!
    @IBOutlet weak var stackViewHeightConstriant: NSLayoutConstraint!
    
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

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

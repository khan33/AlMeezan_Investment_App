//
//  ExtraFeatureCell.swift
//  AlMeezan
//
//  Created by Atta khan on 08/10/2019.
//  Copyright © 2019 Atta khan. All rights reserved.
//

import UIKit

class ExtraFeatureCell: UITableViewCell {
    
    @IBOutlet weak var stackViewHeight: NSLayoutConstraint!
    @IBOutlet weak var lockedInBottom: NSLayoutConstraint!
    @IBOutlet weak var lockInBottomConstriant: NSLayoutConstraint!
    @IBOutlet weak var payoutBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var payoutView: UIView!
    @IBOutlet weak var lockInPeriodLbl: UILabel!
    @IBOutlet weak var payoutPolicyLbl: UILabel!
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

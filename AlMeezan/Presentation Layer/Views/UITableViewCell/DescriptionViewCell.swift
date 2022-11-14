//
//  DescriptionViewCell.swift
//  AlMeezan
//
//  Created by Atta khan on 07/10/2019.
//  Copyright © 2019 Atta khan. All rights reserved.
//

import UIKit

class DescriptionViewCell: UITableViewCell {
    
    
    @IBOutlet weak var fundLblName: UILabel!
    
    @IBOutlet weak var detailsLbl: UILabel!
    
    @IBOutlet weak var borderLine: UIView!
    @IBOutlet weak var indicatorBtn: UIButton!
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

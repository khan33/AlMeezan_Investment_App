//
//  SectorViewCell.swift
//  AlMeezan
//
//  Created by Atta khan on 10/09/2020.
//  Copyright © 2020 Atta khan. All rights reserved.
//

import UIKit

class SectorViewCell: UITableViewCell {

    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var companyLbl: UILabel!
    @IBOutlet weak var industryLbl: UILabel!
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

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

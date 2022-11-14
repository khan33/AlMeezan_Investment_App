//
//  FundsViewCell.swift
//  AlMeezan
//
//  Created by Atta khan on 04/10/2019.
//  Copyright © 2019 Atta khan. All rights reserved.
//

import UIKit

class FundsViewCell: UITableViewHeaderFooterView {

    @IBOutlet weak var fundNameLbl: UILabel!
    @IBOutlet weak var cellBtn: UIButton!
    @IBOutlet weak var indicatorBtn: UIButton!
    static var identifier: String{
        return String(describing: self)
    }
    static var nib: UINib{
        return UINib(nibName: identifier, bundle: nil)
    }
    
    override func prepareForReuse() {
        //fundNameLbl.textColor = UIColor.init(rgb: 0x232746)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
}

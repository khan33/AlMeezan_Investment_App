//
//  FundHeaderCell.swift
//  AlMeezan
//
//  Created by Atta khan on 01/10/2019.
//  Copyright © 2019 Atta khan. All rights reserved.
//

import UIKit

class FundHeaderCell: UITableViewHeaderFooterView {

    @IBOutlet weak var fundGroupName: UILabel!
    static var identifier: String{
        return String(describing: self)
    }
    static var nib: UINib{
        return UINib(nibName: identifier, bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        contentView.backgroundColor = UIColor(red: 244.0 / 255.0, green: 246.0 / 255.0, blue: 255.0 / 255.0, alpha: 1)
    }
}

//
//  FundsExpandableViewCell.swift
//  AlMeezan
//
//  Created by Atta khan on 04/10/2019.
//  Copyright © 2019 Atta khan. All rights reserved.
//

import UIKit

class FundsExpandableViewCell: UITableViewCell {
    
    @IBOutlet weak var fundNameLbl: UILabel!
    @IBOutlet weak var indicatorBtn: UIButton!
    @IBOutlet weak var innerTableView: UITableView!
    
    @IBOutlet weak var bottomView: UIView!
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
    override func prepareForReuse() {
        fundNameLbl.textColor = UIColor.init(rgb: 0x008641)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
   
    
}

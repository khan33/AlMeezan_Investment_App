//
//  ForexViewCell.swift
//  AlMeezan
//
//  Created by Atta khan on 21/11/2019.
//  Copyright © 2019 Atta khan. All rights reserved.
//

import UIKit

class ForexViewCell: UITableViewCell {
    
    @IBOutlet weak var currencyLbl: UILabel!
    
    @IBOutlet weak var sellingLbl: UILabel!
    @IBOutlet weak var buyingLbl: UILabel!
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
    
    
    var forexData: ForexEntity.ForexViewModel! {
        didSet {
            currencyLbl.text = forexData.symbol
            sellingLbl.text = "\(String(format: "%.2f", forexData.close))"
            buyingLbl.text = "\(String(format: "%.2f", forexData.open))"
        }
    }
    
    
}

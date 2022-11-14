//
//  HomeTableViewCell.swift
//  AlMeezan
//
//  Created by Atta khan on 04/09/2019.
//  Copyright © 2019 Atta khan. All rights reserved.
//

import UIKit

class HomeTableViewCell: UITableViewCell {

    
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

//
//  CityViewCell.swift
//  AlMeezan
//
//  Created by Atta khan on 03/10/2019.
//  Copyright © 2019 Atta khan. All rights reserved.
//

import UIKit

class CityViewCell: UITableViewCell {

    
    static var identifier: String{
        return String(describing: self)
    }
    static var nib: UINib{
        return UINib(nibName: identifier, bundle: nil)
    }
    
    @IBOutlet weak var txtLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

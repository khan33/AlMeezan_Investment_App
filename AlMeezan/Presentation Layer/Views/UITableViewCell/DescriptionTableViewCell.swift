//
//  DescriptionTableViewCell.swift
//  AlMeezan
//
//  Created by Atta khan on 10/12/2019.
//  Copyright © 2019 Atta khan. All rights reserved.
//

import UIKit

class DescriptionTableViewCell: UITableViewCell {
    static var identifier: String{
       return String(describing: self)
    }
    static var nib: UINib{
       return UINib(nibName: identifier, bundle: nil)
    }
    @IBOutlet weak var descriptionLbl: UILabel!

    @IBOutlet weak var keyBenfitsLbl: UILabel!
    @IBOutlet weak var investLbl: UILabel!
    
    @IBOutlet weak var heading1: UILabel!
    @IBOutlet weak var heading2: UILabel!
    @IBOutlet weak var heading3: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

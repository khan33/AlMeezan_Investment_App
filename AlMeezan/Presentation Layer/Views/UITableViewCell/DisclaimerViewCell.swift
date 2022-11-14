//
//  DisclaimerViewCell.swift
//  AlMeezan
//
//  Created by Atta khan on 02/07/2020.
//  Copyright © 2020 Atta khan. All rights reserved.
//

import UIKit

class DisclaimerViewCell: UITableViewCell {

    static var identifier: String{
      return String(describing: self)
    }
    static var nib: UINib{
      return UINib(nibName: identifier, bundle: nil)
    }
    @IBOutlet weak var disclaimerLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

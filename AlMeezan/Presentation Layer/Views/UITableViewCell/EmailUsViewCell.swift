//
//  EmailUsViewCell.swift
//  AlMeezan
//
//  Created by Atta khan on 26/11/2019.
//  Copyright © 2019 Atta khan. All rights reserved.
//

import UIKit

class EmailUsViewCell: UITableViewCell {
    @IBOutlet weak var nameTxtField: UITextField!
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var detailsTxtView: UITextView!
    @IBOutlet weak var detailsView: UIView!
    @IBOutlet weak var totalTxtCount: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var detailsLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var submitBtn: UIButton!
    
    @IBOutlet weak var portfolioIdBtn: UIButton!
    
    @IBOutlet weak var complainTypeBtn: UIButton!
    
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

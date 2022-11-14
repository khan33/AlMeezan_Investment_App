//
//  ContactViewCell.swift
//  AlMeezan
//
//  Created by Atta khan on 21/10/2019.
//  Copyright © 2019 Atta khan. All rights reserved.
//

import UIKit

class ContactViewCell: UITableViewCell {
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var nameTxtField: UITextField!
    
    @IBOutlet weak var countryTxtField: UITextField!
    @IBOutlet weak var cityTxtField: UITextField!
    @IBOutlet weak var phoneNumberTxtField: UITextField!

    
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var cityLbl: UILabel!
    @IBOutlet weak var phoneNumberLbl: UILabel!
    @IBOutlet weak var nameBorderLine: UIView!
    @IBOutlet weak var phoneNumberLine: UIView!
    @IBOutlet weak var cityIndicatorBtn: UIButton!
    @IBOutlet weak var cityBottomLine: UIView!
    @IBOutlet weak var locationBottomView: UIView!
    @IBOutlet weak var cityView: UIView!
    @IBOutlet weak var phoneTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var submitBtn: UIButton!
    
    
    
    @IBOutlet weak var contactTopView: UIView!
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

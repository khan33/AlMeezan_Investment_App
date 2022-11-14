//
//  FundFilterCell.swift
//  AlMeezan
//
//  Created by Atta khan on 14/10/2019.
//  Copyright © 2019 Atta khan. All rights reserved.
//

import UIKit

class FundFilterCell: UITableViewCell {
    
    @IBOutlet weak var riskLevelBtn: UIButton!
    @IBOutlet weak var fundCategoryBtn: UIButton!
    @IBOutlet weak var riskLevelfield: UITextField!
    @IBOutlet weak var fundCategoryField: UITextField!
    @IBOutlet weak var entryLoadField: UITextField!
    @IBOutlet weak var entryLoadBtn: UIButton!
    @IBOutlet weak var exitLoadField: UITextField!
    @IBOutlet weak var exitLoadBtn: UIButton!
    @IBOutlet weak var managementFeeField: UITextField!
    @IBOutlet weak var manaegmentBtn: UIButton!
    @IBOutlet weak var fundSizeField: UITextField!
    @IBOutlet weak var fundSizeBtn: UIButton!
    

    @IBOutlet weak var resetBtn: UIButton!
    
    @IBOutlet weak var exitStackView: UIStackView!
    @IBOutlet weak var fundSizeStackView: UIStackView!
    @IBOutlet weak var fundSizeHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var exitLoadHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var fundCategoryView: UIView!
    @IBOutlet weak var exitLoadView: UIView!
    @IBOutlet weak var entryLoadView: UIView!
    @IBOutlet weak var fundSizeView: UIView!
    
    @IBOutlet weak var fundCountLbl: UILabel!
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

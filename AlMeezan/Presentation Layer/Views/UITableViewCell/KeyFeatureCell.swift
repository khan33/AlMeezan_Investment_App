//
//  KeyFeatureCell.swift
//  AlMeezan
//
//  Created by Atta khan on 08/10/2019.
//  Copyright © 2019 Atta khan. All rights reserved.
//

import UIKit

class KeyFeatureCell: UITableViewCell {
    
    @IBOutlet weak var fundNameLbl: UILabel!
    @IBOutlet weak var entryLoadLbl: UILabel!
    @IBOutlet weak var benchmarkLbl: UILabel!
    @IBOutlet weak var exitLoadLbl: UILabel!
    @IBOutlet weak var investorRiskLbl: UILabel!
    @IBOutlet weak var managementLbl: UILabel!
    
    
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

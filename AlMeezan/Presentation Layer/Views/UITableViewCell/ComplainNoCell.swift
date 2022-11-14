//
//  ComplainNoCell.swift
//  AlMeezan
//
//  Created by Atta khan on 26/11/2019.
//  Copyright © 2019 Atta khan. All rights reserved.
//

import UIKit

class ComplainNoCell: UITableViewCell {

    
    @IBOutlet weak var complainNoLbl: UILabel!
    
    static var identifier: String{
       return String(describing: self)
    }
    static var nib: UINib{
       return UINib(nibName: identifier, bundle: nil)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        complainNoLbl.text = "-"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var data : ComplaintModel? {
        didSet {
            guard let list = data else {
                return
            }
            complainNoLbl.text = list.complaint_Number
        }
    }
    
}

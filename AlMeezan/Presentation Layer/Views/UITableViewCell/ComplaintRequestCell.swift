//
//  ComplaintRequestCell.swift
//  AlMeezan
//
//  Created by Atta khan on 26/11/2019.
//  Copyright © 2019 Atta khan. All rights reserved.
//

import UIKit

class ComplaintRequestCell: UITableViewCell {

    @IBOutlet weak var typeBtn: UIButton!
    @IBOutlet weak var statusBtn: UIButton!
    @IBOutlet weak var statusTxtField: UITextField!
    @IBOutlet weak var typeTxtField: UITextField!
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

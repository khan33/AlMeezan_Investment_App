//
//  LeftMenuHeaderCell.swift
//  AlMeezan
//
//  Created by Atta khan on 25/10/2019.
//  Copyright © 2019 Atta khan. All rights reserved.
//

import UIKit

class LeftMenuHeaderCell: UITableViewCell {

    @IBOutlet weak var cellBtn: UIButton!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var menuTitle: UILabel!
    @IBOutlet weak var indicatorBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    static var identifier: String{
        return String(describing: self)
    }
    static var nib: UINib{
        return UINib(nibName: identifier, bundle: nil)
    }
    
}

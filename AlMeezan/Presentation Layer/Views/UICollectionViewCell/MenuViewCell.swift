//
//  MenuViewCell.swift
//  AlMeezan
//
//  Created by Atta khan on 18/09/2019.
//  Copyright © 2019 Atta khan. All rights reserved.
//

import UIKit

class MenuViewCell: UICollectionViewCell {
    
    @IBOutlet weak var indicatorLine: UIView!
    @IBOutlet weak var menuTxt: UILabel!
    static var identifier: String {
        return String(describing: self)
    }
    static var nib: UINib{
        return UINib(nibName: identifier, bundle: nil)
    }
    
    
    
    override var isHighlighted: Bool {
        didSet {
            print(isHighlighted)
            menuTxt.textColor = isHighlighted ? UIColor.white : UIColor(red: 255.0, green: 255.0, blue: 255.0, alpha: 0.7)
            indicatorLine.isHidden = isHighlighted ? false : true
        }
    }
    
    override var isSelected: Bool {
        didSet {
            menuTxt.textColor = isSelected ? UIColor.white : UIColor(red: 255.0, green: 255.0, blue: 255.0, alpha: 0.7)
            indicatorLine.isHidden = isHighlighted ? false : true
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}

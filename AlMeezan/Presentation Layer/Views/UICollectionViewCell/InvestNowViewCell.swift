//
//  InvestNowViewCell.swift
//  AlMeezan
//
//  Created by Atta khan on 18/09/2019.
//  Copyright © 2019 Atta khan. All rights reserved.
//

import UIKit

class InvestNowViewCell: UICollectionViewCell {

    static var identifier: String {
        return String(describing: self)
    }
    static var nib: UINib{
        return UINib(nibName: identifier, bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}

//
//  VideoViewCell.swift
//  AlMeezan
//
//  Created by Atta khan on 15/01/2020.
//  Copyright © 2020 Atta khan. All rights reserved.
//

import UIKit

class VideoViewCell: UITableViewCell {
    
    @IBOutlet weak var imgView: UIImageView!
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

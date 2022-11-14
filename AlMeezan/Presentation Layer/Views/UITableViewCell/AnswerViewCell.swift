//
//  AnswerViewCell.swift
//  AlMeezan
//
//  Created by Atta khan on 15/10/2019.
//  Copyright © 2019 Atta khan. All rights reserved.
//

import UIKit

class AnswerViewCell: UITableViewCell {
    
    @IBOutlet weak var tickBtn: UIButton!
    @IBOutlet weak var answerTitleLbl: UILabel!
    
    @IBOutlet weak var tickImg: UIImageView!
    
    @IBOutlet weak var borderLine: UIView!
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

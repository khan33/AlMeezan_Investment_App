//
//  DocuemntUploadingCell.swift
//  AlMeezan
//
//  Created by Atta khan on 13/12/2022.
//  Copyright © 2022 Atta khan. All rights reserved.
//

import UIKit

class DocuemntUploadingCell: UITableViewCell {

    @IBOutlet weak var yearLbl: UILabel!
    
    @IBOutlet weak var uplaodingView: UIView!
    
    @IBOutlet weak var uploadBtn: UIButton!
    
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var fileNameLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

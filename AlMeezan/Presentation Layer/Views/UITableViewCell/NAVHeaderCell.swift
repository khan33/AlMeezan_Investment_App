//
//  NAVHeaderCell.swift
//  AlMeezan
//
//  Created by Atta khan on 11/09/2019.
//  Copyright © 2019 Atta khan. All rights reserved.
//

import UIKit

class NAVHeaderCell: UITableViewCell {

    
    @IBOutlet weak var tapBtn: UIButton!
    @IBOutlet weak var fundTitleLbl: UILabel!
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var indicatorBtn: UIButton!
    
    static var identifier: String{
        return String(describing: self)
    }
    static var nib: UINib{
        return UINib(nibName: identifier, bundle: nil)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        tapBtn.addTarget(self, action: #selector(handleTap), for: .touchUpInside)
    }
    @objc func handleTap(_ sender: UIButton) {
        didTapOnCell?()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateCell(_ section: Int) {
        fundTitleLbl.textColor = section == 0 ? UIColor.white : UIColor(red: 35.0 / 255.0, green: 39.0 / 255.0, blue: 70.0 / 255.0, alpha: 1)
        cellView.backgroundColor = section == 0 ? UIColor.themeColor : UIColor.white
        let img = section == 0 ? UIImage(named: "whiteIndicator") : UIImage(named: "chevronDown1")
        indicatorBtn.setImage(img, for: .normal)
    }
    
    var didTapOnCell : (() -> ())?

    var nav_data: NavEntity.NavViewModel.DisplayedFund? {
        didSet {
            guard let nav = nav_data else { return }
            
            fundTitleLbl.text = nav_data?.fundGroup
        }
    }
}



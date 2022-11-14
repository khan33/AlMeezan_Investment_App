//
//  SukookViewCell.swift
//  AlMeezan
//
//  Created by Atta khan on 07/09/2020.
//  Copyright © 2020 Atta khan. All rights reserved.
//

import UIKit

class SukookViewCell: UITableViewCell {
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var issueDateLbl: UILabel!
    @IBOutlet weak var couponRateLbl: UILabel!
    @IBOutlet weak var maurityDateLbl: UILabel!
    @IBOutlet weak var nextResetLbl: UILabel!
    @IBOutlet weak var yieldLbl: UILabel!
    static var identifier: String {
        return String(describing: self)
    }
    static var nib: UINib {
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
    
    
    var sukuk: SukukModel? {
        didSet {
            guard let data = sukuk else { return }
            descriptionLbl.text = data.description
            
            if let issueDate = data.issueDate?.toDate(withFormat: "yyyy-MM-dd'T'HH:mm:sss") {
                issueDateLbl.text = issueDate.toString(format: "d-MMM-yy")
            } else {
                nextResetLbl.text = "-"
            }
            
            
            if let maturityDate = data.maturityDate?.toDate(withFormat: "yyyy-MM-dd'T'HH:mm:sss") {
                maurityDateLbl.text = maturityDate.toString(format: "d-MMM-yy")
            } else {
                nextResetLbl.text = "-"
            }
            
            
            if let nextReset = data.nextReset?.toDate(withFormat: "yyyy-MM-dd'T'HH:mm:sss") {
                nextResetLbl.text = nextReset.toString(format: "d-MMM-yy")
            } else {
                nextResetLbl.text = "-"
            }
            
            if let couponRate = data.couponRate {
                couponRateLbl.text = "\(couponRate.rounded(toPlaces: 2))"
            } else {
                couponRateLbl.text = "-"
            }
            
            if let yield = data.yield {
                yieldLbl.text = "\(yield.rounded(toPlaces: 2))"
            } else {
                yieldLbl.text = "-"
            }
            
            
            
            
        }
    }
    
}

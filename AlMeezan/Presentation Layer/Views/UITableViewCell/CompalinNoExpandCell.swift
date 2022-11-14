//
//  CompalinNoExpandCell.swift
//  AlMeezan
//
//  Created by Atta khan on 26/11/2019.
//  Copyright © 2019 Atta khan. All rights reserved.
//

import UIKit

class CompalinNoExpandCell: UITableViewCell {

    
    @IBOutlet weak var complainNoLbl: UILabel!
    
    @IBOutlet weak var customerIdLbl: UILabel!
    
    @IBOutlet weak var resolvedDateLbl: UILabel!
    @IBOutlet weak var createdByLbl: UILabel!
    @IBOutlet weak var accountIdLbl: UILabel!
    @IBOutlet weak var statusLbl: UILabel!
    
    
    @IBOutlet weak var TATLbl: UILabel!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var subTypeLbl: UILabel!
    
    @IBOutlet weak var commentLbl: UILabel!
    
    @IBOutlet weak var descLbl: UILabel!
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
        accountIdLbl.text = "-"
        statusLbl.text = "-"
        createdByLbl.text = "-"
        customerIdLbl.text = "-"
        resolvedDateLbl.text = "-"
        TATLbl.text = "-"
        typeLbl.text = "-"
        subTypeLbl.text = "-"
        commentLbl.text = "-"
        descLbl.text = "-"
        
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
            accountIdLbl.text = list.account_ID
            statusLbl.text = list.status
            createdByLbl.text = list.createdOn
            customerIdLbl.text = list.customerNumber
            resolvedDateLbl.text = list.resolveDate
            TATLbl.text = list.tAT
            typeLbl.text = list.type
            subTypeLbl.text = list.subType
        }
    }
    
}

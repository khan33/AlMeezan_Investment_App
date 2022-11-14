//
//  StatusTransactionsViewCell.swift
//  AlMeezan
//
//  Created by Atta khan on 04/11/2019.
//  Copyright © 2019 Atta khan. All rights reserved.
//

import UIKit

class StatusTransactionsViewCell: UITableViewCell {

    
    @IBOutlet weak var fundLbl: UILabel!
    @IBOutlet weak var transLbl: UILabel!
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var channelLbl: UILabel!
    @IBOutlet weak var valueLbl: UILabel!
    
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
    var transaction: Transactions? {
        didSet {
            guard let data = transaction else {
                return
            }
            fundLbl.text = data.mnumenic
            transLbl.text = data.transDesc
            statusLbl.text = data.status
            channelLbl.text = data.channel
            if let amountVal = data.amount {
                valueLbl.text = "\(String(describing: amountVal ).toCurrencyFormat(withFraction: false))"
            } else {
                valueLbl.text = "-"
            }
        }
    }
    var transaction_details: TransactionDetail? {
        didSet {
            guard let data = transaction_details else {
                return
            }
            fundLbl.text = data.mnumenic
            transLbl.text = data.transDesc
            statusLbl.text = "\(String(describing: data.units ?? 0))"
            channelLbl.text = "\(String(describing: data.nav ?? 0))"
            valueLbl.text = "\(String(describing: data.amount ?? 0).toCurrencyFormat(withFraction: false))"
        }
    }
    
}

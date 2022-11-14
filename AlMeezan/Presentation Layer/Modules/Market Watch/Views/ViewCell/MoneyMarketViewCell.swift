//
//  MoneyMarketViewCell.swift
//  AlMeezan
//
//  Created by Atta khan on 21/11/2019.
//  Copyright © 2019 Atta khan. All rights reserved.
//

import UIKit

class MoneyMarketViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var bidLbl: UILabel!
    @IBOutlet weak var askLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    static var identifier: String {
        return String(describing: self)
    }
    static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
//    var state: MoneyMarketState = MoneyMarketState.kibor {
//        didSet {
//            print(state)
//            switch state {
//            case .kibor:
//                //bidLbl.isHidden = false
//               
//            default:
//                 //bidLbl.isHidden = true
//                break
//            }
//        }
//    }
    
    var data: KIBORDelayModel? {
        didSet {
            guard let list = data else {
                return
            }
            
            titleLbl.text = list.tenor
            askLbl.text = String(describing: list.ask).numberFormatter()
                
                //String(format: "%.2f", list.ask).toCurrencyFormat()
            bidLbl.text = String(describing: list.bid).numberFormatter()
                //String(format: "%.2f", list.bid).toCurrencyFormat()
            
            //bidLbl.text = "\(String(describing:list.bid ?? 0).toCurrencyFormat())"
        }
    }
    
    var PKRdata: PKRVDelayModel? {
        didSet {
            print(PKRdata)
            guard let data = PKRdata else {
                return
            }
            titleLbl.text = data.tenor
            if data.bid == 0 {
                askLbl.text = "Return"
                askLbl.textColor = UIColor.themeColor

            } else {
                askLbl.text = String(describing: data.bid).numberFormatter()
                askLbl.textColor = UIColor.themeLblColor
            }
            
        }
    }
    
    
    fileprivate func converTimeString(_ date: String) -> String {
        let date = date.toDate(withFormat: "yyyy-MM-dd'T'HH:mm:ss.SSS")
        let dateStr = date?.toString(format: "HH:mm")
        return dateStr!
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

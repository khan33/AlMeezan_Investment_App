//
//  NAVSummeryCell.swift
//  AlMeezan
//
//  Created by Atta khan on 12/09/2019.
//  Copyright © 2019 Atta khan. All rights reserved.
//

import UIKit

class NAVSummeryCell: UITableViewCell {

    @IBOutlet weak var cardView: CardView!
    @IBOutlet weak var btnView: UIButton!
    @IBOutlet weak var fundShortName: UILabel!
    @IBOutlet weak var navPrice: UILabel!
    @IBOutlet weak var offerPrice: UILabel!
    @IBOutlet weak var repurchasePrice: UILabel!
    @IBOutlet weak var repurchaseBtnImg: UIButton!
    @IBOutlet weak var offerPriceBtnImg: UIButton!
    
    @IBOutlet weak var navBtnImg: UIButton!
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
    override func prepareForReuse() {
        repurchasePrice.text = "-"
        offerPrice.text = "-"
        navPrice.text = "-"
        repurchasePrice.textColor = UIColor.init(rgb: 0x5B5F78)
        offerPrice.textColor = UIColor.init(rgb: 0x5B5F78)
        
    }
    
    var nav_performance_data: NavPerformance? {
        didSet {
            guard let performance = nav_performance_data else { return }
            fundShortName.text = performance.fundshortname
            let redemptionPrice = performance.redemptionPrice
            if redemptionPrice != 0.0 {
                repurchasePrice.text = "\(String(describing: redemptionPrice).numberFormatter())"
                repurchaseBtnImg.isHidden = false
                if let sign = performance.sign {
                    if sign == "+" {
                        repurchasePrice.textColor = UIColor.init(rgb: 0x47AE0A)
                        repurchaseBtnImg.setImage(UIImage(named: "upArrow"), for: .normal)
                        
                    } else {
                        repurchasePrice.textColor = UIColor.init(rgb: 0xF54F4F)
                        repurchaseBtnImg.setImage(UIImage(named: "redArrow"), for: .normal)
                        
                    }
                }
            } else {
                repurchaseBtnImg.isHidden = true
                repurchasePrice.text = "-"
            }
            
            
            let offer_price = performance.offerPrice
            if offer_price != 0.0 {
                offerPrice.text = "\(String(describing: offer_price).numberFormatter())"
                offerPriceBtnImg.isHidden = false
                if let sign = performance.sign {
                    if sign == "+" {
                        offerPriceBtnImg.setImage(UIImage(named: "upArrow"), for: .normal)
                        offerPrice.textColor = UIColor.init(rgb: 0x47AE0A)
                    } else {
                        offerPriceBtnImg.setImage(UIImage(named: "redArrow"), for: .normal)
                        offerPrice.textColor = UIColor.init(rgb: 0xF54F4F)
                    }
                }
            } else {
                offerPriceBtnImg.isHidden = true
                offerPrice.text = "-"
            }
            let nav_price = performance.nAVPrice
            if nav_price != 0.0 {
                navPrice.text = "\(String(describing: nav_price).numberFormatter())"
                navBtnImg.isHidden = false
                if let sign = performance.sign {
                    if sign == "+" {
                        navBtnImg.setImage(UIImage(named: "upArrow"), for: .normal)
                        navPrice.textColor = UIColor.init(rgb: 0x47AE0A)
                    } else {
                        navBtnImg.setImage(UIImage(named: "redArrow"), for: .normal)
                        navPrice.textColor = UIColor.init(rgb: 0xF54F4F)
                    }
                }
            } else {
                navPrice.text = "-"
                navBtnImg.isHidden = true
                navPrice.textColor = UIColor.init(rgb: 0x232746)
            }
        }
    }
    
    
}

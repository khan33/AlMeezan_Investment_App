//
//  ETransactionPopupVC.swift
//  AlMeezan
//
//  Created by Atta khan on 22/01/2020.
//  Copyright © 2020 Atta khan. All rights reserved.
//

import UIKit

class ETransactionPopupVC: UIViewController {

    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var portfolioIdLbl: UILabel!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var amountLbl: UILabel!
    @IBOutlet weak var transactionsTypeLbl: UILabel!
    @IBOutlet weak var fundCategoryLbl: UILabel!
    
    var titleStr: String?
    var portfolio_id: String?
    var fund_category: String?
    var transaction_type: String?
    var total_amount: String?
    var easyCashValue: Any?
    
    weak var investment_delegate: InvestmentEservices?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateLableValue()
        
        self.tabBarController?.tabBar.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    func updateLableValue() {
        if let title = titleStr {
            titleLbl.text = title
        }
        if let id = portfolio_id {
            portfolioIdLbl.text = id
        }
        if let amount = total_amount {
            amountLbl.text = amount
        }
        if let type = transaction_type {
            transactionsTypeLbl.text = type
        }
        if let funds = fund_category {
            fundCategoryLbl.text = funds
        }
    }
    
    @IBAction func tapOnSubmitBtn(_ sender: Any) {
        investment_delegate?.submitInvestment()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tapOnCancelBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

//
//  UserPortfolioVC.swift
//  AlMeezan
//
//  Created by Muhammad, Atta on 17/10/2022.
//  Copyright © 2022 Atta khan. All rights reserved.
//

import UIKit

class UserPortfolioVC: UIViewController {
    private (set) lazy var headerView: PaymentHeaderView = { [unowned self] in
        let view = PaymentHeaderView.init(titleLbl: "Portfolio List", closeAction: {
            self.navigationController?.popViewController(animated: true)
        }, nextAction: {
            print("next")
        }, previousAction: {
            self.navigationController?.popViewController(animated: true)
        })
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray2
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let tableview: UITableView = {
        let tableview = UITableView(frame: .zero, style: .plain)
        tableview.register(BillPaymentCell.self, forCellReuseIdentifier: BillPaymentCell.identifier)
        tableview.translatesAutoresizingMaskIntoConstraints = false
        tableview.isScrollEnabled = true
        tableview.backgroundColor = UIColor.clear
        return tableview
    }()
    
    
    public var  titleLbl: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.black
        label.text = "From Account"
        label.font = UIFont(name: AppFontName.circularStdBold, size: 14)
        return label
    }()
    
    public var subLbl: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.gray
        label.text = "Select Portfolio Id you would like to transfer from"
        label.font = UIFont(name: AppFontName.robotoRegular, size: 10)
        return label
    }()
    
    
    
    var list: [CustomerInvestment]?
    var payee_detail: FundTransferEntity.PayeeResponseModel?
    var billing_detail: BillListEntity.BillListResponse?
    var router: PayeeRouterProtocol = PayeeRouter()

    override func viewDidLoad() {
        super.viewDidLoad()
        router.navigationController = navigationController

        view.addSubview(headerView)
        view.addSubview(titleLbl)
        view.addSubview(subLbl)
        view.addSubview(tableview)
        list = getPortfolio()
        
        setupContraints()
        configueTablView()
    }
    private func configueTablView() {
        tableview.delegate = self
        tableview.dataSource = self
        self.tableview.reloadData()
    }
    func setupContraints() {
        view.backgroundColor = .gray2
        headerView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        headerView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        
        titleLbl.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 20).isActive = true
        titleLbl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        titleLbl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        
        subLbl.topAnchor.constraint(equalTo: titleLbl.bottomAnchor, constant: 6).isActive = true
        subLbl.leadingAnchor.constraint(equalTo: titleLbl.leadingAnchor, constant: 0).isActive = true
        subLbl.trailingAnchor.constraint(equalTo: titleLbl.trailingAnchor).isActive = true

        
        
        tableview.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24).isActive = true
        tableview.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24).isActive = true
        tableview.topAnchor.constraint(equalTo: subLbl.bottomAnchor, constant: 20).isActive = true
        tableview.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        self.tableview.separatorStyle  = .none

    }
    func getPortfolio() -> [CustomerInvestment]? {
        var list: [CustomerInvestment]?
        PersistenceServices.shared.fetch(CustomerInvestment.self) { [weak self] (data) in
            list = data
        }
        list = list?.filter( {$0.portfolioID != Message.allPortfolio} )
        list = list?.sorted {
            if let id1 = $0.portfolioID, let id2 = $1.portfolioID {
               return id1.localizedStandardCompare(id2) == .orderedAscending
            }
            return true
        }
        return list
    }

}


extension UserPortfolioVC:  UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: BillPaymentCell.identifier, for: indexPath) as! BillPaymentCell
        cell.image.image  = UIImage(named: "logo_border")
        cell.chevronImage.setImage(UIImage(named: "chevronDown"), for: .normal)
        cell.portfolioLbl.text = "Portfolio ID:" + (list?[indexPath.row].portfolioID ?? "")
        if let total = list?[indexPath.row].summary?.map( { Double($0.marketValue )} ).reduce(0, +) {
            cell.balanceLbl.text = "Balance PKR. \(String(describing: total ).toCurrencyFormat(withFraction: false))"
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if payee_detail != nil {
            self.router.paymentVC(payee_detail, portfolio: list?[indexPath.row])
        } else {
            self.router.billTransfer(billing_detail, portfolio: list?[indexPath.row])
        }
    }
}

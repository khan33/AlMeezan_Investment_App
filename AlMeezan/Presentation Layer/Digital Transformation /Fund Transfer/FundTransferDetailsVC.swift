//
//  FundTransferDetailsVC.swift
//  AlMeezan
//
//  Created by Atta khan on 12/09/2022.
//  Copyright © 2022 Atta khan. All rights reserved.
//

import UIKit

struct AccountDetails {
    var accountName: String?
    var amount: Int?
}

class FundTransferDetailsVC: UIViewController {
    
    private let tableview: UITableView = {
        let tableview = UITableView(frame: .zero, style: .plain)
        tableview.register(BillPaymentCell.self, forCellReuseIdentifier: BillPaymentCell.identifier)
        tableview.register(HistoryCell.self, forCellReuseIdentifier: HistoryCell.identifier)
        tableview.translatesAutoresizingMaskIntoConstraints = false
        tableview.isScrollEnabled = true
        tableview.backgroundColor = UIColor.gray2
        return tableview
    }()
    
    private let segmentController: UISegmentedControl = {
        let items = ["My Payees", "History"]
        let customSC = UISegmentedControl(items: items)
        customSC.translatesAutoresizingMaskIntoConstraints = false
        customSC.backgroundColor = UIColor.purple
        customSC.backgroundColor = .purple
        customSC.setTitleTextAttributes([.underlineColor: UIColor.purple], for: .selected)
        customSC.setTitleTextAttributes([.foregroundColor: UIColor.purple], for: .selected)
        customSC.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
        customSC.selectedSegmentIndex = 0
        customSC.addTarget(self, action: #selector(changeController), for: .valueChanged)
        return customSC
    }()
    
    private (set) lazy var headerView: PaymentHeaderView = { [unowned self] in
        let view = PaymentHeaderView.init(titleLbl: Headings.fundTransfer, closeAction: {
            self.navigationController?.popViewController(animated: true)
        }, nextAction: {
            print("next")
        }, previousAction: {
            self.navigationController?.popViewController(animated: true)
        })
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private (set) lazy var customView: CustomPortfolioView = {
        let view = CustomPortfolioView.init(portfolioLabel: "Portfolio ID 316 XXXX XX 88", balanceLabel: "Balance PKR 1200.2", viewColor: .purple)
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    public var  titleLbl: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.black
        label.text = "From Account"
        label.font = UIFont(name: AppFontName.circularStdRegular, size: 13)
        return label
    }()
    
    private var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.gray2
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let saveBtn: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.clipsToBounds = true
        btn.setTitle("ADD BENEFICIARY", for: .normal)
        btn.tintColor = .white
        btn.backgroundColor = UIColor.purple
        btn.layer.cornerRadius = 20
        return btn
    }()
    
    var views: [UIView]!
    var names: [String] = ["Ahmed", "Saeed", "Speed", "s"]
    var amount: [String] = ["1002.3", "12223.2", "1113.2", "12523.2"]
    var date: [String] = ["15, July", "16th July", "17th July", "20th July"]
    var noOfSection = 1
    var accountDetails = AccountDetails()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(headerView)
        view.addSubview(containerView)
        containerView.addSubview(titleLbl)
        containerView.addSubview(saveBtn)
        containerView.addSubview(segmentController)
        containerView.addSubview(customView)
        containerView.addSubview(tableview)
        
        tableview.delegate = self
        tableview.dataSource = self
        
        setupConstraints()
    }
    
    @objc func changeController(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            print("My Payess is selected \(sender.selectedSegmentIndex)")
            self.saveBtn.isHidden = false
        case 1:
            print("History is selected \(sender.selectedSegmentIndex)")
            self.saveBtn.isHidden = true
        default:
            print("No Segment")
        }
        self.tableview.reloadData()
    }
    
    func setupConstraints() {
        
        headerView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        headerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        headerView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        headerView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        containerView.topAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: saveBtn.topAnchor, constant: -20).isActive = true
        
        
        tableview.topAnchor.constraint(equalTo: segmentController.bottomAnchor, constant: 0).isActive = true
        tableview.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20).isActive = true
        tableview.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20).isActive = true
        tableview.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        
        saveBtn.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
        saveBtn.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30).isActive = true
        saveBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        saveBtn.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -35).isActive = true
        
        titleLbl.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 5).isActive = true
        titleLbl.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 15).isActive = true
        
        customView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        customView.topAnchor.constraint(equalTo: titleLbl.bottomAnchor, constant: 5).isActive = true
        customView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 15).isActive = true
        customView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -15).isActive = true
        
        segmentController.topAnchor.constraint(equalTo: customView.bottomAnchor, constant: 10).isActive = true
        segmentController.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20).isActive = true
        segmentController.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20).isActive = true
    }
    
    func defaultTableHeight() {
        containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        containerView.topAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    func increaseTableHeight() {
        containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        containerView.topAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}

extension FundTransferDetailsVC:  UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if segmentController.selectedSegmentIndex == 1 {
            return date[section]
        }
        return " "
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if segmentController.selectedSegmentIndex == 0 {
            return 20
        }
        else {
            return 25
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else {return}
        header.textLabel?.font = UIFont(name: AppFontName.circularStdRegular, size: 13)
        header.textLabel?.textColor = .black
        header.textLabel?.text = header.textLabel?.text?.capitalized
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if segmentController.selectedSegmentIndex == 0 {
            return noOfSection
        }
        else {
            return date.count
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if segmentController.selectedSegmentIndex == 0 {
            return amount.count
        } else {
            return 3
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if segmentController.selectedSegmentIndex == 0 {
            
            guard let cell = tableview.dequeueReusableCell(withIdentifier: BillPaymentCell.identifier, for: indexPath) as? BillPaymentCell else {return UITableViewCell()}
            cell.image.image  = UIImage(named: "meezanLogo")
            cell.portfolioLbl.text = names[indexPath.row]
            cell.balanceLbl.text = amount[indexPath.row]
            cell.layer.borderColor = UIColor.gray2.cgColor
            cell.layer.borderWidth = 2
            cell.layer.cornerRadius = 5
            cell.clipsToBounds = true
            return cell
            
        } else {
            guard let cell = tableview.dequeueReusableCell(withIdentifier: HistoryCell.identifier, for: indexPath) as? HistoryCell else {return UITableViewCell()}
            
            cell.accountDetailLbl.text = "Portfolio ID 316 XXXX XX 88"
            cell.bankNameLbl.text = amount[indexPath.row]
            cell.layer.borderColor = UIColor.gray2.cgColor
            cell.layer.borderWidth = 2
            cell.layer.cornerRadius = 5
            cell.clipsToBounds = true
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
    }
}



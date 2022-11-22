//
//  AddBillPayeeController.swift
//  AlMeezan
//
//  Created by Ahmad on 28/09/2022.
//  Copyright © 2022 Atta khan. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

class BillListController: UIViewController {
    
    private let headerView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let myPayeesView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let historyView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let myPayeesUnderlineView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let historyUnderlineView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let topbarImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "bar")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let midLbl: UILabel = {
        var label = UILabel()
        label.text = "Bill Payment"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.white
        label.font = UIFont(name: AppFontName.circularStdRegular, size: 16)
        return label
    }()
    
    private let backBtn: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.clipsToBounds = true
        btn.setImage(UIImage(named: IconName.backArrow)?.transform(withNewColor: .white), for: .normal)
        btn.tintColor = .white
        btn.addTarget(self, action: #selector(didTapOnBackBtn), for: .touchUpInside)
        return btn
    }()
    
    private let notificationBtn: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.clipsToBounds = true
        btn.setImage(UIImage(named: "notification")?.transform(withNewColor: .white), for: .normal)
        btn.tintColor = .white
        return btn
    }()
    
    private let stackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.distribution = .fillEqually
        view.alignment = .fill
        view.axis = .horizontal
        view.spacing = 4
        view.clipsToBounds = true
        view.frame = view.bounds
        return view
    }()
    
    private let myPayeesBtn: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.clipsToBounds = true
        btn.setTitle("My Payees", for: .normal)
        btn.tintColor = .white
        btn.isSelected = true
        btn.titleLabel?.font = UIFont(name: AppFontName.robotoRegular, size: 12)
        btn.backgroundColor = .clear
        btn.addTarget(self, action: #selector(isBtnTapped), for: .touchUpInside)
        btn.tag = 0
        return btn
    }()
    
    private let historyBtn: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.clipsToBounds = true
        btn.setTitle("History", for: .normal)
        btn.setTitleColor(.offwhite, for: .normal)
        btn.titleLabel?.font = UIFont(name: AppFontName.robotoRegular, size: 12)
        btn.backgroundColor = .clear
        btn.addTarget(self, action: #selector(isBtnTapped), for: .touchUpInside)
        btn.tintColor = .white
        btn.isSelected = true
        btn.tag = 1
        return btn
    }()
    
    private let tableview: UITableView = {
        let tableview = UITableView(frame: .zero, style: .plain)
        tableview.register(BillPaymentCell.self, forCellReuseIdentifier: BillPaymentCell.identifier)
        tableview.register(HistoryCell.self, forCellReuseIdentifier: HistoryCell.identifier)
        tableview.register(DateHeaderCell.self,
               forHeaderFooterViewReuseIdentifier: "DateHeaderCell")
        tableview.translatesAutoresizingMaskIntoConstraints = false
        tableview.isScrollEnabled = true
        tableview.backgroundColor = UIColor.gray2
        return tableview
    }()
    
    private var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.gray2
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var buttonView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let addBeneficiaryBtn: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.clipsToBounds = true
        btn.setTitle("ADD BILL", for: .normal)
        btn.tintColor = .white
        btn.addTarget(self, action: #selector(tranisitionToAddbill), for: .touchUpInside)
        btn.backgroundColor = UIColor.purple
        btn.layer.cornerRadius = 20
        return btn
    }()
    
    var views: [UIView]!
    var names: [String] = ["Ahmed", "Saeed", "Speed", "s"]
    var amount: [String] = ["03303234233", "03303234233", "03303234233", "03303234233d"]
  //  var date: [String] = ["15, July", "16th July", "17th July", "20th July"]
    var details = UIButton()
    var billPayment = [BillListEntity.BillListResponse]()
    //var historyList = [HistoryListEntity.HistoryListResponse]()
    var date: [String] = []
    let noInternet: String = "The Internet connection appears to be offline."

    
    var pagetoShow = PageToShow.myPayees
    
    var interactor: BillListInteractorProtocol?
    var router: BillListRouterProtocol?
    
    
    var historyList = [[FundTransferEntity.PayeeHistroyModel]]()
    var addBeneficiaryBtnHeightConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        router?.navigationController = navigationController
        view.addSubview(headerView)
        view.addSubview(containerView)
        //view.addSubview(buttonView)
        containerView.addSubview(tableview)
        containerView.addSubview(addBeneficiaryBtn)
        headerView.addSubview(topbarImage)
        headerView.addSubview(backBtn)
        headerView.addSubview(midLbl)
        headerView.addSubview(notificationBtn)
        headerView.addSubview(stackView)
        stackView.addArrangedSubview(myPayeesView)
        stackView.addArrangedSubview(historyView)
        myPayeesView.addSubview(myPayeesBtn)
        historyView.addSubview(historyBtn)
        myPayeesView.addSubview(myPayeesUnderlineView)
        historyView.addSubview(historyUnderlineView)
        historyUnderlineView.isHidden = true
        tableview.delegate = self
        tableview.dataSource = self
        setupConstraints()
        interactor?.loadBillList()
        interactor?.loadHistoryList()
        self.tableview.reloadData()
        print("dates \(date)")
    }
    
    @objc func isBtnTapped(sender: UIButton) {
        
        switch sender.tag {
        case 0:
            print("MyPayees is selected \(sender.tag)")
            myPayeesUnderlineView.isHidden = false
            historyUnderlineView.isHidden = true
            historyBtn.setTitleColor(.offwhite, for: .normal)
            myPayeesBtn.setTitleColor(.white, for: .normal)
            self.pagetoShow = PageToShow.myPayees
            self.addBeneficiaryBtnHeightConstraint?.constant = 40

            self.tableview.reloadData()
        case 1 :
            print("History is selected \(sender.tag)")
            myPayeesUnderlineView.isHidden = true
            historyUnderlineView.isHidden = false
            myPayeesBtn.setTitleColor(.offwhite, for: .normal)
            historyBtn.setTitleColor(.white, for: .normal)
            self.addBeneficiaryBtnHeightConstraint?.constant = 0
            self.pagetoShow = PageToShow.history
            self.tableview.reloadData()
        default:
            return
        }
        self.tableview.reloadData()
    }
    
    @objc func tranisitionToAddbill() {
        router?.nextoToAddBill()
    }
    @objc func didTapOnBackBtn(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setupConstraints() {
        
        self.headerView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.headerView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.headerView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        self.headerView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.15).isActive = true
        
        self.topbarImage.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 0).isActive = true
        self.topbarImage.leftAnchor.constraint(equalTo: headerView.leftAnchor, constant: 0).isActive = true
        self.topbarImage.rightAnchor.constraint(equalTo: headerView.rightAnchor, constant: 0).isActive = true
        self.topbarImage.bottomAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
        
        self.backBtn.centerYAnchor.constraint(equalTo: headerView.centerYAnchor, constant: 0).isActive = true
        self.backBtn.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 15).isActive = true
        
        self.midLbl.centerXAnchor.constraint(equalTo: headerView.centerXAnchor, constant: 0).isActive = true
        self.midLbl.centerYAnchor.constraint(equalTo: headerView.centerYAnchor, constant: 5).isActive = true
        
        self.notificationBtn.centerYAnchor.constraint(equalTo: headerView.centerYAnchor, constant: 0).isActive = true
        self.notificationBtn.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -15).isActive = true
        
        self.stackView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor).isActive = true
        self.stackView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor).isActive = true
        self.stackView.bottomAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
        self.stackView.topAnchor.constraint(equalTo: midLbl.bottomAnchor, constant: 4).isActive = true
        
        self.myPayeesBtn.topAnchor.constraint(equalTo: self.myPayeesView.topAnchor).isActive = true
        self.myPayeesBtn.leadingAnchor.constraint(equalTo: self.myPayeesView.leadingAnchor).isActive = true
        self.myPayeesBtn.trailingAnchor.constraint(equalTo: self.myPayeesView.trailingAnchor).isActive = true
        self.myPayeesBtn.bottomAnchor.constraint(equalTo: self.myPayeesUnderlineView.topAnchor).isActive = true
        
        self.historyBtn.topAnchor.constraint(equalTo: self.historyView.topAnchor).isActive = true
        self.historyBtn.leadingAnchor.constraint(equalTo: self.historyView.leadingAnchor).isActive = true
        self.historyBtn.trailingAnchor.constraint(equalTo: self.historyView.trailingAnchor).isActive = true
        self.historyBtn.bottomAnchor.constraint(equalTo: self.historyUnderlineView.topAnchor).isActive = true
        
        self.myPayeesUnderlineView.leadingAnchor.constraint(equalTo: myPayeesView.leadingAnchor).isActive = true
        self.myPayeesUnderlineView.trailingAnchor.constraint(equalTo: myPayeesView.trailingAnchor).isActive = true
        self.myPayeesUnderlineView.bottomAnchor.constraint(equalTo: myPayeesView.bottomAnchor).isActive = true
        self.myPayeesUnderlineView.heightAnchor.constraint(equalToConstant: 2).isActive = true
        
        self.historyUnderlineView.leadingAnchor.constraint(equalTo: historyView.leadingAnchor).isActive = true
        self.historyUnderlineView.trailingAnchor.constraint(equalTo: historyView.trailingAnchor).isActive = true
        self.historyUnderlineView.bottomAnchor.constraint(equalTo: historyView.bottomAnchor).isActive = true
        self.historyUnderlineView.heightAnchor.constraint(equalToConstant: 2).isActive = true
        
        containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        containerView.topAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        self.tableview.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10).isActive = true
        self.tableview.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20).isActive = true
        self.tableview.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20).isActive = true
        self.tableview.bottomAnchor.constraint(equalTo: self.addBeneficiaryBtn.bottomAnchor, constant: -16).isActive = true
        
        addBeneficiaryBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24).isActive = true
        addBeneficiaryBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24).isActive = true
        addBeneficiaryBtn.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16).isActive = true
        addBeneficiaryBtnHeightConstraint = addBeneficiaryBtn.heightAnchor.constraint(equalToConstant: 40)
        addBeneficiaryBtnHeightConstraint.isActive = true
    }
    @objc func didTapOnInfoBtn(_ sender: UIButton) {
        let tag = sender.tag
        
    }
}

extension BillListController:  UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if pagetoShow == PageToShow.myPayees {
            return 5
        } else {
            return 20.0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = tableView.dequeueReusableHeaderFooterView(withIdentifier: "DateHeaderCell") as! DateHeaderCell
        if pagetoShow == PageToShow.history {
            let firstObj = historyList[section].first
            headerCell.dateLbl.text = firstObj?.formatted_date
        } else {
            headerCell.dateLbl.text = ""
        }
        return headerCell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if pagetoShow == PageToShow.myPayees {
            return billPayment.count ?? 0 > 0 ? 1 : 0
        }  else {
            return historyList.count
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if pagetoShow == PageToShow.myPayees {
            return billPayment.count
        } else {
            return historyList[section].count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if pagetoShow == PageToShow.myPayees {
            guard let cell = tableview.dequeueReusableCell(withIdentifier: BillPaymentCell.identifier, for: indexPath) as? BillPaymentCell else {return UITableViewCell()}
//            if let image = billPayment[indexPath.row].imagePath {
//                cell.image.setImage(with: image)
//            } else {
//                cell.image.image = UIImage(named: "Group 769")
//            }
            
            cell.image.image = UIImage(named: "Group 725")
            cell.portfolioLbl.text = billPayment[indexPath.row].utilityCompanyID
            cell.balanceLbl.text = billPayment[indexPath.row].billingMonth
            cell.layer.borderColor = UIColor.gray2.cgColor
            cell.layer.borderWidth = 2
            cell.layer.cornerRadius = 5
            cell.clipsToBounds = true
            cell.chevronImage.setImage(UIImage(named: "chevron-down"), for: .normal)
            
            return cell
        } else {
            guard let cell = tableview.dequeueReusableCell(withIdentifier: HistoryCell.identifier, for: indexPath) as? HistoryCell else {return UITableViewCell()}
            
            cell.accountDetailLbl.text = historyList[indexPath.section][indexPath.row].utilityCompanyId
            if let amount = Int(historyList[indexPath.section][indexPath.row].transactionAmount ?? "0") {
                cell.amountLbl.text = "\(amount)"
            }
            cell.bankNameLbl.text = historyList[indexPath.section][indexPath.row].utilityConsumerNumber
            historyList[indexPath.section][indexPath.row].type = "bill"
            cell.layer.borderColor = UIColor.gray2.cgColor
            cell.layer.borderWidth = 2
            cell.layer.cornerRadius = 5
            cell.clipsToBounds = true
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if pagetoShow == .history {
            let vc = PayeeHistoryDetailBottomSheet()
            vc.payee_detail = historyList[indexPath.section][indexPath.row]
            let activityViewController = CustomActivityViewController(controller: vc)
            self.present(activityViewController, animated: true, completion: nil)
        } else if pagetoShow == .myPayees {
            let vc = UserPortfolioVC()
            vc.billing_detail = billPayment[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

// MARK: - pre

extension BillListController: BillListViewProtocol {
    
    func showDataFailure(error: String) {
        if error == noInternet {
            DispatchQueue.main.async {
                self.showAlert(title: "Error", message: error, controller: self, dismissCompletion: {
                })
            }
        }
    }
    
    func successHistoryList(response: [[FundTransferEntity.PayeeHistroyModel]]) {
        DispatchQueue.main.async {
            self.historyList = response
            self.tableview.reloadData()
        }
    }
    
    func successBillList(response: [BillListEntity.BillListResponse]) {
        DispatchQueue.main.async {
            self.billPayment = response
            self.tableview.reloadData()
            print(response)
        }
    }
}

//
//  PayeeViewController.swift
//  AlMeezan
//
//  Created by Atta khan on 12/09/2022.
//  Copyright © 2022 Atta khan. All rights reserved.
//

import UIKit

enum PageToShow {
    case myPayees
    case history
}

class PayeeViewController: UIViewController {
    
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
        label.text = "Fund Transfer"
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
        btn.addTarget(self, action: #selector(didTapOnBackBtn), for: .touchUpInside)
        btn.tintColor = .white
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
        tableview.backgroundColor = UIColor.clear
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
        btn.setTitle("ADD BENEFICIARY", for: .normal)
        btn.tintColor = .white
        btn.backgroundColor = UIColor.purple
        btn.layer.cornerRadius = 20
        btn.addTarget(self, action: #selector(didTapOnAddPayeeBtn), for: .touchUpInside)
        return btn
    }()

    var pagetoShow = PageToShow.myPayees
    var interactor: PayeeInteractorProtocol?
    var router: PayeeRouterProtocol?
    var payeeList: payeeListResponse?
    var historyList = [[FundTransferEntity.PayeeHistroyModel]]()
    
    var addBeneficiaryBtnHeightConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        router?.navigationController = navigationController

        
        view.addSubview(headerView)
        view.addSubview(containerView)
        view.addSubview(buttonView)
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
        
        setupConstraints()
        showLoader()
        interactor?.viewDidLoad()
    }
    
    
    private func configueTablView() {
        tableview.delegate = self
        tableview.dataSource = self
        self.tableview.reloadData()
    }
    
    @objc func didTapOnBackBtn(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func isBtnTapped(sender: UIButton) {
        
        switch sender.tag {
        case 0:
            myPayeesUnderlineView.isHidden = false
            historyUnderlineView.isHidden = true
            historyBtn.setTitleColor(.offwhite, for: .normal)
            myPayeesBtn.setTitleColor(.white, for: .normal)
            self.pagetoShow = PageToShow.myPayees
            self.buttonView.backgroundColor = .white
            //self.addBeneficiaryBtn.isHidden = false
            self.tableview.reloadData()
            
            self.addBeneficiaryBtnHeightConstraint?.constant = 55
            self.view.layoutIfNeeded()
            
            
        case 1 :
            myPayeesUnderlineView.isHidden = true
            historyUnderlineView.isHidden = false
            myPayeesBtn.setTitleColor(.offwhite, for: .normal)
            historyBtn.setTitleColor(.white, for: .normal)
            self.buttonView.backgroundColor = .gray2
            //self.addBeneficiaryBtn.isHidden = true
            self.pagetoShow = PageToShow.history
            self.tableview.reloadData()
            self.addBeneficiaryBtnHeightConstraint?.constant = 0
            self.view.layoutIfNeeded()
        default:
            return
        }
        self.tableview.reloadData()
    }
    
    @objc func didTapOnAddPayeeBtn(_ sender: UIButton) {
        router?.addPayee()
    }
}

extension PayeeViewController {
    func setupConstraints() {
        self.tableview.separatorStyle  = .none
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
        addBeneficiaryBtnHeightConstraint = addBeneficiaryBtn.heightAnchor.constraint(equalToConstant: 55)
        addBeneficiaryBtnHeightConstraint.isActive = true
        
        
    }
}

extension PayeeViewController:  UITableViewDelegate, UITableViewDataSource {
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
            return payeeList?.count ?? 0 > 0 ? 1 : 0
        }
        else {
            return historyList.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if pagetoShow == PageToShow.myPayees {
            return payeeList?.count ?? 0
        } else {
            return historyList[section].count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if pagetoShow == PageToShow.myPayees {
            guard let cell = tableview.dequeueReusableCell(withIdentifier: BillPaymentCell.identifier, for: indexPath) as? BillPaymentCell else {return UITableViewCell()}
            cell.image.image  = UIImage(named: "alMeezanLogo")
            cell.portfolioLbl.text = payeeList?[indexPath.row].bankAccountTitle
            cell.balanceLbl.text = payeeList?[indexPath.row].bankAccountNo
            cell.chevronImage.tag = indexPath.row
            cell.chevronImage.addTarget(self, action: #selector(didTapOnInfoBtn), for: .touchUpInside)

            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: HistoryCell.identifier) as! HistoryCell
            cell.accountDetailLbl.text = historyList[indexPath.section][indexPath.row].beneficiaryTitle
            cell.bankNameLbl.text = historyList[indexPath.section][indexPath.row].fromAccountNumber
            historyList[indexPath.section][indexPath.row].type = "payee"
            if let amount = historyList[indexPath.section][indexPath.row].transactionAmount {
                cell.amountLbl.text = "\(String(describing: amount).toCurrencyFormat(withFraction: false))"
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if pagetoShow == PageToShow.myPayees {
            let vc = UserPortfolioVC()
            vc.payee_detail = payeeList?[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc = PayeeHistoryDetailBottomSheet()
            vc.payee_detail = historyList[indexPath.section][indexPath.row]
            let activityViewController = CustomActivityViewController(controller: vc)
            self.present(activityViewController, animated: true, completion: nil)
        }
    }
    
    @objc func didTapOnInfoBtn(_ sender: UIButton) {
        let tag = sender.tag
        let vc = PayeeBottomSheetView()
        vc.payee_detail = payeeList?[tag]
        let activityViewController = CustomActivityViewController(controller: vc)
        self.present(activityViewController, animated: true, completion: nil)
    }
    
}

extension PayeeViewController: PayeeViewProtocol {
    func successfullResponse(_ response: payeeListResponse) {
        DispatchQueue.main.async {
            self.hideLoader()
            self.payeeList = response
            self.configueTablView()
        }
    }
    
    func getHistoryResponse(_ response: [[FundTransferEntity.PayeeHistroyModel]]) {
        DispatchQueue.main.async {
            self.hideLoader()
            self.historyList = response
            self.configueTablView()
        }
    }
}




class CustomActivityViewController: UIActivityViewController {

    private let controller: UIViewController!

    required init(controller: UIViewController) {
        self.controller = controller
        super.init(activityItems: [], applicationActivities: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let subViews = self.view.subviews
        for view in subViews {
            view.removeFromSuperview()
        }

        self.addChild(controller)
        self.view.addSubview(controller.view)
    }

}


class PayeeNameView: UIView {
    
    let containerView: UIView = {
        let view = UIView()
//        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let titleLbl: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = UIColor.black
        label.font = UIFont(name: AppFontName.robotoRegular, size: 12)
        label.clipsToBounds = true
        return label
    }()
    
     let subLbl: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = UIColor.black
        label.font = UIFont(name: AppFontName.circularStdBold, size: 14)
        label.clipsToBounds = true
        return label
    }()
    
    private var Image: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    
    private var bottomLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(rgb:0xF2F4F8)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        return view
    }()
    
    
    init(titleLabl: String, subLabel: String, imageName: String) {
        super.init(frame: CGRect.zero)
        self.backgroundColor = .white
        self.titleLbl.text = titleLabl
        self.subLbl.text = subLabel
        self.Image.image = UIImage(named: imageName)
        setupConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupConstraint() {
        self.addSubview(containerView)
        containerView.addSubview(titleLbl)
        containerView.addSubview(subLbl)
        containerView.addSubview(Image)
        containerView.addSubview(bottomLine)
        
        self.containerView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        self.containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
//        self.containerView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        Image.widthAnchor.constraint(equalToConstant: 44).isActive = true
        Image.heightAnchor.constraint(equalToConstant: 44).isActive = true
        Image.centerYAnchor.constraint(equalTo: self.containerView.centerYAnchor).isActive = true
        Image.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor).isActive = true

        self.titleLbl.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16).isActive = true
        self.titleLbl.leftAnchor.constraint(equalTo: self.Image.rightAnchor, constant: 10).isActive = true

        self.subLbl.topAnchor.constraint(equalTo: self.titleLbl.bottomAnchor, constant: 2).isActive = true
        self.subLbl.leftAnchor.constraint(equalTo: self.Image.rightAnchor, constant: 10).isActive = true

        self.Image.widthAnchor.constraint(equalToConstant: 20).isActive = true
        self.Image.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        self.Image.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 25).isActive = true

        self.titleLbl.topAnchor.constraint(equalTo: self.topAnchor, constant: 16).isActive = true
        self.titleLbl.leftAnchor.constraint(equalTo: self.Image.rightAnchor, constant: 10).isActive = true

        self.subLbl.topAnchor.constraint(equalTo: self.titleLbl.bottomAnchor, constant: 2).isActive = true
        self.subLbl.leftAnchor.constraint(equalTo: self.Image.rightAnchor, constant: 10).isActive = true

        self.bottomLine.topAnchor.constraint(equalTo: subLbl.bottomAnchor, constant: 16).isActive = true
        self.bottomLine.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 0).isActive = true
        self.bottomLine.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 0).isActive = true
        self.bottomLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
//
        
    }
    
}

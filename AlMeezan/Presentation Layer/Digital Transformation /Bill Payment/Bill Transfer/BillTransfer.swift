//
//  BillTransfer.swift
//  AlMeezan
//
//  Created by Ahmad on 04/10/2022.
//  Copyright © 2022 Atta khan. All rights reserved.
//

import Foundation
import UIKit

class BillTransferViewController: UIViewController {
    
    private (set) lazy var headerView: PaymentHeaderView = { [unowned self] in
        let view = PaymentHeaderView.init(titleLbl: "Bill Payment", closeAction: {
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
        let view = CustomPortfolioView.init(portfolioLabel: "", balanceLabel: "", viewColor: .purple)
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    public var titleLbl: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.black
        label.text = "From Account"
        label.font = UIFont(name: AppFontName.robotoRegular, size: 13)
        return label
    }()
    
    public var toLbl: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.black
        label.text = "To"
        label.font = UIFont(name: AppFontName.robotoRegular, size: 13)
        return label
    }()
    
    public var enterAmountLbl: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.black
        label.text = "Enter Amount"
        label.font = UIFont(name: AppFontName.robotoRegular, size: 13)
        return label
    }()
    
    public var dotImage: UIImageView = {
        var image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        image.image = UIImage(named: "Ellipse")
        return image
    }()
    
    public var midDotImage: UIImageView = {
        var image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        image.image = UIImage(named: "Ellipse")
        return image
    }()
    
    public var containerView: UIView = {
        var view = UIView()
        view.backgroundColor = .gray2
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var scrollView: UIScrollView = {
        let scrollview = UIScrollView()
        scrollview.contentSize = CGSize(width: self.view.frame.size.width, height: 500)
        scrollview.translatesAutoresizingMaskIntoConstraints = false
        return scrollview
    }()
    
    lazy var innerScrollView: UIScrollView = {
        let scrollview = UIScrollView()
        scrollview.isScrollEnabled = false
        scrollview.translatesAutoresizingMaskIntoConstraints = false
        return scrollview
    }()
    
    private let stackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        view.layer.cornerRadius = 10
        view.distribution = .fillEqually
        view.alignment = .fill
        view.axis = .vertical
        view.backgroundColor = UIColor.gray2
        view.spacing = 2
        view.clipsToBounds = true
        view.frame = view.bounds
        return view
    }()
    
    private let transferBtn: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.clipsToBounds = true
        btn.setTitle("CONTINUE", for: .normal)
        btn.tintColor = .white
        btn.backgroundColor = UIColor.purple
        btn.layer.cornerRadius = 20
        btn.addTarget(self, action: #selector(sendPayment), for: .touchUpInside)
        return btn
    }()
    
    private var uiview: UIView = {
        var view = UIView()
        view.backgroundColor = .gray2
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private (set) lazy var accountView: AccountView = {
        let view = AccountView(accountNames: "", accountNos: "", viewColor: .white)
        view.accountNo.textColor = .black
        view.accountName.textColor = .black
        view.backgroundImage.isHidden = true
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    public var transactionLimitView: TransactionLimit = {
        var subview = TransactionLimit()
        subview.translatesAutoresizingMaskIntoConstraints = false
        return subview
    }()
    
    public var dashedImage: UIImageView = {
        var image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        image.image = UIImage(named: "greenline")
        return image
    }()
    
    public var dashedImageTwo: UIImageView = {
        var image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        image.image = UIImage(named: "line")
        return image
    }()
    
    public var lastDotImage: UIImageView = {
        var image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        image.image = UIImage(named: "Ellipse")?.withRenderingMode(.alwaysTemplate)
        image.tintColor = .themeColor
        
        return image
    }()
    
    private var agreementView: UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .gray2
        return view
    }()
    
    private let checkBoxBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.isSelected = false
        btn.setImage(UIImage(named: "check_box_outline"), for: .normal)
        btn.setImage(UIImage(named: "checked"), for: .selected)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(checkBoxStateDidChange), for: .touchUpInside)
        return btn
    }()
    
    private let agreementLbl: UILabel = {
        var label = UILabel()
        let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: Description.termAndCondition)
        attributedString.setColor(color: UIColor.purple, forText: "Terms & Conditions")
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.gray
        label.numberOfLines = 0
        label.text = Description.termAndCondition
        label.attributedText = attributedString
        label.font = UIFont(name: AppFontName.circularStdRegular, size: 13)
        return label
    }()
    var accountBalance: String?
    var availableBalance = Double .nan
    private var amountPKR: TextInputView!
    private var amountTxt: String = ""
    private var purpose: TextInputView!
    private var purposeTxt: String = " "
    var interactor: BillTransferInteractorProtocol?
    var router: BillTransferRouterProtocol?
    var billTransferResponse: [BillTransferEntity.BillTransferResponse]?
    var date = Date()
    var isTapped: Bool = true
    let noInternet: String = "The Internet connection appears to be offline."

    
    var portfolio: CustomerInvestment?
    var bill: BillListEntity.BillListResponse?
    init(bill: BillListEntity.BillListResponse?, portfolio: CustomerInvestment?) {
        self.bill  = bill
        self.portfolio = portfolio
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        router?.navigationController = navigationController
        view.backgroundColor = UIColor.customGray
        let tap = UITapGestureRecognizer(target: self, action: #selector(termAndCondition))
        agreementLbl.isUserInteractionEnabled = true
        agreementLbl.addGestureRecognizer(tap)
        addSubViews()
        setupConstraint()
        amountToTransfer()
        transactionLimitView.isHidden = true

        if let total = portfolio?.summary?.map( { Double($0.marketValue )} ).reduce(0, +) {
            availableBalance = total
        }
    }
    
    func addSubViews() {
        view.addSubview(headerView)
        view.addSubview(scrollView)
        view.addSubview(transferBtn)
        scrollView.addSubview(uiview)
        uiview.addSubview(dotImage)
        uiview.addSubview(dashedImage)
        uiview.addSubview(dashedImageTwo)
        uiview.addSubview(titleLbl)
        uiview.addSubview(customView)
        uiview.addSubview(midDotImage)
        uiview.addSubview(lastDotImage)
        uiview.addSubview(toLbl)
        uiview.addSubview(accountView)
        uiview.addSubview(enterAmountLbl)
        uiview.addSubview(containerView)
        uiview.addSubview(transactionLimitView)
        containerView.addSubview(innerScrollView)
        innerScrollView.addSubview(stackView)
    }
    
    @objc func checkBoxStateDidChange(_ sender: UIButton) {
        checkBoxBtn.isSelected.toggle()
        if sender.isSelected {
            isTapped = true
        } else {
            isTapped = false
        }
    }
    
    
    @objc func termAndCondition(sender: UITapGestureRecognizer) {
        let vc = BlogsViewController.instantiateFromAppStroyboard(appStoryboard: .main)
        vc.urlStr = TERMS_CONDITIONS
        vc.titleStr = "Terms & Conditions"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func amountToTransfer() {
        let currentDateFormatter = DateFormatter()
        currentDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        let dueDateFormatter = DateFormatter()
        dueDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        let dueDateString = bill?.dueDate ?? ""
        let dueDate = dueDateFormatter.date(from: dueDateString)
    
        let currentDateString = currentDateFormatter.string(from: date)
        let currentDate = currentDateFormatter.date(from: currentDateString)
        
        if let currentDate = currentDate, let dueDate = dueDate {
            print("Current Date is \(currentDate), \n Due Date: \(dueDate)")
            
            if dueDate < currentDate {
                let afterDueAmount = String(bill?.amountAfterDueDate ?? 0)
                self.amountTxt = afterDueAmount
                amountPKR.setData(text: amountTxt)
            }
            else {
                let withinDueamount = String(bill?.amountWithinDueDate ?? 0)
                self.amountTxt = withinDueamount
                amountPKR.setData(text: amountTxt)
            }
        }

    }
    
    func setupConstraint() {
        
        headerView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        headerView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        transferBtn.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
        transferBtn.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30).isActive = true
        transferBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        transferBtn.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30).isActive = true
        
        scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 0).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: transferBtn.topAnchor, constant: -5).isActive = true
        
        uiview.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        uiview.heightAnchor.constraint(equalTo: scrollView.heightAnchor).isActive = true
        
        dotImage.topAnchor.constraint(equalTo: uiview.topAnchor, constant: 13).isActive = true
        dotImage.leadingAnchor.constraint(equalTo: uiview.leadingAnchor, constant: 18).isActive = true
        dotImage.widthAnchor.constraint(equalToConstant: 10).isActive = true
        dotImage.heightAnchor.constraint(equalToConstant: 10).isActive = true
        
        dashedImage.topAnchor.constraint(equalTo: dotImage.bottomAnchor, constant: 1).isActive = true
        dashedImage.leadingAnchor.constraint(equalTo: dotImage.leadingAnchor).isActive = true
        dashedImage.widthAnchor.constraint(equalToConstant: 10).isActive = true
        dashedImage.heightAnchor.constraint(equalToConstant: 90).isActive = true
        
        titleLbl.topAnchor.constraint(equalTo: uiview.topAnchor, constant: 10).isActive = true
        titleLbl.leadingAnchor.constraint(equalTo: dotImage.leadingAnchor, constant: 20).isActive = true
        
        customView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        customView.topAnchor.constraint(equalTo: titleLbl.bottomAnchor, constant: 5).isActive = true
        customView.leadingAnchor.constraint(equalTo: titleLbl.leadingAnchor).isActive = true
        customView.trailingAnchor.constraint(equalTo:  uiview.trailingAnchor, constant: -20).isActive = true
        
        midDotImage.topAnchor.constraint(equalTo: customView.bottomAnchor, constant: 13).isActive = true
        midDotImage.leadingAnchor.constraint(equalTo: dotImage.leadingAnchor).isActive = true
        midDotImage.widthAnchor.constraint(equalToConstant: 10).isActive = true
        midDotImage.heightAnchor.constraint(equalToConstant: 10).isActive = true
        
        toLbl.leadingAnchor.constraint(equalTo: customView.leadingAnchor, constant: 0).isActive = true
        toLbl.topAnchor.constraint(equalTo: customView.bottomAnchor, constant: 10).isActive = true
        
        accountView.leadingAnchor.constraint(equalTo: customView.leadingAnchor).isActive = true
        accountView.trailingAnchor.constraint(equalTo: customView.trailingAnchor).isActive = true
        accountView.topAnchor.constraint(equalTo: toLbl.bottomAnchor, constant: 10).isActive = true
        accountView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        lastDotImage.topAnchor.constraint(equalTo: accountView.bottomAnchor, constant: 13).isActive = true
        lastDotImage.leadingAnchor.constraint(equalTo: dotImage.leadingAnchor).isActive = true
        lastDotImage.widthAnchor.constraint(equalToConstant: 10).isActive = true
        lastDotImage.heightAnchor.constraint(equalToConstant: 10).isActive = true
        
        dashedImageTwo.topAnchor.constraint(equalTo: midDotImage.bottomAnchor, constant: 1).isActive = true
        dashedImageTwo.leadingAnchor.constraint(equalTo: midDotImage.leadingAnchor).isActive = true
        dashedImageTwo.widthAnchor.constraint(equalToConstant: 10).isActive = true
        dashedImageTwo.heightAnchor.constraint(equalToConstant: 95).isActive = true
        
        enterAmountLbl.topAnchor.constraint(equalTo: accountView.bottomAnchor, constant: 10).isActive = true
        enterAmountLbl.leadingAnchor.constraint(equalTo: accountView.leadingAnchor).isActive = true
        
        amountPKR = TextInputView(heading: "Enter Amount", placeholder: "PKR", isPasswordEnable: false) { [weak self] (enteredText) in
            guard let self = self else {return}
            self.amountTxt = enteredText
        }
        amountPKR.txtField.keyboardType = .asciiCapableNumberPad
        //        amountPKR.setData(text: amountTxt)
        self.amountPKR.lblHeading.isHidden = true
        amountPKR.txtField.isUserInteractionEnabled = false
        self.amountPKR.translatesAutoresizingMaskIntoConstraints = false
        uiview.addSubview(amountPKR)
        
        amountPKR.leadingAnchor.constraint(equalTo: self.customView.leadingAnchor).isActive = true
        amountPKR.topAnchor.constraint(equalTo: enterAmountLbl.bottomAnchor, constant: 10).isActive = true
        amountPKR.heightAnchor.constraint(equalToConstant: 50).isActive = true
        amountPKR.trailingAnchor.constraint(equalTo: accountView.trailingAnchor).isActive = true
        
        
        transactionLimitView.topAnchor.constraint(equalTo: amountPKR.bottomAnchor, constant: 15).isActive = true
        transactionLimitView.heightAnchor.constraint(equalToConstant: 0).isActive = true
        transactionLimitView.leadingAnchor.constraint(equalTo: uiview.leadingAnchor, constant: 40).isActive = true
        transactionLimitView.trailingAnchor.constraint(equalTo: uiview.trailingAnchor, constant: -20).isActive = true
        
        containerView.widthAnchor.constraint(equalTo: uiview.widthAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: uiview.bottomAnchor).isActive = true
        containerView.topAnchor.constraint(equalTo: transactionLimitView.bottomAnchor, constant: 10).isActive = true
        
        
        innerScrollView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        innerScrollView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        innerScrollView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        innerScrollView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 0).isActive = true
        
        stackView.topAnchor.constraint(equalTo: innerScrollView.topAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: innerScrollView.leadingAnchor, constant: 30).isActive = true
        stackView.trailingAnchor.constraint(equalTo: innerScrollView.trailingAnchor, constant: -20).isActive = true
        stackView.centerXAnchor.constraint(equalTo: innerScrollView.centerXAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: innerScrollView.bottomAnchor).isActive = true
        
        purpose = TextInputView(heading: "Purpose", placeholder: "Others", isPasswordEnable: false) { [weak self] (enteredText) in
            guard let self = self else {return}
            self.purposeTxt = enteredText
        }
        purpose.txtField.keyboardType = .default
        purpose.containerView.backgroundColor = .gray2
        purpose.setData(text: purposeTxt)
        stackView.addArrangedSubview(purpose)
        
        stackView.addArrangedSubview(agreementView)
        agreementView.addSubview(checkBoxBtn)
        agreementView.addSubview(agreementLbl)
        
        
        checkBoxBtn.centerYAnchor.constraint(equalTo: agreementView.centerYAnchor, constant: 0).isActive = true
        checkBoxBtn.leadingAnchor.constraint(equalTo: agreementView.leadingAnchor, constant: 10).isActive = true
        
        agreementLbl.centerYAnchor.constraint(equalTo: agreementView.centerYAnchor, constant: 0).isActive = true
        agreementLbl.leadingAnchor.constraint(equalTo: checkBoxBtn.trailingAnchor, constant: 10).isActive = true
        
        
        
        customView.portfolioLbl.text = "Portfolio ID: \(portfolio?.portfolioID ?? "")"
        if let total = portfolio?.summary?.map( { Double($0.marketValue )} ).reduce(0, +) {
            customView.fundLbl.text = "Available Balance PKR. \(String(describing: total ).toCurrencyFormat(withFraction: false))"
        }
        customView.balanceLbl.isHidden = true
        
        accountView.accountName.text = bill?.billerName
        accountView.accountNo.text = bill?.accountNumber
        
        
        amountPKR.txtField.isUserInteractionEnabled = false
        if let amount = bill?.amountWithinDueDate {
            amountTxt = String(amount)
            amountPKR.setData(text: amountTxt)
        }
        
    }
    
    @objc func sendPayment() {
        let amount = Double(amountTxt) ?? .nan
        availableBalance = 5739572.0
        if checkBoxBtn.isSelected == false {
            self.showAlert(title: "Error", message: "please check box!", controller: self) {
                return
            }
        } else if availableBalance < amount {
            self.showAlert(title: "Error", message: "You do not have sufficient balance to pay this Bill", controller: self) {
                return
            }
        } else {
            if let bill = bill {
                let account_number = "03001111111" // bill.accountNumber
                let utilityCompanyID = "KESC0001" // bill.utilityCompanyID
                
                
                let request = BillTransferEntity.BillTransferRequest(transmissionDate: "20220610", transmissionTime: "135630", accountNumber: account_number, utilityCompanyID: utilityCompanyID, utilityConsumerNumber: "1700416100034", transactionAmount: amountTxt, branchCode: "1001", branchName: "Meezan Main Branch Lahore")
                
                interactor?.saveBillPayment(request: request)
            }
        }
    }
}

extension BillTransferViewController: BillTransferViewProtocol {
    func showDataFailure(error: String) {
        if error == noInternet {
            DispatchQueue.main.async {
                self.showAlert(title: "Error", message: error, controller: self, dismissCompletion: {
                })
            }
        }
    }
    
    func successBillPayment(response: [BillTransferEntity.BillTransferResponse]) {
        DispatchQueue.main.async {
            let vc = PayemntSuccessView()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

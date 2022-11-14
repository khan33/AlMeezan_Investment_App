//
//  AddPayeeVC.swift
//  AlMeezan
//
//  Created by Atta khan on 12/09/2022.
//  Copyright © 2022 Atta khan. All rights reserved.
//

import UIKit

class FetchTitlePayeeVC: UIViewController {
    private (set) lazy var headerView: PaymentHeaderView = { [unowned self] in
        let view = PaymentHeaderView.init(titleLbl: "Add Beneficiary", closeAction: {
            self.navigationController?.popViewController(animated: true)
        }, nextAction: {
            print("next")
        }, previousAction: {
            self.navigationController?.popViewController(animated: true)
        })
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
        btn.setTitle("VALIDATE", for: .normal)
        btn.tintColor = .white
        btn.backgroundColor = UIColor.purple
        btn.layer.cornerRadius = 20
        btn.addTarget(self, action: #selector(didTapOnValidateBtn), for: .touchUpInside)
        return btn
    }()
    
    private (set) lazy var containerView: UIView = { [unowned self] in
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.backgroundColor = .gray2
        return view
    }()
    
    private (set) lazy var scrollView: UIScrollView = { [unowned self] in
        let view = UIScrollView()
        view.showsVerticalScrollIndicator = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        return view
    }()
    
    private (set) lazy var contentView: UIView = { [unowned self] in
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        return view
    }()
    
    private (set) lazy var stackView: UIStackView = { [unowned self] in
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.distribution = .equalSpacing
        view.alignment = .fill
        view.axis = .vertical
        view.spacing = 16
        view.clipsToBounds = true
        return view
    }()
    
    var transactionLimitView: TransactionLimit = {
        var subview = TransactionLimit()
        subview.translatesAutoresizingMaskIntoConstraints = false
        subview.clipsToBounds = true
        return subview
    }()
    
    var organizationCompany: TextInputView!
    var accountNumberView: TextInputView!
    var orgranizationTxt: String = ""
    var accountNumberTxt: String = ""
    
    
    var dataSource: GenericPickerDataSource<bankListResponse>?
    var bankView: ButtonPickerView!
    private var bankNameTxt: String     =   ""
    private var bankCodeTxt: String     =   ""
    var bankItem: Int = 0

    
    var interactor: FetchTitlePayeeInteractorProtocol?
    var router: FetchTitlePayeeRouterProtocol?
    
    var bankList: [BankInfoViewEntity.BankInfoResponseModel]?

    override func viewDidLoad() {
        super.viewDidLoad()
        router?.navigationController = navigationController
        
        view.backgroundColor = .gray2
        setupContraints()
        showLoader()
        interactor?.viewDidLoad()
    }
    
    
    @objc private func didTapOnValidateBtn(_ sender: UIButton) {
        if self.bankNameTxt == "" {
            self.showAlert(title: "Alert", message: "Please select your bank.", controller: self) {
            }
            return
        }
        else if self.accountNumberTxt == "" {
            self.showAlert(title: "Alert", message: "Please enter your account information.", controller: self) {
            }
            return
        }
        let today = Date()
        let formatter3 = DateFormatter()
        formatter3.dateFormat = "HHmmss"
        let systemTime = formatter3.string(from: today)
        let formatter4 = DateFormatter()
        formatter4.dateFormat = "yyyyMMdd"
       let systemDate = formatter4.string(from: today)
        
        let reqeust = fetchTitleRequest(transmissionDate: systemDate, transmissionTime: systemTime, accountNumber: self.accountNumberTxt, bankName: self.bankCodeTxt)
        self.showLoader()
        interactor?.fetchTitlePayee(reqeust)
        
    }
    
    
    func setupContraints() {
        
        if !headerView.isDescendant(of: self.view) {
            self.view.addSubview(headerView)
        }
        
        headerView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        headerView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        view.addSubview(buttonView)
        buttonView.addSubview(addBeneficiaryBtn)
        if !containerView.isDescendant(of: self.view) {
            self.view.addSubview(containerView)
        }
        
        containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        containerView.topAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: buttonView.topAnchor).isActive = true
        
        if !scrollView.isDescendant(of: containerView) {
            containerView.addSubview(scrollView)
        }

        
        scrollView.topAnchor.constraint(equalTo: self.containerView.topAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor, constant: -16).isActive = true

        
        if !contentView.isDescendant(of: scrollView) {
            scrollView.addSubview(contentView)
        }
        contentView.topAnchor.constraint(equalTo: self.scrollView.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor).isActive = true
        contentView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor).isActive = true
        
        if !stackView.isDescendant(of: contentView) {
            contentView.addSubview(stackView)
        }
        
        stackView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10).isActive = true
        stackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 8).isActive = true
        stackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -8).isActive = true
        stackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: 0).isActive = true
            
        buttonView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        buttonView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        buttonView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        buttonView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.12).isActive = true

        addBeneficiaryBtn.centerYAnchor.constraint(equalTo: buttonView.centerYAnchor, constant: -5).isActive = true
        addBeneficiaryBtn.centerXAnchor.constraint(equalTo: buttonView.centerXAnchor).isActive = true
        addBeneficiaryBtn.heightAnchor.constraint(equalToConstant: 55).isActive = true
        addBeneficiaryBtn.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true

        bankView = ButtonPickerView(heading:  AppString.Heading.bankName, placeholder: AppString.PlaceHoderText.enterBankName, image: "down_Arrow") {
            let vc = CountrySearchVC()
            vc.bankInfo = self.bankList
            vc.searchType = .bank
            vc.bankDelegate = self
            self.present(vc, animated: false)
            
        }
        bankView.txtField.isUserInteractionEnabled = true
        bankView.containerView.backgroundColor = .gray2
        bankView.setData(text: bankNameTxt)
        stackView.addArrangedSubview(bankView)

        accountNumberView = TextInputView(heading: "Beneficiary Account Number / IBAN", placeholder: "Enter Beneficiary Account Number / IBAN", isPasswordEnable: false) { [weak self] (enteredText) in
            guard let self = self else {return}
            self.accountNumberTxt = enteredText
        }
        
        accountNumberView.setData(text: accountNumberTxt)
        accountNumberView.translatesAutoresizingMaskIntoConstraints = false
        accountNumberView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        accountNumberView.containerView.backgroundColor = .gray2
        stackView.addArrangedSubview(accountNumberView)
        stackView.addArrangedSubview(transactionLimitView)
        transactionLimitView.isHidden = true
    }

}

extension FetchTitlePayeeVC: FetchTitlePayeeViewProtocol {
    func getlistOfBank(_ response: [BankInfoViewEntity.BankInfoResponseModel]?){
        DispatchQueue.main.async {
            self.hideLoader()
            self.bankList = response
        }
    }
    
    func fetchTitleResponse(_ response: fetchTitleResponse) {
        DispatchQueue.main.async {
            self.hideLoader()
            if response.count > 0 {
                self.router?.addPayee(response[0])
            } else {
                self.showAlert(title: "Alert", message: "Something went worng please try again!", controller: self) {
                    
                }
            }
        }
    }
}


extension FetchTitlePayeeVC: SearchBankProtocol {
    func selectbankNmae(bank: BankInfoViewEntity.BankInfoResponseModel?) {
        self.hideLoader()
        bankView.txtField.resignFirstResponder()
        bankCodeTxt = bank?.BankID ?? ""
        bankNameTxt = bank?.bankName ?? ""
        bankView?.txtField.text = bankNameTxt
        bankView.setData(text: bankNameTxt)
        transactionLimitView.isHidden = false
        bankView.txtField.isUserInteractionEnabled = false

        let limitStr = (bank?.IBANFormat ?? "") + " <br> " + (bank?.LocalFormat ?? "")
        transactionLimitView.limitLbl.attributedText = limitStr.htmlToAttributedString
    }
}

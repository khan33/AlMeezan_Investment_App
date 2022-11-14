//
//  AddPayeeVC2.swift
//  AlMeezan
//
//  Created by Atta khan on 22/09/2022.
//  Copyright © 2022 Atta khan. All rights reserved.
//

import UIKit

class AddPayeeVC: UIViewController {
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
    
    private (set) lazy var containerView: UIView = { [unowned self] in
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.backgroundColor = .white
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
        view.spacing = 4
        view.clipsToBounds = true
        view.backgroundColor = .gray2
        return view
    }()
    
    
    private (set) lazy var stackView1: UIStackView = { [unowned self] in
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.distribution = .equalSpacing
        view.alignment = .fill
        view.axis = .vertical
        view.spacing = 10
        view.clipsToBounds = true
        view.backgroundColor = .white
        return view
    }()
    
    
    
    private (set) lazy var nameView: PayeeNameView = { [unowned self] in
        let view = PayeeNameView.init(titleLabl: "Name", subLabel: "Almeezan Investment", imageName: "account-box-outline")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private (set) lazy var bankView: PayeeNameView = { [unowned self] in
        let view = PayeeNameView.init(titleLabl: "Bank", subLabel: "00199930001", imageName: "bank")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private (set) lazy var accountView: PayeeNameView = { [unowned self] in
        let view = PayeeNameView.init(titleLabl: "Account Number", subLabel: "Muhammad Azhar", imageName: "file-document-outline")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    private let continueBtn: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.clipsToBounds = true
        btn.setTitle("CONTINUE", for: .normal)
        btn.tintColor = .white
        btn.backgroundColor = UIColor.purple
        btn.layer.cornerRadius = 20
        btn.addTarget(self, action: #selector(didTapOnContinueBtn), for: .touchUpInside)
        return btn
    }()
    
    private var nameTxt: String     =   ""
    private var emailTxt: String    =   ""
    private var mobileNumberTxt: String    =   ""
    private var relationshipTxt: String     =   ""

    
    var interactor: AddPayeeInteractorProtocol?
    var router: AddPayeeRouterProtocol?
    var payee: FundTransferEntity.FetchPayeeTitleResponseModel
    init(payee: FundTransferEntity.FetchPayeeTitleResponseModel) {
        self.payee = payee
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        router?.navigationController = navigationController
        setupContraints()
    }
    
    
    
    
    @objc private
    func didTapOnContinueBtn(_ sender: UIButton) {
        
        if self.emailTxt == "" {
            self.showAlert(title: "Alert", message: "Please enter your email.", controller: self) {
            }
            return
        }
        
        else if self.mobileNumberTxt == "" {
            self.showAlert(title: "Alert", message: "Please enter your mobile number.", controller: self) {
            }
            return
        }
        
        else if self.relationshipTxt == "" {
            self.showAlert(title: "Alert", message: "Please enter your relationship.", controller: self) {
            }
            return
        }
        
        
        
        let request = FundTransferEntity.AddPayeeRequest(BeneficiaryNickName: nameTxt, BankAccountTitle: self.payee.accountTitle, BankBranch: self.payee.branchName, BankName: self.payee.bankName, BankAccountNo: self.payee.beneficiaryIBAN, mobile: mobileNumberTxt, email: emailTxt, relationship: relationshipTxt)
        
        interactor?.addPayee(request)
    }

}


extension AddPayeeVC {
    func setupContraints() {
        view.addSubview(headerView)
        view.addSubview(containerView)
        containerView.addSubview(continueBtn)
       
        containerView.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(stackView)
        contentView.addSubview(stackView1)
        
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 100),
            
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            scrollView.topAnchor.constraint(equalTo: self.containerView.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.continueBtn.topAnchor, constant: -16),

            contentView.topAnchor.constraint(equalTo: self.scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor),
        
            
            stackView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),

            stackView1.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 20),
            stackView1.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20),
            stackView1.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -20),
            stackView1.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -20),
            
            
            bankView.heightAnchor.constraint(equalToConstant: 70),
            accountView.heightAnchor.constraint(equalToConstant: 70),
            nameView.heightAnchor.constraint(equalToConstant: 70),
            
            continueBtn.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: 20),
            continueBtn.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor, constant: -20),
            continueBtn.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor, constant: -20),
            continueBtn.heightAnchor.constraint(equalToConstant: 55)
            
        ])
        bankView.backgroundColor = .gray2
        accountView.backgroundColor = .gray2
        nameView.backgroundColor = .gray2
        bankView.containerView.backgroundColor = .gray2
        accountView.containerView.backgroundColor = .gray2
        nameView.containerView.backgroundColor = .gray2
        
        stackView.addArrangedSubview(bankView)
        stackView.addArrangedSubview(accountView)
        stackView.addArrangedSubview(nameView)
        
        bankView.subLbl.text = self.payee.bankName
        accountView.subLbl.text = self.payee.beneficiaryIBAN
        nameView.subLbl.text = self.payee.accountTitle
        
        
        
        
        
        let nameView = TextInputView(heading:  "Alias(optional)", placeholder: AppString.PlaceHoderText.enterName, isPasswordEnable: false) { [weak self] (enteredText) in
            guard let self = self else {return}
            self.nameTxt = enteredText
        }
        nameView.txtField.autocapitalizationType = .allCharacters
        nameView.setData(text: nameTxt)
        stackView1.addArrangedSubview(nameView)
        
        let emailView = TextInputView(heading:  "Email", placeholder: "Enter your email", isPasswordEnable: false) { [weak self] (enteredText) in
            guard let self = self else {return}
            self.emailTxt = enteredText
        }
        emailView.txtField.keyboardType = .emailAddress
        emailView.setData(text: emailTxt)
        stackView1.addArrangedSubview(emailView)

        
        
        let phoneView = TextInputView(heading:  "Mobile", placeholder: "Enter your mobile Number", isPasswordEnable: false) { [weak self] (enteredText) in
            guard let self = self else {return}
            self.mobileNumberTxt = enteredText
        }
        phoneView.txtField.keyboardType = .asciiCapableNumberPad
        phoneView.setData(text: mobileNumberTxt)
        stackView1.addArrangedSubview(phoneView)
        
        
        let relationshipView = TextInputView(heading:  "Relationship", placeholder: "Enter your relationship", isPasswordEnable: false) { [weak self] (enteredText) in
            guard let self = self else {return}
            self.relationshipTxt = enteredText
        }
        relationshipView.setData(text: relationshipTxt)
        stackView1.addArrangedSubview(relationshipView)   
    }
}

extension AddPayeeVC: AddPayeeViewProtocol {
    func addPayee(_ response: [FundTransferEntity.AddPayeeResponseModel]) {
        if response.count > 0 {
            DispatchQueue.main.async {
                self.router?.navigateToOTPScreen(self.payee, response[0].uniqueId ?? "")
            }
        }
    }
}

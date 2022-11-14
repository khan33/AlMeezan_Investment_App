//
//  AddPayeeSuccessVC.swift
//  AlMeezan
//
//  Created by Atta khan on 26/09/2022.
//  Copyright © 2022 Atta khan. All rights reserved.
//

import UIKit

class AddPayeeSuccessVC: UIViewController {
    //MARK: Properties
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
        view.backgroundColor = .gray2
        return view
    }()
    
    private (set) lazy var imgView: UIImageView = { [unowned self] in
        var imgView = UIImageView()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.clipsToBounds = true
        imgView.image = UIImage(named: "success_img")
        imgView.contentMode = .scaleAspectFill
        return imgView
    }()
    
    private (set) lazy var bottomView: UIView = { [unowned self] in
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.backgroundColor = .white
        view.roundCorners([.layerMinXMinYCorner,.layerMaxXMinYCorner], radius: 20, borderColor: .newGray, borderWidth: 0.3)
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
        view.spacing = 2
        view.clipsToBounds = true
        return view
    }()
    
    private (set) lazy var congrLbl: UILabel = { [unowned self] in
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor().hexStringToUIColor(hex: "#232746")
        label.text = "Congratulations!"
        label.numberOfLines = 0
        label.font = UIFont(name: AppFontName.robotoMedium, size: 29)
        label.textAlignment = .center
        return label
    }()
    private (set) lazy var congdesc: UILabel = { [unowned self] in
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.black
        label.text = "Beneficiary has been added."
        label.numberOfLines = 0
        label.textColor = UIColor().hexStringToUIColor(hex: "#232746")
        label.font = UIFont(name: AppFontName.robotoRegular, size: 15)
        label.textAlignment = .center
        return label
    }()
    
    
    private (set) lazy var nameView: PayeeNameView = { [unowned self] in
        let view = PayeeNameView.init(titleLabl: "Name", subLabel: "", imageName: "account-box-outline")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private (set) lazy var bankView: PayeeNameView = { [unowned self] in
        let view = PayeeNameView.init(titleLabl: "Bank", subLabel: "", imageName: "bank")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private (set) lazy var accountView: PayeeNameView = { [unowned self] in
        let view = PayeeNameView.init(titleLabl: "Account Number", subLabel: "", imageName: "file-document-outline")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let emptyView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private (set) lazy var transferNowBtn: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.clipsToBounds = true
        btn.setTitle("TRANSFER NOW", for: .normal)
        btn.tintColor = .white
        btn.backgroundColor = UIColor.purple
        btn.layer.cornerRadius = 20
        btn.addTarget(self, action: #selector(didTapOnTransferBtn), for: .touchUpInside)
        return btn
    }()
    
    var sections: [String: [FundTransferEntity.PayeeHistroyModel] ] =  [String: [FundTransferEntity.PayeeHistroyModel] ]()
    var sortedSections = [String]()

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
        setupView()
        
    }
    @objc func didTapOnTransferBtn() {
        let vc = PayeeViewController()
        PayeeViewControllerConfigurator.configureModule(viewController: vc)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


extension AddPayeeSuccessVC {
    private func setupView() {
        
        if !headerView.isDescendant(of: self.view) {
            self.view.addSubview(headerView)
        }
        
        if !containerView.isDescendant(of: self.view) {
            self.view.addSubview(containerView)
        }
        
        if !imgView.isDescendant(of: containerView) {
            containerView.addSubview(imgView)
        }
        
        if !bottomView.isDescendant(of: self.containerView) {
            containerView.addSubview(bottomView)
        }
        
        if !scrollView.isDescendant(of: self.bottomView) {
            bottomView.addSubview(scrollView)
        }
        
        if !contentView.isDescendant(of: self.scrollView) {
            scrollView.addSubview(contentView)
        }
        
        if !stackView.isDescendant(of: self.contentView) {
            contentView.addSubview(stackView)
        }
        
        
        
        stackView.addArrangedSubview(congrLbl)
        stackView.addArrangedSubview(congdesc)
        stackView.addArrangedSubview(nameView)
        stackView.addArrangedSubview(bankView)
        stackView.addArrangedSubview(accountView)
        stackView.addArrangedSubview(emptyView)
        stackView.addArrangedSubview(transferNowBtn)
        
        
        
        NSLayoutConstraint.activate([
            
            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 100),
            
            containerView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            
            imgView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor, constant: 0),
            imgView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 24),
            
            bottomView.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor, constant: 0),
            bottomView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
            bottomView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0),
            bottomView.heightAnchor.constraint(equalTo: self.containerView.heightAnchor, multiplier: 0.6),
            
            
            scrollView.topAnchor.constraint(equalTo: self.bottomView.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: self.bottomView.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.bottomView.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.bottomView.bottomAnchor),
            
            
            

            contentView.topAnchor.constraint(equalTo: self.scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor),
        
            
            
            stackView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            
            congrLbl.topAnchor.constraint(equalTo: self.stackView.topAnchor, constant: 20),
            
            nameView.heightAnchor.constraint(equalToConstant: 70),
            bankView.heightAnchor.constraint(equalToConstant: 70),
            accountView.heightAnchor.constraint(equalToConstant: 70),
            emptyView.heightAnchor.constraint(equalToConstant: 30),
            transferNowBtn.heightAnchor.constraint(equalToConstant: 44),
            transferNowBtn.leadingAnchor.constraint(equalTo: self.stackView.leadingAnchor, constant: 20),
            transferNowBtn.trailingAnchor.constraint(equalTo: self.stackView.trailingAnchor, constant: -20),
            
            
            
        ])
        bankView.subLbl.text = self.payee.bankName
        accountView.subLbl.text = self.payee.beneficiaryIBAN
        nameView.subLbl.text = self.payee.accountTitle
    }
    
}

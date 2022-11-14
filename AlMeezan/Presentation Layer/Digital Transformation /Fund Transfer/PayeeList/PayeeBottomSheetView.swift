//
//  PayeeBottomSheetView.swift
//  AlMeezan
//
//  Created by Atta khan on 28/09/2022.
//  Copyright © 2022 Atta khan. All rights reserved.
//

import Foundation


class PayeeBottomSheetView: UIViewController {
    
    private (set) lazy var lblTitle: UILabel = { [unowned self] in
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Payee Details"
        label.textColor =  UIColor.black
        label.font = UIFont(name: AppFontName.robotoMedium, size: 16)
        return label
    }()
    
    private (set) lazy var closeBtn: UIButton = { [unowned self] in
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.clipsToBounds = true
        btn.setImage(UIImage(named: "closegray"), for: .normal)
        btn.addTarget(self, action: #selector(didTapCloseBtn), for: .touchUpInside)
        return btn
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
    
    
    private (set) lazy var addTransferBtn: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.clipsToBounds = true
        btn.setTitle("TRANSFER NOW", for: .normal)
        btn.tintColor = .white
        btn.backgroundColor = UIColor.purple
        btn.layer.cornerRadius = 20
        //btn.addTarget(self, action: #selector(didTapOnAddPayeeBtn), for: .touchUpInside)
        return btn
    }()
    
    
    
    var payee_detail: FundTransferEntity.PayeeResponseModel?
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        view.layer.borderColor = UIColor.gray2.cgColor
        view.layer.borderWidth = 0.5
//        view.layer.shadowOffset = 0.5
        setupView()
        nameView.subLbl.text = payee_detail?.bankAccountTitle
        bankView.subLbl.text = payee_detail?.bankName
        accountView.subLbl.text = payee_detail?.bankAccountNo
        
    }
    
    
    func setupView() {
        view.addSubview(lblTitle)
        view.addSubview(closeBtn)
        view.addSubview(nameView)
        view.addSubview(bankView)
        view.addSubview(accountView)
        view.addSubview(addTransferBtn)
        
        
        NSLayoutConstraint.activate([
            lblTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            lblTitle.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            closeBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            closeBtn.topAnchor.constraint(equalTo: view.topAnchor, constant: 8),
            
            nameView.topAnchor.constraint(equalTo: lblTitle.bottomAnchor, constant: 30),
            nameView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            nameView.heightAnchor.constraint(equalToConstant: 70),
            bankView.topAnchor.constraint(equalTo: nameView.bottomAnchor, constant: 16),
            bankView.leadingAnchor.constraint(equalTo: nameView.leadingAnchor),
            bankView.trailingAnchor.constraint(equalTo: nameView.trailingAnchor),
            bankView.heightAnchor.constraint(equalToConstant: 70),
            accountView.topAnchor.constraint(equalTo: bankView.bottomAnchor, constant: 16),
            accountView.leadingAnchor.constraint(equalTo: nameView.leadingAnchor),
            accountView.trailingAnchor.constraint(equalTo: nameView.trailingAnchor),
            accountView.heightAnchor.constraint(equalToConstant: 70),
            addTransferBtn.topAnchor.constraint(equalTo: accountView.bottomAnchor, constant: 16),
            addTransferBtn.leadingAnchor.constraint(equalTo: nameView.leadingAnchor),
            addTransferBtn.trailingAnchor.constraint(equalTo: nameView.trailingAnchor),
            addTransferBtn.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    @objc private func didTapCloseBtn() {
        dismiss(animated: true, completion: nil)
    }
}

//
//  PayeeHistoryDetailBottomSheet.swift
//  AlMeezan
//
//  Created by Atta khan on 28/09/2022.
//  Copyright © 2022 Atta khan. All rights reserved.
//

import Foundation

class PayeeHistoryDetailBottomSheet: UIViewController {
 
    private (set) lazy var dissMissBtn: UIButton = { [unowned self] in
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.clipsToBounds = true
        btn.setImage(UIImage(named: "closegray"), for: .normal)
        btn.addTarget(self, action: #selector(didTapCloseBtn), for: .touchUpInside)
        return btn
    }()
    
    // MARK: Views
    
    private var amountView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var dateView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var descriptionView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var fromAccountView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var dashedView: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGreen
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    
    //MARK: Labels
    
    public var transactionLabl: UILabel = {
        var label = UILabel()
        label.text = "Transaction Details"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.black
        label.font = UIFont(name: AppFontName.circularStdRegular, size: 16)
        return label
    }()
    
    public var amountTitleLbl: UILabel = {
        var label = UILabel()
        label.text = "Amount"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.black
        label.font = UIFont(name: AppFontName.robotoRegular, size: 12)
        return label
    }()
    
    public var amountLbl: UILabel = {
        var label = UILabel()
        label.text = ""
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.black
        label.font = UIFont(name: AppFontName.circularStdBold, size: 16)
        return label
    }()
    
    public var dateTitleLbl: UILabel = {
        var label = UILabel()
        label.text = "Date"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.black
        label.font = UIFont(name: AppFontName.robotoRegular, size: 12)
        return label
    }()
    
    public var dateLbl: UILabel = {
        var label = UILabel()
        label.text = ""
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.black
        label.font = UIFont(name: AppFontName.robotoRegular, size: 12)
        return label
    }()
    
    public var fromLbl: UILabel = {
        var label = UILabel()
        label.text = "From"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.black
        label.font = UIFont(name: AppFontName.robotoMedium, size: 11)
        return label
    }()
    
    public var portfolioLbl: UILabel = {
        var label = UILabel()
        label.text = ""
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.black
        label.font = UIFont(name: AppFontName.robotoRegular, size: 12)
        return label
    }()
    
    public var portfolioNumber: UILabel = {
        var label = UILabel()
        label.text = ""
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .lightGray
        label.font = UIFont(name: AppFontName.robotoRegular, size: 12)
        return label
    }()
    
    public var toLbl: UILabel = {
        var label = UILabel()
        label.text = "To"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.black
        label.font = UIFont(name: AppFontName.robotoMedium, size: 11)
        return label
    }()
    
    public var accountNameLbl: UILabel = {
        var label = UILabel()
        label.text = ""
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.black
        label.font = UIFont(name: AppFontName.robotoRegular, size: 12)
        return label
    }()
    
    public var accountNoLbl: UILabel = {
        var label = UILabel()
        label.text = ""
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .lightGray
        label.font = UIFont(name: AppFontName.robotoRegular, size: 12)
        return label
    }()
    
    
    public var descriptionTitleLbl: UILabel = {
        var label = UILabel()
        label.text = "Description"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.black
        label.font = UIFont(name: AppFontName.robotoRegular, size: 12)
        return label
    }()
    
    public var descriptionLbl: UILabel = {
        var label = UILabel()
        label.text = "Payment of 8932423432 Mohammad Azhar to Account 011153234323"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.black
        label.numberOfLines = 0
        label.font = UIFont(name: AppFontName.robotoRegular, size: 12)
        return label
    }()
    
    // MARK: Images
    
    public var greenDot: UIImageView = {
        var image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        image.image = UIImage(named: "Ellipse")
        return image
    }()
    
    public var secondGreenDot: UIImageView = {
        var image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        image.image = UIImage(named: "Ellipse")
        return image
    }()
    
    
    
    var payee_detail: FundTransferEntity.PayeeHistroyModel?
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        view.layer.borderColor = UIColor.gray2.cgColor
        view.layer.borderWidth = 0.5
                
        addSubViews()
        setupContraints()

    }
    
    
    
    
    @objc private func didTapCloseBtn() {
        dismiss(animated: true, completion: nil)
    }
    func addSubViews() {
        
        view.addSubview(transactionLabl)
        view.addSubview(dissMissBtn)
        view.addSubview(amountView)
        view.addSubview(dateView)
        view.addSubview(fromAccountView)
        view.addSubview(descriptionView)
        amountView.addSubview(amountTitleLbl)
        amountView.addSubview(amountLbl)
        dateView.addSubview(dateTitleLbl)
        dateView.addSubview(dateLbl)
        fromAccountView.addSubview(greenDot)
        fromAccountView.addSubview(secondGreenDot)
        fromAccountView.addSubview(dashedView)
        fromAccountView.addSubview(fromLbl)
        fromAccountView.addSubview(portfolioLbl)
        fromAccountView.addSubview(portfolioNumber)
        fromAccountView.addSubview(toLbl)
        fromAccountView.addSubview(accountNameLbl)
        fromAccountView.addSubview(accountNoLbl)
        descriptionView.addSubview(descriptionTitleLbl)
        descriptionView.addSubview(descriptionLbl)
    }
    
    func setupContraints() {
        transactionLabl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        transactionLabl.topAnchor.constraint(equalTo: view.topAnchor, constant: 10).isActive = true
//
        dissMissBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5).isActive = true
        dissMissBtn.topAnchor.constraint(equalTo: view.topAnchor, constant: 5).isActive = true
        dissMissBtn.heightAnchor.constraint(equalToConstant: 30).isActive = true
        dissMissBtn.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        amountView.topAnchor.constraint(equalTo: transactionLabl.bottomAnchor, constant: 10).isActive = true
        amountView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        amountView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5).isActive = true
        amountView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.19).isActive = true
        
        dateView.topAnchor.constraint(equalTo: transactionLabl.bottomAnchor, constant: 10).isActive = true
        dateView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        dateView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5).isActive = true
        dateView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.19).isActive = true
        
        fromAccountView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        fromAccountView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        fromAccountView.topAnchor.constraint(equalTo: dateView.bottomAnchor).isActive = true
        fromAccountView.bottomAnchor.constraint(equalTo: descriptionView.topAnchor).isActive = true
        
        descriptionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 10).isActive = true
        descriptionView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1).isActive = true
        descriptionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3).isActive = true
        
        amountTitleLbl.topAnchor.constraint(equalTo: amountView.topAnchor, constant: 10).isActive = true
        amountTitleLbl.leadingAnchor.constraint(equalTo: amountView.leadingAnchor, constant: 20).isActive = true
        amountTitleLbl.trailingAnchor.constraint(equalTo: amountView.trailingAnchor).isActive = true
        
        amountLbl.topAnchor.constraint(equalTo: amountTitleLbl.bottomAnchor, constant: 5).isActive = true
        amountLbl.leadingAnchor.constraint(equalTo: amountTitleLbl.leadingAnchor).isActive = true
        amountLbl.trailingAnchor.constraint(equalTo: amountTitleLbl.trailingAnchor).isActive = true
        
        dateTitleLbl.topAnchor.constraint(equalTo: dateView.topAnchor, constant: 10).isActive = true
        dateTitleLbl.leadingAnchor.constraint(equalTo: dateView.leadingAnchor, constant: 20).isActive = true
        dateTitleLbl.trailingAnchor.constraint(equalTo: dateView.trailingAnchor).isActive = true
        
        dateLbl.topAnchor.constraint(equalTo: dateTitleLbl.bottomAnchor, constant: 5).isActive = true
        dateLbl.leadingAnchor.constraint(equalTo: dateTitleLbl.leadingAnchor).isActive = true
        dateLbl.trailingAnchor.constraint(equalTo: dateTitleLbl.trailingAnchor).isActive = true
        
        
        greenDot.topAnchor.constraint(equalTo: fromAccountView.topAnchor, constant: 5).isActive = true
        greenDot.leadingAnchor.constraint(equalTo: fromAccountView.leadingAnchor, constant: 20).isActive = true
        greenDot.widthAnchor.constraint(equalToConstant: 10).isActive = true
        greenDot.heightAnchor.constraint(equalToConstant: 10).isActive = true
        
        dashedView.topAnchor.constraint(equalTo: greenDot.bottomAnchor).isActive = true
        dashedView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2).isActive = true
        dashedView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24).isActive = true
        dashedView.widthAnchor.constraint(equalToConstant: 2).isActive = true
        
        secondGreenDot.topAnchor.constraint(equalTo: dashedView.bottomAnchor).isActive = true
        secondGreenDot.leadingAnchor.constraint(equalTo: fromAccountView.leadingAnchor, constant: 20).isActive = true
        secondGreenDot.widthAnchor.constraint(equalToConstant: 10).isActive = true
        secondGreenDot.heightAnchor.constraint(equalToConstant: 10).isActive = true

        fromLbl.topAnchor.constraint(equalTo: fromAccountView.topAnchor, constant: 5).isActive = true
        fromLbl.leadingAnchor.constraint(equalTo: greenDot.trailingAnchor, constant: 10).isActive = true
        
        portfolioLbl.topAnchor.constraint(equalTo: fromLbl.bottomAnchor, constant: 5).isActive = true
        portfolioLbl.leadingAnchor.constraint(equalTo: fromLbl.leadingAnchor).isActive = true
        
        portfolioNumber.topAnchor.constraint(equalTo: portfolioLbl.bottomAnchor, constant: 5).isActive = true
        portfolioNumber.leadingAnchor.constraint(equalTo: portfolioLbl.leadingAnchor).isActive = true
        
        toLbl.topAnchor.constraint(equalTo: secondGreenDot.topAnchor).isActive = true
        toLbl.leadingAnchor.constraint(equalTo: portfolioNumber.leadingAnchor).isActive = true
        
        accountNameLbl.topAnchor.constraint(equalTo: toLbl.bottomAnchor, constant: 5).isActive = true
        accountNameLbl.leadingAnchor.constraint(equalTo: toLbl.leadingAnchor).isActive = true
        
        accountNoLbl.topAnchor.constraint(equalTo: accountNameLbl.bottomAnchor, constant: 5).isActive = true
        accountNoLbl.leadingAnchor.constraint(equalTo: accountNameLbl.leadingAnchor).isActive = true
        
        descriptionTitleLbl.topAnchor.constraint(equalTo: descriptionView.topAnchor, constant: 0).isActive = true
        descriptionTitleLbl.leadingAnchor.constraint(equalTo: descriptionView.leadingAnchor, constant: 20).isActive = true
        descriptionTitleLbl.trailingAnchor.constraint(equalTo: descriptionView.trailingAnchor).isActive = true
        
        descriptionLbl.topAnchor.constraint(equalTo: descriptionTitleLbl.bottomAnchor, constant: 5).isActive = true
        descriptionLbl.leadingAnchor.constraint(equalTo: descriptionTitleLbl.leadingAnchor).isActive = true
        descriptionLbl.trailingAnchor.constraint(equalTo: descriptionView.trailingAnchor, constant: -30).isActive = true
        
        
        if let amount = Int(payee_detail?.transactionAmount ?? "0") {
            amountLbl.text = "PKR \(amount)"
        }
        
        if payee_detail?.type == "bill" {
            portfolioLbl.text = payee_detail?.utilityCompanyId
            accountNameLbl.text = payee_detail?.utilityConsumerNumber
            accountNoLbl.text = payee_detail?.utilityConsumerNumber
        } else {
            portfolioLbl.text = "Portfolio ID \(payee_detail?.fromAccountNumber ?? "000")"
            accountNameLbl.text = payee_detail?.beneficiaryTitle ?? ""
            accountNoLbl.text = payee_detail?.toAccountNumber ?? ""
        }
        
        
        portfolioNumber.isHidden = true
        
        
        
        
        let dateStr = payee_detail?.time_stamp?.toDate(withFormat: "yyyy-MM-dd'T'HH:mm:ss.SSS")
        
        let transaction_date = dateStr?.toString(format: "EE, d MMM yyyy hh:mm a") ?? ""
        dateLbl.text = transaction_date
        
    }
}

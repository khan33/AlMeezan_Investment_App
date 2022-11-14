//
//  TransferFundViewController.swift
//  AlMeezan
//
//  Created by Atta khan on 12/09/2022.
//  Copyright © 2022 Atta khan. All rights reserved.
//

import UIKit

class TransferFundViewController: UIViewController {
    
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
        image.image = UIImage(named: IconName.greenDot)
        return image
    }()
    
    public var midDotImage: UIImageView = {
        var image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        image.image = UIImage(named: IconName.greenDot)
        return image
    }()
    
    public var containerView: UIView = {
        var view = UIView()
        view.backgroundColor = .white
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
        btn.setTitle("TRANSFER", for: .normal)
        btn.tintColor = .white
        btn.backgroundColor = UIColor.purple
        btn.layer.cornerRadius = 20
        btn.addTarget(self, action: #selector(hideLimit), for: .touchUpInside)
        return btn
    }()
    
    private var uiview: UIView = {
        var view = UIView()
        view.backgroundColor = .gray2
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private (set) lazy var accountView: AccountView = {
        let view = AccountView(accountNames: "Azhar", accountNos: "AlMezan022131232", viewColor: .white)
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
        image.image = UIImage(named: "dashedline")
        return image
    }()
    
    public var dashedImageTwo: UIImageView = {
        var image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        if #available(iOS 13.0, *) {
            image.image = UIImage(named: "dashedline")?.withTintColor(.gray, renderingMode: .alwaysOriginal)
        } else {
            // Fallback on earlier versions
        }
        return image
    }()
    
    public var lastDotImage: UIImageView = {
        var image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        if #available(iOS 13.0, *) {
            image.image = UIImage(named: IconName.greenDot)?.withTintColor(.purple, renderingMode: .alwaysOriginal)
        } else {
            // Fallback on earlier versions
        }
        return image
    }()
    
    private var agreementView: UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    private let checkBoxBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.isSelected = false
        btn.setImage(UIImage(named: "unchecked"), for: .normal)
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
    
    private var amountPKR: TextInputView!
    private var amountTxt: String = ""
    private var purpose: TextInputView!
    private var purposeTxt: String = " "
    
    var isTapped: Bool = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.customGray
        addSubViews()
        setupConstraint()
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
        dotImage.leadingAnchor.constraint(equalTo: uiview.leadingAnchor, constant: 40).isActive = true
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
        customView.trailingAnchor.constraint(equalTo:  uiview.trailingAnchor, constant: -15).isActive = true
        
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
        UserDefaults.standard.set(amountTxt, forKey: "Amount")
        amountPKR.txtField.keyboardType = .asciiCapableNumberPad
        amountPKR.setData(text: amountTxt)
        self.amountPKR.lblHeading.isHidden = true
        self.amountPKR.translatesAutoresizingMaskIntoConstraints = false
        uiview.addSubview(amountPKR)
        
        amountPKR.leadingAnchor.constraint(equalTo: uiview.leadingAnchor, constant: 55).isActive = true
        amountPKR.topAnchor.constraint(equalTo: enterAmountLbl.bottomAnchor, constant: 10).isActive = true
        amountPKR.heightAnchor.constraint(equalToConstant: 50).isActive = true
        amountPKR.trailingAnchor.constraint(equalTo: accountView.trailingAnchor).isActive = true
        
        
        transactionLimitView.topAnchor.constraint(equalTo: amountPKR.bottomAnchor, constant: 15).isActive = true
        transactionLimitView.heightAnchor.constraint(equalToConstant: 50).isActive = true
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
        stackView.leadingAnchor.constraint(equalTo: innerScrollView.leadingAnchor, constant: 20).isActive = true
        stackView.trailingAnchor.constraint(equalTo: innerScrollView.trailingAnchor, constant: -20).isActive = true
        stackView.centerXAnchor.constraint(equalTo: innerScrollView.centerXAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: innerScrollView.bottomAnchor).isActive = true
        
        purpose = TextInputView(heading: "Purpose", placeholder: "Others", isPasswordEnable: false) { [weak self] (enteredText) in
            guard let self = self else {return}
            self.purposeTxt = enteredText
        }
        UserDefaults.standard.set(purposeTxt, forKey: "Purpose")
        purpose.txtField.keyboardType = .default
        purpose.setData(text: purposeTxt)
        stackView.addArrangedSubview(purpose)
        
        stackView.addArrangedSubview(agreementView)
        agreementView.addSubview(checkBoxBtn)
        agreementView.addSubview(agreementLbl)
        
        
        checkBoxBtn.centerYAnchor.constraint(equalTo: agreementView.centerYAnchor, constant: 0).isActive = true
        checkBoxBtn.leadingAnchor.constraint(equalTo: agreementView.leadingAnchor, constant: 20).isActive = true
        
        agreementLbl.centerYAnchor.constraint(equalTo: agreementView.centerYAnchor, constant: 0).isActive = true
        agreementLbl.leadingAnchor.constraint(equalTo: checkBoxBtn.trailingAnchor, constant: 10).isActive = true
        
    }
    
    @objc func hideLimit() {
        transactionLimitView.isHidden = true
        transactionLimitView.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
}


class CustomPortfolioView: UIView {
    
    private let view: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.purple
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    public var backgroundImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.image = UIImage(named: "MaskGroup")
        view.layer.cornerRadius = 10
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    public var image: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.image = UIImage(named: "logo")
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    public var portfolioLbl: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.white
        label.font = UIFont(name: AppFontName.circularStdBold, size: 14)
        return label
    }()
    
    public var  balanceLbl: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.white
        label.font = UIFont(name: AppFontName.robotoRegular, size: 12)
        return label
    }()
    
    public var fundLbl: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.white
        label.text = ""
        label.font = UIFont(name: AppFontName.robotoRegular, size: 12)
        return label
    }()
    
    public var chevronImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.image = UIImage(named: IconName.chevron_down)
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    init(portfolioLabel: String, balanceLabel: String, viewColor: UIColor) {
        super.init(frame: CGRect.zero)
        self.balanceLbl.text = balanceLabel
        self.portfolioLbl.text = portfolioLabel
        self.view.backgroundColor = viewColor
        self.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(view)
        view.addSubview(backgroundImage)
        view.addSubview(image)
        view.addSubview(portfolioLbl)
        view.addSubview(fundLbl)
        view.addSubview(balanceLbl)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupConstraints() {
        
        view.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        view.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        view.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        backgroundImage.heightAnchor.constraint(equalTo: view.heightAnchor, constant: 1).isActive = true
        backgroundImage.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -1).isActive = true
        
        image.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        image.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        image.widthAnchor.constraint(equalToConstant: 50).isActive = true
        image.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        portfolioLbl.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -15).isActive = true
        portfolioLbl.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 10).isActive = true
        
        fundLbl.topAnchor.constraint(equalTo: portfolioLbl.bottomAnchor, constant: 2).isActive = true
        fundLbl.leadingAnchor.constraint(equalTo: portfolioLbl.leadingAnchor).isActive = true
        fundLbl.trailingAnchor.constraint(equalTo: portfolioLbl.trailingAnchor, constant: 0).isActive = true
        
        balanceLbl.topAnchor.constraint(equalTo: fundLbl.bottomAnchor, constant: 2).isActive = true
        balanceLbl.leadingAnchor.constraint(equalTo: fundLbl.leadingAnchor).isActive = true
        balanceLbl.trailingAnchor.constraint(equalTo: fundLbl.trailingAnchor).isActive = true
        
    }
    
}
class AccountView: UIView {
    
    private let view: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.purple
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    public var backgroundImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.image = UIImage(named: "MaskGroup")
        view.layer.cornerRadius = 10
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    public var image: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.image = UIImage(named: "logo")
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    public var accountName: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.white
        label.font = UIFont(name: AppFontName.circularStdBold, size: 14)
        return label
    }()
    
    public var accountNo: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.white
        label.font = UIFont(name: AppFontName.robotoRegular, size: 12)
        return label
    }()
    
    init(accountNames: String, accountNos: String, viewColor: UIColor) {
        super.init(frame: CGRect.zero)
        self.accountName.text = accountNames
        self.accountNo.text = accountNos
        self.view.backgroundColor = viewColor
        self.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(view)
        view.addSubview(backgroundImage)
        view.addSubview(image)
        view.addSubview(accountName)
        view.addSubview(accountNo)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupConstraints() {
        
        view.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        view.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        view.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        backgroundImage.heightAnchor.constraint(equalTo: view.heightAnchor, constant: 1).isActive = true
        backgroundImage.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -1).isActive = true
        
        image.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        image.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        image.widthAnchor.constraint(equalToConstant: 50).isActive = true
        image.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        accountName.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -10).isActive = true
        accountName.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 10).isActive = true
        
        accountNo.topAnchor.constraint(equalTo: accountName.bottomAnchor, constant: 5).isActive = true
        accountNo.leadingAnchor.constraint(equalTo: accountName.leadingAnchor).isActive = true
        accountNo.trailingAnchor.constraint(equalTo: accountName.trailingAnchor).isActive = true
        
    }
    
}
class TransactionLimit: UIView {
    
    public var containerView: UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightPurple
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.purple.cgColor
        view.layer.cornerRadius = 6
        
        return view
    }()
    
    var limitLbl: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.textAlignment = .center
        label.textColor = UIColor.black
        label.font = UIFont(name: AppFontName.robotoRegular, size: 12)
        label.clipsToBounds = true
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    
    let image: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "information-outline")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    init() {
        super.init(frame: CGRect.zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        setupConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupConstraint() {
        self.addSubview(containerView)
        containerView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        containerView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        containerView.addSubview(image)
        image.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 15).isActive = true
        image.heightAnchor.constraint(equalToConstant: 20).isActive = true
        image.widthAnchor.constraint(equalToConstant: 20).isActive = true
        image.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10).isActive = true
        
        containerView.addSubview(limitLbl)
        limitLbl.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10).isActive = true
        limitLbl.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 10).isActive = true
        limitLbl.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10).isActive = true
        limitLbl.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10).isActive = true
    }
    
}

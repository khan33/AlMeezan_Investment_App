//
//  InvestmentdetailsViewController.swift
//  AlMeezan
//
//  Created by Atta khan on 08/02/2022.
//  Copyright © 2022 Atta khan. All rights reserved.
//
//AccountOpeningFunds

import UIKit

class InvestmentdetailsViewController: UIViewController {
    private (set) lazy var headerView: HeaderView = { [unowned self] in
        let view = HeaderView.init(stepValue: "8 / 9", titleStr: "Investment Detail", subTitle: "Fund Category" ,numberOfPages: 0, currentPageNo: 0, closeAction: {
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
        view.spacing = 16
        view.clipsToBounds = true
        return view
    }()
    
    private var fundCategoryTxt: String                  =   ""
    private var fundSelectionTxt: String  =   ""
    private var transactionDetailTxt: String          =   ""
    private var totalDeductionTxt: String           =   ""
    private var bankTxt: String  =   ""
    private var bankId: String  =   ""
    private var occupationTxt: String =   ""
    private var fund_id: String = ""
    private var agent_id: String = ""
    var bankNameItem: Int = 0

    var fundCategoryView: ButtonPickerView!
    var fundSelectionView: ButtonPickerView!
    var bankView: ButtonPickerView!
    var occupationView: ButtonPickerView!
    var transactionDetailView: CurrencyInputView!
    var totalDeductionView: TextInputView!
    var termsAndConditionView: TermsAndConditionView!
    var dataSource: GenericPickerDataSource<OptionModel>?
    var bankDataSource: GenericPickerDataSource<BankInfoViewEntity.BankInfoResponseModel>?
    var occupation: [OptionModel] = [OptionModel]()
    var banks: [BankInfoViewEntity.BankInfoResponseModel] = [BankInfoViewEntity.BankInfoResponseModel]()
    var fundDataSource: GenericPickerDataSource<AccountOpeningFunds>?
    var interactor: InvestmentInteractor?
    var router: InvestmentRouterProtocol?
    var funds: [AccountOpeningFunds] = [AccountOpeningFunds]()
    var unique_funds: [AccountOpeningFunds] = [AccountOpeningFunds]()
    var filter_funds = [AccountOpeningFunds]()
    var isMoneyMarket = false
    var isTerms: Bool = false
    var disclaimer: [String] = [String]()
    var totalDisclaimer = 6
    var totalDisclaimerSelected = 0
    let disclaimer4: String = "I confirm acceptance of Terms & Condition and all changes governing in this Transaction"
    var disclaimer2Lbl: UILabel = UILabel()
    var idealFund: String?
    var categoryItem: Int = 0
    var fundItem: Int = 0
    var onlineAccountType: String = OnlineAccountType.SSA.rawValue
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let account = UserDefaults.standard.string(forKey: "OnlineAccountType") {
            onlineAccountType = account
        }
        router?.navigationController = navigationController
        if let data = Constant.setup_data {
            occupation = data.occupation ?? []
        }
        if let bank = Constant.banks {
            banks = bank
            if banks.count > 0 {
                bankTxt = banks[0].bankName ?? ""
            }
        }
        showLoader()
        interactor?.getFunds()
        
        let disclaimer1: String = "I do hereby confirm that the investment being made is solely my own funds and that the funds beneficially owned by other person(s) will not be used."
        let disclaimer2: String = "I understand and agree that Al Meezan Investment Management Limited (Al Meezan) has suggested me a specific fund category as per my risk profile. However, I reserve the discretion to invest in any other fund category. I confirm that I am aware of associated risks with investment in this fund category and confirm that I will not hold Al Meezan responsible for any loss which may occur as a result of my decision. I further confirm that I have read the Trust Deeds, Offering Documents, Supplemental Trust Deeds and Supplemental Offering Documents that govern these investment/Conversion transactions."
        let disclaimer3: String = "NAV will be applied after confirmation of fund transfers from one-Link within the cut off time"
        
        let disclaimer5: String = "All investments in mutual funds are subject to market risk. The NAV based prices of units and any dividends/returns thereon are dependent on force and factors affecting the capital markets. These may go up or down based on market condition. Past performance is not necessarily indicative of future results. Performance data does not include cost incurred by investor in the form of sales load etc"
        
        let diclamimer6: String = "I am fully informed and understand that investment in units of mutual funds /CIS are not bank deposits, not guaranteed and not issued by any person. Shareholders of AMCs are not responsible for any loss to investor resulting from the operations of any CIS launched /to be launched by AMCs unless otherwise mentioned."

        
        
        let accountType = UserDefaults.standard.string(forKey: "accountType") ?? "BOTH"
        disclaimer = [disclaimer2, disclaimer1, disclaimer3, disclaimer4, disclaimer5, diclamimer6]
        
        idealFund = UserDefaults.standard.string(forKey: "idealFund")
        setupViews()
    }
    
    fileprivate func setupViews() {
        self.view.backgroundColor = .white
        
        bankTxt = UserDefaults.standard.string(forKey: "bankName") ?? ""
        let bank = self.banks.filter( { $0.bankName == bankTxt })
        if bank.count > 0 {
            self.bankId = bank[0].BankID ?? ""
        }
        self.bankNameItem = self.banks.firstIndex(where: {$0.bankName == self.bankTxt}) ?? 0

        
        if !headerView.isDescendant(of: self.view) {
            self.view.addSubview(headerView)
        }
        headerView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        headerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        headerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        headerView.heightAnchor.constraint(equalToConstant: 124.0).isActive = true
 
        if !containerView.isDescendant(of: self.view) {
            self.view.addSubview(containerView)
        }
        containerView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 16).isActive = true
        containerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16).isActive = true
        containerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16).isActive = true
        containerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -16).isActive = true
        
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
        
        
        
        fundCategoryView = ButtonPickerView(heading:  "Fund Category", placeholder: "Select Fund Category", image: "down_Arrow") {
            self.fundDataSource = GenericPickerDataSource<AccountOpeningFunds>(
                withItems: self.unique_funds,
                        withRowTitle: { (data) -> String in
                            return data.category ?? ""
                        }, row: self.categoryItem,  didSelect: { (data) in
                            self.fundCategoryView?.txtField.text = data.category
                            self.fundCategoryTxt = data.category ?? ""
                            self.filter_funds.removeAll()
                            
                            let view = self.stackView.arrangedSubviews[9] as? TermsAndConditionView
                            if self.fundCategoryTxt == "Shariah Compliant Money Market" {
                                view?.isHidden = true
                                view?.checkBtn.isSelected = true
                                self.isMoneyMarket = true
                                self.totalDisclaimer = 5
                                if self.totalDisclaimerSelected == 6 {
                                    self.totalDisclaimerSelected = self.totalDisclaimerSelected - 1
                                }
                            } else {
                                if self.isMoneyMarket {
                                    view?.isHidden = false
                                    view?.checkBtn.isSelected = false
                                    self.totalDisclaimer = 6
                                }
                                self.isMoneyMarket = false
                            }
                            if self.fundCategoryTxt != "" {
                                self.fundSelectionView.txtField.text = ""
                                self.agent_id = ""
                                self.fund_id = ""
                                self.fundSelectionTxt = ""
                                self.fundSelectionView.txtField.isUserInteractionEnabled = true
                                self.filter_funds = self.funds.filter {( $0.category == self.fundCategoryTxt )}
                            }
                            
                         
                            
                        })
            self.fundCategoryView?.txtField.setupPickerField(withDataSource: self.fundDataSource!)
        }
        fundCategoryView.setData(text: fundCategoryTxt)
        fundCategoryView.txtField.isUserInteractionEnabled = false
        stackView.addArrangedSubview(fundCategoryView)
        
        fundSelectionView = ButtonPickerView(heading:  "Fund/Plan Selection", placeholder: "Select Fund/Plan Selection", image: "down_Arrow") {
            self.fundDataSource = GenericPickerDataSource<AccountOpeningFunds>(
                withItems: self.filter_funds,
                        withRowTitle: { (data) -> String in
                            return data.fundName ?? ""
                        }, row: self.fundItem,  didSelect: { (data) in
                            self.fundSelectionView?.txtField.text = data.fundName
                            self.fundSelectionTxt = data.fundName ?? ""
                            self.agent_id = data.agentID ?? ""
                            self.fund_id = data.fundID ?? ""
                        })
            self.fundSelectionView?.txtField.setupPickerField(withDataSource: self.fundDataSource!)
        }
        fundSelectionView.setData(text: fundSelectionTxt)
        fundSelectionView.txtField.isUserInteractionEnabled = false
        stackView.addArrangedSubview(fundSelectionView)
        
//        CurrencyInputView
        transactionDetailView = CurrencyInputView(heading:  AppString.Heading.transactionAmount, placeholder: "Enter Transaction Amount", isPasswordEnable: false) { [weak self] (enteredText) in
            guard let self = self else {return}
            let txt = enteredText
            self.transactionDetailTxt = txt.replacingOccurrences(of: ",", with: "", options: NSString.CompareOptions.literal)
            
            if let investment_info = Constant.setup_data?.investmentCharges {
                for info in investment_info {
                    let amount = Int(self.transactionDetailTxt) ?? 0
                    let min = info.min ?? 0
                    let max = info.max ?? 10000
                    let charge = info.charges ?? 20
                    if min...max ~= amount {
                        let total = amount + charge
                        self.totalDeductionTxt = String(total)
                        self.totalDeductionView.setData(text: self.totalDeductionTxt.toCurrencyFormat(withFraction: false))
                    }
                }
            }
        }
        transactionDetailView.setData(text: transactionDetailTxt)
        transactionDetailView.txtField.keyboardType = .asciiCapableNumberPad
        stackView.addArrangedSubview(transactionDetailView)
        
        totalDeductionView = TextInputView(heading:  "Total Deducation From Bank", placeholder: "Enter Deducation", isPasswordEnable: false) { [weak self] (enteredText) in
            guard let self = self else {return}
            self.totalDeductionTxt = enteredText
        }
        totalDeductionView.setData(text: totalDeductionTxt)
        totalDeductionView.txtField.isUserInteractionEnabled = false
        
        stackView.addArrangedSubview(totalDeductionView)

        bankView = ButtonPickerView(heading:  "Select a Bank", placeholder: "Select a Bank", image: "down_Arrow") {
            self.bankDataSource = GenericPickerDataSource<BankInfoViewEntity.BankInfoResponseModel>(
                withItems: self.banks,
                        withRowTitle: { (data) -> String in
                            return data.bankName ?? ""
                        },row: self.bankNameItem, didSelect: { (data) in
                            self.bankView?.txtField.text = data.bankName
                            self.bankTxt = data.bankName ?? ""
                            self.bankId = data.BankID ?? ""
                        })
            self.bankView?.txtField.setupPickerField(withDataSource: self.bankDataSource!)
        }
        
        bankView.setData(text: bankTxt)
        stackView.addArrangedSubview(bankView)
        
        
        for i in 0..<disclaimer.count {
            let termsAndConditionView = TermsAndConditionView(heading: self.disclaimer[i], selectedCheckboxCloser: { isSelect in
                if isSelect {
                    self.totalDisclaimerSelected = self.totalDisclaimerSelected + 1
                } else {
                    self.totalDisclaimerSelected = self.totalDisclaimerSelected - 1
                }
                
            })
            if i == 3 {
                disclaimer2Lbl = termsAndConditionView.termsAndConditionLbl
                termsAndConditionView.termsAndConditionLbl.isUserInteractionEnabled = true
                let tapgesture = UITapGestureRecognizer(target: self, action: #selector(tappedOnTerms(_ :)))
                tapgesture.numberOfTapsRequired = 1
                tapgesture.numberOfTouchesRequired = 1
                termsAndConditionView.termsAndConditionLbl.addGestureRecognizer(tapgesture)
                
                let attributedString = NSMutableAttributedString(string: self.disclaimer[i])
                let range: NSRange = attributedString.mutableString.range(of: "Terms & Condition", options: .caseInsensitive)
                attributedString.addAttribute(.font, value: UIFont(name: AppFontName.robotoMedium, size: 14), range: range)
                attributedString.addAttribute(.foregroundColor, value: UIColor.init(rgb: 0x0000e6), range: range)
                attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.thick.rawValue, range: range)
                termsAndConditionView.termsAndConditionLbl.attributedText = attributedString
                disclaimer2Lbl.attributedText = attributedString
            }
            
            stackView.addArrangedSubview(termsAndConditionView)
        }
        let btnView = CenterButtonView.init(title: "PROCEED") { [weak self] (clicked) in
            guard let self = self else {return}
            if self.fundCategoryTxt == ""{
                self.showAlert(title: "Alert", message: "Please select fund category.", controller: self) {
                    //self.nameView.txt.becomeFirstResponder()
                }
                return
            }

            if self.fundSelectionTxt == ""{
                self.showAlert(title: "Alert", message: "Please select fund selection.", controller: self) {
                    //self.nameView.txt.becomeFirstResponder()
                }
                return
            }


            if self.transactionDetailTxt == ""{
                self.showAlert(title: "Alert", message: "Please enter transaction detail.", controller: self) {
                    //self.nameView.txt.becomeFirstResponder()
                }
                return
            }
            
            
            if let amount = Int(self.transactionDetailTxt) {
                if amount < 5000 {
                    self.showAlert(title: "Alert", message: "Amount should be greater than 5000.", controller: self) {
                    }
                    return
                }
                if self.onlineAccountType == OnlineAccountType.SSA.rawValue {
                    if amount > 400000 {
                        self.showAlert(title: "Alert", message: "Maximum initial investment amount should be Rs. 400,000/-.", controller: self) {
                        }
                        return
                    }
                }
            }
            
            if self.totalDeductionTxt == ""{
                self.showAlert(title: "Alert", message: "Please enter total deduction from bank.", controller: self) {
                    //self.nameView.txt.becomeFirstResponder()
                }
                return
            }

            if self.bankTxt == ""{
                self.showAlert(title: "Alert", message: "Please Select a Bank.", controller: self) {
                    //self.nameView.txt.becomeFirstResponder()
                }
                return
            }

            
            if self.totalDisclaimerSelected == self.totalDisclaimer {
                self.isTerms = true
            } else {
                self.isTerms = false
            }
            
            
            if self.isTerms == false {
                self.showAlert(title: "Alert", message: "Please Check Terms and Conditions.", controller: self) {
                    //self.nameView.txt.becomeFirstResponder()
                }
                return
            }
            
            let cnic = UserDefaults.standard.string(forKey: "CNIC")  ?? ""
            let info = FundRequest(CNIC: cnic, fundID: self.fund_id, agentID: self.agent_id, amount: self.transactionDetailTxt, bank: self.bankId)
            self.showLoader()
            self.interactor?.submitFund(request: info)
            
        }
        stackView.addArrangedSubview(btnView)
    }
    
    @objc func tappedOnTerms(_ gesture: UITapGestureRecognizer) {
        guard let text = disclaimer2Lbl.text else { return }
        let callUSRange = (text as NSString).range(of: "Terms & Condition")
        if gesture.didTapAttributedTextInLabel(label: self.disclaimer2Lbl, inRange: callUSRange) {
            let appURL = URL(string: "https://members.almeezangroup.com/TermsAndConditions.pdf")!
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(appURL, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(appURL)
            }
        }  else {
            print("false")
        }
    }
}


extension InvestmentdetailsViewController: InvestmentViewProtocol {
    func fundList(response: [AccountOpeningFunds]) {
        DispatchQueue.main.async {
            self.hideLoader()
            if response.count > 0 {
                self.fundCategoryView.txtField.isUserInteractionEnabled = true
                self.funds = response
                self.unique_funds = response.unique( by: { $0.category } )
                
                if self.unique_funds.count > 0 {
                    let idealCategory = self.unique_funds.filter({
                        $0.category?.lowercased().contains(self.idealFund?.lowercased() ?? "") ?? false
                    })
                    
                    if idealCategory.count > 0 {
                        self.fundCategoryTxt = idealCategory[0].category ?? ""
                        self.fund_id = idealCategory[0].fundID ?? ""
                    } else {
                        self.fundCategoryTxt = self.unique_funds[0].category ?? ""
                        self.fund_id = self.unique_funds[0].fundID ?? ""
                    }
                    
                    
                    self.fundCategoryView.setData(text: self.fundCategoryTxt)
                    self.filter_funds = self.funds.filter {( $0.category == self.fundCategoryTxt )}
                    if self.filter_funds.count > 0 {
                        self.fundSelectionView.txtField.isUserInteractionEnabled = true
                        self.fundSelectionTxt = self.filter_funds[0].fundName ?? ""
                        self.agent_id = self.filter_funds[0].agentID ?? ""
                        self.fundSelectionView.setData(text: self.fundSelectionTxt)
                        self.fundItem = self.filter_funds.firstIndex(where: { $0.fundName == self.fundSelectionTxt}) ?? 0
                        self.agent_id = self.unique_funds[0].agentID ?? ""
                    }
                    
                    
                    self.categoryItem = self.unique_funds.firstIndex(where: {$0.category == self.fundCategoryTxt}) ?? 0
                    
                }
            }
        }
        
    }
    func InvestmentResponse(response: [SubmissionResponse]) {
        DispatchQueue.main.async {
            self.hideLoader()
            if response.count > 0 {
                if response[0].errID == "00" {
                    self.showAlert(title: "Alert", message: "Investment Submitted successfully.", controller: self) {
                        // next to thank you screen
                        let vc = ThankYouViewController()
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            }
        }
        
    }
    
    
    func noFund() {
        hideLoader()
    }
}

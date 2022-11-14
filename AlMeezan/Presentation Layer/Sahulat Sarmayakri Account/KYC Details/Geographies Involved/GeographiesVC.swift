//
//  GeographiesVC.swift
//  AlMeezan
//
//  Created by Atta khan on 13/12/2021.
//  Copyright © 2021 Atta khan. All rights reserved.
//

import UIKit

class GeographiesVC: UIViewController {
    //MARK: Properties
    private (set) lazy var headerView: HeaderView = { [unowned self] in
        let view = HeaderView.init(stepValue: "2 / 3", titleStr: "KYC", subTitle: "Principal Account Holder" ,numberOfPages: 3, currentPageNo: 1, closeAction: {
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
    private var domesticTxt: String         =   "PUNJAB"
    private var internationalTxt: String       =   "FATF Compliant"
    private var transactionTxt: String       =   ""
    private var quantityTxt: String             =   ""
    private var expectedTxt: String     =   ""
    private var amountTxt: String = ""
    
    var domesticView: ButtonPickerView!
    var internationalView: ButtonPickerView!
    var modeOfTransactionView: ButtonPickerView!
    var expectedTurnoverView: ButtonPickerView!
    var dataSource: GenericPickerDataSource<OptionModel>?
    
    
    var domestic: [OptionModel] = [OptionModel]()
    var international: [OptionModel] = [OptionModel]()
    var modeOfTrasaction: [OptionModel] = [OptionModel]()
    var expectedTurnover: [OptionModel] = [OptionModel]()
    // Selected Picker View Items
    var modeOfTrasactionItem: Int = 0
    var expectedTurnoverItem: Int = 0
    
    var onlineAccountType: String = OnlineAccountType.SSA.rawValue
    var basicInfo: PersonalInfoEntity.BasicInfo
    var KYCInfo: KYCModel
    init(KYCInfo: KYCModel, basicInfo: PersonalInfoEntity.BasicInfo) {
        self.KYCInfo = KYCInfo
        self.basicInfo = basicInfo
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
            fatalError("init(coder:) is not supported")
        }
    var router: GeographiesRouterProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        router?.navigationController = navigationController
        if let account = UserDefaults.standard.string(forKey: "OnlineAccountType") {
            onlineAccountType = account
        }
        
        if let data = Constant.setup_data {
            international = data.geographyInternational ?? []
            domestic = data.geographyDomestic ?? []
        }
        
        modeOfTrasaction.append(
            contentsOf: [
                OptionModel(code: "", name: "Online", isActive: 0),
                OptionModel(code: "", name: "Physical", isActive: 0),
                OptionModel(code: "", name: "Both", isActive: 0)
            ]
        )
        
        expectedTurnover.append(
            contentsOf: [
                OptionModel(code: "", name: "Monthly", isActive: 0),
                OptionModel(code: "", name: "Annually", isActive: 0)
            ]
        )
        
        expectedTxt = "Monthly"
        transactionTxt = "Both"
        domesticTxt = "SINDH"
        internationalTxt = "FATF COMPLIANT"
        setupViews()
    }

}
extension GeographiesVC {
    fileprivate func setupViews() {
        self.view.backgroundColor = .white
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
        if let info = Constant.CustomerData.customer_data?.cNICData?.kyc {
            transactionTxt = info.modeOfTransaction ?? ""
            expectedTxt = info.expectedTurnOverMonthlyAnnual ?? ""
            quantityTxt = info.numberOfTransaction ?? ""
            amountTxt = info.expectedTurnOver ?? ""
            internationalTxt = info.geographiesIntl ?? ""
            domesticTxt = info.geographiesDomestic ?? ""
        }
        modeOfTrasactionItem = modeOfTrasaction.firstIndex(where: {$0.name == transactionTxt}) ?? 0
        expectedTurnoverItem = expectedTurnover.firstIndex(where: {$0.name == expectedTxt}) ?? 0
        
        if self.onlineAccountType == OnlineAccountType.digital.rawValue {
            domesticView = ButtonPickerView(heading:  "Domestic", placeholder: "Domestic", image: "down_Arrow") {
                self.dataSource = GenericPickerDataSource<OptionModel>(
                    withItems: self.domestic,
                            withRowTitle: { (data) -> String in
                                return data.name ?? ""
                            }, row: 0,  didSelect: { (data) in
                                self.domesticView?.txtField.text = data.name
                                self.domesticTxt = data.name ?? ""
                            })
                self.domesticView?.txtField.setupPickerField(withDataSource: self.dataSource!)
            }
            domesticView.setData(text: domesticTxt)
            stackView.addArrangedSubview(domesticView)


            internationalView = ButtonPickerView(heading:  "International", placeholder: "International", image: "down_Arrow") {
                self.dataSource = GenericPickerDataSource<OptionModel>(
                    withItems: self.international,
                            withRowTitle: { (data) -> String in
                                return data.name ?? ""
                            }, row: 0,  didSelect: { (data) in
                                self.internationalView?.txtField.text = data.name
                                self.internationalTxt = data.name ?? ""
                            })
                self.internationalView?.txtField.setupPickerField(withDataSource: self.dataSource!)
            }
            internationalView.setData(text: internationalTxt)
            stackView.addArrangedSubview(internationalView)
        }
//
       
        
        modeOfTransactionView = ButtonPickerView(heading:  "Possible Mode of Transaction", placeholder: "Possible Mode of Transaction", image: "down_Arrow") {
            self.dataSource = GenericPickerDataSource<OptionModel>(
                withItems: self.modeOfTrasaction,
                        withRowTitle: { (data) -> String in
                            return data.name ?? ""
                        }, row: self.modeOfTrasactionItem,  didSelect: { (data) in
                            self.modeOfTransactionView?.txtField.text = data.name
                            self.transactionTxt = data.name ?? ""
                        })
            self.modeOfTransactionView?.txtField.setupPickerField(withDataSource: self.dataSource!)
        }
        modeOfTransactionView.setData(text: transactionTxt)
        stackView.addArrangedSubview(modeOfTransactionView)
        
        
        let noOfTransactionView = CurrencyInputView(heading:  AppString.Heading.numbeerOfTransaction, placeholder: "Number of Transactions/Quantity", isPasswordEnable: false) { [weak self] (enteredText) in
            guard let self = self else {return}
            self.quantityTxt = enteredText
        }
        noOfTransactionView.setData(text: quantityTxt)
        noOfTransactionView.txtField.keyboardType = .asciiCapableNumberPad
        stackView.addArrangedSubview(noOfTransactionView)
        
        expectedTurnoverView = ButtonPickerView(heading:  "Expected Turnover In Account", placeholder: "Expected Turnover In Account", image: "down_Arrow") {
            self.dataSource = GenericPickerDataSource<OptionModel>(
                withItems: self.expectedTurnover,
                        withRowTitle: { (data) -> String in
                            return data.name ?? ""
                        }, row: self.expectedTurnoverItem,  didSelect: { (data) in
                            self.expectedTurnoverView?.txtField.text = data.name
                            self.expectedTxt = data.name ?? ""
                        })
            self.expectedTurnoverView?.txtField.setupPickerField(withDataSource: self.dataSource!)
        }
        expectedTurnoverView.setData(text: expectedTxt)
        

        stackView.addArrangedSubview(expectedTurnoverView)
        
        let amountView = CurrencyInputView(heading:  AppString.Heading.expectedAmount, placeholder: "Enter Expected Amount", isPasswordEnable: false) { [weak self] (enteredText) in
            guard let self = self else {return}
            self.amountTxt = enteredText
        }
        amountView.setData(text: amountTxt)
        amountView.txtField.keyboardType = .asciiCapableNumberPad
        stackView.addArrangedSubview(amountView)
        
        
        let btnView = CenterButtonView.init(title: AppString.Heading.savebtn) { [weak self] (clicked) in
            guard let self = self else {return}
            
            if self.onlineAccountType == OnlineAccountType.digital.rawValue {
                if self.domesticTxt == "" {
                    self.showAlert(title: "Alert", message: "Please select domestic.", controller: self) {
                        //self.nameView.txt.becomeFirstResponder()
                    }
                    return
                }
                if self.internationalTxt == "" {
                    self.showAlert(title: "Alert", message: "Please select international.", controller: self) {
                        //self.nameView.txt.becomeFirstResponder()
                    }
                    return
                }
            }
            
            
            if self.transactionTxt == "" {
                self.showAlert(title: "Alert", message: "Please enter pssible mode of transaction", controller: self) {
                    //self.nameView.txt.becomeFirstResponder()
                }
                return
            }
            
            
            if self.quantityTxt == "" {
                self.showAlert(title: "Alert", message: "Please enter number of transactions.", controller: self) {
                    //self.nameView.txt.becomeFirstResponder()
                }
                return
            }
            
            if self.expectedTxt == "" {
                self.showAlert(title: "Alert", message: "Please enter expected turnover in account", controller: self) {
                    //self.nameView.txt.becomeFirstResponder()
                }
                return
            }
            
            if self.amountTxt == "" {
                self.showAlert(title: "Alert", message: "Please enter expected turnover amount.", controller: self) {
                    //self.nameView.txt.becomeFirstResponder()
                }
                return
            }
            if self.onlineAccountType == OnlineAccountType.SSA.rawValue {
                let amountVal = self.amountTxt.replacingOccurrences(of: ",", with: "", options: NSString.CompareOptions.literal)
                if let amount = Int(amountVal) {
                    if amount > 1000000 {
                        self.showAlert(title: "Alert", message: "Expected transaction amount should not be greater than 1,000,000.", controller: self) {
                        }
                        return
                    }
                }
            
            }
            
            let info = KYCModel(
                residentialStatus: "",
                sourceOfIncome: self.KYCInfo.sourceOfIncome,
                sourceOfWealth: self.KYCInfo.sourceOfWealth,
                nameOfEmployer: self.KYCInfo.nameOfEmployer,
                designation: self.KYCInfo.designation,
                natureOfBusiness: self.KYCInfo.natureOfBusiness,
                education: self.KYCInfo.education,
                profession: self.KYCInfo.profession,
                geographiesDomestic: self.domesticTxt,
                geographiesIntl: self.internationalTxt,
                counterPartyDomestic: "",
                counterPartyIntl: "",
                modeOfTransaction: self.transactionTxt,
                numberOfTransaction: self.quantityTxt,
                expectedTurnOverMonthlyAnnual: self.expectedTxt,
                expectedTurnOver: self.amountTxt,
                expectedInvestmentAmount: "",
                annualIncome: "",
                actionOnBehalfOfOther: 0,
                refusedYourAccount: 0,
                seniorPositionInGovtInstitute: 0,
                seniorPositionInPoliticalParty: 0,
                financiallyDependent: 0,
                highValueGoldSilverDiamond: 0,
                incomeIsHighRisk: 0,
                headOfState: 0,
                seniorMilitaryOfficer: 0,
                headOfDeptOrIntlOrg: 0,
                memberOfBoard: 0,
                memberOfNationalSenate: 0,
                politicalPartyOfficials: 0,
                pep_Declaration: "",
                whereDidYouHearAboutUs: self.KYCInfo.whereDidYouHearAboutUs,
                daoID: self.KYCInfo.daoID,
                cnic: self.basicInfo.cnic,
                accountType: self.basicInfo.accountType,
                fundSupporter: self.KYCInfo.fundSupporter
            
            )
            self.router?.routerToQuestionaireVC(basicinfo: self.basicInfo, KYCinfo: info)
        }
        stackView.addArrangedSubview(btnView)
    }
}



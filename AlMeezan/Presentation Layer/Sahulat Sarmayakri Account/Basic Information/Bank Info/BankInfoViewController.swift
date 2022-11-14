//
//  BankInfoViewController.swift
//  AlMeezan
//
//  Created by Atta khan on 10/11/2021.
//  Copyright © 2021 Atta khan. All rights reserved.
//

import UIKit

class BankInfoViewController: UIViewController {
    //MARK: Properties
    private (set) lazy var headerView: HeaderView = { [unowned self] in
        let view = HeaderView.init(stepValue: "3 / 3", titleStr: "Basic Information", subTitle: AppString.Heading.bankDetail ,numberOfPages: 3, currentPageNo: 2, closeAction: {
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
    
    
    private (set) lazy var stackView1: UIStackView = { [unowned self] in
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.distribution = .fillEqually
        view.alignment = .fill
        view.axis = .horizontal
        view.spacing = 4
        view.clipsToBounds = true
        return view
    }()
    
    private (set) lazy var cashLbl: UILabel = { [unowned self] in
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Dividend Mandate"
        label.textColor =  UIColor.init(rgb: 0xB9BBC6)
        label.font = UIFont(name: AppFontName.robotoMedium, size: 15)
        return label
    }()
    private (set) lazy var nextKINLbl: UILabel = { [unowned self] in
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Next of KIN (Optional)"
        label.textColor =  UIColor.init(rgb: 0xB9BBC6)
        label.font = UIFont(name: AppFontName.robotoMedium, size: 15)
        return label
    }()
    var relationshipPrincipalView: ButtonPickerView!
    var bankNameView: ButtonPickerView!
    var cashDividendView: ButtonPickerView!
    var stockDividendsView: ButtonPickerView!
    var branchCityView: ButtonPickerView!
    var IBANView: TextInputView!
    var branchNameView: TextInputView!
    
    private var bankIdTxt : String = ""
    private var bankNameTxt: String         =   ""
    private var branchNameTxt: String       =   ""
    private var branchCityTxt: String       =   ""
    private var IBANTxt: String             =   ""
    private var cashDividendTxt: String     =   ""
    private var stockDividendsTxt: String   =   ""
    private var contactNumberTxt: String    =   ""
    private var addressTxt: String          =   ""
    private var relationshipPrincipalTxt: String    =   ""
    private var nameTxt: String             =   ""
    var branchCity :   [City]?
    var router: BankInfoViewRouterProtocol?
    var interactor: BankInofoViewInteractorProtocol?
    
    // Selected Picker View Items
    var bankNameItem: Int = 0
    var branchCityItem: Int = 0
    var cashItem: Int = 0
    var stockItem: Int = 0
    var filterRelationship: [OptionModel] = [OptionModel]()
    var relationshipArray : [OptionModel] = [OptionModel]()
    var cashDividend: [OptionModel] = [OptionModel]()
    var stockDividend: [OptionModel] = [OptionModel]()
    var bankInfo: [BankInfoViewEntity.BankInfoResponseModel]?
    var bankdataSource: GenericPickerDataSource<BankInfoViewEntity.BankInfoResponseModel>?
    var branchDataSource: GenericPickerDataSource<City>?
    var dataSource: GenericPickerDataSource<OptionModel>?
    var basicInfo: PersonalInfoEntity.BasicInfo
    init(basicInfo: PersonalInfoEntity.BasicInfo) {
        self.basicInfo = basicInfo
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
            fatalError("init(coder:) is not supported")
    }
    var info: PersonalInfoEntity.BasicInfo?
    override func viewDidLoad() {
        super.viewDidLoad()
        router?.navigationController = navigationController
        
        
        
        let cashDividend1 = OptionModel(code: "", name: "Reinvest", isActive: 0)
        let cashDividend2 = OptionModel(code: "", name: "Provide Cash", isActive: 0)
        cashDividend.append(cashDividend1)
        cashDividend.append(cashDividend2)

        
        let stockDividend1 = OptionModel(code: "", name: "Issue bonus units", isActive: 0)
        let stockDividend2 = OptionModel(code: "", name: "Encash bonus units", isActive: 0)
        stockDividend.append(stockDividend1)
        stockDividend.append(stockDividend2)
        
        cashDividendTxt = "Reinvest"
        stockDividendsTxt = "Issue bonus units"
        
        if let data = Constant.setup_data {
            relationshipArray = data.relationship ?? []
            filterRelationship = relationshipArray
        }
        
        if self.basicInfo.maritalStatus == "Single" {
        var total = self.relationshipArray.count
            while total > 4 {
                total -= 1
                self.filterRelationship.remove(at: total)
            }
        }
        setupViews()
        showLoader()
        interactor?.getBranchName()
        interactor?.getBankName()
    }
    

}
extension BankInfoViewController {
    fileprivate func setupViews() {
        self.view.backgroundColor = .white
        
        
        
        if let info = Constant.CustomerData.customer_data?.cNICData?.basicInfo {
            branchNameTxt =   info.branchName ?? ""
            branchCityTxt =   info.branchCity ?? ""
            IBANTxt =   info.bankAccountNo ?? ""
            contactNumberTxt =   info.nextOfKin?.contactNumber ?? ""
            addressTxt =   info.nextOfKin?.address ?? ""
            relationshipPrincipalTxt =  info.nextOfKin?.relationship ?? ""
            nameTxt             =   info.nextOfKin?.fullName ?? ""
            bankNameTxt = info.bankName ?? ""
            cashDividendTxt = info.cashDividend ?? ""
            stockDividendsTxt = info.stockDividend ?? ""
            cashItem = cashDividend.firstIndex(where: {$0.name == cashDividendTxt}) ?? 0
            stockItem = stockDividend.firstIndex(where: { $0.name ==  stockDividendsTxt }) ?? 0
            
            
        }
        
        
        
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
        
        
        bankNameView = ButtonPickerView(heading:  AppString.Heading.bankName, placeholder: AppString.PlaceHoderText.enterBankName, image: "down_Arrow") {
            let vc = CountrySearchVC()
            vc.bankInfo = self.bankInfo
            vc.searchType = .bank
            vc.bankDelegate = self
            self.present(vc, animated: false)
            
        }
        bankNameView.setData(text: bankNameTxt)
        stackView.addArrangedSubview(bankNameView)
        
        
        branchNameView = TextInputView(heading:  AppString.Heading.branchName, placeholder: AppString.PlaceHoderText.enterBranchName, isPasswordEnable: false) { [weak self] (enteredText) in
            guard let self = self else {return}
            self.branchNameTxt = enteredText
        }
        branchNameView.setData(text: branchNameTxt)
        stackView.addArrangedSubview(branchNameView)
        
        
        branchCityView = ButtonPickerView(heading:  AppString.Heading.branchCity, placeholder: AppString.PlaceHoderText.enterBranchCity, image: "down_Arrow") {
            let vc = CountrySearchVC()
            vc.branchCity = self.branchCity
            vc.searchType = .branch
            vc.branchDelegate = self
            self.present(vc, animated: false)
            
        }
        branchCityView.txtField.isUserInteractionEnabled = false
        branchCityView.setData(text: branchCityTxt)
        stackView.addArrangedSubview(branchCityView)
        
        
        
        IBANView = TextInputView(heading:  AppString.Heading.iban, placeholder: AppString.PlaceHoderText.enterIBAN, isPasswordEnable: false) { [weak self] (enteredText) in
            guard let self = self else {return}
            self.IBANTxt = enteredText
        }
        IBANView.setData(text: IBANTxt)
        IBANView.txtField.autocapitalizationType = .allCharacters
        stackView.addArrangedSubview(IBANView)
        
        stackView.addArrangedSubview(cashLbl)
        
        
        cashDividendView = ButtonPickerView(heading:  AppString.Heading.cashDivide, placeholder: AppString.PlaceHoderText.enterCashDividend, image: "down_Arrow") {
            self.dataSource = GenericPickerDataSource<OptionModel>(
                withItems: self.cashDividend ?? [],
                        withRowTitle: { (data) -> String in
                            return data.name ?? ""
                        }, row: self.cashItem,  didSelect: { (data) in
                            self.cashDividendTxt = data.name ?? ""
                            self.cashDividendView?.txtField.text = self.cashDividendTxt
                        })
            self.cashDividendView?.txtField.setupPickerField(withDataSource: self.dataSource!)
        }
        cashDividendView.setData(text: cashDividendTxt)
        stackView.addArrangedSubview(cashDividendView)
        
        
        stockDividendsView = ButtonPickerView(heading:  AppString.Heading.stockDivide, placeholder: AppString.PlaceHoderText.enterStockDividend, image: "down_Arrow") {
            self.dataSource = GenericPickerDataSource<OptionModel>(
                withItems: self.stockDividend ?? [],
                        withRowTitle: { (data) -> String in
                            return data.name ?? ""
                        }, row: self.stockItem,  didSelect: { (data) in
                            self.stockDividendsTxt = data.name ?? ""
                            self.stockDividendsView?.txtField.text = self.stockDividendsTxt
                        })
            self.stockDividendsView?.txtField.setupPickerField(withDataSource: self.dataSource!)
        }
        stockDividendsView.setData(text: stockDividendsTxt)
        stackView.addArrangedSubview(stockDividendsView)
        
        if self.basicInfo.accountType == "VPS" {
            stockDividendsView.txtField.isUserInteractionEnabled = false
            cashDividendView.txtField.isUserInteractionEnabled = false
            stockDividendsTxt = "issue bonus units"
            cashDividendTxt = "Reinvest"
        }
        
        
        print(self.basicInfo.jointHolder?.fullName)
        
        
        if self.basicInfo.jointHolder == nil {
            stackView.addArrangedSubview(nextKINLbl)
            
            let nameView = TextInputView(heading:  AppString.Heading.name, placeholder: AppString.PlaceHoderText.enterName, isPasswordEnable: false) { [weak self] (enteredText) in
                guard let self = self else {return}
                self.nameTxt = enteredText
            }
            nameView.setData(text: nameTxt)
            stackView.addArrangedSubview(nameView)
            
            
            
            let contactNumberView = TextInputView(heading:  AppString.Heading.contactNumber, placeholder: AppString.PlaceHoderText.enterContactNumber, isPasswordEnable: false) { [weak self] (enteredText) in
                guard let self = self else {return}
                self.contactNumberTxt = enteredText
            }
            contactNumberView.setData(text: contactNumberTxt)
            contactNumberView.txtField.keyboardType = .asciiCapableNumberPad
            stackView.addArrangedSubview(contactNumberView)
            
            
            
            let addressView = TextInputView(heading:  AppString.Heading.address, placeholder: AppString.PlaceHoderText.enterAddress, isPasswordEnable: false) { [weak self] (enteredText) in
                guard let self = self else {return}
                self.addressTxt = enteredText
            }
            addressView.setData(text: addressTxt)
            stackView.addArrangedSubview(addressView)
            
            relationshipPrincipalView = ButtonPickerView(heading:  AppString.Heading.relationshipKin, placeholder: AppString.PlaceHoderText.enterRelationship, image: "down_Arrow") {
                self.dataSource = GenericPickerDataSource<OptionModel>(
                    withItems: self.filterRelationship ?? [],
                            withRowTitle: { (data) -> String in
                                return data.name ?? ""
                            }, row: 0,  didSelect: { (data) in
                                self.relationshipPrincipalView?.txtField.text = data.name
                                self.relationshipPrincipalTxt = data.name ?? ""
                            })
                self.relationshipPrincipalView?.txtField.setupPickerField(withDataSource: self.dataSource!)
            }
            relationshipPrincipalView.setData(text: relationshipPrincipalTxt)
            stackView.addArrangedSubview(relationshipPrincipalView)
        }
        
        
        
        
        
        
        let btnView = CenterButtonView.init(title: AppString.Heading.savebtn) { [weak self] (clicked) in
            guard let self = self else {return}
            
            if self.bankNameTxt == "" {
                self.showAlert(title: "Alert", message: "Please enter your bank name.", controller: self) {
                    //self.nameView.txt.becomeFirstResponder()
                }
                return
            }
            
            
            if self.branchNameTxt == "" {
                self.showAlert(title: "Alert", message: "Please enter your branch name.", controller: self) {
                    //self.nameView.txt.becomeFirstResponder()
                }
                return
            }
            
            if self.branchCityTxt == "" {
                self.showAlert(title: "Alert", message: "Please enter your branch city.", controller: self) {
                    //self.nameView.txt.becomeFirstResponder()
                }
                return
            }
            
            if self.IBANTxt == "" {
                self.showAlert(title: "Alert", message: "Please Enter Valid IBAN.", controller: self) {
                    //self.nameView.txt.becomeFirstResponder()
                }
                return
            }
            if !self.IBANTxt.isValidIBAN {
                self.showAlert(title: "Alert", message: "Please Enter Valid IBAN.", controller: self) {
                    //self.nameView.txt.becomeFirstResponder()
                }
                return
            }
            
            
            if self.cashDividendTxt == "" {
                self.showAlert(title: "Alert", message: "Please enter cash dividend.", controller: self) {
                    //self.nameView.txt.becomeFirstResponder()
                }
                return
            }
            
            if self.stockDividendsTxt == "" {
                self.showAlert(title: "Alert", message: "Please enter stock dividend.", controller: self) {
                    //self.nameView.txt.becomeFirstResponder()
                }
                return
            }
            
            let simeOwnerCode = UserDefaults.standard.string(forKey: "SimOwner_Code") ?? "SELF"
            let simeOwnerCNIC = UserDefaults.standard.string(forKey: "SimOwnerCNIC") ?? ""
            let simOwner = PersonalInfoEntity.SimOwner(simOwnerType: simeOwnerCode, simOwnerCnic: simeOwnerCNIC, cnic: self.basicInfo.cnic, accountType: self.basicInfo.accountType)
            
            let nextOfKin = PersonalInfoEntity.NextOfKin(fullName: self.nameTxt, contactNumber: self.contactNumberTxt, relationship: self.relationshipPrincipalTxt, address: self.addressTxt, cnic: self.basicInfo.cnic, accountType: self.basicInfo.accountType)

            let info = PersonalInfoEntity.BasicInfo(fullName: self.basicInfo.fullName, fatherHusbandName: self.basicInfo.fatherHusbandName, motherMaidenName: self.basicInfo.motherMaidenName, cnicIssueDate: self.basicInfo.cnicIssueDate, cnicExpiryDate: self.basicInfo.cnicExpiryDate, dateOfBirth: self.basicInfo.dateOfBirth, maritalStatus: self.basicInfo.maritalStatus, zakatStatus: self.basicInfo.zakatStatus, religion: self.basicInfo.religion, nationality: self.basicInfo.nationality, dualNational: self.basicInfo.dualNational, dualNationalCountry: self.basicInfo.dualNationalCountry, residentialStatus: self.basicInfo.residentialStatus, phoneNo: self.basicInfo.phoneNo, officeNo: self.basicInfo.officeNo, mobileNo: self.basicInfo.mobileNo, mobileNetwork: nil, ported: nil, emailAddress: self.basicInfo.emailAddress, currentAddress: self.basicInfo.currentAddress, currentCity: self.basicInfo.currentCity, currentCountry: self.basicInfo.currentCountry, permanentAddress: self.basicInfo.permanentAddress, permanentCity: self.basicInfo.permanentCity, permanentCountry: self.basicInfo.permanentCountry, bankName: self.bankIdTxt, bankAccountNo: self.IBANTxt, branchName: self.branchNameTxt, branchCity: self.branchCityTxt, cashDividend: self.cashDividendTxt, stockDividend: self.stockDividendsTxt,nextOfKin: nextOfKin, jointHolder: self.basicInfo.jointHolder, simOwner: simOwner, daoID: self.basicInfo.daoID, cnic: self.basicInfo.cnic, accountType: self.basicInfo.accountType, channel: self.basicInfo.channel)

            self.info = info
            Constant.joint_account = self.basicInfo.jointHolder
            self.showLoader()
            self.interactor?.saveData(basicInfo: info, healthDec: Constant.health_dec, kyc: nil, fatca: nil, crs: nil, riskProfile: nil)
            
        }
        stackView.addArrangedSubview(btnView)
    }
}


extension BankInfoViewController : BankInforViewProtocol {
    func getBanklist(result: [BankInfoViewEntity.BankInfoResponseModel]) {
        DispatchQueue.main.async {
            self.hideLoader()
            self.bankInfo = result
            Constant.banks = result
            self.bankNameView.txtField.isUserInteractionEnabled = true
            self.bankNameItem = self.bankInfo?.firstIndex(where: {$0.bankName == self.bankNameTxt}) ?? 0
            let bank = self.bankInfo?.filter( { $0.BankID == self.bankNameTxt })
            if bank?.count ?? 0 > 0 {
                self.bankIdTxt = bank?[0].BankID ?? ""
                self.bankNameTxt = bank?[0].bankName ?? ""
                self.bankNameView.setData(text: self.bankNameTxt)
            }
        }
    }
    func SaveDatasuccessfully(response: [SubmissionResponse]) {
        DispatchQueue.main.async {
            self.hideLoader()
        if response[0].errID == "00" {
                if let data = self.info {
                    self.router?.routerToKYCInfoVC(info: data)
                }
            }
        }
    }
    
    func getBranch(response: [BranchLocator]) {
        if response.count ?? 0 > 1 {
            DispatchQueue.main.async {
                self.branchCity =   response[1].city
                self.branchCityView.txtField.isUserInteractionEnabled = true
                self.branchCityItem = self.branchCity?.firstIndex(where: { $0.city == self.branchCityTxt}) ?? 0
            }
        }
    }
}

extension BankInfoViewController: SearchBankProtocol {
    func selectbankNmae(bank: BankInfoViewEntity.BankInfoResponseModel?) {
        bankNameView.txtField.resignFirstResponder()
        bankIdTxt = bank?.BankID ?? ""
        bankNameTxt = bank?.bankName ?? ""
        bankNameView?.txtField.text = bankNameTxt
        bankNameView.setData(text: bankNameTxt)
        UserDefaults.standard.set(bankNameTxt, forKey: "bankName")
    }
}
extension BankInfoViewController: SearchBranchProtocol {
    
    func selectBranchCity(branch: City?) {
        branchCityView.txtField.resignFirstResponder()
        branchCityTxt = branch?.city ?? ""
        branchCityView?.txtField.text = branchCityTxt
        branchCityView.setData(text: branchCityTxt)
    }

}

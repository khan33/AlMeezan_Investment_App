//
//  ContactInfoViewController.swift
//  AlMeezan
//
//  Created by Atta khan on 10/11/2021.
//  Copyright © 2021 Atta khan. All rights reserved.
//

import UIKit
import CryptoSwift

class ContactInfoViewController: UIViewController {
    //MARK: Properties
    private (set) lazy var headerView: HeaderView = { [unowned self] in
        let view = HeaderView.init(stepValue: "2 / 3", titleStr: "Basic Information", subTitle: AppString.Heading.contactDetails ,numberOfPages: 3, currentPageNo: 1, closeAction: {
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
    
    private var phoneNumberTxt: String              =   ""
    private var mobileNumberTxt: String             =   ""
    private var officeNumberTxt: String             =   ""
    private var emailAddressTxt: String             =   ""
    private var currentAddressTxt: String           =   ""
    private var permanentAddressTxt: String         =   ""
    private var isSameAddress: Bool                 =   false
    private var currentAddressCountryTxt: String    =   ""
    private var permanentAddressCountryTxt: String  =   ""
    private var currentCityTxt: String = ""
    private var permanentCityTxt: String = ""
    var country : [Country]?
    var cities: [CityModel]?
    var countryDataSource: GenericPickerDataSource<Country>?
    var cityDataSource: GenericPickerDataSource<CityModel>?
    var router: ContactInfoRouterProtocol?
    var dataSource: GenericPickerDataSource<OptionModel>?
    var permanentAddressView: TextInputView!
    var permanentAddressCountryView: ButtonPickerView!
    var currentAddressCountryView: ButtonPickerView!
    var currentCityView: ButtonPickerView!
    var permanentCityView: ButtonPickerView!

    
    // Selected Picker View Items
    var currentAddressCityItem: Int = 0
    var permanentAddressCityItem: Int = 0
    var currentAddressCountryItem: Int = 0
    var permanentAddressCountryItem: Int = 0
    
    var nationality: [OptionModel] = [OptionModel]()
    var basicInfo: PersonalInfoEntity.BasicInfo
    var interactor: ContactInfoInteractorProtocol?
    
    init(basicInfo: PersonalInfoEntity.BasicInfo) {
        self.basicInfo = basicInfo
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        router?.navigationController = navigationController
        if let data = Constant.setup_data {
            nationality = data.nationality ?? []
        }
        showLoader()
        self.interactor?.getCountries()
        
        currentAddressCountryTxt = "Pakistan"
        permanentAddressCountryTxt = "Pakistan"
        
        setupViews()
    }
}
extension ContactInfoViewController {
    fileprivate func setupViews() {
        self.view.backgroundColor = .white
        if let info = Constant.CustomerData.customer_data?.cNICData?.basicInfo {
            emailAddressTxt = info.emailAddress ?? ""
            currentAddressTxt = info.currentAddress ?? ""
            currentCityTxt = info.currentCity ?? ""
            permanentCityTxt = info.permanentCity ?? ""
            permanentAddressTxt = info.permanentAddress ?? ""
            phoneNumberTxt = info.phoneNo ?? ""
            mobileNumberTxt = info.mobileNo ?? ""
            officeNumberTxt = info.officeNo ?? ""
            currentAddressCountryTxt = info.currentCountry ?? ""
            permanentAddressCountryTxt = info.permanentCountry ?? ""
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
        
        let phoneNumberView = TextInputView(heading:  AppString.Heading.phoneNumber, placeholder: AppString.PlaceHoderText.enterPhoneNumber, isPasswordEnable: false) { [weak self] (enteredText) in
            guard let self = self else {return}
            self.phoneNumberTxt = enteredText
        }
        phoneNumberView.setData(text: phoneNumberTxt)
        phoneNumberView.txtField.keyboardType = .asciiCapableNumberPad
        stackView.addArrangedSubview(phoneNumberView)

        if let phone_number = UserDefaults.standard.string(forKey: "phone_number") {
            mobileNumberTxt = phone_number
        }
        let mobileNumberView = TextInputView(heading:  AppString.Heading.mobileNumber, placeholder: AppString.PlaceHoderText.enterMobileNumber, isPasswordEnable: false) { [weak self] (enteredText) in
            guard let self = self else {return}
            self.mobileNumberTxt = enteredText
        }
        mobileNumberView.txtField.keyboardType = .asciiCapableNumberPad
        mobileNumberView.txtField.isUserInteractionEnabled = false
        
        mobileNumberView.setData(text: mobileNumberTxt)
        stackView.addArrangedSubview(mobileNumberView)

        let officeNumberView = TextInputView(heading:  AppString.Heading.officeNumber, placeholder: AppString.PlaceHoderText.enterOfficeNumber, isPasswordEnable: false) { [weak self] (enteredText) in
            guard let self = self else {return}
            self.officeNumberTxt = enteredText
        }
        officeNumberView.setData(text: officeNumberTxt)
        officeNumberView.txtField.keyboardType = .asciiCapableNumberPad
        stackView.addArrangedSubview(officeNumberView)
        
        let emailAddressView = TextInputView(heading:  AppString.Heading.emailAddress, placeholder: AppString.PlaceHoderText.enterEmailAddress, isPasswordEnable: false) { [weak self] (enteredText) in
            guard let self = self else {return}
            self.emailAddressTxt = enteredText
        }
        
        if let email = UserDefaults.standard.string(forKey: "EmailAddress") {
            emailAddressTxt = email
        }
        emailAddressView.txtField.isUserInteractionEnabled = false
        emailAddressView.setData(text: emailAddressTxt)
        stackView.addArrangedSubview(emailAddressView)
        
        let currentAddressView = TextInputView(heading:  AppString.Heading.currentAddress, placeholder: AppString.PlaceHoderText.enterCurrentAddress, isPasswordEnable: false) { [weak self] (enteredText) in
            guard let self = self else {return}
            self.currentAddressTxt = enteredText
            if self.isSameAddress == true {
                self.permanentAddressView.txtField.text = enteredText
                //self.permanentAddressTxt =
            }
        }
        currentAddressView.setData(text: currentAddressTxt)
        stackView.addArrangedSubview(currentAddressView)
//        "Current Address City*"
        
        currentCityView = ButtonPickerView(heading:  "Current Address City", placeholder: "Enter Current Address City", image: "down_Arrow") {
            let vc = CountrySearchVC()
            vc.cities = self.cities
            vc.searchType = .currentCity
            vc.cityDelegate = self
            self.present(vc, animated: false) {
                
            }

        }
        currentCityView.setData(text: currentCityTxt)
        stackView.addArrangedSubview(currentCityView)
        
        
        currentAddressCountryView = ButtonPickerView(heading:  AppString.Heading.currentCoutryAddress, placeholder: AppString.PlaceHoderText.enterCountryAddress, image: "down_Arrow") {
            let vc = CountrySearchVC()
            vc.country = self.country
            vc.searchType = .currentCountry
            vc.countryDelegate = self
            self.present(vc, animated: false)
        }
        currentAddressCountryView.setData(text: currentAddressCountryTxt)
        stackView.addArrangedSubview(currentAddressCountryView)
        
        let isSelectedView = CheckBoxView(heading: AppString.Heading.sameAsCurrent, image: "checkbox") { isSelected in
            self.isSameAddress = isSelected
            if isSelected {
                self.permanentAddressView.txtField.isUserInteractionEnabled = false
                self.permanentCityView.txtField.isUserInteractionEnabled = false
                self.permanentAddressCountryView.txtField.isUserInteractionEnabled = false
                
                self.permanentAddressView.txtField.text = currentAddressView.txtField.text ?? ""
                self.permanentCityView.txtField.text = self.currentCityView.txtField.text ?? ""
                self.permanentAddressCountryView.txtField.text = self.currentAddressCountryView.txtField.text ?? ""
                
                self.permanentAddressTxt = self.permanentAddressView.txtField.text ?? ""
                self.permanentAddressCountryTxt = self.permanentAddressCountryView.txtField.text ?? ""
                self.permanentCityTxt = self.permanentCityView.txtField.text ?? ""
            } else {
                self.permanentAddressView.txtField.isUserInteractionEnabled = true
                self.permanentCityView.txtField.isUserInteractionEnabled = true
                self.permanentAddressCountryView.txtField.isUserInteractionEnabled = true
                self.permanentAddressView.txtField.text =  self.permanentAddressTxt
                self.permanentCityView.txtField.text = self.permanentCityTxt
                self.permanentAddressCountryView.txtField.text =  self.permanentAddressCountryTxt
            }
            
        }
        stackView.addArrangedSubview(isSelectedView)
        
        permanentAddressView = TextInputView(heading:  AppString.Heading.permanentAddress, placeholder: AppString.PlaceHoderText.enterPermanentAddress, isPasswordEnable: false) { [weak self] (enteredText) in
            guard let self = self else {return}
            self.permanentAddressTxt = enteredText
        }
        permanentAddressView.setData(text: permanentAddressTxt)
        stackView.addArrangedSubview(permanentAddressView)
        permanentCityView = ButtonPickerView(heading:  "Permanent Address City", placeholder: "Enter Permanent Address City", image: "down_Arrow") {
            let vc = CountrySearchVC()
            vc.cities = self.cities
            vc.searchType = .permanentCity
            vc.cityDelegate = self
            self.present(vc, animated: false) {
                
            }
        }
        permanentCityView.setData(text: permanentCityTxt)
        stackView.addArrangedSubview(permanentCityView)
        
        permanentAddressCountryView = ButtonPickerView(heading:  AppString.Heading.permanentCountryAddress, placeholder: AppString.PlaceHoderText.enterCountryPermanentAddress, image: "down_Arrow") {
            let vc = CountrySearchVC()
            vc.country = self.country
            vc.searchType = .permanentCountry
            vc.countryDelegate = self
            self.present(vc, animated: false)
            
            
            
        }
        permanentAddressCountryView.setData(text: permanentAddressCountryTxt)
        stackView.addArrangedSubview(permanentAddressCountryView)
        
        
        
        let btnView = CenterButtonView.init(title: AppString.Heading.savebtn) { [weak self] (clicked) in
            guard let self = self else {return}
            print(self.phoneNumberTxt)
//            if self.phoneNumberTxt != "" {
//                if !self.phoneNumberTxt.isValidMobileNo {
//                    self.showAlert(title: "Alert", message: "Please enter your valid Phone No.", controller: self) {
//                        //self.nameView.txt.becomeFirstResponder()
//                    }
//                    return
//                }
//            }
            if self.mobileNumberTxt == "" {
                self.showAlert(title: "Alert", message: "Please enter your Mobile No.", controller: self) {
                    //self.nameView.txt.becomeFirstResponder()
                }
                return
            }
//            if self.officeNumberTxt != "" {
//                if !self.officeNumberTxt.isValidMobileNo {
//                    self.showAlert(title: "Alert", message: "Please enter your valid Office No.", controller: self) {
//                        //self.nameView.txt.becomeFirstResponder()
//                    }
//                    return
//                }
//            }
            if self.currentAddressTxt == "" {
                self.showAlert(title: "Alert", message: "Please enter your current Address.", controller: self) {
                    //self.nameView.txt.becomeFirstResponder()
                }
                return
            }
            
            if self.currentCityTxt == "" {
                self.showAlert(title: "Alert", message: "Please enter your current City.", controller: self) {
                    //self.nameView.txt.becomeFirstResponder()
                }
                return
            }
            
            if self.currentAddressCountryTxt == "" {
                self.showAlert(title: "Alert", message: "Please enter your current Country Address.", controller: self) {
                    //self.nameView.txt.becomeFirstResponder()
                }
                return
            }
            
            self.permanentAddressTxt = self.permanentAddressView.txtField.text ?? ""
            self.permanentAddressCountryTxt = self.permanentAddressCountryView.txtField.text ?? ""
            self.permanentCityTxt = self.permanentCityView.txtField.text ?? ""
            
            if self.permanentAddressTxt == "" {
                self.showAlert(title: "Alert", message: "Please enter your permanent Address.", controller: self) {
                    //self.nameView.txt.becomeFirstResponder()
                }
                return
            }
            
            if self.permanentCityTxt == "" {
                self.showAlert(title: "Alert", message: "Please enter your permanent City.", controller: self) {
                    //self.nameView.txt.becomeFirstResponder()
                }
                return
            }
            
            if self.permanentAddressCountryTxt == "" {
                self.showAlert(title: "Alert", message: "Please enter your permanent Country Address.", controller: self) {
                    //self.nameView.txt.becomeFirstResponder()
                }
                return
            }
            
            
            let info = PersonalInfoEntity.BasicInfo(fullName: self.basicInfo.fullName, fatherHusbandName: self.basicInfo.fatherHusbandName, motherMaidenName: self.basicInfo.motherMaidenName, cnicIssueDate: self.basicInfo.cnicIssueDate, cnicExpiryDate: self.basicInfo.cnicExpiryDate, dateOfBirth: self.basicInfo.dateOfBirth, maritalStatus: self.basicInfo.maritalStatus, zakatStatus: self.basicInfo.zakatStatus, religion: self.basicInfo.religion, nationality: self.basicInfo.nationality, dualNational: self.basicInfo.dualNational, dualNationalCountry: self.basicInfo.dualNationalCountry, residentialStatus: self.basicInfo.residentialStatus, phoneNo: self.phoneNumberTxt, officeNo: self.officeNumberTxt, mobileNo: self.mobileNumberTxt, mobileNetwork: nil, ported: nil, emailAddress: self.emailAddressTxt, currentAddress: self.currentAddressTxt, currentCity: self.currentCityTxt, currentCountry: self.currentAddressCountryTxt, permanentAddress: self.permanentAddressTxt, permanentCity: self.permanentCityTxt, permanentCountry: self.permanentAddressCountryTxt, bankName: nil, bankAccountNo: nil, branchName: nil, branchCity: nil, cashDividend: nil, stockDividend: nil, nextOfKin: nil, jointHolder: self.basicInfo.jointHolder, simOwner: nil, daoID: self.basicInfo.daoID, cnic: self.basicInfo.cnic, accountType: self.basicInfo.accountType, channel: self.basicInfo.channel)
            
            
            
            self.router?.routerToBankInfoVC(info: info)
        }
        
        stackView.addArrangedSubview(btnView)
        
    }
}

extension ContactInfoViewController: ContactInfoViewProtocol {
    func getCountries(resposne: CountryModel) {
        if resposne.country?.count ?? 0 > 0 {
            self.hideLoader()
            country = resposne.country
            cities = resposne.city
            Constant.country = country
            currentAddressCityItem = cities?.firstIndex(where: {$0.cITY == currentCityTxt}) ?? 0
            permanentAddressCityItem = cities?.firstIndex(where: {$0.cITY == permanentCityTxt}) ?? 0
            currentAddressCountryItem = country?.firstIndex(where: {$0.cOUNTRY == currentAddressCountryTxt}) ?? 0
            permanentAddressCountryItem = country?.firstIndex(where: {$0.cOUNTRY == permanentAddressCountryTxt}) ?? 0
        }
    }
    
    func requestFail() {
        hideLoader()
    }
    
}


extension ContactInfoViewController: SelectCity {
    func selectCurrentCity(city: CityModel?) {
        self.currentCityView?.txtField.text = city?.cITY
        self.currentCityView?.txtField.resignFirstResponder()
        self.currentCityTxt = city?.cITY ?? ""
        if self.isSameAddress == true {
            self.permanentCityView.txtField.text = self.currentCityTxt
        }
        currentCityView.setData(text: currentCityTxt)
    }
    func selectPermanentCity(city: CityModel?) {
        self.permanentCityView?.txtField.text = city?.cITY
        self.permanentCityView?.txtField.resignFirstResponder()
        self.permanentCityTxt = city?.cITY ?? ""
        permanentCityView.setData(text: permanentCityTxt)
    }
    
}
extension ContactInfoViewController: SelectCountry {
    func selectCurrentCountry(country: Country?) {
        currentAddressCountryView?.txtField.text = country?.cOUNTRY
        currentAddressCountryView?.txtField.resignFirstResponder()
        currentAddressCountryTxt = country?.cOUNTRY ?? ""

        if isSameAddress == true {
            permanentAddressCountryView.txtField.text = currentAddressCountryTxt
        }
        currentAddressCountryView.setData(text: currentAddressCountryTxt)
    }
    func selectPermanentCountry(country: Country?) {
        self.permanentAddressCountryView?.txtField.text = country?.cOUNTRY
        self.permanentAddressCountryTxt = country?.cOUNTRY ?? ""
        permanentAddressCountryView.txtField.resignFirstResponder()
        permanentAddressCountryView.setData(text: permanentAddressCountryTxt)
    }
}

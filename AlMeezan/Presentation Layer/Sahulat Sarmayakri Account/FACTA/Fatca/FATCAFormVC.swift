//
//  FATCAFormVC.swift
//  AlMeezan
//
//  Created by Atta khan on 13/12/2021.
//  Copyright © 2021 Atta khan. All rights reserved.
//

import UIKit

class FATCAFormVC: UIViewController {
    //MARK: Properties
    private (set) var headerView: HeaderView!
    
    var titleTxt = "Principal Account Holder"
    var totalSteps = "1 / 3"
    var numberOfPages = 3
    var currentPage = 0
    
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
    private (set) lazy var lblTitle: UILabel = { [unowned self] in
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor =  UIColor.rgb(red: 185, green: 187, blue: 198, alpha: 1)
        label.font = UIFont(name: AppFontName.robotoMedium, size: 14)
        label.text = "FATCA Form"
        return label
    }()
    
    private (set) lazy var placeOfBirthLbl: UILabel = { [unowned self] in
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor =  UIColor.black
        label.font = UIFont(name: AppFontName.robotoMedium, size: 16)
        label.text = "Place of Birth"
        return label
    }()
    var otherView: TextInputView!
    var dataSource: GenericPickerDataSource<OptionModel>?
    var countryTaxResidence: [OptionModel] = [OptionModel]()
    private var accountTitleTxt: String         =   ""
    private var CNICTxt: String    =   ""
    private var residenceTxt: String      =   ""
    private var otherTxt: String      =   ""
    private var cityTxt: String         =   ""
    private var stateTxt: String    =   ""
    private var countryTxt: String      =   ""
    private var countryTaxResidenceView: ButtonPickerView!
    
    var countryTaxResidenceItem: Int = 0
    
    var router: FATCAFormRouterProtocol?
    var basicInfo: PersonalInfoEntity.BasicInfo?
    var KYCInfo: KYCModel?
    init(KYCInfo: KYCModel?, basicInfo: PersonalInfoEntity.BasicInfo?) {
        self.KYCInfo = KYCInfo
        self.basicInfo = basicInfo
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        router?.navigationController = navigationController
        countryTaxResidence.append(
            contentsOf: [
                OptionModel(code: "", name: "NONE", isActive: 0),
                OptionModel(code: "", name: "USA", isActive: 0),
                OptionModel(code: "", name: "Other", isActive: 0)
            ]
        )
        residenceTxt = "NONE"
        
        
        if self.basicInfo?.isJointAccount ?? false {
            titleTxt = "Join Account Holder"
            totalSteps = "3 / 5"
            numberOfPages = 5
            currentPage = 2
        }
        
        headerView = { [unowned self] in
        let view = HeaderView.init(stepValue: totalSteps, titleStr: titleTxt, subTitle: "FATCA FORM", numberOfPages: numberOfPages, currentPageNo: currentPage, closeAction: {
            self.navigationController?.popViewController(animated: true)
        }, nextAction: {
            print("next")
        }, previousAction: {
            self.navigationController?.popViewController(animated: true)
        })
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
        setupViews()
    }

}
extension FATCAFormVC {
    fileprivate func setupViews() {
        self.view.backgroundColor = .white
        
        
        self.accountTitleTxt = self.basicInfo?.fullName ?? ""
        self.CNICTxt = self.basicInfo?.cnic ?? ""
        
        
       
        if let info = self.basicInfo?.isJointAccount ?? false ? self.basicInfo?.jointHolder?.fatca : Constant.CustomerData.customer_data?.cNICData?.fatca {
            cityTxt = info.pobCity ?? ""
            stateTxt = info.pobState ?? ""
            countryTxt = info.pobCountry ?? ""
            residenceTxt = info.countryOfTaxResidence ?? "NONE"
            if countryTaxResidence.count > 0 {
                self.countryTaxResidenceView?.txtField.text = countryTaxResidence[0].name
            }
            if self.residenceTxt != "USA" && self.residenceTxt != "NONE" {
                countryTaxResidenceItem = countryTaxResidence.firstIndex(where: {$0.name == "Other"}) ?? 0
            } else {
                countryTaxResidenceItem = countryTaxResidence.firstIndex(where: {$0.name == residenceTxt}) ?? 0
            }
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
        
        
        let titleView = TextInputView(heading:  "Account Title", placeholder: "Enter Account Title", isPasswordEnable: false) { [weak self] (enteredText) in
            guard let self = self else {return}
            self.accountTitleTxt = enteredText
        }
        titleView.setData(text: accountTitleTxt)
        titleView.txtField.isUserInteractionEnabled = false
        stackView.addArrangedSubview(titleView)

        let CNICView = TextInputView(heading:  AppString.Heading.cnic, placeholder: "Enter CNIC", isPasswordEnable: false) { [weak self] (enteredText) in
            guard let self = self else {return}
            self.CNICTxt = enteredText
        }
        CNICView.setData(text: CNICTxt)
        CNICView.txtField.isUserInteractionEnabled = false
        stackView.addArrangedSubview(CNICView)
        
        countryTaxResidenceView = ButtonPickerView(heading:  "Country of Tax Residence Other Than Pakistan", placeholder: "Select Country of Tax Residence", image: "down_Arrow") {
            self.dataSource = GenericPickerDataSource<OptionModel>(
                withItems: self.countryTaxResidence,
                        withRowTitle: { (data) -> String in
                            return data.name ?? ""
                        }, row: self.countryTaxResidenceItem,  didSelect: { (data) in
                            self.countryTaxResidenceView?.txtField.text = data.name
                            self.residenceTxt = data.name ?? ""
                            self.otherView.isHidden = self.residenceTxt == "Other" ? false : true
                        })
            self.countryTaxResidenceView?.txtField.setupPickerField(withDataSource: self.dataSource!)
        }
        countryTaxResidenceView.setData(text: residenceTxt)
        stackView.addArrangedSubview(countryTaxResidenceView)
        
        
        
        otherView = TextInputView(heading:  "Other Country ", placeholder: "Enter Country Name", isPasswordEnable: false) { [weak self] (enteredText) in
            guard let self = self else {return}
            self.otherTxt = enteredText
        }
        
        stackView.addArrangedSubview(otherView)
        
        if self.residenceTxt != "USA" && self.residenceTxt != "NONE" {
            otherView.isHidden = false
            countryTaxResidenceView.setData(text: "Other")
            otherTxt = self.residenceTxt
        } else {
            otherView.isHidden = true
        }
        otherView.setData(text: otherTxt)
        
        stackView.addArrangedSubview(placeOfBirthLbl)
        
        
        
        let cityView = TextInputView(heading:  "City", placeholder: "Enter City", isPasswordEnable: false) { [weak self] (enteredText) in
            guard let self = self else {return}
            self.cityTxt = enteredText
        }
        cityView.setData(text: cityTxt)
        stackView.addArrangedSubview(cityView)

        
        let stateView = TextInputView(heading:  "State", placeholder: "Enter your state", isPasswordEnable: false) { [weak self] (enteredText) in
            guard let self = self else {return}
            self.stateTxt = enteredText
        }
        stateView.setData(text: stateTxt)
        stackView.addArrangedSubview(stateView)
        
        let countryView = TextInputView(heading:  "Country", placeholder: "Enter your Country", isPasswordEnable: false) { [weak self] (enteredText) in
            guard let self = self else {return}
            self.countryTxt = enteredText
        }
        countryView.setData(text: countryTxt)
        stackView.addArrangedSubview(countryView)
        
        
        
        let btnView = CenterButtonView.init(title: AppString.Heading.savebtn) { [weak self] (clicked) in
            guard let self = self else {return}
            
            if self.accountTitleTxt == ""{
                self.showAlert(title: "Alert", message: "Please enter account Title.", controller: self) {
                    //self.nameView.txt.becomeFirstResponder()
                }
                return
            }
            
            if self.CNICTxt == ""{
                self.showAlert(title: "Alert", message: "Please enter CNIC.", controller: self) {
                    //self.nameView.txt.becomeFirstResponder()
                }
                return
            }
            if self.residenceTxt == ""{
                self.showAlert(title: "Alert", message: "Please enter country of Tax Residence.", controller: self) {
                    //self.nameView.txt.becomeFirstResponder()
                }
                return
            }
            if self.residenceTxt == "Other" && self.otherTxt == "" {
                self.showAlert(title: "Alert", message: "Enter Country Name", controller: self) {
                    //self.nameView.txt.becomeFirstResponder()
                }
                return
            }
            
            if self.cityTxt == ""{
                self.showAlert(title: "Alert", message: "Please enter your city.", controller: self) {
                    //self.nameView.txt.becomeFirstResponder()
                }
                return
            }
            
            if self.stateTxt == ""{
                self.showAlert(title: "Alert", message: "Please enter your state.", controller: self) {
                    //self.nameView.txt.becomeFirstResponder()
                }
                return
            }
            
            if self.countryTxt == ""{
                self.showAlert(title: "Alert", message: "Please enter your country.", controller: self) {
                    //self.nameView.txt.becomeFirstResponder()
                }
                return
            }
            
            if self.residenceTxt != "USA" && self.residenceTxt != "NONE" {
                self.residenceTxt = self.otherTxt
            }
            
            if self.basicInfo?.isJointAccount ?? false {
                let info = FACTAModel(
                    accountTitle: self.accountTitleTxt,
                    countryOfTaxResidence: self.residenceTxt,
                    pobCity: self.cityTxt,
                    pobState: self.stateTxt,
                    pobCountry: self.countryTxt,
                    areYouUsCitizen: self.basicInfo?.jointHolder?.fatca?.areYouUsCitizen,
                    areYouUsResident: self.basicInfo?.jointHolder?.fatca?.areYouUsResident ,
                    holdGreenCard: self.basicInfo?.jointHolder?.fatca?.holdGreenCard,
                    whereBornInUsa: self.basicInfo?.jointHolder?.fatca?.whereBornInUsa,
                    accountMaintainedInUsa: self.basicInfo?.jointHolder?.fatca?.accountMaintainedInUsa,
                    powerOfAttorney: self.basicInfo?.jointHolder?.fatca?.powerOfAttorney,
                    usResidenceMailiingAddress: self.basicInfo?.jointHolder?.fatca?.usResidenceMailiingAddress,
                    usTelephoneNumber: self.basicInfo?.jointHolder?.fatca?.usTelephoneNumber,
                    cnic: self.basicInfo?.cnic,
                    accountType: self.basicInfo?.accountType
                )
                self.basicInfo?.jointHolder?.fatca = info
                self.router?.routerToQuestionairVC(basicinfo: self.basicInfo, KYCinfo: nil, factaInfo: nil)
                
            } else {
                let info = FACTAModel(
                    accountTitle: self.accountTitleTxt,
                    countryOfTaxResidence: self.residenceTxt,
                    pobCity: self.cityTxt,
                    pobState: self.stateTxt,
                    pobCountry: self.countryTxt,
                    areYouUsCitizen: 0,
                    areYouUsResident: 0,
                    holdGreenCard: 0,
                    whereBornInUsa: 0,
                    accountMaintainedInUsa: 0,
                    powerOfAttorney: 0,
                    usResidenceMailiingAddress: 0,
                    usTelephoneNumber: 0,
                    cnic: self.basicInfo?.cnic,
                    accountType: self.basicInfo?.accountType
                )
                
                
                self.router?.routerToQuestionairVC(basicinfo: self.basicInfo, KYCinfo: self.KYCInfo, factaInfo: info)
            }
            
            
           
        }
        
        stackView.addArrangedSubview(btnView)
        
    }
}

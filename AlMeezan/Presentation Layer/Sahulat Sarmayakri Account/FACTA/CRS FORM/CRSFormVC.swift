//
//  CRSFormVC.swift
//  AlMeezan
//
//  Created by Atta khan on 18/01/2022.
//  Copyright © 2022 Atta khan. All rights reserved.
//

import UIKit

class CRSFormVC: UIViewController {
    //MARK: Properties
    
    private (set) var headerView: HeaderView!
    
    var titleTxt = "Principal Account Holder"
    var totalSteps = "3 / 3"
    var numberOfPages = 3
    var currentPage = 2
    
    
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
    
   
    
    private var resaonViewA: ReasonView!
    private var resaonViewB: ReasonView!
    private var resaonViewC: ReasonView!
    
    var explainationView: TextInputView!
    var taxResidenceView: ButtonPickerView!
    var tintView: ButtonPickerView!
    
    var stateView: TextInputView!
    var cityView: TextInputView!
    var addressView: TextInputView!
    
    private var addressTxt: String = ""
    private var stateTxt: String = ""
    private var cityTxt: String = ""
    
    private var explainationTxt: String = ""
    private var countryTxt: String      =   "Pakistan"
    private var tintTxt : String = ""
    private var countryCode: String = "PK"
    var countries: [Country] = [Country]()
    var countryDataSource: GenericPickerDataSource<Country>?
    var tint: [OptionModel] = [OptionModel]()
    var dataSource: GenericPickerDataSource<OptionModel>?
    var crsInfo: Crs?
    var basicInfo: PersonalInfoEntity.BasicInfo?
    var KYCInfo: KYCModel?
    var factaInfo: FACTAModel?
    init(factaInfo: FACTAModel?, KYCInfo: KYCModel?, basicInfo: PersonalInfoEntity.BasicInfo?) {
        self.factaInfo = factaInfo
        self.KYCInfo = KYCInfo
        self.basicInfo = basicInfo
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
    var taxResidenceViewItem = 0
    var tinItem = 0
    var isOtherCountry: Bool = false
    var router: CRSFormRouterProtocol?
    var interactor: CRSInteractorProtocol?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        router?.navigationController = navigationController
        let w9From = UserDefaults.standard.bool(forKey: "W9Form") ?? false

        tint.append(
            contentsOf: [
                OptionModel(code: "", name: "Reason A", isActive: 0),
                OptionModel(code: "", name: "Reason B", isActive: 0),
                OptionModel(code: "", name: "Reason C", isActive: 0),
                OptionModel(code: "", name: "TIN", isActive: 0)
            ]
        )
        
        if self.basicInfo?.isJointAccount ?? false {
            if self.basicInfo?.jointHolder?.fatca?.countryOfTaxResidence != "USA" && self.basicInfo?.jointHolder?.fatca?.countryOfTaxResidence != "NONE" {
                isOtherCountry = true
            }
        } else {
            if self.factaInfo?.countryOfTaxResidence != "USA" && self.factaInfo?.countryOfTaxResidence != "NONE" {
                isOtherCountry = true
            }
        }
        
        
        if self.basicInfo?.isJointAccount ?? false {
            titleTxt = "Join Account Holder"
            totalSteps = "5 / 5"
            numberOfPages = 5
            currentPage = 4
        }
        
        headerView = { [unowned self] in
            let view = HeaderView.init(stepValue: totalSteps, titleStr: titleTxt, subTitle: "CRS FORM", numberOfPages: numberOfPages, currentPageNo: currentPage, closeAction: {
                self.navigationController?.popViewController(animated: true)
            }, nextAction: {
                print("next")
            }, previousAction: {
                self.navigationController?.popViewController(animated: true)
            })
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        
        if let info = Constant.country {
            countries = info
            setupViews()
        } else {
            self.interactor?.getCountries()
        }
        
    }
    
    @objc func didTapCheckboxBtn(_ sender: UIButton) {
        sender.isSelected != sender.isSelected
    }
    
    
}
extension CRSFormVC {
    fileprivate func setupViews() {
        
        if let info = self.basicInfo?.isJointAccount ?? false ? self.basicInfo?.jointHolder?.crs : Constant.CustomerData.customer_data?.cNICData?.crs {
            countryTxt = info.countryOfTaxResidence ?? "Pakistan"
            explainationTxt = info.explaination ?? ""
            tintTxt = info.tinNo ?? ""
            addressTxt = info.address ?? ""
            cityTxt = info.city ?? ""
            stateTxt = info.state ?? ""
        }
        
        taxResidenceViewItem = countries.firstIndex(where: {$0.cOUNTRY == countryTxt}) ?? 0
        
        let country = self.countries.filter( { $0.cOUNTRY_SHORT_NAME == self.countryTxt })
        if country.count > 0 {
            self.countryCode    =   country[0].cOUNTRY_SHORT_NAME ?? ""
            self.countryTxt     =   country[0].cOUNTRY ?? ""
        }
        
        
        tinItem = tint.firstIndex(where: { $0.name == tintTxt}) ?? 0
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
        
        
        taxResidenceView = ButtonPickerView(heading:  "Country of Tax Residence", placeholder: "Country of Tax Residence", image: "down_Arrow") {
            let vc = CountrySearchVC()
            vc.country = self.countries
            vc.searchType = .currentCountry
            vc.countryDelegate = self
            self.present(vc, animated: false)
        }
        taxResidenceView.setData(text: countryTxt)
        stackView.addArrangedSubview(taxResidenceView)

        tintView = ButtonPickerView(heading:  "TIN No", placeholder: "Select TIN No", image: "down_Arrow") {
            self.dataSource = GenericPickerDataSource<OptionModel>(
                withItems: self.tint,
                        withRowTitle: { (data) -> String in
                            return data.name ?? ""
                        }, row: self.tinItem,  didSelect: { (data) in
                            self.tintView?.txtField.text = data.name
                            self.tintTxt = data.name ?? ""
                        })
            self.tintView?.txtField.setupPickerField(withDataSource: self.dataSource!)
        }
        tintView.setData(text: tintTxt)
        stackView.addArrangedSubview(tintView)
        
        explainationView = TextInputView(heading:  "TIN No./Explanation", placeholder: "Enter Explaination", isPasswordEnable: false) { [weak self] (enteredText) in
            guard let self = self else {return}
            self.explainationTxt = enteredText
        }
        explainationView.setData(text: explainationTxt)
        stackView.addArrangedSubview(explainationView)
        
        
        if isOtherCountry {
            addressView = TextInputView(heading:  "Address", placeholder: "Enter Address", isPasswordEnable: false) { [weak self] (enteredText) in
                guard let self = self else {return}
                self.addressTxt = enteredText
            }
            addressView.setData(text: addressTxt)
            stackView.addArrangedSubview(addressView)
            cityView = TextInputView(heading:  "City", placeholder: "Enter City", isPasswordEnable: false) { [weak self] (enteredText) in
                guard let self = self else {return}
                self.cityTxt = enteredText
            }
            cityView.setData(text: cityTxt)
            stackView.addArrangedSubview(cityView)
            
            stateView = TextInputView(heading:  "State", placeholder: "Enter State", isPasswordEnable: false) { [weak self] (enteredText) in
                guard let self = self else {return}
                self.stateTxt = enteredText
            }
            stateView.setData(text: stateTxt)
            stackView.addArrangedSubview(stateView)
        
        }
        
        resaonViewA = ReasonView(heading: "Reason A", desc: "The country/jurisdiction where the account holder is resident doesn’t issue TIN to its residents", checkSelectedCloser: { isSelected in
            print(isSelected)
        })
        
        resaonViewB = ReasonView(heading: "Reason B", desc: "The Account Holder is otherwise unable to obtain a TIN or equivalent number (Explanation will be required at this stage)", checkSelectedCloser: { isSelected in
            print(isSelected)
        })
        
        resaonViewC = ReasonView(heading: "Reason C", desc: "No TIN is required (Note: Only select this reason, along with evidence if the domnestic law of the relevant country does not require the collection of TIN issued by such country)", checkSelectedCloser: { isSelected in
            print(isSelected)
        })
        
        stackView.addArrangedSubview(resaonViewA)
        stackView.addArrangedSubview(resaonViewB)
        stackView.addArrangedSubview(resaonViewC)
            
        
        tinFields()
        
        
        let btnView = CenterButtonView.init(title: AppString.Heading.savebtn) { [weak self] (clicked) in
            guard let self = self else {return}
            
            if self.countryTxt == ""{
                self.showAlert(title: "Alert", message: "Please enter your country.", controller: self) {
                    //self.nameView.txt.becomeFirstResponder()
                }
                return
            }
            
            if self.countryCode != "" && self.countryTxt != "Pakistan" && self.countryCode != "US" {
                if self.tintTxt == "" {
                    self.showAlert(title: "Alert", message: "Please enter TIN No", controller: self) {
                        //self.nameView.txt.becomeFirstResponder()
                    }
                    return
                }
                
                if self.tintTxt == "TIN" || self.tintTxt == "Reason B" {
                    if self.explainationTxt == "" {
                        self.showAlert(title: "Alert", message: "Please enter Explanation", controller: self) {
                            //self.nameView.txt.becomeFirstResponder()
                        }
                        return
                    }
                }
            }
            
            
            if self.isOtherCountry {
                if self.addressTxt == "" {
                    self.showAlert(title: "Alert", message: "Please enter Address", controller: self) {
                    }
                    return
                }
                
                if self.cityTxt == "" {
                    self.showAlert(title: "Alert", message: "Please enter City", controller: self) {
                    }
                    return
                }
                if self.stateTxt == "" {
                    self.showAlert(title: "Alert", message: "Please enter State", controller: self) {
                    }
                    return
                }
            }
            
            
            let info = Crs(countryOfTaxResidence: self.countryCode, tinNo: self.tintTxt, explaination: self.explainationTxt, city: self.cityTxt, state: self.stateTxt, address: self.addressTxt, cnic: self.basicInfo?.cnic, accountType: self.basicInfo?.accountType)
            
            if self.basicInfo?.isJointAccount ?? false {
                self.basicInfo?.jointHolder?.crs = info
                self.basicInfo?.isJointAccount = false
                NotificationCenter.default.post(name: Notification.Name("JointAccountHolder"), object: nil, userInfo: ["basicInfo": self.basicInfo])
                Constant.CustomerData.customer_data?.cNICData?.basicInfo = self.basicInfo
                self.navigationController?.backToViewController(viewController: PersonalInfoVC.self)
                
//                self.interactor?.saveData(basicInfo: self.basicInfo, healthDec: nil, kyc: nil, fatca: nil, crs: nil, riskProfile: nil)
            } else {
                self.crsInfo = info
                self.interactor?.saveData(basicInfo: nil, healthDec: nil, kyc: nil, fatca: nil, crs: info, riskProfile: nil)
            }
        }
        
        stackView.addArrangedSubview(btnView)
        
    }
    
    private func tinFields() {
        if countryTxt != "Pakistan" && countryCode != "US" {
            tintView.isHidden = false
            explainationView.isHidden = false
            resaonViewA.isHidden = false
            resaonViewB.isHidden = false
            resaonViewC.isHidden = false
        } else {
            tintView.isHidden = true
            explainationView.isHidden = true
            resaonViewA.isHidden = true
            resaonViewB.isHidden = true
            resaonViewC.isHidden = true
        }
        tintView.txtField.text = tintTxt
        explainationView.txtField.text = explainationTxt
    }

}

extension CRSFormVC: CRSViewProtocol {
    func getCountries(resposne: CountryModel) {
        if resposne.country?.count ?? 0 > 0 {
            self.hideLoader()
            countries = resposne.country ?? []
            DispatchQueue.main.async {
                self.setupViews()
            }
        }
    }
    func SaveDatasuccessfully(response: [SubmissionResponse]) {
        if response[0].errID == "00" {
            DispatchQueue.main.async {
                if let data = self.crsInfo {
                    self.router?.routerToRiskProfileVC(basicinfo: self.basicInfo, KYCinfo: self.KYCInfo, factaInfo: self.factaInfo, crs: data )
                }
            }
        }
    }
}


extension CRSFormVC: SelectCountry {
    func selectCurrentCountry(country: Country?) {
        self.taxResidenceView?.txtField.text = country?.cOUNTRY
        self.countryTxt = country?.cOUNTRY ?? ""
        self.countryCode = country?.cOUNTRY_SHORT_NAME ?? "PK"
        self.tinFields()
        taxResidenceView?.txtField.resignFirstResponder()
        
    }
    func selectPermanentCountry(country: Country?) {
        
    }
}

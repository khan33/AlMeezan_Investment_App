//
//  QuestionnaireVC.swift
//  AlMeezan
//
//  Created by Atta khan on 13/12/2021.
//  Copyright © 2021 Atta khan. All rights reserved.
//

import UIKit

class QuestionnaireVC: UIViewController {
    private (set) var headerView: HeaderView!
    
    
    
    private (set) lazy var questionTitle: UILabel = { [unowned self] in
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "PEP Declaration Details"
        label.textColor =  UIColor.init(rgb:0x232746)
        label.font = UIFont(name: AppFontName.robotoRegular, size: 16)
        label.numberOfLines = 0
        return label
    }()
    private (set) lazy var questionDesc: UILabel = { [unowned self] in
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "There will be a set of questions with a yes or no answer(the default will be set at No.)"
        label.textColor =  UIColor.init(rgb:0x232746)
        label.font = UIFont(name: AppFontName.robotoRegular, size: 16)
        label.numberOfLines = 0
        return label
    }()
    
    
    private (set) lazy var collectionView:UICollectionView = { [unowned self] in
        let flow = UICollectionViewFlowLayout()
        flow.scrollDirection = .vertical
        flow.estimatedItemSize = CGSize.zero
        flow.minimumInteritemSpacing = 0
        flow.minimumLineSpacing = 0
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flow)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isScrollEnabled = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(QuestionItemCell.self, forCellWithReuseIdentifier: "QuestionItemCell")
        return collectionView;
    }()
    var btnView: CenterButtonView!
    private var pepQuesitons: [OptionModel] = [OptionModel]()
    private var factaAnswer: [Int] = [Int]()
    var router: QuestionnaireRouterProtocol?
    var interactor: QuestionaireInteractorProtocol?
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
    
    var titleTxt = "Principal Account Holder"
    var totalSteps = "3 / 3"
    var numberOfPages = 3
    var currentPage = 1
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        router?.navigationController = navigationController
        
        
        
        
        if let data = Constant.setup_data {
            pepQuesitons = data.pEP ?? []
            
            if self.basicInfo?.isJointAccount ?? false {
                
                
                 titleTxt = "Join Account Holder"
                 totalSteps = "2 / 5"
                 numberOfPages = 5
                 currentPage = 1
                
                
                
                if let info = self.basicInfo?.jointHolder?.pebDec {
                    self.pepQuesitons[0].answer = info.actionOnBehalfOfOther ?? 0
                    self.pepQuesitons[1].answer = info.refusedYourAccount ?? 0
                    self.pepQuesitons[2].answer = info.seniorPositionInGovtInstitute ?? 0
                    self.pepQuesitons[3].answer = info.seniorPositionInPoliticalParty ?? 0
                    self.pepQuesitons[4].answer = info.financiallyDependent ?? 0
                    self.pepQuesitons[5].answer = info.highValueGoldSilverDiamond ?? 0
                    self.pepQuesitons[6].answer = info.incomeIsHighRisk ?? 0
                    self.pepQuesitons[7].answer = info.headOfState ?? 0
                    self.pepQuesitons[8].answer = info.seniorMilitaryOfficer ?? 0
                    self.pepQuesitons[9].answer = info.headOfDeptOrIntlOrg ?? 0
                    self.pepQuesitons[10].answer = info.memberOfBoard ?? 0
                    self.pepQuesitons[11].answer = info.memberOfNationalSenate ?? 0
                    self.pepQuesitons[12].answer = info.politicalPartyOfficials ?? 0
                }
            } else {
                if let info = Constant.CustomerData.customer_data?.cNICData?.kyc {
                    
                    self.pepQuesitons[0].answer = info.actionOnBehalfOfOther ?? 0
                    self.pepQuesitons[1].answer = info.refusedYourAccount ?? 0
                    self.pepQuesitons[2].answer = info.seniorPositionInGovtInstitute ?? 0
                    self.pepQuesitons[3].answer = info.seniorPositionInPoliticalParty ?? 0
                    self.pepQuesitons[4].answer = info.financiallyDependent ?? 0
                    self.pepQuesitons[5].answer = info.highValueGoldSilverDiamond ?? 0
                    self.pepQuesitons[6].answer = info.incomeIsHighRisk ?? 0
                    self.pepQuesitons[7].answer = info.headOfState ?? 0
                    self.pepQuesitons[8].answer = info.seniorMilitaryOfficer ?? 0
                    self.pepQuesitons[9].answer = info.headOfDeptOrIntlOrg ?? 0
                    self.pepQuesitons[10].answer = info.memberOfBoard ?? 0
                    self.pepQuesitons[11].answer = info.memberOfNationalSenate ?? 0
                    self.pepQuesitons[12].answer = info.politicalPartyOfficials ?? 0
                }
            }
            collectionView.reloadData()
        }
        
        
        headerView = { [unowned self] in
            let view = HeaderView.init(stepValue: totalSteps, titleStr: titleTxt, subTitle: "PEP Declaration" ,numberOfPages: numberOfPages, currentPageNo: currentPage , closeAction: {
                self.navigationController?.popViewController(animated: true)
            }, nextAction: {
            }, previousAction: {
                self.navigationController?.popViewController(animated: true)
            })
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        
        setupViews()
    }
    
}
extension QuestionnaireVC: QuestionaireViewProtocol {
    func SaveDatasuccessfully(response: [SubmissionResponse]) {
        if response[0].errID == "00" {
            DispatchQueue.main.async {
                self.router?.routerToFACTAVC(basicinfo: self.basicInfo, KYCinfo: self.KYCInfo)
            }
        }
    }
    
    
}

extension QuestionnaireVC {
    fileprivate func setupViews() {
        self.view.backgroundColor = .white
        
        
        
        if !headerView.isDescendant(of: self.view) {
            self.view.addSubview(headerView)
        }
        headerView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        headerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        headerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        headerView.heightAnchor.constraint(equalToConstant: 124.0).isActive = true
        
        if !questionTitle.isDescendant(of: self.view) {
            self.view.addSubview(questionTitle)
        }
        questionTitle.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 16).isActive = true
        questionTitle.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        questionTitle.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        
        
//        if !questionDesc.isDescendant(of: self.view) {
//            self.view.addSubview(questionDesc)
//        }
//        questionDesc.topAnchor.constraint(equalTo: questionTitle.bottomAnchor, constant: 16).isActive = true
//        questionDesc.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
//        questionDesc.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16).isActive = true
        
        
        btnView = CenterButtonView.init(title: AppString.Heading.savebtn) { [weak self] (clicked) in
            guard let self = self else {return}
            
            if self.basicInfo?.isJointAccount ?? false {
                let info = PEBDesModel (
                    actionOnBehalfOfOther: self.pepQuesitons[0].answer,
                    refusedYourAccount: self.pepQuesitons[1].answer,
                    seniorPositionInGovtInstitute: self.pepQuesitons[2].answer,
                    seniorPositionInPoliticalParty: self.pepQuesitons[3].answer,
                    financiallyDependent: self.pepQuesitons[4].answer,
                    highValueGoldSilverDiamond: self.pepQuesitons[5].answer,
                    incomeIsHighRisk: self.pepQuesitons[6].answer,
                    headOfState: self.pepQuesitons[7].answer,
                    seniorMilitaryOfficer: self.pepQuesitons[8].answer,
                    headOfDeptOrIntlOrg: self.pepQuesitons[9].answer,
                    memberOfBoard: self.pepQuesitons[10].answer,
                    memberOfNationalSenate: self.pepQuesitons[11].answer,
                    politicalPartyOfficials: self.pepQuesitons[12].answer
                )
                
                self.basicInfo?.jointHolder?.pebDec = info
                self.router?.routerToFACTAVC(basicinfo: self.basicInfo, KYCinfo: nil)
                
            } else {
                
                let info = KYCModel(
                    residentialStatus: self.basicInfo?.residentialStatus,
                    sourceOfIncome: self.KYCInfo?.sourceOfIncome,
                    sourceOfWealth: self.KYCInfo?.sourceOfWealth,
                    nameOfEmployer: self.KYCInfo?.nameOfEmployer ?? "",
                    designation: self.KYCInfo?.designation ?? "",
                    natureOfBusiness: self.KYCInfo?.natureOfBusiness ?? "",
                    education: self.KYCInfo?.education,
                    profession: self.KYCInfo?.profession,
                    geographiesDomestic: self.KYCInfo?.geographiesDomestic,
                    geographiesIntl: self.KYCInfo?.geographiesIntl,
                    counterPartyDomestic: "Sindh",
                    counterPartyIntl: "FATF Compliant",
                    modeOfTransaction: self.KYCInfo?.modeOfTransaction,
                    numberOfTransaction: self.KYCInfo?.numberOfTransaction,
                    expectedTurnOverMonthlyAnnual: self.KYCInfo?.expectedTurnOverMonthlyAnnual,
                    expectedTurnOver: self.KYCInfo?.expectedTurnOver,
                    expectedInvestmentAmount: "upto Rs. 2.5M",
                    annualIncome: "upto Rs. 1M",
                    
                    actionOnBehalfOfOther: self.pepQuesitons[0].answer,
                    refusedYourAccount: self.pepQuesitons[1].answer,
                    seniorPositionInGovtInstitute: self.pepQuesitons[2].answer,
                    seniorPositionInPoliticalParty: self.pepQuesitons[3].answer,
                    financiallyDependent: self.pepQuesitons[4].answer,
                    highValueGoldSilverDiamond: self.pepQuesitons[5].answer,
                    incomeIsHighRisk: self.pepQuesitons[6].answer,
                    headOfState: self.pepQuesitons[7].answer,
                    seniorMilitaryOfficer: self.pepQuesitons[8].answer,
                    headOfDeptOrIntlOrg: self.pepQuesitons[9].answer,
                    memberOfBoard: self.pepQuesitons[10].answer,
                    memberOfNationalSenate: self.pepQuesitons[11].answer,
                    politicalPartyOfficials: self.pepQuesitons[12].answer,
                    pep_Declaration: "",
                    whereDidYouHearAboutUs: self.KYCInfo?.whereDidYouHearAboutUs,
                    daoID: self.KYCInfo?.daoID,
                    cnic: self.basicInfo?.cnic,
                    accountType: self.basicInfo?.accountType,
                    fundSupporter: self.KYCInfo?.fundSupporter
                )
                self.KYCInfo = info
                self.interactor?.saveData(basicInfo: nil, healthDec: nil, kyc: info, fatca: nil, crs: nil, riskProfile: nil)
            }
            
            
            
            
            //self.router?.routerToFACTAVC()
        }
        self.view.addSubview(btnView)
        btnView.translatesAutoresizingMaskIntoConstraints = false
        btnView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -16).isActive = true
        btnView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16).isActive = true
        btnView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16).isActive = true
        btnView.heightAnchor.constraint(equalToConstant: 55).isActive = true
        
        if !collectionView.isDescendant(of: self.view) {
            self.view.addSubview(collectionView)
        }
        collectionView.topAnchor.constraint(equalTo: questionTitle.bottomAnchor, constant: 16).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: self.btnView.topAnchor, constant: -16).isActive = true
    }
}

extension QuestionnaireVC: QuestionAnswerProtocol {
    func getAnswer(row: Int, option: AnswerOption, answer: Bool) {
        if option == AnswerOption.yes {
            pepQuesitons[row].answer = 1
        } else {
            pepQuesitons[row].answer = 0
        }
    }
}

//MARK: - Collection Delegete
extension QuestionnaireVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pepQuesitons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(with: QuestionItemCell.self, for: indexPath)
        cell.questionLbl.text = pepQuesitons[indexPath.row].name
        cell.questionNo.text = ""
        cell.indexRow = indexPath.row
        cell.quesiton_model = pepQuesitons[indexPath.row]
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 130.0)
    }
}

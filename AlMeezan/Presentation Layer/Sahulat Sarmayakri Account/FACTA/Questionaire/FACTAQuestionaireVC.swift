//
//  FACTAQuestionaireVC.swift
//  AlMeezan
//
//  Created by Atta khan on 18/01/2022.
//  Copyright © 2022 Atta khan. All rights reserved.
//

import UIKit
import Toast

class FACTAQuestionaireVC: UIViewController {
    
    private (set) var headerView: HeaderView!
    
    var titleTxt = "Principal Account Holder"
    var totalSteps = "2 / 3"
    var numberOfPages = 3
    var currentPage = 1
    
    
    
    private (set) lazy var questionTitle: UILabel = { [unowned self] in
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Questionnaire"
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
    private var factaQuesitons: [OptionModel] = [OptionModel]()
    private var factaAnswer: [Int] = [Int]()
    var router: FACTAQuestionaireRouterProtocol?
    var interactor: FactaInteractorProtocol?
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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        router?.navigationController = navigationController
        UserDefaults.standard.set(false, forKey: "W9Form")
        if self.basicInfo?.isJointAccount ?? false {
            titleTxt = "Join Account Holder"
            totalSteps = "4 / 5"
            numberOfPages = 5
            currentPage = 3
        }
        
        headerView = { [unowned self] in
            let view = HeaderView.init(stepValue: totalSteps, titleStr: titleTxt, subTitle: "FATCA Questionnaire", numberOfPages: numberOfPages, currentPageNo: currentPage, closeAction: {
                self.navigationController?.popViewController(animated: true)
            }, nextAction: {
                print("next")
            }, previousAction: {
                self.navigationController?.popViewController(animated: true)
            })
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        
        
        
        if let data = Constant.setup_data {
            factaQuesitons = data.fatcaQuestions ?? []
            if let info = self.basicInfo?.isJointAccount ?? false ? self.basicInfo?.jointHolder?.fatca : Constant.CustomerData.customer_data?.cNICData?.fatca {
                self.factaQuesitons[0].answer = info.areYouUsCitizen ?? 0
                self.factaQuesitons[1].answer = info.areYouUsResident ?? 0
                self.factaQuesitons[2].answer = info.holdGreenCard ?? 0
                self.factaQuesitons[3].answer = info.whereBornInUsa ?? 0
                self.factaQuesitons[4].answer = info.accountMaintainedInUsa ?? 0
                self.factaQuesitons[5].answer = info.powerOfAttorney ?? 0
                self.factaQuesitons[6].answer = info.usResidenceMailiingAddress ?? 0
                self.factaQuesitons[7].answer = info.usTelephoneNumber ?? 0
            }
            collectionView.reloadData()
        }
        setupViews()
    }
    
    
    
}

extension FACTAQuestionaireVC {
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
        
        btnView = CenterButtonView.init(title: AppString.Heading.savebtn) { [weak self] (clicked) in
            guard let self = self else {return}
            
            self.factaQuesitons.forEach { item in
                if item.answer == 1 {
                    
                    print(self.basicInfo?.isJointAccount)
                    
                    if self.basicInfo?.isJointAccount ?? false {
                        UserDefaults.standard.set(true, forKey: "W9JointForm")
                    } else {
                        UserDefaults.standard.set(true, forKey: "W9Form")
                    }
                } else {
                   // UserDefaults.standard.set(false, forKey: "W9Form")
                }
            }
            
            
            
            if self.basicInfo?.isJointAccount ?? false {
                let info = FACTAModel(
                    accountTitle: self.basicInfo?.fullName,
                    countryOfTaxResidence: self.basicInfo?.jointHolder?.fatca?.countryOfTaxResidence,
                    pobCity: self.basicInfo?.jointHolder?.fatca?.pobCity,
                    pobState: self.basicInfo?.jointHolder?.fatca?.pobState,
                    pobCountry: self.basicInfo?.jointHolder?.fatca?.pobCountry,
                    areYouUsCitizen: self.factaQuesitons[0].answer,
                    areYouUsResident: self.factaQuesitons[1].answer,
                    holdGreenCard: self.factaQuesitons[2].answer,
                    whereBornInUsa: self.factaQuesitons[3].answer,
                    accountMaintainedInUsa: self.factaQuesitons[4].answer,
                    powerOfAttorney: self.factaQuesitons[5].answer,
                    usResidenceMailiingAddress: self.factaQuesitons[6].answer,
                    usTelephoneNumber: self.factaQuesitons[7].answer,
                    cnic: self.basicInfo?.cnic,
                    accountType: self.basicInfo?.accountType
                )
                self.basicInfo?.jointHolder?.fatca = info
                self.router?.routerToNextVC(basicinfo: self.basicInfo, KYCinfo: nil, factaInfo: nil)
            } else {
                let info = FACTAModel(
                    accountTitle: self.factaInfo?.accountTitle,
                    countryOfTaxResidence: self.factaInfo?.countryOfTaxResidence,
                    pobCity: self.factaInfo?.pobCity,
                    pobState: self.factaInfo?.pobState,
                    pobCountry: self.factaInfo?.pobCountry,
                    areYouUsCitizen: self.factaQuesitons[0].answer,
                    areYouUsResident: self.factaQuesitons[1].answer,
                    holdGreenCard: self.factaQuesitons[2].answer,
                    whereBornInUsa: self.factaQuesitons[3].answer,
                    accountMaintainedInUsa: self.factaQuesitons[4].answer,
                    powerOfAttorney: self.factaQuesitons[5].answer,
                    usResidenceMailiingAddress: self.factaQuesitons[6].answer,
                    usTelephoneNumber: self.factaQuesitons[7].answer,
                    cnic: self.basicInfo?.cnic,
                    accountType: self.basicInfo?.accountType
                )
                self.factaInfo = info
                self.interactor?.saveData(basicInfo: nil, healthDec: nil, kyc: nil, fatca: info, crs: nil, riskProfile: nil)
            }
            
            
            
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
extension FACTAQuestionaireVC: FactaViewProtocol {
    func SaveDatasuccessfully(response: [SubmissionResponse]) {
        if response[0].errID == "00" {
            DispatchQueue.main.async {
                self.router?.routerToNextVC(basicinfo: self.basicInfo, KYCinfo: self.KYCInfo, factaInfo: self.factaInfo)
            }
        }
    }
}
extension UserDefaults {
    var domainSchemas: [OptionModel] {
        get {
            guard let data = UserDefaults.standard.data(forKey: "domainSchemas") else { return [] }
            return (try? PropertyListDecoder().decode([OptionModel].self, from: data)) ?? []
        }
        set {
            UserDefaults.standard.set(try? PropertyListEncoder().encode(newValue), forKey: "domainSchemas")
        }
    }
}

extension FACTAQuestionaireVC: QuestionAnswerProtocol {
    func getAnswer(row: Int, option: AnswerOption, answer: Bool) {
        if option == AnswerOption.yes {
            let array = factaQuesitons.filter { $0.answer == 1 }
            if array.count == 0 {
                self.showAlert(title: "Alert", message: "From W9 will be required when uploading documents.", controller: self) {
                }
            }
            factaQuesitons[row].answer = 1
        } else {
            factaQuesitons[row].answer = 0

        }
        UserDefaults.standard.domainSchemas = factaQuesitons
    }
}

//MARK: - Collection Delegete
extension FACTAQuestionaireVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return factaQuesitons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(with: QuestionItemCell.self, for: indexPath)
        cell.questionLbl.text = factaQuesitons[indexPath.row].name
        cell.questionNo.text = ""
        //answerOptionArr[indexPath.row] = 0
        cell.indexRow = indexPath.row
        cell.quesiton_model = factaQuesitons[indexPath.row]
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 130.0)
    }
}

struct FACTAModel : Codable {
    let accountTitle : String?
    let countryOfTaxResidence : String?
    let pobCity : String?
    let pobState : String?
    let pobCountry : String?
    let areYouUsCitizen : Int?
    let areYouUsResident : Int?
    let holdGreenCard : Int?
    let whereBornInUsa : Int?
    let accountMaintainedInUsa : Int?
    let powerOfAttorney : Int?
    let usResidenceMailiingAddress : Int?
    let usTelephoneNumber : Int?
    let cnic : String?
    let accountType : String?

    enum CodingKeys: String, CodingKey {

        case accountTitle = "AccountTitle"
        case countryOfTaxResidence = "CountryOfTaxResidence"
        case pobCity = "PobCity"
        case pobState = "PobState"
        case pobCountry = "PobCountry"
        case areYouUsCitizen = "areYouUsCitizen"
        case areYouUsResident = "areYouUsResident"
        case holdGreenCard = "holdGreenCard"
        case whereBornInUsa = "whereBornInUsa"
        case accountMaintainedInUsa = "accountMaintainedInUsa"
        case powerOfAttorney = "powerOfAttorney"
        case usResidenceMailiingAddress = "UsResidenceMailiingAddress"
        case usTelephoneNumber = "UsTelephoneNumber"
        case cnic = "Cnic"
        case accountType = "AccountType"
    }

}


enum AnswerOption: String {
    case no = "No"
    case yes = "Yes"
}

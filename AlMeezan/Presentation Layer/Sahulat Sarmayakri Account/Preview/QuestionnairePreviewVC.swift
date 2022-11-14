//
//  QuestionnairePreviewVC.swift
//  AlMeezan
//
//  Created by Atta khan on 21/02/2022.
//  Copyright © 2022 Atta khan. All rights reserved.
//

import UIKit

class QuestionnairePreviewVC: UIViewController {
    private (set) lazy var containerView: UIView = { [unowned self] in
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.backgroundColor = .black
        view.alpha = 0.888888
        return view
    }()
    
    private (set) lazy var questionTitle: UILabel = { [unowned self] in
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Questionnaire"
        label.textColor =  UIColor.init(rgb:0x232746)
        label.font = UIFont(name: AppFontName.robotoMedium, size: 16)
        label.numberOfLines = 0
        return label
    }()
    
    
    private (set) lazy var closeBtn: UIButton = { [unowned self] in
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.clipsToBounds = true
        btn.setImage(UIImage(named: "closegray"), for: .normal)
        btn.addTarget(self, action: #selector(didTapCloseBtn), for: .touchUpInside)
        return btn
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
        collectionView.register(QuestionPreviewCell.self, forCellWithReuseIdentifier: "QuestionPreviewCell")
        return collectionView;
    }()
    
    private var quesitonnaire: [OptionModel] = [OptionModel]()
    private var kycDetail: KYCModel?
    private var fatcaDetail: FACTAModel?
    init(quesitonnaire: [OptionModel], kycDetail: KYCModel?, fatca: FACTAModel?) {
        self.quesitonnaire = quesitonnaire
        self.kycDetail = kycDetail
        self.fatcaDetail = fatca
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        if let kyc = kycDetail {
            self.quesitonnaire[0].answer = kyc.actionOnBehalfOfOther ?? 0
            self.quesitonnaire[1].answer = kyc.refusedYourAccount ?? 0
            self.quesitonnaire[2].answer = kyc.seniorPositionInGovtInstitute ?? 0
            self.quesitonnaire[3].answer = kyc.seniorPositionInPoliticalParty ?? 0
            self.quesitonnaire[4].answer = kyc.financiallyDependent ?? 0
            self.quesitonnaire[5].answer = kyc.highValueGoldSilverDiamond ?? 0
            self.quesitonnaire[6].answer = kyc.incomeIsHighRisk ?? 0
            self.quesitonnaire[7].answer = kyc.headOfState ?? 0
            self.quesitonnaire[8].answer = kyc.seniorMilitaryOfficer ?? 0
            self.quesitonnaire[9].answer = kyc.headOfDeptOrIntlOrg ?? 0
            self.quesitonnaire[10].answer = kyc.memberOfBoard ?? 0
            self.quesitonnaire[11].answer = kyc.memberOfNationalSenate ?? 0
            self.quesitonnaire[12].answer = kyc.politicalPartyOfficials ?? 0
        }
        
        if let fatca = fatcaDetail {
            self.quesitonnaire[0].answer = fatca.areYouUsCitizen ?? 0
            self.quesitonnaire[1].answer = fatca.areYouUsResident ?? 0
            self.quesitonnaire[2].answer = fatca.holdGreenCard ?? 0
            self.quesitonnaire[3].answer = fatca.whereBornInUsa ?? 0
            self.quesitonnaire[4].answer = fatca.accountMaintainedInUsa ?? 0
            self.quesitonnaire[5].answer = fatca.powerOfAttorney ?? 0
            self.quesitonnaire[6].answer = fatca.usResidenceMailiingAddress ?? 0
            self.quesitonnaire[7].answer = fatca.usTelephoneNumber ?? 0
        }
        setupView()
    }
    
    @objc private func didTapCloseBtn() {
        dismiss(animated: true, completion: nil)
    }

    func setupView() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.75)
        
        if !containerView.isDescendant(of: self.view) {
            self.view.addSubview(containerView)
        }
        containerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 24).isActive = true
        containerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -24).isActive = true
        containerView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        containerView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.8).isActive = true
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 4
        
        if !questionTitle.isDescendant(of: self.containerView) {
            containerView.addSubview(questionTitle)
        }
        questionTitle.topAnchor.constraint(equalTo: self.containerView.topAnchor, constant: 8).isActive = true
        questionTitle.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: 8).isActive = true
        
        
        if !closeBtn.isDescendant(of: self.containerView) {
            containerView.addSubview(closeBtn)
        }
        closeBtn.topAnchor.constraint(equalTo: self.containerView.topAnchor, constant: 8).isActive = true
        closeBtn.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor, constant: -8).isActive = true
        
        if !collectionView.isDescendant(of: self.containerView) {
            self.containerView.addSubview(collectionView)
        }
        collectionView.topAnchor.constraint(equalTo: closeBtn.bottomAnchor, constant: 16).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: 16).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor, constant: -16).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor, constant: -16).isActive = true
        collectionView.reloadData()
    }
}
//MARK: - Collection Delegete
extension QuestionnairePreviewVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return quesitonnaire.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(with: QuestionPreviewCell.self, for: indexPath)
        cell.questionLbl.text = quesitonnaire[indexPath.row].name
        cell.questionNo.text = "Q \(indexPath.row + 1):"
        if quesitonnaire[indexPath.row].answer == 1 {
            cell.lblAnswer.text = "YES"
        } else {
            cell.lblAnswer.text = "No"
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 110.0)
    }
}
extension UIApplication {
    class func topViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }

        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }

        return base
    }
}

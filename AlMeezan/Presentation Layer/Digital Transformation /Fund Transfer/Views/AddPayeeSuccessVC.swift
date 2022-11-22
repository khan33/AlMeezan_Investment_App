//
//  AddPayeeSuccessVC.swift
//  AlMeezan
//
//  Created by Atta khan on 26/09/2022.
//  Copyright © 2022 Atta khan. All rights reserved.
//

import UIKit

class AddPayeeSuccessVC: UIViewController {
    
    private var innerView: View = {
        let view = View.init(titleLabl: Title.name, subLabel: "Mohammad Ahmed", imageName: "bankImage")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let headerView: UIView = {
        let view = UIView()
        view.backgroundColor = .brown
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let congratulationView: UIView = {
        let view = UIView()
        if #available(iOS 13.0, *) {
            view.backgroundColor = .systemBackground
        } else {
            // Fallback on earlier versions
        }
        view.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        view.layer.cornerRadius = 15
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let topbarImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "bar")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let congratulationImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "success_img")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let nameImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "account-box-outline")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let bankImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "bank")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let accountImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "file-document-outline")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let innerStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.distribution = .fillEqually
        view.alignment = .fill
        view.axis = .vertical
        view.backgroundColor = UIColor.newGray
        view.spacing = 1
        view.clipsToBounds = true
        view.frame = view.bounds
        return view
    }()
    
    private let midLbl: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Funds Transfer"
        label.textColor = UIColor.white
        label.font = UIFont(name: AppFontName.circularStdRegular, size: 16)
        return label
    }()
    
    private let backBtn: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.clipsToBounds = true
        btn.setImage(UIImage(named: IconName.backArrow)?.transform(withNewColor: .white), for: .normal)
        btn.tintColor = .white
        btn.isHidden = true
        return btn
    }()
    
    private let notificationBtn: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.clipsToBounds = true
        btn.setImage(UIImage(named: "notification")?.transform(withNewColor: .white), for: .normal)
        btn.tintColor = .white
        return btn
    }()
    
    private let transferBtn: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.clipsToBounds = true
        btn.setTitle("TRASNFER NOW", for: .normal)
        btn.tintColor = .white
        btn.backgroundColor = UIColor.purple
        btn.layer.cornerRadius = 20
        btn.addTarget(self, action: #selector(didTapOnTransferBtn), for: .touchUpInside)

        return btn
    }()
    
    private let innerNameView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let innerTextView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let innerBankView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let innerAccountNo: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let congLbl: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Congratulations !"
        label.textAlignment = .center
        label.textColor = UIColor.black
        label.font = UIFont(name: AppFontName.circularStdBold, size: 20)
        label.clipsToBounds = true
        return label
    }()
    private let benefLbl: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "beneficiary has been added"
        label.textColor = UIColor.black
        label.textAlignment = .center
        label.clipsToBounds = true
        label.font = UIFont(name: AppFontName.robotoRegular, size: 16)
        return label
    }()
    
    private let nameLbl: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Name"
        label.textAlignment = .center
        label.textColor = UIColor.black
        label.font = UIFont(name: AppFontName.robotoRegular, size: 12)
        label.clipsToBounds = true
        return label
    }()
    private let personNameLbl: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Muhammad Ahmed"
        label.textAlignment = .center
        label.textColor = UIColor.black
        label.font = UIFont(name: AppFontName.circularStdBold, size: 14)
        label.clipsToBounds = true
        return label
    }()
    private let bankLbl: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Bank"
        label.textAlignment = .center
        label.textColor = UIColor.black
        label.font = UIFont(name: AppFontName.robotoRegular, size: 12)
        label.clipsToBounds = true
        return label
    }()
    private let BankNameLbl: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Almeezan Investment Bank"
        label.textAlignment = .center
        label.textColor = UIColor.black
        label.font = UIFont(name: AppFontName.circularStdBold, size: 14)
        label.clipsToBounds = true
        return label
    }()
    private let accountLbl: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Account Number"
        label.textAlignment = .center
        label.textColor = UIColor.black
        label.font = UIFont(name: AppFontName.robotoRegular, size: 12)
        label.clipsToBounds = true
        return label
    }()
    private let accountNoLbl: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "00199930001"
        label.textAlignment = .center
        label.textColor = UIColor.black
        label.font = UIFont(name: AppFontName.circularStdBold, size: 14)
        label.clipsToBounds = true
        return label
    }()
    
    
    private let scrollView: UIScrollView = {
        let scrollview = UIScrollView()
        scrollview.translatesAutoresizingMaskIntoConstraints = false
        return scrollview
    }()
    
    var payee: FundTransferEntity.FetchPayeeTitleResponseModel?
    init(payee: FundTransferEntity.FetchPayeeTitleResponseModel?) {
        self.payee = payee
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.gray2
        view.addSubview(headerView)
        view.addSubview(congratulationImage)
        view.addSubview(congratulationView)
        congratulationView.addSubview(transferBtn)
        congratulationView.addSubview(scrollView)
        scrollView.addSubview(innerStackView)
        
        
        innerStackView.addArrangedSubview(innerTextView)
        innerStackView.addArrangedSubview(innerNameView)
        innerStackView.addArrangedSubview(innerBankView)
        innerStackView.addArrangedSubview(innerAccountNo)
//        innerStackView.addArrangedSubview(innerView)
        
        innerTextView.addSubview(congLbl)
        innerTextView.addSubview(benefLbl)
        
        innerNameView.addSubview(nameLbl)
        innerNameView.addSubview(nameImage)
        innerNameView.addSubview(personNameLbl)
        
        innerBankView.addSubview(bankLbl)
        innerBankView.addSubview(bankImage)
        innerBankView.addSubview(BankNameLbl)
        
        innerAccountNo.addSubview(accountLbl)
        innerAccountNo.addSubview(accountImage)
        innerAccountNo.addSubview(accountNoLbl)
        
        headerView.addSubview(topbarImage)
        headerView.addSubview(backBtn)
        headerView.addSubview(midLbl)
        headerView.addSubview(notificationBtn)
        
        applyConstraints()
    }
    
    private func applyConstraints() {
        
        headerView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        headerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        headerView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        headerView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        topbarImage.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 0).isActive = true
        topbarImage.leftAnchor.constraint(equalTo: headerView.leftAnchor, constant: 0).isActive = true
        topbarImage.rightAnchor.constraint(equalTo: headerView.rightAnchor, constant: 0).isActive = true
        topbarImage.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 0).isActive = true
        
        congratulationImage.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 10).isActive = true
        congratulationImage.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        congratulationImage.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        congratulationImage.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        congratulationView.topAnchor.constraint(equalTo: congratulationImage.bottomAnchor, constant: 10).isActive = true
        congratulationView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        congratulationView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        congratulationView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        backBtn.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 52).isActive = true
        backBtn.leftAnchor.constraint(equalTo: headerView.leftAnchor, constant: 15).isActive = true
        
        midLbl.centerXAnchor.constraint(equalTo: headerView.centerXAnchor, constant: 0).isActive = true
        midLbl.centerYAnchor.constraint(equalTo: headerView.centerYAnchor, constant: 10).isActive = true
        
        notificationBtn.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 52).isActive = true
        notificationBtn.rightAnchor.constraint(equalTo: headerView.rightAnchor, constant: -15).isActive = true
        
        transferBtn.leftAnchor.constraint(equalTo: congratulationView.leftAnchor, constant: 30).isActive = true
        transferBtn.rightAnchor.constraint(equalTo: congratulationView.rightAnchor, constant: -30).isActive = true
        transferBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        transferBtn.bottomAnchor.constraint(equalTo: congratulationView.bottomAnchor, constant: -20).isActive = true
        
        scrollView.centerXAnchor.constraint(equalTo: congratulationView.centerXAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: congratulationView.widthAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: congratulationView.topAnchor, constant: 10).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: transferBtn.topAnchor, constant: -5).isActive = true
        
        innerStackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 1).isActive = true
        innerStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        innerStackView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        innerStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        
        innerNameView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        innerBankView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        innerAccountNo.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        congLbl.centerXAnchor.constraint(equalTo: innerTextView.centerXAnchor).isActive = true
        congLbl.centerYAnchor.constraint(equalTo: innerTextView.centerYAnchor, constant: -15).isActive = true
        benefLbl.topAnchor.constraint(equalTo: congLbl.bottomAnchor, constant: 1).isActive = true
        benefLbl.leftAnchor.constraint(equalTo: innerTextView.leftAnchor, constant: 10).isActive = true
        benefLbl.rightAnchor.constraint(equalTo: innerTextView.rightAnchor, constant: -10).isActive = true
        
        nameImage.widthAnchor.constraint(equalToConstant: 20).isActive = true
        nameImage.topAnchor.constraint(equalTo: innerNameView.topAnchor, constant: 1).isActive = true
        nameImage.leftAnchor.constraint(equalTo: innerNameView.leftAnchor, constant: 25).isActive = true
        nameImage.bottomAnchor.constraint(equalTo: innerNameView.bottomAnchor, constant: -2).isActive = true
        
        nameLbl.topAnchor.constraint(equalTo: innerNameView.topAnchor, constant: 15).isActive = true
        nameLbl.leftAnchor.constraint(equalTo: nameImage.rightAnchor, constant: 10).isActive = true
        
        personNameLbl.topAnchor.constraint(equalTo: nameLbl.bottomAnchor, constant: 2).isActive = true
        personNameLbl.leftAnchor.constraint(equalTo: nameImage.rightAnchor, constant: 10).isActive = true
        
        bankImage.widthAnchor.constraint(equalToConstant: 20).isActive = true
        bankImage.topAnchor.constraint(equalTo: innerBankView.topAnchor, constant: 1).isActive = true
        bankImage.leftAnchor.constraint(equalTo: innerBankView.leftAnchor, constant: 25).isActive = true
        bankImage.bottomAnchor.constraint(equalTo: innerBankView.bottomAnchor, constant: -2).isActive = true
        
        bankLbl.topAnchor.constraint(equalTo: innerBankView.topAnchor, constant: 15).isActive = true
        bankLbl.leftAnchor.constraint(equalTo: bankImage.rightAnchor, constant: 10).isActive = true
        
        BankNameLbl.topAnchor.constraint(equalTo: bankLbl.bottomAnchor, constant: 2).isActive = true
        BankNameLbl.leftAnchor.constraint(equalTo: bankImage.rightAnchor, constant: 10).isActive = true
        
        accountImage.widthAnchor.constraint(equalToConstant: 20).isActive = true
        accountImage.topAnchor.constraint(equalTo: innerAccountNo.topAnchor, constant: 1).isActive = true
        accountImage.leftAnchor.constraint(equalTo: innerAccountNo.leftAnchor, constant: 25).isActive = true
        accountImage.bottomAnchor.constraint(equalTo: innerAccountNo.bottomAnchor, constant: -2).isActive = true
        
        accountLbl.topAnchor.constraint(equalTo: innerAccountNo.topAnchor, constant: 15).isActive = true
        accountLbl.leftAnchor.constraint(equalTo: accountImage.rightAnchor, constant: 10).isActive = true
        
        accountNoLbl.topAnchor.constraint(equalTo: accountLbl.bottomAnchor, constant: 2).isActive = true
        accountNoLbl.leftAnchor.constraint(equalTo: accountImage.rightAnchor, constant: 10).isActive = true
        
        
        
        BankNameLbl.text = self.payee?.bankName
        accountLbl.text = self.payee?.beneficiaryIBAN
        personNameLbl.text = self.payee?.accountTitle
        
    }
    @objc func didTapOnTransferBtn() {
        let vc = PayeeViewController()
        PayeeViewControllerConfigurator.configureModule(viewController: vc)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


//
//  PaymentServicesVC.swift
//  AlMeezan
//
//  Created by Atta khan on 12/09/2022.
//  Copyright © 2022 Atta khan. All rights reserved.
//

import UIKit

class PaymentServicesVC: UIViewController {
    
    private (set) lazy var headerView: PaymentHeaderView = { [unowned self] in
        let view = PaymentHeaderView.init(titleLbl: Headings.paymentService, closeAction: {
            self.navigationController?.popViewController(animated: true)
        }, nextAction: {
            print("next")
        }, previousAction: {
            self.navigationController?.popViewController(animated: true)
        })
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let fundTransferView: PaymentServiceView = {
        let view = PaymentServiceView(titleLabel: Headings.fundTransfer, subTitleLabel: Description.fundTransferDecription , imageName: IconName.fundImage )
        view.isUserInteractionEnabled = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let subscriptionView: PaymentServiceView = {
        let view = PaymentServiceView(titleLabel: Headings.subscribe, subTitleLabel: Description.subscriptionDescription, imageName: IconName.subImage )
        view.isUserInteractionEnabled = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let billPaymentView: PaymentServiceView = {
        let view = PaymentServiceView(titleLabel: Headings.billPayment, subTitleLabel: Description.billPaymentDescription , imageName: IconName.billImage )
        //view.isUserInteractionEnabled = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    var interactor: SubscriptionInteractorProtocol?
    var router: SubscriptionRouterProtocol?
    var customerSubscribe: [SubscriptionEntity.CustomerSubscribed]?

    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .gray2

        
        
        let subscribeGesture = UITapGestureRecognizer(target: self, action: #selector(subscribeTapped))
        self.subscriptionView.addGestureRecognizer(subscribeGesture)

        
        
        let billPaymentGesture = UITapGestureRecognizer(target: self, action: #selector(self.billPaymentTapped))
        self.billPaymentView.addGestureRecognizer(billPaymentGesture)
        
        let fundtrasnferGesture = UITapGestureRecognizer(target: self, action: #selector(self.fundTranferTapped))
        self.fundTransferView.addGestureRecognizer(fundtrasnferGesture)
        
        view.addSubview(headerView)
        view.addSubview(subscriptionView)
        view.addSubview(fundTransferView)
        view.addSubview(billPaymentView)
        
        setupConstraint()
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.billPaymentView.isUserInteractionEnabled = false
        self.fundTransferView.isUserInteractionEnabled = false
        self.showLoader()
        interactor?.viewDidLoad()
    }
    
    
    @objc func fundTranferTapped(sender: UITapGestureRecognizer) {
        let vc = PayeeViewController()
        PayeeViewControllerConfigurator.configureModule(viewController: vc)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func subscribeTapped(sender: UITapGestureRecognizer) {
        let vc = SubscriptionViewController()
        SubscriptionConfigurator.configureModule(viewController: vc)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func billPaymentTapped(sender: UITapGestureRecognizer) {
        let vc = BillListController()
        BillListConfigurator.configureModule(viewController: vc)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    private func setupConstraint() {
        
        headerView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        headerView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        subscriptionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2).isActive = true
        subscriptionView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        
        subscriptionView.trailingAnchor.constraint(equalTo: fundTransferView.trailingAnchor, constant: 0).isActive = true
        subscriptionView.leadingAnchor.constraint(equalTo: fundTransferView.leadingAnchor, constant: 0).isActive = true
        subscriptionView.bottomAnchor.constraint(equalTo: fundTransferView.topAnchor, constant: 15).isActive = true
        
        fundTransferView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        fundTransferView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 30).isActive = true
        fundTransferView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2).isActive = true
        fundTransferView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        
        billPaymentView.leadingAnchor.constraint(equalTo: fundTransferView.leadingAnchor, constant: 0).isActive = true
        billPaymentView.trailingAnchor.constraint(equalTo: fundTransferView.trailingAnchor).isActive = true
        billPaymentView.topAnchor.constraint(equalTo: fundTransferView.bottomAnchor, constant: -20).isActive = true
        
        billPaymentView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2).isActive = true
        billPaymentView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        
    }
    
}
class PaymentServiceView: UIView {
    
    private let views: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        // view.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        view.layer.borderColor = UIColor.gray.cgColor
        view.layer.shadowOpacity = 0.3
        view.layer.shadowColor = UIColor.gray.cgColor
        view.layer.shadowRadius = 10
        view.layer.borderWidth = 0.1
        view.layer.cornerRadius = 20
        view.isUserInteractionEnabled = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titleLbl: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = UIColor.black
        label.font = UIFont(name: AppFontName.circularStdRegular, size: 18)
        label.clipsToBounds = true
        return label
    }()
    
    private let subLbl: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = UIColor.gray
        label.numberOfLines = 0
        label.textAlignment = .left
        label.font = UIFont(name: AppFontName.robotoRegular, size: 15)
        label.clipsToBounds = true
        return label
    }()
    
    private let image: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let btnImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: IconName.chevron_down)?.transform(withNewColor: UIColor.btnGray)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    init(titleLabel: String, subTitleLabel: String, imageName: String) {
        super.init(frame: CGRect.zero)
        self.addSubview(views)
        self.views.addSubview(btnImage)
        self.views.addSubview(titleLbl)
        self.views.addSubview(image)
        self.views.addSubview(subLbl)
        
        titleLbl.text = titleLabel
        image.image = UIImage(named: imageName)
        subLbl.text = subTitleLabel
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        
        self.views.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.views.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.views.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
        self.views.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        self.image.centerYAnchor.constraint(equalTo: self.views.centerYAnchor).isActive = true
        self.image.leadingAnchor.constraint(equalTo: self.views.leadingAnchor, constant: 20).isActive = true
        self.image.widthAnchor.constraint(equalToConstant: 36).isActive = true
        self.image.heightAnchor.constraint(equalToConstant: 36).isActive = true
        
        
        
        self.titleLbl.centerYAnchor.constraint(equalTo: self.views.centerYAnchor, constant: -35).isActive = true
        self.titleLbl.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 16).isActive = true
        
        self.subLbl.topAnchor.constraint(equalTo: titleLbl.bottomAnchor, constant: 5).isActive = true
        self.subLbl.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 16).isActive = true
        self.subLbl.trailingAnchor.constraint(equalTo: btnImage.leadingAnchor, constant: -15).isActive = true
        
        btnImage.centerYAnchor.constraint(equalTo: views.centerYAnchor).isActive = true
        btnImage.trailingAnchor.constraint(equalTo: views.trailingAnchor, constant: -12).isActive = true
        btnImage.heightAnchor.constraint(equalTo: views.heightAnchor, multiplier: 0.06).isActive = true
        
    }
    
}
extension PaymentServicesVC: SubscriptionViewProtocol {
    func subcribedResponse(_ response: subcribedResponseModel) {
        print(response)
    }
    
    
    func subscriptionResponse(_ response: subscriptionResponse) {
        DispatchQueue.main.async {
            self.hideLoader()
            self.customerSubscribe = response.customerSubscribed
            if self.customerSubscribe?.count ?? 0 > 0 {
                for customer in response.customerSubscribed! {
                    if customer.mnemonic == "BILL" && customer.isActive == true {
                        self.billPaymentView.isUserInteractionEnabled = true
                    } else if customer.mnemonic == "IBFT"  && customer.isActive == true {
                        self.fundTransferView.isUserInteractionEnabled = true
                    }
                }
            }
        }
    }
}

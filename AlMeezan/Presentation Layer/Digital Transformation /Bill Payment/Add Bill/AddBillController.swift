//
//  AddBillController.swift
//  AlMeezan
//
//  Created by Ahmad on 30/09/2022.
//  Copyright © 2022 Atta khan. All rights reserved.
//

import Foundation
import UIKit

class AddBillController: UIViewController {
    
    private (set) lazy var headerView: PaymentHeaderView = { [unowned self] in
        let view = PaymentHeaderView.init(titleLbl: "Add Bill Payee", closeAction: {
            self.navigationController?.popViewController(animated: true)
            print("BackClose")
        }, nextAction: {
            print("next")
        }, previousAction: {
            print("Back")
            self.navigationController?.popViewController(animated: true)
        })
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    private var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.gray2
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let saveBtn: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.clipsToBounds = true
        btn.setTitle("SAVE", for: .normal)
        btn.tintColor = .white
        btn.addTarget(self, action: #selector(nextToOTP), for: .touchUpInside)
        btn.backgroundColor = UIColor.purple
        btn.layer.cornerRadius = 20
        return btn
    }()
    
    private let scrollView: UIScrollView = {
        let scrollview = UIScrollView()
        scrollview.translatesAutoresizingMaskIntoConstraints = false
        return scrollview
    }()
    
    private let stackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        view.layer.cornerRadius = 10
        view.distribution = .fillEqually
        view.alignment = .fill
        view.axis = .vertical
        view.backgroundColor = UIColor.gray2
        view.spacing = 2
        view.clipsToBounds = true
        view.frame = view.bounds
        return view
    }()
    
    var addBillList: [AddBillEntity.AddBillResponse]?
    var billInquiryResponse: [BillInquiryEntity.BillInquiryResponse]?
    var consumerView: TextInputView!
    var consumerNumberTxt: String = ""
    var interactor: AddBillInteractorProtocol?
    var router: AddBillRouterProtocol?
    var billingOrganizationView: ButtonPickerView?
    var dataSource: GenericPickerDataSource<AddBillEntity.AddBillResponse>?
    let date = Date()
    var billCompanyID: String = ""
    var billCompanyName: String = ""
    let noInternet: String = "The Internet connection appears to be offline."

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.navigationItem.hidesBackButton = true
        addViews()
        setupContraints()
        interactor?.loadAddMerchandBill()
        //   billInquiry()
    }
    
    @objc func nextToOTP() {
        self.billInquiry()
      //  self.billAdd()
    }
    
    func addViews() {
        view.addSubview(headerView)
        view.addSubview(containerView)
        view.addSubview(saveBtn)
        containerView.addSubview(scrollView)
        scrollView.addSubview(stackView)
    }
    
    func billAdd() {
        let requests = BillAddEntity.BillAddRequest(billerName: self.billCompanyName, utilityCompanyID: self.billInquiryResponse?[0].utilityCompanyID ,customerName: self.billInquiryResponse?[0].customerName, billStatus: self.billInquiryResponse?[0].billStatus, billingMonth: self.billInquiryResponse?[0].billingMonth, dueDate: self.billInquiryResponse?[0].dueDate, amountWithinDueDate: self.billInquiryResponse?[0].amountWithinDueDate, amountAfterDueDate: self.billInquiryResponse?[0].amountAfterDueDate, accountNumber: self.consumerNumberTxt)
        
        self.interactor?.saveBillAdd(request: requests)
    }
    
    func billInquiry() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        let systemDate = dateFormatter.string(from: date)
        print("date is \(systemDate)")
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HHmmss"
        let systemTime = timeFormatter.string(from: date)
        print("System Time is \(systemTime) ")
        
        if consumerNumberTxt.isEmpty {
            self.showAlert(title: "Alert", message: "Please enter consumer number", controller: self) {
            }
        } else if billCompanyName.isEmpty {
            self.showAlert(title: "Alert", message: "Please Select Billing Organization", controller: self) {
            }
        }
        else {
            let request = BillInquiryEntity.BillInquiryRequest(transmissionDate: systemDate, transmissionTime: systemTime, utilityCompanyID: self.billCompanyID, utilityConsumerNumber: self.consumerNumberTxt, nickName: "saad home")
            interactor?.loadBillInquiry(request: request)
  
        }
        
    }
    
    func setupContraints() {
        headerView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        headerView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        saveBtn.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
        saveBtn.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30).isActive = true
        saveBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        saveBtn.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -35).isActive = true
        
        containerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        containerView.topAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: saveBtn.topAnchor, constant: -20).isActive = true
        
        scrollView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 0).isActive = true
        
        // stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        stackView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20).isActive = true
        stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20).isActive = true
        
        billingOrganizationView?.txtField.isUserInteractionEnabled = true
        billingOrganizationView = ButtonPickerView(heading:  "Select Billing Organization", placeholder: "Mobile Company", image: "down_Arrow") {
            self.dataSource = GenericPickerDataSource<AddBillEntity.AddBillResponse>(
                withItems: self.addBillList ?? [],
                withRowTitle: { (data) -> String in
                    return data.billCompany ?? ""
                }, row: 0, didSelect: { (data) in
                    self.billingOrganizationView?.txtField.text = data.billCompany
                    self.billCompanyID = data.billCompanyID ?? ""
                    self.billCompanyName  = data.billCompany ?? ""
                    
                }
            )
            self.billingOrganizationView?.txtField.setupPickerField(withDataSource: self.dataSource!)
        }
        billingOrganizationView?.txtField.isUserInteractionEnabled = true
        billingOrganizationView?.setData(text: billCompanyName)
        billingOrganizationView?.containerView.backgroundColor = .gray2
        stackView.addArrangedSubview(billingOrganizationView!)
        
        consumerView = TextInputView(heading: "Consumer Number", placeholder: "Enter consumer Number", isPasswordEnable: false) { [weak self] (enteredText) in
            guard let self = self else {return}
            self.consumerNumberTxt = enteredText
        }
        consumerView.txtField.keyboardType = .asciiCapableNumberPad
        consumerView.setData(text: consumerNumberTxt)
        consumerView.containerView.backgroundColor = .gray2
        stackView.addArrangedSubview(consumerView)
    }
}


extension AddBillController: AddBillViewProtocol {
    
    func showDataFailure(error: String) {
        if error == noInternet {
            DispatchQueue.main.async {
                self.showAlert(title: "Error", message: error, controller: self, dismissCompletion: {
                })
            }
        }
    }
    
    func successBillAdd(response: [BillAddEntity.BillAddResponse]) {
        DispatchQueue.main.async {
            print(response)
        }
    }
    
    func successBillInquiry(response: [BillInquiryEntity.BillInquiryResponse]) {
        DispatchQueue.main.async {
            self.billInquiryResponse = response
            print("Bill Inqiry Response \(self.billInquiryResponse ?? response), Bill Status: \(self.billInquiryResponse?[0].billStatus ?? "")")
            self.billAdd()
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    func successBillList(response: [AddBillEntity.AddBillResponse]) {
        DispatchQueue.main.async {
            self.addBillList = response
        }
    }
}

//
//  BillPaymentTransactionComplete.swift
//  AlMeezan
//
//  Created by Ahmad on 11/10/2022.
//  Copyright © 2022 Atta khan. All rights reserved.
//

import Foundation

import UIKit

enum Button: Int {
    case share = 1
    case download = 2
    case done = 3
}

class BillPaymentTransactionComplete: UIViewController {
    
    
    private (set) lazy var headerView: HeaderViews = { [unowned self] in
        let view = HeaderViews.init(titleLbl: Headings.fundTransfer, closeAction: {
            self.navigationController?.popViewController(animated: true)
        }, nextAction: {
            print("next")
        }, previousAction: {
            self.navigationController?.popViewController(animated: true)
        })
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let topImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "congratz")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private var views: UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .blue
        return view
    }()
    
    private let containerView: UIView = {
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
    
    private let shareButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.clipsToBounds = true
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.gray2.cgColor
        btn.setTitle("Share", for: .normal)
        btn.backgroundColor = .white
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = UIFont(name: AppFontName.robotoRegular, size: 12)
        btn.setImage(UIImage(named: "share")?.transform(withNewColor: .black), for: .normal)
        btn.imageEdgeInsets = UIEdgeInsets(top: -40, left: 30, bottom: 0, right: 0)
        btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: -15, bottom: 0, right: 0)
        btn.tintColor = .white
        btn.addTarget(self, action: #selector(isTapped), for: .touchUpInside)
        btn.tag = 1
        
        return btn
    }()
    
    private let downloadButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.clipsToBounds = true
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.gray2.cgColor
        btn.setTitle("Download Receipt", for: .normal)
        btn.backgroundColor = .white
        btn.addTarget(self, action: #selector(isTapped), for: .touchUpInside)
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = UIFont(name: AppFontName.robotoRegular, size: 12)
        btn.setImage(UIImage(named: "download")?.transform(withNewColor: .black), for: .normal)
        btn.imageEdgeInsets = UIEdgeInsets(top: -40, left: 60, bottom: 0, right: 0)
        btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: -15, bottom: 0, right: 0)
        btn.tintColor = .white
        btn.tag = 2
        
        return btn
    }()
    
    private let doneButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.clipsToBounds = true
        btn.layer.borderWidth = 1
        btn.addTarget(self, action: #selector(isTapped), for: .touchUpInside)
        btn.layer.borderColor = UIColor.gray2.cgColor
        btn.setTitle("Done", for: .normal)
        btn.backgroundColor = .white
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = UIFont(name: AppFontName.robotoRegular, size: 12)
        btn.setImage(UIImage(named: "done")?.transform(withNewColor: .black), for: .normal)
        btn.imageEdgeInsets = UIEdgeInsets(top: -40, left: 30, bottom: 0, right: 0)
        btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: -15, bottom: 0, right: 0)
        btn.tintColor = .white
        btn.tag = 3
        
        return btn
    }()

    var congoView = congratulationView(titleLabl: "Congratulations", subLabel: "You have added the bill payee.")
    var fromAccountView = View(titleLabl: "From", subLabel: "AlMeezan Investment Wallet", imageName: IconName.accountarrow)
    var toAcocuntView = View(titleLabl: "To", subLabel: "Mohammad Ahmed", imageName: IconName.accountBox)
    var amountView = View(titleLabl: "Amount", subLabel: "PKR 1,500.00", imageName: IconName.money)
    var dateView = View(titleLabl: "Date", subLabel: "10 monday", imageName: IconName.date)
    
    var router: BillTransactionCompleteRouterProtocol?
    var billTransfer: [BillTransferEntity.BillTransferResponse]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        router?.navigationController = navigationController
        view.backgroundColor = .gray2
        view.addSubview(headerView)
        view.addSubview(topImage)
        view.addSubview(containerView)
        view.addSubview(shareButton)
        view.addSubview(downloadButton)
        view.addSubview(doneButton)
        containerView.addSubview(scrollView)
        scrollView.addSubview(stackView)
        stackView.addArrangedSubview(congoView)
        stackView.addArrangedSubview(fromAccountView)
        stackView.addArrangedSubview(toAcocuntView)
        stackView.addArrangedSubview(amountView)
        stackView.addArrangedSubview(dateView)
        setupConstraint()
        print("Response of BillList \(self.billTransfer)")
        configureDateLabel()
    }
    
    func configureDateLabel() {
      
    }
    
    @objc func isTapped(_ sender: UIButton) {
        
        if sender.tag == Button.share.rawValue {
        shareButton.isSelected.toggle()
                shareButton.backgroundColor = .purple
            downloadButton.backgroundColor = .white
            shareButton.setImage(UIImage(named: "share")?.transform(withNewColor: .white), for: .normal)
            shareButton.setTitleColor(.white, for: .normal)
            downloadButton.setTitleColor(.black, for: .normal)
            downloadButton.setImage(UIImage(named: "download")?.transform(withNewColor: .black), for: .normal)
            self.termsAndConditionTapped()
            print("share is tapped")
            
        }
        else if sender.tag == Button.download.rawValue {
            downloadButton.backgroundColor = .purple
            shareButton.backgroundColor = .white
            downloadButton.setImage(UIImage(named: "download")?.transform(withNewColor: .white), for: .normal)
            downloadButton.setTitleColor(.white, for: .normal)
            shareButton.setTitleColor(.black, for: .normal)
            shareButton.setImage(UIImage(named: "share")?.transform(withNewColor: .black), for: .normal)
            self.takeScreenshot()

        }
        else if sender.tag == Button.done.rawValue{
           doneButton.backgroundColor = .purple
            doneButton.setImage(UIImage(named: "done")?.transform(withNewColor: .white), for: .normal)
            doneButton.setTitleColor(.white, for: .normal)
            router?.backToPaymentServices()
        } else {
            print("")
        }
    }
    
    @objc func termsAndConditionTapped() {
        let vc = BlogsViewController.instantiateFromAppStroyboard(appStoryboard: .main)
        vc.urlStr = TERMS_CONDITIONS
        vc.titleStr = "Terms & Conditions"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    open func takeScreenshot(_ shouldSave: Bool = true) -> UIImage? {
        print("takeScreenshot")
        var screenshotImage :UIImage?
        let layer = UIApplication.shared.keyWindow!.layer
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, scale);
        guard let context = UIGraphicsGetCurrentContext() else {return nil}
        layer.render(in:context)
        screenshotImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        if let image = screenshotImage, shouldSave {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        }
        return screenshotImage
    }
    
    func setupConstraint() {
        headerView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        headerView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        topImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        topImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        topImage.topAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
        topImage.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2).isActive = true
        
        containerView.topAnchor.constraint(equalTo: topImage.bottomAnchor).isActive = true
        containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: shareButton.bottomAnchor, constant: -1).isActive = true
        
        shareButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 1).isActive = true
        shareButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 1).isActive = true
        shareButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.35).isActive = true
        shareButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.11).isActive = true
        
        downloadButton.leadingAnchor.constraint(equalTo: shareButton.trailingAnchor, constant: 0).isActive = true
        downloadButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 1).isActive = true
        downloadButton.widthAnchor.constraint(equalTo: shareButton.widthAnchor).isActive = true
        downloadButton.heightAnchor.constraint(equalTo: shareButton.heightAnchor).isActive = true
        
        doneButton.leadingAnchor.constraint(equalTo: downloadButton.trailingAnchor, constant: 0).isActive = true
        doneButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 1).isActive = true
        doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -1).isActive = true
        doneButton.heightAnchor.constraint(equalTo: downloadButton.heightAnchor).isActive = true
        
        scrollView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -2).isActive = true
      
        stackView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        stackView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        
        fromAccountView.heightAnchor.constraint(equalToConstant: 70).isActive = true
    }
}

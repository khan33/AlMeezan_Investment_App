//
//  PayemntSuccessView.swift
//  AlMeezan
//
//  Created by Muhammad, Atta on 19/10/2022.
//  Copyright © 2022 Atta khan. All rights reserved.
//

import Foundation

import UIKit

enum Button: Int {
    case share = 1
    case download = 2
    case done = 3
}

class PayemntSuccessView: UIViewController {
    
    
    private (set) lazy var headerView: PaymentHeaderView = { [unowned self] in
        let view = PaymentHeaderView.init(titleLbl: Headings.fundTransfer, closeAction: {
            self.navigationController?.popViewController(animated: true)
        }, nextAction: {
            print("next")
        }, previousAction: {
            self.navigationController?.popViewController(animated: true)
        })
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backBtn.isHidden = true
        return view
    }()
    
    private let topImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "Group 3710")
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

    var congoView = CongratulationView(titleLabl: "Congratulations", subLabel: "You have added the bill payee.")
    var fromAccountView = View(titleLabl: "From", subLabel: "", imageName: IconName.receiver)
    var toAcocuntView = View(titleLabl: "To", subLabel: "", imageName: IconName.sender)
    var amountView = View(titleLabl: "Amount", subLabel: "", imageName: IconName.payment)
    var dateView = View(titleLabl: "Date", subLabel: "", imageName: IconName.calendar)
    
    
    var accountFrom: String?
    var accountTo: String?
    var amount: String?
    
    
//    var router: BillTransactionCompleteRouterProtocol?
//    var billTransfer: [BillTransferEntity.BillTransferResponse]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //router?.navigationController = navigationController
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
        //print("Response of BillList \(self.billTransfer)")
        configureDateLabel()
        
        
        let dateStr = Date().toString(format: "d MMM yyyy")
        dateView.subLbl.text = dateStr
        fromAccountView.subLbl.text = accountFrom ?? ""
        amountView.subLbl.text =  "PKR. \(amount ?? "")"
        toAcocuntView.subLbl.text = accountTo ?? ""
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
            self.shareScreenShot()
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
//            router?.backToPaymentServices()
        } else {
            print("")
        }
        
    }
    
    private func shareScreenShot() {
        let bounds = UIScreen.main.bounds
         UIGraphicsBeginImageContextWithOptions(bounds.size, true, 0.0)
         self.view.drawHierarchy(in: bounds, afterScreenUpdates: false)
         let img = UIGraphicsGetImageFromCurrentImageContext()
         UIGraphicsEndImageContext()
         let activityViewController = UIActivityViewController(activityItems: [img!], applicationActivities: nil)
         self.present(activityViewController, animated: true, completion: nil)
    }
    
    private func takeScreenshot(_ shouldSave: Bool = true) -> UIImage? {
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
        
        self.showAlert(title: "Screenshot Taken!", message: "Your screenshot is saved in Gallery", controller: self) {
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
        topImage.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.25).isActive = true
        
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

class CongratulationView: UIView {
    
    public let inner: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var titleLbl: UILabel = { [unowned self] in
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = UIColor.black
        label.font = UIFont(name: AppFontName.robotoRegular, size: 18)
        label.clipsToBounds = true
        return label
    }()
    
     lazy var subLbl: UILabel = { [unowned self] in
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = UIColor.black
        label.font = UIFont(name: AppFontName.circularStdRegular, size: 14)
        label.clipsToBounds = true
        return label
    }()
    
    init(titleLabl: String, subLabel: String) {
        super.init(frame: CGRect.zero)
        self.backgroundColor = .white
        self.titleLbl.text = titleLabl
        self.subLbl.text = subLabel
        setupConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setValues(subLabel: String) {
        subLbl.text = subLabel
    }
    
    
    func setupConstraint() {
        
        self.addSubview(inner)
        inner.addSubview(titleLbl)
        inner.addSubview(subLbl)
        
        self.inner.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.inner.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.inner.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        self.inner.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        self.titleLbl.centerXAnchor.constraint(equalTo: inner.centerXAnchor, constant: 0).isActive = true
        self.titleLbl.topAnchor.constraint(equalTo: self.inner.topAnchor, constant: 10).isActive = true
        
        self.subLbl.topAnchor.constraint(equalTo: self.titleLbl.bottomAnchor, constant: 2).isActive = true
        self.subLbl.leadingAnchor.constraint(equalTo: self.titleLbl.leadingAnchor).isActive = true
        self.subLbl.trailingAnchor.constraint(equalTo: self.titleLbl.trailingAnchor).isActive = true
        
        
    }
    
}

class View: UIView {
    
    public let inner: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    public var titleLbl: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = UIColor.black
        label.font = UIFont(name: AppFontName.robotoRegular, size: 12)
        label.clipsToBounds = true
        return label
    }()
    
    public let subLbl: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = UIColor.black
        label.font = UIFont(name: AppFontName.circularStdRegular, size: 14)
        label.clipsToBounds = true
        return label
    }()
    
    public var Image: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    init(titleLabl: String, subLabel: String, imageName: String) {
        super.init(frame: CGRect.zero)
        self.backgroundColor = .white
        self.titleLbl.text = titleLabl
        self.subLbl.text = subLabel
        self.Image.image = UIImage(named: imageName)
        setupConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupConstraint() {
        
        self.addSubview(inner)
        inner.addSubview(titleLbl)
        inner.addSubview(subLbl)
        inner.addSubview(Image)
        
        self.inner.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.inner.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.inner.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        self.inner.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        self.Image.widthAnchor.constraint(equalToConstant: 25).isActive = true
        self.Image.heightAnchor.constraint(equalToConstant: 44).isActive = true
        self.Image.centerYAnchor.constraint(equalTo: self.inner.centerYAnchor).isActive = true
        self.Image.leadingAnchor.constraint(equalTo: self.inner.leadingAnchor, constant: 20).isActive = true
        
        self.titleLbl.topAnchor.constraint(equalTo: inner.topAnchor, constant: 15).isActive = true
        self.titleLbl.leftAnchor.constraint(equalTo: self.Image.rightAnchor, constant: 10).isActive = true
        
        self.subLbl.topAnchor.constraint(equalTo: self.titleLbl.bottomAnchor, constant: 2).isActive = true
        self.subLbl.leftAnchor.constraint(equalTo: self.Image.rightAnchor, constant: 10).isActive = true
        
    }
    
}

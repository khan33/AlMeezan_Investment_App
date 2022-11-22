//
//  PaymentHeaderView.swift
//  AlMeezan
//
//  Created by Atta khan on 12/09/2022.
//  Copyright © 2022 Atta khan. All rights reserved.
//

import Foundation
import UIKit

class PaymentHeaderView: UIView {
    
    private let headerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.clipsToBounds = true
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
    
    private let midLbl: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.white
        label.font = UIFont(name: AppFontName.circularStdRegular, size: 16)
        return label
    }()
    
    let backBtn: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.clipsToBounds = true
        btn.setImage(UIImage(named: IconName.backArrow)?.transform(withNewColor: .white), for: .normal)
        btn.tintColor = .white
        btn.addTarget(self, action: #selector(previousBtnPressed), for: .touchUpInside)
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
    
    
    private var closeBtnAction: (() -> Void)!
    private var nextBtnAction: (() -> Void)!
    private var previousBtnAction: (() -> Void)!
    
    init(titleLbl: String, closeAction: @escaping () -> Void, nextAction: @escaping () -> Void, previousAction: @escaping () -> Void) {
        super.init(frame: CGRect.zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.midLbl.text = titleLbl
        self.previousBtnAction = closeAction
        self.nextBtnAction = nextAction
        self.addSubview(headerView)
        headerView.addSubview(topbarImage)
        headerView.addSubview(midLbl)
        headerView.addSubview(backBtn)
        headerView.addSubview(notificationBtn)
        setupConstraints()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupConstraints() {
        
        self.headerView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.headerView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        self.headerView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        self.headerView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        self.topbarImage.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 0).isActive = true
        self.topbarImage.leftAnchor.constraint(equalTo: headerView.leftAnchor, constant: 0).isActive = true
        self.topbarImage.rightAnchor.constraint(equalTo: headerView.rightAnchor, constant: 0).isActive = true
        self.topbarImage.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 0).isActive = true
        
        self.backBtn.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 52).isActive = true
        self.backBtn.leftAnchor.constraint(equalTo: headerView.leftAnchor, constant: 15).isActive = true
        
        self.midLbl.centerXAnchor.constraint(equalTo: headerView.centerXAnchor, constant: 0).isActive = true
        self.midLbl.centerYAnchor.constraint(equalTo: headerView.centerYAnchor, constant: 10).isActive = true
        
        self.notificationBtn.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 52).isActive = true
        self.notificationBtn.rightAnchor.constraint(equalTo: headerView.rightAnchor, constant: -15).isActive = true
    }
    
    @objc private
    func previousBtnPressed() {
        self.previousBtnAction()
    }
    @objc private
    func nextBtnPressed() {
        self.nextBtnAction()
    }
    
}

//
//  DeclarationButton.swift
//  AlMeezan
//
//  Created by Atta khan on 29/12/2021.
//  Copyright © 2021 Atta khan. All rights reserved.
//

import Foundation

import UIKit
class DeclarationButton : UIView {
    private (set) lazy var containerView: UIView = {[unowned self] in
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.backgroundColor = UIColor.rgb(red: 244, green: 246, blue: 250, alpha: 1)
        view.layer.cornerRadius = 8
        return view
    }()
    
    private (set) lazy var lblHeading: UILabel = {[unowned self] in
        let lbl = UILabel()
        lbl.numberOfLines = 0
        lbl.textAlignment = .left
        lbl.textColor = UIColor.rgb(red: 71, green: 174, blue: 10, alpha: 1)
        lbl.font = UIFont(name: AppFontName.circularStdRegular, size: 14)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.clipsToBounds = true
        return lbl
    }()
    
    private (set) lazy var btnIcon: UIButton = { [unowned self] in
        var btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.clipsToBounds = true
        //btn.setImage(UIImage(named: "health"), for: .normal)
        return btn
    }()
    
    private (set) lazy var checkMarkBtn: UIButton = { [unowned self] in
        var btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.clipsToBounds = true
        btn.setImage(UIImage(named: ""), for: .normal)
        return btn
    }()
    
    private (set) lazy var btn: UIButton = { [unowned self] in
        var btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.clipsToBounds = true
        btn.addTarget(self, action: #selector(btnPressed), for: .touchUpInside)
        return btn
    }()
//    private (set) lazy var checkBtn: UIButton = { [unowned self] in
//        let btn = UIButton()
//        btn.translatesAutoresizingMaskIntoConstraints = false
//        btn.setImage(UIImage(named: "check_box_outline"), for: .normal)
//        btn.setImage(UIImage(named: "checked"), for: .selected)
//        btn.addTarget(self, action: #selector(didTapCheckboxBtn), for: .touchUpInside)
//        return btn
//    }()
    
    
    private var enterTextCloser: (() -> Void)!
    

    
    init(heading: String, headingColor: UIColor, image: String, checkMarkIcon: String, enterTextCloser: @escaping () -> Void) {
        super.init(frame: CGRect.zero)
        self.enterTextCloser = enterTextCloser
        setUpContainerView()
        lblHeading.text = heading
        lblHeading.textColor = headingColor
        checkMarkBtn.setImage(UIImage(named: checkMarkIcon), for: .normal)
        btnIcon.setImage(UIImage(named: image), for: .normal)
//        if heading == AppString.Heading.accountHolder{
//            checkBtn.isHidden = false
//            checkMarkBtn.isHidden = true
//            btn.isHidden = true
//        } else {
//            checkMarkBtn.isHidden = false
//            checkBtn.isHidden = true
//            btn.isHidden = false
//        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setUpContainerView() {
        if !containerView.isDescendant(of: self) {
            self.addSubview(containerView)
        }
        containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        containerView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 66).isActive = true
        
        if !btnIcon.isDescendant(of: containerView) {
            containerView.addSubview(btnIcon)
        }
        
        btnIcon.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16).isActive = true
        btnIcon.centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: 0).isActive = true
        btnIcon.widthAnchor.constraint(equalToConstant: 28).isActive = true
        btnIcon.heightAnchor.constraint(equalToConstant: 28).isActive = true
        
        
        if !lblHeading.isDescendant(of: containerView) {
            containerView.addSubview(lblHeading)
        }
        
        lblHeading.leadingAnchor.constraint(equalTo: btnIcon.trailingAnchor, constant: 12).isActive = true
        lblHeading.centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: 0).isActive = true
        
        
        
        if !checkMarkBtn.isDescendant(of: containerView) {
            containerView.addSubview(checkMarkBtn)
        }
        
        checkMarkBtn.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16).isActive = true
        checkMarkBtn.centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: 0).isActive = true
        
        
        
        
        
        if !btn.isDescendant(of: containerView) {
            containerView.addSubview(btn)
        }
        
        btn.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        btn.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        btn.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        btn.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        
//        if !checkBtn.isDescendant(of: containerView) {
//            containerView.addSubview(checkBtn)
//        }
//        checkBtn.centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: 0).isActive = true
//        checkBtn.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16).isActive = true
//        checkBtn.widthAnchor.constraint(equalToConstant: 24).isActive = true
//        checkBtn.heightAnchor.constraint(equalToConstant: 24).isActive = true

    }
    
    @objc private
    func btnPressed() {
        self.enterTextCloser()
    }
    @objc private func didTapCheckboxBtn(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        let tag = sender.isSelected
        self.enterTextCloser()
        
    }
    
}

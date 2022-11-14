//
//  FundRoundedView.swift
//  AlMeezan
//
//  Created by Atta khan on 24/11/2021.
//  Copyright © 2021 Atta khan. All rights reserved.
//

import UIKit

class FundRoundedView: UIView {
    
    private (set) lazy var containerView: UIView = { [unowned self] in
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.backgroundColor = .white
        view.roundCorners([.layerMinXMinYCorner,.layerMaxXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner], radius: 30, borderColor: UIColor.rgb(red: 35, green: 39, blue: 70, alpha: 1), borderWidth: 0.1)
        
        return view
    }()
    private (set) lazy var imgView: UIImageView = {
        let imgView = UIImageView()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.clipsToBounds = true
        imgView.image = UIImage(named: "fund_suggestion")
        imgView.contentMode = .scaleAspectFill
        return imgView
    }()
    
    private (set) lazy var accountTitle: UILabel = { [unowned self] in
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Mutual Funds CIS"
        label.textColor =  UIColor.init(rgb:0x000000)
        label.font = UIFont(name: AppFontName.circularStdRegular, size: 13)
        label.numberOfLines = 0
        return label
    }()
    
//    private (set) lazy var accountdesc: UILabel = { [unowned self] in
//        var label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.text = "Select Your Mutual Funds CIS"
//        label.textColor =  UIColor.init(rgb:0x232746)
//        label.font = UIFont(name: AppFontName.circularStdRegular, size: 12)
//        return label
//    }()
    
    private (set) lazy var arrowBtn: UIButton = { [unowned self] in
        var btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.clipsToBounds = true
        btn.setImage(UIImage(named: "chevronDown1"), for: .normal)
        btn.contentMode = .scaleAspectFill
        btn.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        return btn
    }()
    
    private (set) lazy var btn: UIButton = { [unowned self] in
        var btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.clipsToBounds = true
        btn.addTarget(self, action: #selector(btnPressed), for: .touchUpInside)
        return btn
    }()
    
    private var enterTextCloser: (() -> Void)!
    
    init(heading: String, desc: String, image: String, enterTextCloser: @escaping () -> Void) {
        super.init(frame: CGRect.zero)
        self.enterTextCloser = enterTextCloser
        
        setUpContainerView()
        imgView.image = UIImage(named: image)
        accountTitle.text = heading
        //accountdesc.text = desc
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

        if !arrowBtn.isDescendant(of: containerView) {
            containerView.addSubview(arrowBtn)
        }
        arrowBtn.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        arrowBtn.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16).isActive = true
        
        if !imgView.isDescendant(of: containerView) {
            containerView.addSubview(imgView)
        }
        imgView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16).isActive = true
        imgView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        
        
        if !accountTitle.isDescendant(of: containerView) {
            containerView.addSubview(accountTitle)
        }
        accountTitle.leadingAnchor.constraint(equalTo: imgView.trailingAnchor, constant: 16).isActive = true
        accountTitle.trailingAnchor.constraint(equalTo: arrowBtn.leadingAnchor, constant: 8).isActive = true
        accountTitle.centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: 0).isActive = true
//
//        if !accountdesc.isDescendant(of: containerView) {
//            containerView.addSubview(accountdesc)
//        }
//        accountdesc.leadingAnchor.constraint(equalTo: accountTitle.leadingAnchor).isActive = true
//        accountdesc.topAnchor.constraint(equalTo: accountTitle.bottomAnchor, constant: 16).isActive = true
        
        if !btn.isDescendant(of: containerView) {
            containerView.addSubview(btn)
        }
        btn.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        btn.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        btn.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        btn.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        
    }
     
    @objc private
    func btnPressed() {
        self.enterTextCloser()
    }
}


extension UIView {
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius

        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
      }
}

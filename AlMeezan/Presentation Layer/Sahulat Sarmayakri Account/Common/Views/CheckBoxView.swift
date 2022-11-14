//
//  CheckBoxView.swift
//  AlMeezan
//
//  Created by Atta khan on 24/11/2021.
//  Copyright © 2021 Atta khan. All rights reserved.
//

import Foundation
import UIKit
class CheckBoxView : UIView {
    private (set) lazy var containerView: UIView = {[unowned self] in
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.backgroundColor = .white
        return view
    }()
    
    private (set) lazy var lblHeading: UILabel = {[unowned self] in
        let lbl = UILabel()
        lbl.numberOfLines = 0
        lbl.textAlignment = .left
        lbl.textColor = UIColor.rgb(red: 35, green: 39, blue: 79, alpha: 1)
        lbl.font = UIFont(name: AppFontName.robotoRegular, size: 13)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.clipsToBounds = true
        return lbl
    }()
    
    private (set) lazy var bottomLine: UIView = { [unowned self] in
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.backgroundColor = .lightGray
        return view
    }()
    
    
    private (set) lazy var btnIcon: UIButton = { [unowned self] in
        var btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.clipsToBounds = true
        btn.setImage(UIImage(named: "checkbox"), for: .normal)//checkbox
        
        btn.setImage(UIImage(named : "checked"), for: .selected)

        btn.addTarget(self, action: #selector(btnPressed), for: .touchUpInside)
        return btn
    }()
    
    
    private var isSelectedCloser: ((_ isSelected: Bool) -> Void)!
    
    init(heading: String, image: String , isSelectedCloser: @escaping (_ select: Bool) -> Void) {
        super.init(frame: CGRect.zero)
        self.isSelectedCloser = isSelectedCloser
        setUpContainerView()
        lblHeading.text = heading
        btnIcon.setImage(UIImage(named: image), for: .normal)
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
        containerView.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        if !lblHeading.isDescendant(of: containerView) {
            containerView.addSubview(lblHeading)
        }
        
        lblHeading.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8).isActive = true
        lblHeading.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8).isActive = true
        lblHeading.centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: 0).isActive = true
        //lblHeading.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 0).isActive = true
        
        
        if !btnIcon.isDescendant(of: containerView) {
            containerView.addSubview(btnIcon)
        }
        btnIcon.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8).isActive = true
        btnIcon.centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: 0).isActive = true
        btnIcon.widthAnchor.constraint(equalToConstant: 24).isActive = true
        btnIcon.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        if !bottomLine.isDescendant(of: containerView) {
            containerView.addSubview(bottomLine)
        }
        bottomLine.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8).isActive = true
        bottomLine.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8).isActive = true
        bottomLine.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 0).isActive = true
        bottomLine.heightAnchor.constraint(equalToConstant: 1.0).isActive = true
        
    }
    
    @objc private
    func btnPressed() {
        btnIcon.isSelected = !btnIcon.isSelected
        let isSelected = btnIcon.isSelected
        
        self.isSelectedCloser(isSelected)
    }
}

//
//  TermsAndConditionView.swift
//  AlMeezan
//
//  Created by Atta khan on 18/01/2022.
//  Copyright © 2022 Atta khan. All rights reserved.
//

import Foundation
import UIKit
class TermsAndConditionView : UIView {
    private (set) lazy var containerView: UIView = {[unowned self] in
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.backgroundColor = .white
        return view
    }()
    
    private (set) lazy var checkBtn: UIButton = { [unowned self] in
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(UIImage(named: "check_box_outline"), for: .normal)
        btn.setImage(UIImage(named: "checked"), for: .selected)
        btn.addTarget(self, action: #selector(didTapCheckboxBtn), for: .touchUpInside)
        return btn
    }()
    
    private (set) lazy var termsAndConditionLbl: UILabel = {[unowned self] in
        let lbl = UILabel()
        lbl.numberOfLines = 0
        lbl.textAlignment = .justified
        lbl.textColor = UIColor.rgb(red: 91, green: 95, blue: 120, alpha: 1)
        lbl.font = UIFont(name: AppFontName.robotoRegular, size: 12)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.clipsToBounds = true
        return lbl
    }()
    
    
    
    private var selectedCheckboxCloser: ((_ isSelect: Bool) -> Void)!
    init(heading: String, selectedCheckboxCloser: @escaping (_ isSelect: Bool) -> Void) {
        super.init(frame: CGRect.zero)
        self.selectedCheckboxCloser = selectedCheckboxCloser
        termsAndConditionLbl.text = heading
        setUpContainerView()
        
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
//        containerView.heightAnchor.constraint(equalToConstant: 90).isActive = true
        
        if !checkBtn.isDescendant(of: containerView) {
            containerView.addSubview(checkBtn)
        }
        checkBtn.topAnchor.constraint(equalTo: self.containerView.topAnchor, constant: 8).isActive = true
        checkBtn.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: 8).isActive = true
        checkBtn.widthAnchor.constraint(equalToConstant: 24).isActive = true
        checkBtn.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        if !termsAndConditionLbl.isDescendant(of: containerView) {
            containerView.addSubview(termsAndConditionLbl)
        }
        
        termsAndConditionLbl.leadingAnchor.constraint(equalTo: checkBtn.trailingAnchor, constant: 8).isActive = true
        termsAndConditionLbl.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8).isActive = true
        termsAndConditionLbl.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8).isActive = true
        termsAndConditionLbl.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -8).isActive = true
//        termsAndConditionLbl.centerYAnchor.constraint(equalTo: checkBtn.centerYAnchor, constant: 0).isActive = true
        
    }
    
    @objc private func didTapCheckboxBtn(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        let tag = sender.isSelected
        selectedCheckboxCloser(tag)
        
    }

}

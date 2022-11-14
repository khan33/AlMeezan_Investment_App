//
//  ZakatExemption.swift
//  AlMeezan
//
//  Created by Atta khan on 23/01/2022.
//  Copyright © 2022 Atta khan. All rights reserved.
//

import Foundation
import UIKit

class ZakatExemption : UIView {
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
        lbl.textColor = UIColor.rgb(red: 35, green: 39, blue: 70, alpha: 1)
        lbl.font = UIFont(name: AppFontName.circularStdRegular, size: 14)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.clipsToBounds = true
        lbl.text = "Zakat Exemption"
        return lbl
    }()
    
    private (set) lazy var yesBtn: UIButton = { [unowned self] in
        var btn = UIButton()
        btn.tag = 1
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.clipsToBounds = true
        btn.setImage(UIImage(named: "radio_button_unchecked"), for: .normal)
        btn.setImage(UIImage(named: "radio_button_checked"), for: .selected)
        btn.addTarget(self, action: #selector(didTapOnOptionBtn), for: .touchUpInside)
        return btn
    }()
    private (set) lazy var yesLbl: UILabel = {[unowned self] in
        let lbl = UILabel()
        lbl.numberOfLines = 0
        lbl.textAlignment = .left
        lbl.textColor = UIColor.rgb(red: 35, green: 39, blue: 70, alpha: 1)
        lbl.font = UIFont(name: AppFontName.circularStdRegular, size: 12)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.clipsToBounds = true
        lbl.text = "Yes"
        return lbl
    }()
    
    private (set) lazy var affidavitLbl: UILabel = {[unowned self] in
        let lbl = UILabel()
        lbl.numberOfLines = 0
        lbl.textAlignment = .left
        lbl.textColor = UIColor.rgb(red: 185, green: 187, blue: 198, alpha: 1)
        lbl.font = UIFont(name: AppFontName.circularStdRegular, size: 9)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.clipsToBounds = true
        lbl.text = "(NDZ-Non-Deduction Affidavit of Zakat is required)"
        return lbl
    }()
    
    
    private (set) lazy var noBtn: UIButton = { [unowned self] in
        var btn = UIButton()
        btn.tag = 0
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.clipsToBounds = true
        btn.setImage(UIImage(named: "radio_button_unchecked"), for: .normal)
        btn.setImage(UIImage(named: "radio_button_checked"), for: .selected)
        btn.addTarget(self, action: #selector(didTapOnOptionBtn), for: .touchUpInside)
        
        return btn
    }()
    
    private (set) lazy var noLbl: UILabel = {[unowned self] in
        let lbl = UILabel()
        lbl.numberOfLines = 0
        lbl.textAlignment = .left
        lbl.textColor = UIColor.rgb(red: 35, green: 39, blue: 70, alpha: 1)
        lbl.font = UIFont(name: AppFontName.circularStdRegular, size: 12)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.clipsToBounds = true
        lbl.text = "No"
        return lbl
    }()
    
   
    
    
    private var enterTextCloser: ((_ value: String) -> Void)!
    

    
    init(heading: String, enterTextCloser: @escaping (_ value: String) -> Void) {
        super.init(frame: CGRect.zero)
        self.enterTextCloser = enterTextCloser
        //noBtn.isSelected = true
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
        containerView.heightAnchor.constraint(equalToConstant: 130).isActive = true
        
        
        if !lblHeading.isDescendant(of: containerView) {
            containerView.addSubview(lblHeading)
        }
        lblHeading.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12).isActive = true
        lblHeading.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12).isActive = true
        
        
        
        if !yesBtn.isDescendant(of: containerView) {
            containerView.addSubview(yesBtn)
        }
        
        yesBtn.topAnchor.constraint(equalTo: lblHeading.topAnchor, constant: 30).isActive = true
        yesBtn.leadingAnchor.constraint(equalTo: lblHeading.leadingAnchor, constant: 0).isActive = true
        
        if !yesLbl.isDescendant(of: containerView) {
            containerView.addSubview(yesLbl)
        }
        
        yesLbl.centerYAnchor.constraint(equalTo: yesBtn.centerYAnchor, constant: -2).isActive = true
        yesLbl.leadingAnchor.constraint(equalTo: yesBtn.trailingAnchor, constant: 10).isActive = true
        
        
        if !affidavitLbl.isDescendant(of: containerView) {
            containerView.addSubview(affidavitLbl)
        }


        affidavitLbl.topAnchor.constraint(equalTo: yesBtn.topAnchor, constant: 20).isActive = true
        affidavitLbl.leadingAnchor.constraint(equalTo: lblHeading.leadingAnchor, constant: 0).isActive = true

        if !noBtn.isDescendant(of: containerView) {
            containerView.addSubview(noBtn)
        }

        noBtn.topAnchor.constraint(equalTo: affidavitLbl.topAnchor, constant: 20).isActive = true
        noBtn.leadingAnchor.constraint(equalTo: lblHeading.leadingAnchor, constant: 0).isActive = true

        if !noLbl.isDescendant(of: containerView) {
            containerView.addSubview(noLbl)
        }
        
        noLbl.centerYAnchor.constraint(equalTo: noBtn.centerYAnchor, constant: -2).isActive = true
        noLbl.leadingAnchor.constraint(equalTo: noBtn.trailingAnchor, constant: 10).isActive = true
        

    }
    
    @objc func didTapOnOptionBtn(_ sender: UIButton) {
        var value = "N"
        if sender.tag == 0 {
            noBtn.isSelected = true
            yesBtn.isSelected = false
            value = "N"
        } else {
            noBtn.isSelected = false
            yesBtn.isSelected = true
            value = "Y"
        }
        self.enterTextCloser(value)
    }
}

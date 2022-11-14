//
//  ReasonView.swift
//  AlMeezan
//
//  Created by Atta khan on 18/01/2022.
//  Copyright © 2022 Atta khan. All rights reserved.
//

import Foundation
import UIKit
class ReasonView : UIView {
    private (set) lazy var containerView: UIView = {[unowned self] in
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.backgroundColor = UIColor.rgb(red: 79, green: 90, blue: 101, alpha: 0.1)
        return view
    }()
    
    private (set) lazy var lblHeading: UILabel = {[unowned self] in
        let lbl = UILabel()
        lbl.textColor = UIColor.rgb(red: 35, green: 39, blue: 70, alpha: 1)
        lbl.font = AppFonts.txtFieldLblFont
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.clipsToBounds = true
        lbl.text = "Reason A"
        return lbl
    }()
    
    private (set) lazy var resaonDesc: UILabel = { [unowned self] in
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.clipsToBounds = true
        label.textColor =  UIColor.rgb(red: 35, green: 39, blue: 70, alpha: 1)
        label.font = UIFont(name: AppFontName.robotoRegular, size: 13)
        label.numberOfLines = 0
        label.text = "The country/jurisdiction where the account holder is resident doesn’t issue TIN to its residents"
        return label
    }()
    
    private (set) lazy var checkBtn: UIButton = { [unowned self] in
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(UIImage(named: "radio_button_unchecked"), for: .normal)
        btn.setImage(UIImage(named: "radio_button_checked"), for: .selected)
        btn.addTarget(self, action: #selector(didTapCheckboxBtn), for: .touchUpInside)
        return btn
    }()
    
    private var checkSelectedCloser: ((_ isSelected: Bool) -> Void)!
    var heading: String = ""
    init(heading: String, desc: String, checkSelectedCloser: @escaping (_ selected: Bool) -> Void) {
        super.init(frame: CGRect.zero)
        self.checkSelectedCloser = checkSelectedCloser
        setUpContainerView()
        lblHeading.text = heading
        resaonDesc.text = desc
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
        containerView.heightAnchor.constraint(equalToConstant: 110).isActive = true
        
//        if !checkBtn.isDescendant(of: containerView) {
//            containerView.addSubview(checkBtn)
//        }
//        checkBtn.topAnchor.constraint(equalTo: self.containerView.topAnchor, constant: 16).isActive = true
//        checkBtn.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: 16).isActive = true
        
        if !lblHeading.isDescendant(of: containerView) {
            containerView.addSubview(lblHeading)
        }
        lblHeading.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8).isActive = true
        lblHeading.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16).isActive = true

        if !resaonDesc.isDescendant(of: containerView) {
            containerView.addSubview(resaonDesc)
        }
        resaonDesc.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8).isActive = true
        resaonDesc.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8).isActive = true
        resaonDesc.topAnchor.constraint(equalTo: lblHeading.bottomAnchor, constant: 8).isActive = true
    }
    
    
    @objc func didTapCheckboxBtn(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        checkSelectedCloser(sender.isSelected)
    }
    
    
}

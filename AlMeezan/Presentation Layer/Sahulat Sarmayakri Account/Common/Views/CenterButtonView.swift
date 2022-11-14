//
//  CenterButtonView.swift
//  AlMeezan
//
//  Created by Atta khan on 16/11/2021.
//  Copyright © 2021 Atta khan. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class CenterButtonView : UIView {
    private (set) lazy var containerView: UIView = {[unowned self] in
        let view = UIView()
        view.clipsToBounds = true
        view.backgroundColor = .white
        return view
    }()
    
    private (set) lazy var centerBtn: UIButton = {[unowned self] in
        let view = UIButton()
        view.clipsToBounds = true
        view.backgroundColor = .themeColor
        view.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        view.setTitleColor(.white, for: UIControl.State.init())
        view.cornerReduis(reduis: 20, BGColor: .themeColor, borderColor: .clear, borderWidth: 0)
        view.addTarget(self, action: #selector(btnPressed), for: .touchUpInside)
        return view
    }()
    
    private var btnAction: ((_ clicked: Bool) -> Void)!
    
    init(title: String, action: @escaping (_ clicked: Bool) -> Void) {
        super.init(frame: CGRect.zero)
        centerBtn.setTitle(title, for: UIControl.State.init())
        btnAction = action
        setUpContainerView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        
    }
    
    func setUpContainerView() {
        if !containerView.isDescendant(of: self) {
            self.addSubview(containerView)
        }
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        if !centerBtn.isDescendant(of: containerView) {
            containerView.addSubview(centerBtn)
        }
        centerBtn.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(8)
            make.top.equalToSuperview().offset(15)
            make.bottom.equalToSuperview()
            make.height.equalTo(40)
        }
    }
    
    @objc private
    func btnPressed() {
        self.btnAction(true)
    }
    
    func hideLoading() {
    }
}

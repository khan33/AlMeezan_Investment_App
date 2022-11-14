//
//  SurveyAnswerCell.swift
//  AlMeezan
//
//  Created by Atta khan on 10/05/2022.
//  Copyright © 2022 Atta khan. All rights reserved.
//

import UIKit

class SurveyAnswerCell: UICollectionViewCell {
    private (set) lazy var containerView: UIView = {[unowned self] in
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.backgroundColor = .white
        //view.cornerReduis(reduis: 5, BGColor: .white, borderColor: .clear, borderWidth: 1)
        return view
    }()
    private (set) lazy var yesRadioBtn: UIButton = { [unowned self] in
        let btn = UIButton()
        btn.tag = 1
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(UIImage(named: "radio_button_unchecked"), for: .normal)
        btn.setImage(UIImage(named: "radio_button_checked"), for: .selected)
       // btn.addTarget(self, action: #selector(didTapOnOptionBtn), for: .touchUpInside)
        return btn
    }()
    
    private (set) lazy var yesLbl: UILabel = { [unowned self] in
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.textColor =  UIColor.init(rgb:0x232746)
        label.font = UIFont(name: AppFontName.robotoRegular, size: 12)
        label.numberOfLines = 1
        return label
    }()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        loadUIView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func loadUIView() {
        if !containerView.isDescendant(of: contentView) {
            contentView.addSubview(containerView)
        }
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        if !yesRadioBtn.isDescendant(of: containerView) {
            containerView.addSubview(yesRadioBtn)
        }
        
        yesRadioBtn.snp.makeConstraints { make in
            make.centerY.equalTo(containerView)
            make.leading.equalTo(containerView.snp.leading).offset(8)
        }
        
        if !yesLbl.isDescendant(of: containerView) {
            containerView.addSubview(yesLbl)
        }
        
        yesLbl.snp.makeConstraints { make in
            make.centerY.equalTo(containerView)
            make.leading.equalTo(yesRadioBtn.snp.trailing).offset(8)
            make.bottom.equalToSuperview()
        }

    }
}

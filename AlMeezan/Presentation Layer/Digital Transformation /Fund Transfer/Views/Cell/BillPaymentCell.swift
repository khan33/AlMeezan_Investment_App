//
//  BillPaymentCell.swift
//  AlMeezan
//
//  Created by Atta khan on 14/09/2022.
//  Copyright © 2022 Atta khan. All rights reserved.
//

import Foundation
import UIKit

class BillPaymentCell: UITableViewCell {
    
    static var identifier: String{
        return String(describing: self)
    }
    
    private (set) lazy var containerView: UIView = { [unowned self] in
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.borderColor = UIColor.newGray.cgColor
        view.layer.borderWidth = 0.5
        view.layer.cornerRadius = 8
        view.layer.shadowColor = UIColor.gray2.cgColor
        view.layer.shadowOpacity = 0.32
        view.layer.shadowRadius = 1.0
        view.layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
        view.clipsToBounds = true
        return view
    }()
    
    public var image: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    public var portfolioLbl: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor().hexStringToUIColor(hex: "#232746")
        label.font = UIFont(name: AppFontName.robotoRegular, size: 14)
        return label
    }()
    
    public var  balanceLbl: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor().hexStringToUIColor(hex: "#5B5F78")
        label.font = UIFont(name: AppFontName.robotoMedium, size: 10)
        return label
    }()
    
    public var chevronImage: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.setTitle("", for: .normal)
        view.setImage(UIImage(named: IconName.info), for: .normal)
        return view
    }()
    
    
//    public var chevronImage: UIImageView = {
//        let view = UIImageView()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.clipsToBounds = true
//        view.image = UIImage(named: IconName.info)
//        view.contentMode = .scaleAspectFit
//        return view
//    }()
   
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = UIColor.gray2
        contentView.addSubview(containerView)
        containerView.addSubview(image)
        containerView.addSubview(portfolioLbl)
        containerView.addSubview(balanceLbl)
        containerView.addSubview(chevronImage)
    }
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupConstraints()
    }
    
    func setupConstraints() {
        
        NSLayoutConstraint.activate([
            
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            
            image.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            image.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            image.widthAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 0.5),
            image.heightAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.45),
            
            portfolioLbl.centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: -10),
            portfolioLbl.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 10),
            
            balanceLbl.topAnchor.constraint(equalTo: portfolioLbl.bottomAnchor, constant: 5),
            balanceLbl.leadingAnchor.constraint(equalTo: portfolioLbl.leadingAnchor),
            balanceLbl.trailingAnchor.constraint(equalTo: portfolioLbl.trailingAnchor),
            
            chevronImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            chevronImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            chevronImage.heightAnchor.constraint(equalToConstant: 16),
            chevronImage.widthAnchor.constraint(equalToConstant: 16),
        ])
    }

}

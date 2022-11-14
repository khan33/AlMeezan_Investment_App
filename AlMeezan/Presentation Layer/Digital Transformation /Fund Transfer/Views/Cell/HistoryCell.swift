//
//  HistoryCell.swift
//  AlMeezan
//
//  Created by Atta khan on 14/09/2022.
//  Copyright © 2022 Atta khan. All rights reserved.
//

import Foundation
import UIKit

class HistoryCell: UITableViewCell {
    
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
        view.image = UIImage(named: "sendrecImage")
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    public var accountDetailLbl: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor().hexStringToUIColor(hex: "#232746")
        label.font = UIFont(name: AppFontName.circularStdBold, size: 12)
        label.text = "IABT 18/12/2022 565656....."
        return label
    }()
    
    public var bankNameLbl: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.subHeadingColor
        label.font = UIFont(name: AppFontName.robotoRegular, size: 10)
        label.text = "Almeezan Bank"
        return label
    }()
    
    public var amountPKRLbl: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.subHeadingColor
        label.text = "PKR"
        label.font = UIFont(name: AppFontName.circularStdBold, size: 14)
        return label
    }()
    
    public var amountLbl: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor().hexStringToUIColor(hex: "#232746")
        label.text = "6000.0"
        label.font = UIFont(name: AppFontName.circularStdBold, size: 14)
        return label
    }()
    
    public var chevronImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.image = UIImage(named: IconName.chevron_down)
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
       
    }
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupConstraints()
    }
    
    func setupConstraints() {
        contentView.backgroundColor = .gray2
        contentView.addSubview(containerView)
        
        contentView.addSubview(image)
        contentView.addSubview(accountDetailLbl)
        contentView.addSubview(bankNameLbl)
        contentView.addSubview(chevronImage)
        contentView.addSubview(amountPKRLbl)
        contentView.addSubview(amountLbl)
        
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            containerView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -8),
            
            
            image.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            image.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            
            accountDetailLbl.centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: -10),
            accountDetailLbl.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 10),

            bankNameLbl.topAnchor.constraint(equalTo: accountDetailLbl.bottomAnchor, constant: 8),
            bankNameLbl.leadingAnchor.constraint(equalTo: accountDetailLbl.leadingAnchor),
            bankNameLbl.trailingAnchor.constraint(equalTo: accountDetailLbl.trailingAnchor),
            
            
            
            amountLbl.centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: -10),
            amountLbl.trailingAnchor.constraint(equalTo: chevronImage.leadingAnchor, constant: -16),
            amountPKRLbl.trailingAnchor.constraint(equalTo: amountLbl.leadingAnchor, constant: -4),
            amountPKRLbl.centerYAnchor.constraint(equalTo: amountLbl.centerYAnchor),
    
            chevronImage.centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: 0),
            chevronImage.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            chevronImage.heightAnchor.constraint(equalToConstant: 12),
        ])
    }
    
}
class DateHeaderCell: UITableViewHeaderFooterView {
    
    private (set) lazy var dateLbl: UILabel = { [unowned self] in
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "abcd"
        label.textColor =  UIColor().hexStringToUIColor(hex: "#4F5A6599")
        label.font = UIFont(name: AppFontName.robotoRegular, size: 13)
        return label
    }()
    
    
    static var identifier: String{
        return String(describing: self)
    }
   
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configureContents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureContents() {
        contentView.addSubview(dateLbl)
        contentView.backgroundColor = .clear
        
        NSLayoutConstraint.activate([
            dateLbl.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16),
            dateLbl.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor)
        ])
    }
    
}

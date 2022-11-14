//
//  UploadView.swift
//  AlMeezan
//
//  Created by Atta khan on 30/01/2022.
//  Copyright © 2022 Atta khan. All rights reserved.
//

import UIKit

class UploadView: UIView {
    private (set) lazy var containerView: UIView = {[unowned self] in
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.backgroundColor = .white
        return view
    }()
    
    private (set) lazy var contentView: UIView = {[unowned self] in
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.cornerReduis(reduis: 8, BGColor: .white, borderColor: UIColor.rgb(red: 236, green: 240, blue: 249, alpha: 1), borderWidth: 1)
        return view
    }()
    
    
    private (set) lazy var closeBtn: UIButton = {[unowned self] in
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.setImage(UIImage(named: "Group 3519"), for: .normal)
        view.addTarget(self, action: #selector(bntAction), for: .touchUpInside)
        return view
    }()
    
    private (set) lazy var uploadImageView: UIImageView = {[unowned self] in
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.clipsToBounds = true
        img.contentMode = .scaleAspectFit
        return img
    }()
    private var btnAction: ((_ clicked: Bool) -> Void)!
    init(image: String, upload: @escaping (_ clicked: Bool) -> Void) {
        super.init(frame: CGRect.zero)
        //uploadImageView.image = UIImage(named: image)
        closeBtn.isHidden = true
        self.btnAction = upload
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
        containerView.heightAnchor.constraint(equalToConstant: 88.0).isActive = true
        
        if !contentView.isDescendant(of: containerView) {
            containerView.addSubview(contentView)
        }
        contentView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 4).isActive = true
        contentView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 4).isActive = true
        contentView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -4).isActive = true
        contentView.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.5).isActive = true
        
        
        
        
        if !uploadImageView.isDescendant(of: contentView) {
            contentView.addSubview(uploadImageView)
        }
        uploadImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        uploadImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        uploadImageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        uploadImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
        
        if !closeBtn.isDescendant(of: contentView) {
            contentView.addSubview(closeBtn)
        }
        closeBtn.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4).isActive = true
        closeBtn.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0).isActive = true
        
        
    }
        
    @objc fileprivate func bntAction() {
        self.btnAction(true)
    }
    

}

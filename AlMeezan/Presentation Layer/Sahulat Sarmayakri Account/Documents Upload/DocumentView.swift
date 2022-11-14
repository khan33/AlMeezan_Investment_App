//
//  DocumentView.swift
//  AlMeezan
//
//  Created by Atta khan on 30/01/2022.
//  Copyright © 2022 Atta khan. All rights reserved.
//

import UIKit

class DocumentView: UIView {
    private (set) lazy var containerView: UIView = {[unowned self] in
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.backgroundColor = UIColor.rgb(red: 246, green: 244, blue: 250, alpha: 1)
        return view
    }()
    
    private (set) lazy var lblHeading: UILabel = {[unowned self] in
        let lbl = UILabel()
        lbl.numberOfLines = 0
        lbl.textAlignment = .left
        lbl.textColor = UIColor.rgb(red: 0, green: 0, blue: 0, alpha: 1)
        lbl.font = UIFont(name: AppFontName.circularStdRegular, size: 16)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.clipsToBounds = true
        return lbl
    }()
    
    private (set) lazy var documentImgView: UIImageView = {[unowned self] in
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.clipsToBounds = true
        img.contentMode = .scaleAspectFit
        img.image = UIImage(named: "Group 2586")
        return img
    }()
    
    private (set) lazy var uploadImageView: UIButton = {[unowned self] in
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.clipsToBounds = true
        btn.setImage(UIImage(named: "upload"), for: .normal)
        btn.addTarget(self, action: #selector(didTapOnUploadBtn), for: .touchUpInside)
        return btn
    }()
    
    private (set) lazy var lblValue: UILabel = {[unowned self] in
        let lbl = UILabel()
        lbl.numberOfLines = 0
        lbl.textAlignment = .left
        lbl.textColor = UIColor.rgb(red: 138, green: 38, blue: 155, alpha: 1)
        lbl.font = UIFont(name: AppFontName.robotoRegular, size: 12)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.clipsToBounds = true
        return lbl
    }()
    
    
    private var btnAction: ((_ clicked: Bool) -> Void)!
    init(title: String, image: String, upload: @escaping (_ clicked: Bool) -> Void) {
        super.init(frame: CGRect.zero)
        lblHeading.text = title
        documentImgView.image = UIImage(named: image)
        self.btnAction = upload
        setUpContainerView()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @objc private
    func didTapOnUploadBtn() {
        self.btnAction(true)
    }
    
    func setUpContainerView() {
        if !containerView.isDescendant(of: self) {
            self.addSubview(containerView)
        }
        containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        containerView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 66.0).isActive = true
        containerView.layer.cornerRadius = 12
        
        
        if !documentImgView.isDescendant(of: containerView) {
            containerView.addSubview(documentImgView)
        }
        
        documentImgView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16).isActive = true
        documentImgView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: 0).isActive = true
        documentImgView.widthAnchor.constraint(equalToConstant: 36).isActive = true
        documentImgView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        if !uploadImageView.isDescendant(of: containerView) {
            containerView.addSubview(uploadImageView)
        }
        
        uploadImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16).isActive = true
        uploadImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: 0).isActive = true
       
        if !lblHeading.isDescendant(of: containerView) {
            containerView.addSubview(lblHeading)
        }
        
        lblHeading.leadingAnchor.constraint(equalTo: documentImgView.trailingAnchor, constant: 16).isActive = true
        lblHeading.trailingAnchor.constraint(equalTo: uploadImageView.leadingAnchor, constant: 16).isActive = true
        lblHeading.centerYAnchor.constraint(equalTo: documentImgView.centerYAnchor, constant: 0).isActive = true
        
        

    }

}

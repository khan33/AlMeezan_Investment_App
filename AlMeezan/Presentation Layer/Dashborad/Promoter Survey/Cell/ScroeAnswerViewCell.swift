//
//  ScroeAnswerViewCell.swift
//  AlMeezan
//
//  Created by Atta khan on 16/05/2022.
//  Copyright © 2022 Atta khan. All rights reserved.
//

import UIKit

class ScroeAnswerViewCell: UICollectionViewCell {
    private (set) lazy var containerView: UIView = {[unowned self] in
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.backgroundColor = .white
        //view.cornerReduis(reduis: 5, BGColor: .white, borderColor: .clear, borderWidth: 1)
        return view
    }()
    private var flowLayout: UICollectionViewFlowLayout = {
        let flow = UICollectionViewFlowLayout()
        flow.scrollDirection = .vertical
        flow.estimatedItemSize = CGSize.zero
        flow.minimumInteritemSpacing = 0
        flow.minimumLineSpacing = 0
        return flow
    }()
    
    private (set) lazy var collectionView:UICollectionView = { [unowned self] in
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isScrollEnabled = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(QuestionAnswerViewCell.self, forCellWithReuseIdentifier: "QuestionAnswerViewCell")
        return collectionView;
    }()
    lazy var width: NSLayoutConstraint = {
        let width = contentView.widthAnchor.constraint(equalToConstant: bounds.size.width)
        width.isActive = true
        return width
    }()
    
    weak var delegate: UpdateQuestionAnswer?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        collectionView.reloadData()
    }
    var question: [Questions]? {
        didSet {
            guard let data = question else { return }
            loadUIView()
            collectionView.reloadData()
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        width.constant = bounds.size.width
        return contentView.systemLayoutSizeFitting(CGSize(width: targetSize.width, height: 1))
    }
    
    private func loadUIView() {
        if !containerView.isDescendant(of: contentView) {
            contentView.addSubview(containerView)
        }
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        if !collectionView.isDescendant(of: containerView) {
            containerView.addSubview(collectionView)
        }
        let count = question?.count ?? 0
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo((count * 55) + 44)
        }
        
    }
}

extension ScroeAnswerViewCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return question?.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(with: QuestionAnswerViewCell.self, for: indexPath)
        cell.question = question?[indexPath.row]
        cell.delegate = self
        cell.indexRow = indexPath.row
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 55)
    }
}

extension ScroeAnswerViewCell: UpdateQuestionAnswer {
    func updateAnswer(_ answer: String, id: Int) {
        delegate?.updateAnswer(answer, id: id + 2)
    }
    
    
}



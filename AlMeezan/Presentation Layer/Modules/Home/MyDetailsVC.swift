//
//  MyDetailsVC.swift
//  AlMeezan
//
//  Created by Atta khan on 04/11/2019.
//  Copyright © 2019 Atta khan. All rights reserved.
//

import UIKit
import SVProgressHUD

class MyDetailsVC: UIViewController {
    @IBOutlet weak var pageController: UIPageControl!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var portfolioLbl: UILabel!
    
    var customer_details: [CustomerDetail]?
    private var indexOfCellBeforeDragging = 0
    var selectedPortfolioID: Int = 0
    var portfolioid_list: [CustomerInvestment]?
    var selectedPortfolioId: Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideNavigationBar()
    }
    
    private func setUpCollectionView() {
        collectionView.register(UINib(nibName: "PortfolioViewCell", bundle: nil), forCellWithReuseIdentifier: "PortfolioViewCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.reloadData()
    }
    
    func getData() {
        let bodyParam = RequestBody()
        let bodyRequest = bodyParam.encryptData(bodyParam)
        let url = URL(string: CUSTOMER_DETAILS)!
        SVProgressHUD.show()
        
        WebServiceManager.sharedInstance.fetch(params: bodyRequest as Dictionary<String, AnyObject>, url: url, serviceType: "Nav Fund", modelType: CustomerDetail.self, errorMessage: { (errorMessage) in
            errorResponse = errorMessage
            self.showErrorMsg(errorMessage)
        }, success: { (response) in
            self.customer_details = response
            self.setUpCollectionView()
        }, fail: { (error) in
            print(error.localizedDescription)
        }, showHUD: true)

    }
    
    @IBAction func tapOnPortfolioBtn(_ sender: Any) {
        let vc = UIViewController()
        vc.preferredContentSize = CGSize(width: 250,height: 200)
        let pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: 250, height: 200))
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.selectRow(selectedPortfolioId, inComponent:0, animated:true)
        vc.view.addSubview(pickerView)
        let editRadiusAlert = UIAlertController(title: title, message: "", preferredStyle: UIAlertController.Style.alert)
        editRadiusAlert.setValue(vc, forKey: "contentViewController")
        editRadiusAlert.addAction(UIAlertAction(title: "Done", style: .default, handler: { (alert: UIAlertAction!) in
            self.portfolioLbl.text = self.portfolioid_list?[self.selectedPortfolioId].portfolioID
        }))
        self.present(editRadiusAlert, animated: true)
    }
    
    
}
extension MyDetailsVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        let pageWidth = self.view.bounds.width
        let proportionalOffset = collectionView.contentOffset.x / pageWidth
        indexOfCellBeforeDragging = Int(round(proportionalOffset))
    }
    
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        // Stop scrolling
        targetContentOffset.pointee = scrollView.contentOffset
        
        // Calculate conditions
        let pageWidth = self.view.bounds.width
        let collectionViewItemCount = customer_details?.count ?? 0
        let proportionalOffset = collectionView.contentOffset.x / pageWidth
        let indexOfMajorCell = Int(round(proportionalOffset))
        let swipeVelocityThreshold: CGFloat = 0.5
        let hasEnoughVelocityToSlideToTheNextCell = indexOfCellBeforeDragging + 1 < collectionViewItemCount && velocity.x > swipeVelocityThreshold
        let hasEnoughVelocityToSlideToThePreviousCell = indexOfCellBeforeDragging - 1 >= 0 && velocity.x < -swipeVelocityThreshold
        let majorCellIsTheCellBeforeDragging = indexOfMajorCell == indexOfCellBeforeDragging
        let didUseSwipeToSkipCell = majorCellIsTheCellBeforeDragging && (hasEnoughVelocityToSlideToTheNextCell || hasEnoughVelocityToSlideToThePreviousCell)
        
        if didUseSwipeToSkipCell {
            // Animate so that swipe is just continued
            let snapToIndex = indexOfCellBeforeDragging + (hasEnoughVelocityToSlideToTheNextCell ? 1 : -1)
            let toValue = pageWidth * CGFloat(snapToIndex)
            UIView.animate(
                withDuration: 0.3,
                delay: 0,
                usingSpringWithDamping: 1,
                initialSpringVelocity: velocity.x,
                options: .allowUserInteraction,
                animations: {
                    scrollView.contentOffset = CGPoint(x: toValue, y: 0)
                    scrollView.layoutIfNeeded()
            },
                completion: nil
            )
        } else {
            // Pop back (against velocity)
            let indexPath = IndexPath(row: indexOfMajorCell, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .left, animated: true)
        }
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return customer_details?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PortfolioViewCell", for: indexPath) as! PortfolioViewCell
        cell.pageController.currentPage = indexPath.item
        cell.pageController.numberOfPages = customer_details?.count ?? 0
        cell.customer = customer_details?[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.size.width, height: collectionView.frame.size.height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
}
extension MyDetailsVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return portfolioid_list?.count ?? 0
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
       return portfolioid_list?[row].portfolioID
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        portfolioLbl.text = portfolioid_list?[row].portfolioID
        selectedPortfolioId = row
    }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var title = UILabel()
        if let titleLbl = view {
            title = titleLbl as! UILabel
        }
        title.font = UIFont(name: "Roboto-Regular", size: 15)
        title.text =  portfolioid_list?[row].portfolioID
        title.textAlignment = .center
        return title
    }
}

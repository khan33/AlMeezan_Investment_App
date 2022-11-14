//
//  SummeryInteractor.swift
//  AlMeezan
//
//  Created by Atta khan on 20/10/2021.
//  Copyright © 2021 Atta khan. All rights reserved.
//

import Foundation

class SummeryInteractor: SummeryInteractorProtocol {
    
    var presenter: SummeryPresenterProtocol?
    private let container = DependencyContainer()
    private let worker: SummeryWorkerProtocol
    
    
    init(worker: SummeryWorkerProtocol) {
        self.worker = worker
    }
    
    func viewDidLoad() {
        
    }
    
    func viewWillAppear(_ animated: Bool) {
        
    }
    
    func viewWillDisappear(_ animated: Bool) {
        
    }
    
    func getData(_ fund: String) {
        
    }

    func setUpTableView() {
        
    }
    func getFundSummery(fund: String) {
        let request_data = SummeryEntity.SummeryRequest(fundId: fund)
        let dataString = self.container.createCodeableManger().encodeToString(from: request_data)
        let encryptedString = self.container.createEncryptionManger().encrypt(withString: dataString)
        worker.fetchFundSummery(encryptedString: encryptedString) { result in
            switch result {
            case .success(let resposne):
                if let data = self.container.createDecryptionManger().decrypt(with: resposne) {
                    self.container.createCodeableManger().decodeArray(data, isCaching: false) { (result: [FundHistoryModel] ) in
                        let responseModel = SummeryEntity.SummeryResponseModel(summery: result)
                        self.presenter?.presentFetchSummery(response: responseModel)
                    }
                } else {
                    // data is empty
                }
            case .failure(let error):
                break
            }
        }
    }
    func filterFundGroup(navData: [NavEntity.NavViewModel.DisplayedFund], fund: String) -> String {
        let indexOf = navData.firstIndex(where: {$0.fundGroup == fund}) ?? 0
        let navPerformance = Array(navData[indexOf].navPerformance )
        
        if let dateStr = navPerformance[0].nAVDate {
            let strDate =  dateStr.toDate()
            let strValue = strDate?.toString(format: "MMM d, yyyy")
            if let lastUpdatedDate = strValue {
                return "NAV applicable date – \(lastUpdatedDate)"
            }
        }
        return ""
    }
    
    func choosePickerValue() {
//        let vc = UIViewController()
//        vc.preferredContentSize = CGSize(width: 250,height: 200)
//        let pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: 250, height: 200))
//        pickerView.delegate = self
//        pickerView.dataSource = self
//        pickerView.tag = 1
//        pickerView.selectRow(selectedFund, inComponent:0, animated:true)
//        vc.view.addSubview(pickerView)
//        let editRadiusAlert = UIAlertController(title: "Choose Fund", message: "", preferredStyle: UIAlertController.Style.alert)
//        editRadiusAlert.setValue(vc, forKey: "contentViewController")
//        editRadiusAlert.addAction(UIAlertAction(title: "Done", style: .default, handler: { (alert: UIAlertAction!) in
//            self.filterFundGroup()
//            self.fundGroupLbl.text = self.fundGroup
//            self.getData(self.fundGroup!)
//        }))
//        self.present(editRadiusAlert, animated: true)
    }
}

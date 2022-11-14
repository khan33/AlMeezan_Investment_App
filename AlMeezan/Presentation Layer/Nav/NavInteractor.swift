//
//  NavInteractor.swift
//  AlMeezan
//
//  Created by Atta khan on 15/09/2021.
//  Copyright © 2021 Atta khan. All rights reserved.
//

import Foundation



class NavInteractor: NavInteractorProtocol {
    
    var displayedFunds: NavEntity.NavResponseModel?
    var presenter: NavPresenterProtocol?
    private let worker: NavWorkerProtocol
    private let container = DependencyContainer()
    private var nav_model: NavEntity.NavResponseModel?
    
    init(worker: NavWorkerProtocol) {
        self.worker = worker
    }
    
    func viewDidLoad() {
        fetchNavFunds()
    }
    func viewWillAppear(_ animated: Bool) {
        
    }
    
    func countNotificationBadge(_ btn: UIButton) {
        Utility.shared.renderNotificationCount(btn)
    }
    
    func handleCell(section: Int, cell: NAVHeaderCell, data: NavEntity.NavViewModel.DisplayedFund) {
        cell.nav_data = data
        cell.updateCell(section)
    }
    

    var numberOfRows: Int {
        return displayedFunds?.nav.count ?? 0
    }
    
    
    func fetchNavFunds() {
        let request_data = NavEntity.NavRequest()
        let dataString = self.container.createCodeableManger().encodeToString(from: request_data)
        let encryptedString = self.container.createEncryptionManger().encrypt(withString: dataString)
        worker.getNavFundslist(encryptedString: encryptedString) { result in
            switch result {
            case .success(let resposne):
                if let data = self.container.createDecryptionManger().decrypt(with: resposne) {
                    self.container.createCodeableManger().decodeArray(data, isCaching: true) { (result: [NavModel] ) in
                        self.nav_model = NavEntity.NavResponseModel(nav: result)
                        self.displayedFunds = self.nav_model
                        self.presenter?.presentFetchFunds(response: self.nav_model!)
                    }
                } else {
                    // data is empty
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

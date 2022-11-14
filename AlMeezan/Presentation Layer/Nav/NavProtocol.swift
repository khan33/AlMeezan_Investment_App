//
//  NavProtocol.swift
//  AlMeezan
//
//  Created by Atta khan on 23/09/2021.
//  Copyright © 2021 Atta khan. All rights reserved.
//

import Foundation

protocol NavInteractorProtocol: AnyObject {
    func viewDidLoad()
    func viewWillAppear(_ animated: Bool)
    func fetchNavFunds()
    func handleCell(section: Int, cell: NAVHeaderCell, data: NavEntity.NavViewModel.DisplayedFund)
    func countNotificationBadge(_ btn: UIButton)
    var numberOfRows: Int { get }
}

protocol NavPresenterProtocol: AnyObject {
    func presentFetchFunds(response: NavEntity.NavResponseModel)
}

protocol NAVViewControllerProtocol: AnyObject {
    func displayFetchedFund(viewModel: NavEntity.NavViewModel)
}

protocol NavWorkerProtocol: AnyObject {
    func getNavFundslist(encryptedString: String, completion: @escaping (Swift.Result<String, Error>) -> Void)
}

protocol NavRouterProtocol: MainRouterProtocol {
    func routerToNavSummery(with index: Int, nav_data: [NavEntity.NavViewModel.DisplayedFund])
}

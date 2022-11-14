//
//  SummeryProtocol.swift
//  AlMeezan
//
//  Created by Atta khan on 20/10/2021.
//  Copyright © 2021 Atta khan. All rights reserved.
//

import Foundation

// MARK: VIEW => INTERACTOR
protocol SummeryInteractorProtocol : AnyObject{
    func viewDidLoad()
    func viewWillAppear(_ animated: Bool)
    func viewWillDisappear(_ animated: Bool)
    func getData(_ fund: String)
    func setUpTableView()
    func getFundSummery(fund: String)
    func filterFundGroup(navData: [NavEntity.NavViewModel.DisplayedFund], fund: String) -> String
    func choosePickerValue()
}





// MARK: INTERACTOR => PRESENTER
protocol SummeryPresenterProtocol : AnyObject{
    func presentFetchSummery(response: SummeryEntity.SummeryResponseModel)
}



// MARK: PRESENTER => VIEW

protocol SummeryViewContorllerProtocol: AnyObject {
    func displayedFundHistroyDetails(viewModel: SummeryEntity.SummeryViewModel)
}


// MARK: ROUTER PROTOCOL

protocol SummeryRouterProtocol: MainRouterProtocol {
    
}


// MARK: SUMMERY WORKER PROTOCOL

protocol SummeryWorkerProtocol: AnyObject {
    func fetchFundSummery(encryptedString: String, completion: @escaping (Swift.Result<String, Error>) -> Void)
}

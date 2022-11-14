//
//  SummeryPresenter.swift
//  AlMeezan
//
//  Created by Atta khan on 20/10/2021.
//  Copyright © 2021 Atta khan. All rights reserved.
//

import Foundation

class SummeryPresenter: SummeryPresenterProtocol {
    weak var viewController: SummeryViewContorllerProtocol?
    
    func presentFetchSummery(response: SummeryEntity.SummeryResponseModel) {
        var displayHistory: [SummeryEntity.SummeryViewModel.DisplayedSummeryFund] = []
        for history in response.summery {
            let fundHistory = SummeryEntity.SummeryViewModel.DisplayedSummeryFund(fundName: history.fUND_NAME, fundHistory: history.history)
            displayHistory.append(fundHistory)
        }
        let viewModel = SummeryEntity.SummeryViewModel(displaySummeryFund: displayHistory)
        viewController?.displayedFundHistroyDetails(viewModel: viewModel)
    }
}

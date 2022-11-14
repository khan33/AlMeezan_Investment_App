//
//  NavPresenter.swift
//  AlMeezan
//
//  Created by Atta khan on 15/09/2021.
//  Copyright © 2021 Atta khan. All rights reserved.
//

import Foundation


class NavPresenter: NavPresenterProtocol {
    
    weak var viewController: NAVViewController?
    func presentFetchFunds(response: NavEntity.NavResponseModel) {
        var displayFunds: [NavEntity.NavViewModel.DisplayedFund] = []
        displayFunds.append(NavEntity.NavViewModel.DisplayedFund(fundGroup: "All Fund", fundsort: 0, navPerformance: []))
        for fund in response.nav {
            let diplayFund = NavEntity.NavViewModel.DisplayedFund(fundGroup: fund.fundGroup ?? "" , fundsort: fund.fundsort, navPerformance: fund.navPerformance ?? [])
            displayFunds.append(diplayFund)
        }
        
        let viewModel = NavEntity.NavViewModel(displayFund: displayFunds)
        viewController?.displayFetchedFund(viewModel: viewModel)
    }
    
}

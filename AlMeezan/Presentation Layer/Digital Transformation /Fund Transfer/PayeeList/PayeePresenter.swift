//
//  PayeePresenter.swift
//  AlMeezan
//
//  Created by Atta khan on 19/09/2022.
//  Copyright © 2022 Atta khan. All rights reserved.
//

import Foundation

class PayeePresenter: PayeePresenterProtocol {
    weak var viewController: PayeeViewProtocol?
    
    func getPayeeList(_ response: payeeListResponse) {
        viewController?.successfullResponse(response)
    }
    
    func getPayeeHistoryList(_ response: payeeHistoryResponse) {
        var data = response
        var history = [[FundTransferEntity.PayeeHistroyModel]]()
        for (index, _) in data.enumerated() {
            let dateStr = data[index].time_stamp?.toDate(withFormat: "yyyy-MM-dd'T'HH:mm:ss.SSS")
            let start_date = dateStr?.toString(format: "d MMM yyyy") ?? ""
            data[index].formatted_date = start_date
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM yyyy"

        let grouped  = Dictionary(grouping: data, by: { $0.formatted_date })
        let sortedKeys = grouped.keys.sorted {
            return formatter.date(from: $0)! > formatter.date(from: $1)!
        }
        sortedKeys.forEach { (key) in
            let values = grouped[key]
            history.append(values ?? [])
        }
        viewController?.getHistoryResponse(history)
    }
}


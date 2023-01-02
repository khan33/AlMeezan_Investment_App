//
//  RedemptionVC + TableView.swift
//  AlMeezan
//
//  Created by Atta khan on 28/12/2022.
//  Copyright © 2022 Atta khan. All rights reserved.
//

import Foundation

extension RedemptionVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vpsTax.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if vpsTax[indexPath.row].isExpandable == true {
            return 124
        } else {
            return rowHeight
            
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: DocuemntUploadingCell.self, for: indexPath)
        cell.yearLbl.text = vpsTax[indexPath.row].yearList
        if vpsTax[indexPath.row].isExpandable == false {
            cell.uplaodingView.isHidden = true
        } else {
            cell.uplaodingView.isHidden = false
        }
        cell.fileNameLbl.text = randomfileName
        cell.uploadBtn.tag = indexPath.row
        cell.uploadBtn.addTarget(self, action: #selector(didTapOnUploadBtn), for: .touchUpInside)
        cell.closeBtn.tag = indexPath.row
        cell.closeBtn.addTarget(self, action: #selector(didTapOnCloseBtn), for: .touchUpInside)
        cell.selectionStyle = .none
        return cell
    }
    
    
}

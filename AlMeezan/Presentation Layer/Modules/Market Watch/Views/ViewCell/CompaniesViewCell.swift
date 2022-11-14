//
//  CompaniesViewCell.swift
//  AlMeezan
//
//  Created by Atta khan on 20/11/2019.
//  Copyright © 2019 Atta khan. All rights reserved.
//

import UIKit

class CompaniesViewCell: UITableViewCell {

    @IBOutlet weak var companyLbl: UILabel!
    @IBOutlet weak var innerTableView: InnerTableView!
    static var identifier: String {
        return String(describing: self)
    }
    static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    var sectorData: [PSXSectorTopModel]?
    var companyData: [ActiveCompanies]?
    var state: MarketState = MarketState.ActiveSectors
    override func awakeFromNib() {
        super.awakeFromNib()
        
        innerTableView.estimatedRowHeight = 36.0
        innerTableView.rowHeight = UITableView.automaticDimension
        innerTableView.delegate = self
        innerTableView.dataSource = self
        
        innerTableView.register(ActiveCompanyViewCell.nib, forCellReuseIdentifier: ActiveCompanyViewCell.identifier)
        innerTableView.reloadData()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
extension CompaniesViewCell: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ActiveCompanyViewCell.identifier, for: indexPath) as! ActiveCompanyViewCell
        switch state {
        case .ActiveSectors:
            print(indexPath.row)
            cell.sectorData = sectorData?[indexPath.row]
        default:
            cell.companyData = companyData?[indexPath.row]
        }
        cell.selectionStyle = .none
        cell.layoutIfNeeded()
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        var numOfSections: Int = 0
        if (NetworkState().isInternetAvailable) {
            tableView.backgroundView = nil
            numOfSections = 1
        } else {
            Utility.shared.emptyTableView(tableView)
        }
        return numOfSections
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        switch state {
        case .ActiveSectors:
            count = sectorData?.count ?? 0
        default:
            count = companyData?.count ?? 0
        }
        if count == 0 {
            Utility.shared.emptyTableViewForMW(tableView)
        } else {
            tableView.backgroundView = nil
        }
        return count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

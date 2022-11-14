//
//  MarketPerformersVC.swift
//  AlMeezan
//
//  Created by Atta khan on 20/11/2019.
//  Copyright © 2019 Atta khan. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

class MarketPerformersVC: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let imgArray = [UIImage(named: "arrow-up"),UIImage(named: "arrow-down"),UIImage(named: "briefcase"),UIImage(named: "building")]
    let titleArray = ["Advancers","Decliners","Active Sectors","Active Companies"]
    var indices: PSXCompanyIndicesModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getData()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MarketTableViewCell.nib, forCellReuseIdentifier: MarketTableViewCell.identifier)
        tableView.reloadData()
    }
    private func getData() {
        let bodyParam = RequestBody()
        let bodyRequest = bodyParam.encryptData(bodyParam)
        let url = URL(string: PSX_COMPANY_INDICES)!
        
        WebServiceManager.sharedInstance.fetchObject(params: bodyRequest as Dictionary<String, AnyObject>, url: url, serviceType: "PSX COMPANY INDICES TOP", modelType: PSXCompanyIndicesModel.self, errorMessage: { (errorMessage) in
            errorResponse = errorMessage
            self.showErrorMsg(errorMessage)
        }, success: { (response) in
            self.indices = response
            self.updateIndices()
        }, fail: { (error) in
            print(error.localizedDescription)
        }, showHUD: true)
    }
    
    func updateIndices() {
        let defaults = UserDefaults.standard
        if let indices = self.indices {
            defaults.set(codable: indices, forKey: "indices")
        }
    }
}

extension MarketPerformersVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imgArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MarketTableViewCell.identifier, for: indexPath) as! MarketTableViewCell
        cell.imgView.image = imgArray[indexPath.row]
        cell.titleLbl.text = titleArray[indexPath.row]
        cell.selectionStyle = .none
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 66.0
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = MarketPerformerDetailsVC.instantiateFromAppStroyboard(appStoryboard: .marketWatch)
        switch indexPath.row {
        case 0:
            vc.currentState = MarketState.Advancers
        case 1:
            vc.currentState = MarketState.Decliners
        case 2:
            vc.currentState = MarketState.ActiveSectors
        case 3:
            vc.currentState = MarketState.ActiveCompanies
        default:
            break
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
extension UserDefaults {

    func set<T: Encodable>(codable: T, forKey key: String) {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(codable)
            let jsonString = String(data: data, encoding: .utf8)!
            self.set(jsonString, forKey: key)
        } catch {
            print("Saving \"\(key)\" failed: \(error)")
        }
    }

    func codable<T: Decodable>(_ codable: T.Type, forKey key: String) -> T? {
        guard let jsonString = self.string(forKey: key) else { return nil }
        guard let data = jsonString.data(using: .utf8) else { return nil }
        let decoder = JSONDecoder()
        return try? decoder.decode(codable, from: data)
    }
}

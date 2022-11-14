//
//  CountrySearchVC.swift
//  AlMeezan
//
//  Created by Atta khan on 07/03/2022.
//  Copyright © 2022 Atta khan. All rights reserved.
//

import UIKit

enum SearchType {
    case currentCity
    case permanentCity
    case currentCountry
    case permanentCountry
    case bank
    case branch
}

protocol SearchBankProtocol: AnyObject {
    func selectbankNmae(bank: BankInfoViewEntity.BankInfoResponseModel?)
}

protocol SearchBranchProtocol: AnyObject {
    func selectBranchCity(branch: City?)
}

protocol SelectCity: AnyObject {
    func selectCurrentCity(city: CityModel?)
    func selectPermanentCity(city: CityModel?)
}
protocol SelectCountry: AnyObject {
    func selectCurrentCountry(country: Country?)
    func selectPermanentCountry(country: Country?)
}

class CountrySearchVC: UIViewController {
    weak var countryDelegate: SelectCountry?
    weak var cityDelegate: SelectCity?
    weak var branchDelegate: SearchBranchProtocol?
    weak var bankDelegate: SearchBankProtocol?

    private (set) lazy var tableView: UITableView = { [unowned self] in
        let tv = UITableView(frame: .zero, style: .plain)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = .lightGray
        tv.delegate = self
        tv.dataSource = self
        tv.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        return tv
    }()
    
    private (set) lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.searchBarStyle = UISearchBar.Style.default
        searchBar.placeholder = " Search..."
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
        return searchBar
    }()
    
    var country : [Country]?
    var search_country : [Country]?
    var cities: [CityModel]?
    var search_city: [CityModel]?
    var bankInfo: [BankInfoViewEntity.BankInfoResponseModel]?
    var search_bank: [BankInfoViewEntity.BankInfoResponseModel]?
    var branchCity :   [City]?
    var search_branchCity: [City]?
    var searchType: SearchType = .currentCity
    override func viewDidLoad() {
        super.viewDidLoad()
        search_city = cities
        search_country = country
        search_bank = bankInfo
        search_branchCity = branchCity
        setupViews()
    }
    
    fileprivate func setupViews() {
        self.view.backgroundColor = .white
        
        if !searchBar.isDescendant(of: self.view) {
            self.view.addSubview(searchBar)
        }
        searchBar.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 8).isActive = true
        searchBar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        searchBar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        
        if !tableView.isDescendant(of: self.view) {
            self.view.addSubview(tableView)
        }
        tableView.topAnchor.constraint(equalTo: self.searchBar.bottomAnchor, constant: 8).isActive = true
        tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }


}


extension CountrySearchVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchType == .permanentCountry || searchType == .currentCountry {
            return search_country?.count ?? 0
        }
        else if searchType == .bank {
            return search_bank?.count ?? 0
        }
        else if searchType == .branch {
            return search_branchCity?.count ?? 0
        }
        return search_city?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath as IndexPath)
        if searchType == .permanentCountry || searchType == .currentCountry {
            cell.textLabel?.text = search_country?[indexPath.row].cOUNTRY
        }
        else if searchType == .bank {
            cell.textLabel?.text = search_bank?[indexPath.row].bankName
        }
        else if searchType == .branch {
            cell.textLabel?.text = search_branchCity?[indexPath.row].city
        }
        else {
            cell.textLabel?.text = search_city?[indexPath.row].cITY
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if searchType == .currentCity {
            let city = search_city?[indexPath.row]
            cityDelegate?.selectCurrentCity(city: city)
        } else if searchType == .permanentCity {
            let city = search_city?[indexPath.row]
            cityDelegate?.selectPermanentCity(city: city)
        } else if searchType == .currentCountry {
            let country = search_country?[indexPath.row]
            countryDelegate?.selectCurrentCountry(country: country)
        } else if searchType == .bank {
            let bank = search_bank?[indexPath.row]
            bankDelegate?.selectbankNmae(bank: bank)
        }
        else if searchType == .branch {
            let branch = search_branchCity?[indexPath.row]
            branchDelegate?.selectBranchCity(branch: branch)
        }
        else if searchType == .permanentCountry {
            let country = search_country?[indexPath.row]
            countryDelegate?.selectPermanentCountry(country: country)
        }
        dismiss(animated: true, completion: nil)
    }
}


extension CountrySearchVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchType == .currentCountry || searchType == .permanentCountry {
            guard !searchText.isEmpty else {
                search_country = country
                tableView.reloadData()
                return
            }
            search_country = country?.filter({ ele -> Bool in
                return ele.cOUNTRY?.lowercased().contains(searchText.lowercased()) ?? false
            })
            
        }
        else if searchType == .bank {
            guard !searchText.isEmpty else {
                search_bank = bankInfo
                tableView.reloadData()
                return
            }
            search_bank = bankInfo?.filter({ ele -> Bool in
                return ele.bankName?.lowercased().contains(searchText.lowercased()) ?? false
            })
            
        }
        else if searchType == .branch {
            guard !searchText.isEmpty else {
                search_branchCity = branchCity
                tableView.reloadData()
                return
            }
            search_branchCity = branchCity?.filter({ ele -> Bool in
                return ele.city?.lowercased().contains(searchText.lowercased()) ?? false
            })
        }
        
        else {
            guard !searchText.isEmpty else {
                search_city = cities
                tableView.reloadData()
                return
            }
            search_city = cities?.filter({ city -> Bool in
                return city.cITY?.lowercased().contains(searchText.lowercased()) ?? false
            })
            
        }
        tableView.reloadData()
    }
}

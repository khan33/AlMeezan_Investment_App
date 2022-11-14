//
//  SearchViewController.swift
//  AlMeezan
//
//  Created by Atta khan on 03/10/2019.
//  Copyright © 2019 Atta khan. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UIAdaptivePresentationControllerDelegate {

    var data: [City]?
    var search_data: [City]?
    var city_branch_data: [Branches]?
    var search_branch_data: [Branches]?
    weak var delegate : CityProtocol?
    weak var branch_delegate: BranchProtocol?
    var search_city_array: [String] = citiesArray
    var current_state: String?
    
    
    @IBOutlet weak var searchBarView: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        search_data = data
        search_branch_data = city_branch_data
        searchBarView.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        
        self.presentationController?.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideNavigationBar()
    }
    
    
    @IBAction func onClickBackBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if current_state == "Branch" {
            return search_branch_data?.count ?? 0
        } else if current_state == "City" {
            return search_data?.count ?? 0
        } else {
            return search_city_array.count
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CityViewCell", for: indexPath) as! CityViewCell
        if current_state == "Branch" {
            cell.txtLbl.text = search_branch_data?[indexPath.row].branch
        } else if current_state == "City" {
            cell.txtLbl.text = search_data?[indexPath.row].city
        }
        else {
            cell.txtLbl.text = search_city_array[indexPath.row]
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if current_state == "Branch" {
            branch_delegate?.getBranches(search_branch_data?[indexPath.row])
        } else if current_state == "City" {
            delegate?.getCityBranches(search_data?[indexPath.row])
        }
        else {
            delegate?.getCities(search_city_array[indexPath.row])
        }
        self.navigationController?.popViewController(animated: true)
        //dismiss(animated: true, completion: nil)
    }
    
}
extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if current_state == "Branch" {
            guard !searchText.isEmpty else {
                search_branch_data = city_branch_data
                tableView.reloadData()
                return
            }
            search_branch_data = city_branch_data?.filter({ branch -> Bool in
                return branch.branch?.lowercased().contains(searchText.lowercased()) ?? false
            })
        }
        else if current_state == "City" {
            guard !searchText.isEmpty else {
                search_data = data
                tableView.reloadData()
                return
            }
            search_data = data?.filter({ city -> Bool in
                return city.city?.lowercased().contains(searchText.lowercased()) ?? false
            })
        }
        else {
            guard !searchText.isEmpty else {
                search_city_array = citiesArray
                tableView.reloadData()
                return
            }
            search_city_array = citiesArray.filter({ city -> Bool in
                return city.lowercased().contains(searchText.lowercased()) ?? false
            })
        }
            
        tableView.reloadData()
    }
}

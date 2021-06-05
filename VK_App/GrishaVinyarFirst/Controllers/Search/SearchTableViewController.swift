//
//  SearchTableViewController.swift
//  GrishaVinyarFirst
//
//  Created by Григорий Виняр on 09.04.2021.
//

import UIKit
import RealmSwift

class SearchTableViewController: UITableViewController {
    
    var filterArray = List<GroupList>()
    
    let searchController = UISearchController(searchResultsController: nil)
    
    let networkingService = NetworkingService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.rowHeight = 93
        
        tableView.register(GroupTableViewCell.self, forCellReuseIdentifier: "GroupCell")
        
        setupFilterArray()
        
        setupSearchController()
        
    }
    
    func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
    }
    
    func setupFilterArray() {
        filterArray = DataStorage.shared.allGroupsArray
    }
    
    func setupAlert() {
        let alertController = UIAlertController(title: "Добавление группы", message: "Хотите ли вы добавить группу?", preferredStyle: .alert)
        let alertActionOne = UIAlertAction(title: "Закрыть", style: .cancel, handler: nil)
        let alertActionTwo = UIAlertAction(title: "Добавить", style: .default) { [weak self] (alert) in
            if alert.isEnabled {
                
                if let indexOfTappedOne = self?.tableView.indexPathForSelectedRow {
                    
                    let tappedElement = DataStorage.shared.allGroupsArray[indexOfTappedOne.row]
                    
                    DataStorage.shared.allGroupsArray.remove(at: indexOfTappedOne.row)
                    
                    self?.tableView.reloadData()
                    
                    DataStorage.shared.groupsArray.append(tappedElement)
                    
                    self?.navigationController?.popViewController(animated: true)
                }
            }
            
        }
        
        alertController.addAction(alertActionOne)
        alertController.addAction(alertActionTwo)
        present(alertController, animated: true, completion: nil)
    }
    
    //MARK: Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        setupAlert()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return DataStorage.shared.allGroupsArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell", for: indexPath) as? GroupTableViewCell else { return UITableViewCell() }
        
        let filteredData = DataStorage.shared.allGroupsArray[indexPath.row]
        
        let imageView = UIImageView()
        
        imageView.sd_setImage(with: URL(string: filteredData.photo50), placeholderImage: UIImage(systemName: "person.3"))
        
        cell.storageElementsForGroup(groupLabel: filteredData.name , groupImage: imageView.image)
        
        return cell
    }
    
}

// MARK: - UISearchResultsUpdating
extension SearchTableViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        networkingService.searchGroups(name: searchController.searchBar.text ?? "Sport") { [weak self] (result) in
            
            switch result {
            
            case .failure(let error):
                print(error.localizedDescription)
                
            case .success(let list):
                
                DataStorage.shared.allGroupsArray = list
                
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            }
        }
        
    }
}

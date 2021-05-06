//
//  SearchTableViewController.swift
//  GrishaVinyarFirst
//
//  Created by Григорий Виняр on 09.04.2021.
//

import UIKit

class SearchTableViewController: UITableViewController {
    
    var filterArray = [Groups]()
    
    let searchController = UISearchController(searchResultsController: nil)
    
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
        let alertActionTwo = UIAlertAction(title: "Добавить", style: .default) { (alert) in
            if alert.isEnabled {
                
                    if let indexOfTappedOne = self.tableView.indexPathForSelectedRow {
                        
                        let tappedElement = self.filterArray[indexOfTappedOne.row]
                        
                        DataStorage.shared.allGroupsArray.removeAll { (group) -> Bool in
                            group.name == tappedElement.name
                        }
                        
                        self.tableView.reloadData()
                        
                        DataStorage.shared.groupsArray.append(tappedElement)
                        
                        self.navigationController?.popViewController(animated: true)
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
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return filterArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell", for: indexPath) as? GroupTableViewCell else { return UITableViewCell() }
        
        let filteredData = filterArray[indexPath.row]
        
        cell.storageElementsForGroup(groupLabel: filteredData.name, groupImage: filteredData.groupImage)
       
        return cell
    }
    
}

// MARK: - UISearchResultsUpdating
extension SearchTableViewController: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {

        self.filterArray = []

        for group in DataStorage.shared.allGroupsArray {
            if searchController.searchBar.text == "" {
                filterArray = DataStorage.shared.allGroupsArray
            } else if group.name.contains(searchController.searchBar.text!) {
                filterArray.append(group)
            }
        }
        self.tableView.reloadData()
    }
}

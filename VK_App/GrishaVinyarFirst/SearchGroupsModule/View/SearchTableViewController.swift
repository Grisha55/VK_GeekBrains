//
//  SearchTableViewController.swift
//  GrishaVinyarFirst
//
//  Created by Григорий Виняр on 09.04.2021.
//

import UIKit
import RealmSwift

protocol SearchGroupsView {
    func onSearchGroupsRetrieval(groups: List<GroupsArray>?)
}

class SearchTableViewController: UITableViewController {
    
    //MARK: - Properties
    var filterArray: List<GroupsArray>?
    let searchController = UISearchController(searchResultsController: nil)
    var token: NotificationToken?
    var presenter: SearchGroupsPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.rowHeight = 93
        
        tableView.register(GroupTableViewCell.self, forCellReuseIdentifier: "GroupCell")
        
        setupSearchController()
        
        presenter = SearchGroupsPresenter(view: self, realmSearchManager: RealmManager())
        presenter?.viewDidLoad(tableView: tableView)
        
    }
    
    //MARK: - Methods
    func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
    }
    
    //MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.setupAlert(controller: self, indexOfTappedOne: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let filterArray = filterArray else { return 0 }
        return filterArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell", for: indexPath) as? GroupTableViewCell else { return UITableViewCell() }
        
        guard let filterArray = filterArray else { return UITableViewCell() }
        
        let filteredData = filterArray[indexPath.row]
        
        let photo = filteredData.photo50
        
        guard let url = URL(string: photo) else { return UITableViewCell() }
        
        cell.storageElementsForGroup(groupLabel: filteredData.name , url: url)
        
        return cell
    }
    
}
// MARK: - SearchGroupsView
extension SearchTableViewController: SearchGroupsView {
    func onSearchGroupsRetrieval(groups: List<GroupsArray>?) {
        self.filterArray = groups
        tableView.reloadData()
    }
}

// MARK: - UISearchResultsUpdating
extension SearchTableViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let text = searchController.searchBar.text else { return }
        
        presenter?.textDidChange(name: text, tableView: tableView)
    }
}

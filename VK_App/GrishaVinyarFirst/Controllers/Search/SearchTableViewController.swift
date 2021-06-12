//
//  SearchTableViewController.swift
//  GrishaVinyarFirst
//
//  Created by Григорий Виняр on 09.04.2021.
//

import UIKit
import RealmSwift

class SearchTableViewController: UITableViewController {
    
    var filterArray: Results<GroupsArray>?
    
    let searchController = UISearchController(searchResultsController: nil)
    
    let networkingService = NetworkingService()
    
    var token: NotificationToken?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pairTableAndRealm()
        
        self.tableView.rowHeight = 93
        
        tableView.register(GroupTableViewCell.self, forCellReuseIdentifier: "GroupCell")
        
        setupSearchController()
    }
    
    func pairTableAndRealm() {
        
        guard let realm = try? Realm() else { return }
        
        filterArray = realm.objects(GroupsArray.self)
        
        token = filterArray?.observe({ [weak self] changes in
            switch changes {
            case .initial:
                self?.tableView.reloadData()
                
            case .update(_, deletions: let deletion, insertions: let insertions, modifications: let modifications):
                self?.tableView.beginUpdates()
                
                self?.tableView.insertRows(at: insertions.map { IndexPath(row: $0, section: 0) }, with: .automatic)
                
                self?.tableView.deleteRows(at: deletion.map { IndexPath(row: $0, section: 0) }, with: .automatic)
                
                self?.tableView.reloadRows(at: modifications.map { IndexPath(row: $0, section: 0) }, with: .automatic)
                
                self?.tableView.endUpdates()
                
            case .error(let error):
                print(error.localizedDescription)
                
            }
        })
    }
    
    func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
    }
    
    func setupAlert() {
        let alertController = UIAlertController(title: "Добавление группы", message: "Хотите ли вы добавить группу?", preferredStyle: .alert)
        let alertActionOne = UIAlertAction(title: "Закрыть", style: .cancel, handler: nil)
        let alertActionTwo = UIAlertAction(title: "Добавить", style: .default) { [weak self] (alert) in
            if alert.isEnabled {
                
                if let indexOfTappedOne = self?.tableView.indexPathForSelectedRow {
                    
                    guard let filterArray = self?.filterArray else { return }
                    
                    let tappedElement = filterArray[indexOfTappedOne.row]
                    
                    // Добавляем группу в свои группы
                    do {
                        let realm = try Realm()
                        realm.beginWrite()
                        let groupClass = GroupList()
                        groupClass.id = 0
                        groupClass.name = tappedElement.name
                        groupClass.photo50 = tappedElement.photo50
                        realm.add(groupClass)
                        try realm.commitWrite()
                    } catch {
                        print(error.localizedDescription)
                    }
                    
                    // Удаляем группу из общих групп
                    do {
                        let realm = try Realm()
                        realm.beginWrite()
                        realm.delete(tappedElement)
                        try realm.commitWrite()
                    } catch {
                        print(error.localizedDescription)
                    }
                    
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
        guard let filterArray = filterArray else { return 0 }
        return filterArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell", for: indexPath) as? GroupTableViewCell else { return UITableViewCell() }
        
        guard let filterArray = filterArray else { return UITableViewCell() }
        
        let filteredData = filterArray[indexPath.row]
        
        let imageView = UIImageView()
        
        let photo = filteredData.photo50
        
        imageView.sd_setImage(with: URL(string: photo), placeholderImage: UIImage(systemName: "person.3"))
        
        cell.storageElementsForGroup(groupLabel: filteredData.name , groupImage: imageView.image)
        
        return cell
    }
    
}

// MARK: - UISearchResultsUpdating
extension SearchTableViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let text = searchController.searchBar.text else { return }
        
        RealmManager().updateAllGroups(name: text)
    }
}

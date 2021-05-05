//
//  MessageViewController.swift
//  GrishaVinyarFirst
//
//  Created by Григорий Виняр on 21.04.2021.
//

import UIKit

class MessageViewController: UIViewController {

    var userMessages = [User]()
    
    let tableView = UITableView()
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userMessages = DataStorage.shared.usersArray
        
        constraintsForTableView()
        tableView.register(MessageTableViewCell.self, forCellReuseIdentifier: "MessageCell")
        tableView.dataSource = self
        tableView.delegate = self
        
        searchController.searchBar.delegate = self
        setSearchController()
    }
    
    private func setSearchController() {
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    private func constraintsForTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive           = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive     = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive   = true
    }
}

//MARK: - UITableViewDelegatee
extension MessageViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}

// MARK: - UITableViewDataSource
extension MessageViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userMessages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as? MessageTableViewCell else { return UITableViewCell() }
        
        let userMessage = userMessages[indexPath.row]
        
        cell.configure(photo: userMessage.avatar, name: userMessage.name)
        
        return cell
    }
}
// MARK: - UISearchBarDelegate
extension MessageViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        userMessages = []
        
        for user in DataStorage.shared.usersArray {
            if searchText == "" {
                userMessages = DataStorage.shared.usersArray
            } else if user.name.contains(searchText) {
                userMessages.append(user)
            }
        }
        tableView.reloadData()
    }
}

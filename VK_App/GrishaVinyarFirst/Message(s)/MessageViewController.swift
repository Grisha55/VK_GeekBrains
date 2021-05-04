//
//  MessageViewController.swift
//  GrishaVinyarFirst
//
//  Created by Григорий Виняр on 21.04.2021.
//

import UIKit

class MessageViewController: UIViewController {

    var userMessages = [User]()
    
    @IBOutlet var searchBar: UISearchBar!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let leftNavigationBarButton = UIBarButtonItem(customView: searchBar)
        self.navigationItem.leftBarButtonItem = leftNavigationBarButton
        
        tableView.rowHeight = 120
        
        userMessages = DataStorage.shared.usersArray
        
        navigationItem.titleView = searchBar
        searchBar.delegate = self
        
        searchBar.delegate = self
        
        tableView.register(UINib(nibName: "MessageTableViewCell", bundle: nil), forCellReuseIdentifier: "messageCell")
        tableView.dataSource = self
        tableView.delegate = self
    }
}
//MARK: -UITableViewDelegatee

extension MessageViewController: UITableViewDelegate {}

// MARK: -UITableViewDataSource

extension MessageViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userMessages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as? MessageTableViewCell else { return UITableViewCell() }
        
        let userMessage = userMessages[indexPath.row]
        
        cell.configureCell(photo: userMessage.avatar, name: userMessage.name)
        
        return cell
    }
    
    
}

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

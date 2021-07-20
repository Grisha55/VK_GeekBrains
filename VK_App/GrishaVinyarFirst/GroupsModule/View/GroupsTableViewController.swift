//
//  GroupsTableViewController.swift
//  GrishaVinyarFirst
//
//  Created by Григорий Виняр on 09.04.2021.
//

import UIKit
import SDWebImage
import RealmSwift
import Firebase

protocol UserGroupsView {
    func onGroupRetrieval(groups: [GroupFB])
}

class GroupsTableViewController: UITableViewController {
    
    //MARK: - Properties
    let groupCell = "GroupCell"
    let networkingService = NetworkingService()
    var groups = [GroupFB]()
    var presenter: GroupsPresenter!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.loadUsersGroupFromFB(tableView: tableView) { groupsFB in
            self.groups = groupsFB
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(GroupTableViewCell.self, forCellReuseIdentifier: groupCell)
        
        presenter = GroupsPresenter(view: self, firebaseStore: FirebaseStore())
        presenter.viewDidLoad(tableView: tableView)
    }
    
    //MARK: - Methods
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        tableView.rowHeight = 93
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: groupCell, for: indexPath) as? GroupTableViewCell else { return UITableViewCell() }
        
        let group = groups[indexPath.row]
        
        guard let url = URL(string: group.photo ?? "") else { return UITableViewCell() }
        
        cell.storageElementsForGroup(groupLabel: group.name ?? "Warning!!! (deleted group)" , url: url)
        
        return cell
    }
    
    // Удаляем группу из Firebase
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let name = groups[indexPath.row].name else { return }
            var safeName = name.replacingOccurrences(of: "", with: "^")
            safeName = safeName.replacingOccurrences(of: ".", with: "_")
            safeName = safeName.replacingOccurrences(of: "#", with: "-")
            safeName = safeName.replacingOccurrences(of: "$", with: "-")
            safeName = safeName.replacingOccurrences(of: "[", with: "{")
            safeName = safeName.replacingOccurrences(of: "]", with: "}")
            safeName = safeName.replacingOccurrences(of: "@", with: "-")
            
            guard let id = SessionApp.shared.userID else { return }
            Database.database().reference().child("users").child("\(id)").child(name).removeValue { error, ref in
                if error != nil {
                    print(error?.localizedDescription as Any)
                }
            }
            self.groups.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
}
// MARK: - UserGroupsProtocol
extension GroupsTableViewController: UserGroupsView {
    func onGroupRetrieval(groups: [GroupFB]) {
        self.groups = groups
        tableView.reloadData()
    }
}

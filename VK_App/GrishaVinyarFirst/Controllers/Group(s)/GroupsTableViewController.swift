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

class GroupsTableViewController: UITableViewController {
    
    let groupCell = "GroupCell"
    
    let networkingService = NetworkingService()

    var token: NotificationToken?
    
    var groups = [GroupFB]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(GroupTableViewCell.self, forCellReuseIdentifier: groupCell)
        FirebaseStore().takeUsersGroupToFB()
        loadUsersGroupFromFB()
    }
    
    // Загружаем все группы пользователя из Firebase
    func loadUsersGroupFromFB() {
        guard let id = SessionApp.shared.userID else { return }
        let refGroups = Database.database().reference(withPath: "users").child("\(id)")
        
        refGroups.observe(.value) { [weak self] snapshot in
            var _groups = Array<GroupFB>()
            
            for group in snapshot.children {
                
                let group = GroupFB(snapshot: group as! DataSnapshot)
                
                _groups.append(group)
            }
            self?.groups = _groups
            self?.tableView.reloadData()
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        tableView.rowHeight = 93
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: groupCell, for: indexPath) as? GroupTableViewCell else { return UITableViewCell() }
        
        let group = groups[indexPath.row]
        
        let imageView = UIImageView()
        
        guard let url = URL(string: group.photo ?? "") else { return UITableViewCell() }
        
        imageView.sd_setImage(with: url, placeholderImage: UIImage(systemName: "person.3"))
        
        cell.storageElementsForGroup(groupLabel: group.name ?? "" , groupImage: imageView.image)
        
        return cell
    }
    
    // Удаляем группу из Firebase
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let name = groups[indexPath.row].name else { return }
            guard let id = SessionApp.shared.userID else { return }
            Database.database().reference().child("users").child("\(id)").child(name).removeValue { [weak self] error, ref in
                if error != nil {
                    print(error?.localizedDescription as Any)
                }
                
                self?.groups.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        }
    }
    
}

//
//  GroupsTableViewController.swift
//  GrishaVinyarFirst
//
//  Created by Григорий Виняр on 09.04.2021.
//

import UIKit
import SDWebImage
import RealmSwift

class GroupsTableViewController: UITableViewController {
    
    let groupCell = "GroupCell"
    
    let networkingService = NetworkingService()

    var token: NotificationToken?
    
    var groups: Results<GroupList>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        RealmManager().updataUsersGroups()
        pairTableWithRealm()
        tableView.register(GroupTableViewCell.self, forCellReuseIdentifier: groupCell)
    }
    
    func pairTableWithRealm() {
        guard let realm = try? Realm() else { return }
        groups = realm.objects(GroupList.self)
        token = groups?.observe({ [weak self] changes in
            guard let strongSelf = self else { return }
            switch changes {
            case .error(let error):
                print(error.localizedDescription)
            case .initial:
                strongSelf.tableView.reloadData()
            case .update(_, deletions: let deletions, insertions: let insertions, modifications: let modifications):
                strongSelf.tableView.beginUpdates()
                
                strongSelf.tableView.insertRows(at: insertions.map { IndexPath(row: $0, section: 0) }, with: .automatic)
                strongSelf.tableView.deleteRows(at: deletions.map { IndexPath(row: $0, section: 0) }, with: .automatic)
                strongSelf.tableView.reloadRows(at: modifications.map { IndexPath(row: $0, section: 0) }, with: .automatic)
                
                strongSelf.tableView.endUpdates()
            }
        })
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let groups = groups else { return 0 }
        return groups.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        tableView.rowHeight = 93
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: groupCell, for: indexPath) as? GroupTableViewCell else { return UITableViewCell() }
        
        guard let groups = groups else { return UITableViewCell() }
        
        let group = groups[indexPath.row]
        
        let imageView = UIImageView()
        
        imageView.sd_setImage(with: URL(string: group.photo50), placeholderImage: UIImage(systemName: "person.3"))
        
        cell.storageElementsForGroup(groupLabel: group.name , groupImage: imageView.image)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let groups = groups else { return }
            do {
                let realm = try Realm()
                realm.beginWrite()
                realm.delete(groups[indexPath.row])
                try realm.commitWrite()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
}

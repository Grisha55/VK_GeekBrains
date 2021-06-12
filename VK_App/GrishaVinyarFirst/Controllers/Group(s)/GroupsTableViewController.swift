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
    
<<<<<<< Updated upstream
    var groups: Results<GroupList>?
=======
    var token: NotificationToken?
    
    var groups: Results<GroupList>? {
        didSet {
            token = groups?.observe({ [weak self] changes in
                switch changes {
                case .error(let error):
                    print(error.localizedDescription)
                case .initial(let results):
                    print("Start to modified")
                case .update(let results, deletions: let deletions, insertions: let insertions, modifications: let modifications):
                    self?.tableView.reloadData()
                }
            })
        }
    }
>>>>>>> Stashed changes
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(GroupTableViewCell.self, forCellReuseIdentifier: groupCell)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkGroups()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
    }
    
    func checkGroups() {
        if groups?.count == 0 {
            RealmManager().updataUsersGroups()
        } else {
            pairTableWithRealm()
        }
    }
    
    func pairTableWithRealm() {
        
        do {
            let realm = try Realm()
            let groups = realm.objects(GroupList.self)
            self.groups = groups
            tableView.reloadData()
        } catch {
            print(error.localizedDescription)
        }
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
    
    /*override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     guard let groups = groups else { return }
     
     let element = groups[indexPath.row]
     
<<<<<<< Updated upstream
     let indexOfElement = DataStorage.shared.groupsArray?.index(of: element)
     
     DataStorage.shared.allGroupsArray.append(element)
=======
        Array(groups).remove(at: indexPath.row)
>>>>>>> Stashed changes
     
     self.tableView.deleteRows(at: [indexPath], with: .fade)
     
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }*/
    
}

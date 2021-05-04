//
//  GroupsTableViewController.swift
//  GrishaVinyarFirst
//
//  Created by Григорий Виняр on 09.04.2021.
//

import UIKit

class GroupsTableViewController: UITableViewController {

    let groupCell = "groupCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let  nib = UINib(nibName: "GroupTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: groupCell)
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return DataStorage.shared.groupsArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        tableView.rowHeight = 93
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: groupCell, for: indexPath) as? GroupTableViewCell else { return UITableViewCell() }
        
        let nameString = DataStorage.shared.groupsArray[indexPath.row]
        
        cell.storageElementsForGroup(groupLabel: nameString.name, groupImage: nameString.groupImage)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let element = DataStorage.shared.groupsArray[indexPath.row]
            
            DataStorage.shared.groupsArray.remove(at: indexPath.row)
            
            DataStorage.shared.allGroupsArray.append(element)
            
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

}

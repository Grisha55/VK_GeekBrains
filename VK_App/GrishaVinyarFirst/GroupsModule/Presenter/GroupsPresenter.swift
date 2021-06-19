//
//  GroupsPresenter.swift
//  GrishaVinyarFirst
//
//  Created by Григорий Виняр on 19.06.2021.
//

import Foundation
import Firebase
import RealmSwift

protocol GroupsPresenterProtocol {
    init(view: UserGroupsView, firebaseStore: FirebaseStore)
    func viewDidLoad(tableView: UITableView)
}

protocol FirebaseStoreProtocol {
    func takeUsersGroupToFB(view: UserGroupsView)
}

class GroupsPresenter: GroupsPresenterProtocol {
   
    var view: UserGroupsView
    var firebaseStore: FirebaseStoreProtocol
    var userGroups: [GroupFB]?
    
    required init(view: UserGroupsView, firebaseStore: FirebaseStore) {
        self.view = view
        self.firebaseStore = firebaseStore
    }
    
    func viewDidLoad(tableView: UITableView) {
        firebaseStore.takeUsersGroupToFB(view: view)
        loadUsersGroupFromFB(tableView: tableView)
    }
    
    func loadUsersGroupFromFB(tableView: UITableView) {
        guard let id = SessionApp.shared.userID else { return }
        let refGroups = Database.database().reference(withPath: "users").child("\(id)")
        
        refGroups.observe(.value) { [weak self] snapshot in
            guard let self = self else { return }
            
            var _groups = Array<GroupFB>()
            
            for group in snapshot.children {
                
                let group = GroupFB(snapshot: group as! DataSnapshot)
                
                _groups.append(group)
            }
            self.userGroups = _groups
            tableView.reloadData()
        }
    }
    
}

//
//  FriendsPresenter.swift
//  GrishaVinyarFirst
//
//  Created by Григорий Виняр on 19.06.2021.
//

import Foundation
import RealmSwift

protocol FriendsViewPresenterProtocol: AnyObject {
    init(view: FriendsView, realmService: RealmFriendsServiceProtocol, networkService: NetworkServiceProtocol)
    func viewDidLoad(tableView: UITableView)
}

protocol RealmFriendsServiceProtocol {
    func getAllFriendsToBase(view: FriendsView)
}

class FriendsPresenter: FriendsViewPresenterProtocol {
    
    private var friends: Results<Item>?
    weak var view: FriendsView?
    let networkService: NetworkServiceProtocol!
    var token: NotificationToken?
    var realmService: RealmFriendsServiceProtocol!
    
    required init(view: FriendsView, realmService: RealmFriendsServiceProtocol, networkService: NetworkServiceProtocol) {
        self.view = view
        self.realmService = realmService
        self.networkService = networkService
    }
    
    func viewDidLoad(tableView: UITableView) {
        guard let view = view else { return }
        realmService?.getAllFriendsToBase(view: view)
        pairTableAndRealm(tableView: tableView)
    }
    
    private func pairTableAndRealm(tableView: UITableView) {
        
        guard let realm = try? Realm() else { return }
        self.friends = realm.objects(Item.self)
        
        self.token = friends?.observe({ changes in
            switch changes {
            case .initial:
                tableView.reloadData()
                
            case .update(_, deletions: _, insertions: _, modifications: let modifications):
                tableView.beginUpdates()
                
                tableView.reloadRows(at: modifications.map { IndexPath(row: $0, section: 0) }, with: .automatic)
                
                tableView.endUpdates()
                
            case .error(let error):
                print(error.localizedDescription)
            }
        })
    }
}

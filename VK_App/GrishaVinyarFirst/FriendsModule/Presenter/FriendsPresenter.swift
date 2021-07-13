//
//  FriendsPresenter.swift
//  GrishaVinyarFirst
//
//  Created by Григорий Виняр on 19.06.2021.
//

import Foundation
import RealmSwift

protocol FriendsViewPresenterProtocol: AnyObject {
    init(view: FriendsView, networkService: NetworkServiceProtocol)
    func viewDidLoad(tableView: UITableView)
}

class FriendsPresenter: FriendsViewPresenterProtocol {
    
    private var friends: Results<Item>?
    weak var view: FriendsView?
    let networkService: NetworkServiceProtocol!
    var token: NotificationToken?
    
    required init(view: FriendsView, networkService: NetworkServiceProtocol) {
        self.view = view
        self.networkService = networkService
    }
    
    func viewDidLoad(tableView: UITableView) {
        pairTableAndRealm(tableView: tableView)
    }
    
    private func pairTableAndRealm(tableView: UITableView) {
        
        networkService.getFriends()
        
        guard let realm = try? Realm() else { return }
        self.friends = realm.objects(Item.self)
        view?.onItemsRetrieval(friends: friends)
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

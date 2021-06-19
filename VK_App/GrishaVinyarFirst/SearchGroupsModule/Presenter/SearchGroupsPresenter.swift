//
//  SearchGroupsPresenter.swift
//  GrishaVinyarFirst
//
//  Created by Григорий Виняр on 19.06.2021.
//

import UIKit
import RealmSwift

protocol SearchGroupsPresenterProtocol {
    init(view: SearchGroupsView, realmSearchManager: RealmSearchManagerProtocol)
    func viewDidLoad(tableView: UITableView)
}

protocol RealmSearchManagerProtocol {
    func updateAllGroups(view: SearchGroupsView, name: String)
}

class SearchGroupsPresenter: SearchGroupsPresenterProtocol {
    
    var view: SearchGroupsView
    var realmSearchManager: RealmSearchManagerProtocol
    var searchGroups: Results<GroupsArray>?
    var token: NotificationToken?
    
    required init(view: SearchGroupsView, realmSearchManager: RealmSearchManagerProtocol) {
        self.view = view
        self.realmSearchManager = realmSearchManager
    }
    
    func viewDidLoad(tableView: UITableView) {
        pairTableAndRealm(tableView: tableView)
    }
    
    func textDidChange(name: String, tableView: UITableView) {
        realmSearchManager.updateAllGroups(view: view, name: name)
        tableView.reloadData()
    }
    
    func pairTableAndRealm(tableView: UITableView) {
        
        guard let realm = try? Realm() else { return }
        
        searchGroups = realm.objects(GroupsArray.self)
        
        token = searchGroups?.observe({ changes in
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
    
    func setupAlert(controller: UIViewController, indexOfTappedOne: IndexPath) {
        let alertController = UIAlertController(title: "Добавление группы", message: "Хотите ли вы добавить группу?", preferredStyle: .alert)
        let alertActionOne = UIAlertAction(title: "Закрыть", style: .cancel, handler: nil)
        let alertActionTwo = UIAlertAction(title: "Добавить", style: .default) { [weak self] (alert) in
            if alert.isEnabled {
                    
                    guard let searchGroups = self?.searchGroups else { return }
                    
                    let tappedElement = searchGroups[indexOfTappedOne.row]
                    
                    var safeName = tappedElement.name.replacingOccurrences(of: "", with: "_")
                    safeName = safeName.replacingOccurrences(of: ".", with: "_")
                    safeName = safeName.replacingOccurrences(of: "#", with: "-")
                    safeName = safeName.replacingOccurrences(of: "$", with: "dollar")
                    safeName = safeName.replacingOccurrences(of: "[", with: "{")
                    safeName = safeName.replacingOccurrences(of: "]", with: "}")
                    safeName = safeName.replacingOccurrences(of: "@", with: "dog")
                    
                    FirebaseStore().loadDataToFirebase(name: safeName, photo: tappedElement.photo50)
                    
                    controller.navigationController?.popViewController(animated: true)
            }
        }
        
        alertController.addAction(alertActionOne)
        alertController.addAction(alertActionTwo)
        controller.present(alertController, animated: true, completion: nil)
    }
}

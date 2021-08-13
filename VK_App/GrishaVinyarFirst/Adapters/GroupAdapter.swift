//
//  GroupAdapter.swift
//  GrishaVinyarFirst
//
//  Created by Григорий Виняр on 13.08.2021.
//

import Foundation
import RealmSwift

class GroupAdapter {
    private let networkingSevice = NetworkingService()
    private var token = NotificationToken()
    
    func getGroups(name: String, completion: @escaping ([SimpleGroup]) -> Void) {
        guard let realm = try? Realm() else { return }
        let rlmGroups = realm.objects(GroupsArray.self)
        
        token = rlmGroups.observe({ (changes) in
            switch changes {
            
            case .initial(_):
                break
                
            case .update(let rlmGroups, deletions: _, insertions: _, modifications: _):
                var groups = [SimpleGroup]()
                
                for rlmGroup in rlmGroups {
                    groups.append(self.groups(from: rlmGroup))
                }
                completion(groups)
                
            case .error(let error):
                print(error.localizedDescription)
            }
        })
        self.networkingSevice.searchGroups(name: name)
    }
    
    private func groups(from rlmGroup: GroupsArray) -> SimpleGroup {
        return SimpleGroup(name: rlmGroup.name,
                           photo50: rlmGroup.photo50)
    }
}

//
//  FirebaseStore.swift
//  GrishaVinyarFirst
//
//  Created by Григорий Виняр on 15.06.2021.
//

import Foundation
import Firebase

class FirebaseStore: FirebaseStoreProtocol {
    
    // Добавляем новую группу в Firebase
    func loadDataToFirebase(name: String, photo: String) {
        let db = Database.database().reference()
        
        guard let id = SessionApp.shared.userID else { return }
        db.child("users").child("\(id)").child(name).setValue([
            "name": name,
            "photo": photo
        ])
    }
    
    // Загружаем все группы юзера в Firebase
    func takeUsersGroupToFB(view: UserGroupsView) {
        
        NetworkingService().getUserGroups { status in
            switch status {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let groups):
                var groupsFB = [GroupFB]()
                groups.forEach { group in
                    let groupFB = GroupFB(name: group.name, photo: group.photo50)
                    groupsFB.append(groupFB)
                    
                    var safeName = group.name.replacingOccurrences(of: "", with: "^")
                    safeName = safeName.replacingOccurrences(of: ".", with: "_")
                    safeName = safeName.replacingOccurrences(of: "#", with: "-")
                    safeName = safeName.replacingOccurrences(of: "$", with: "-")
                    safeName = safeName.replacingOccurrences(of: "[", with: "{")
                    safeName = safeName.replacingOccurrences(of: "]", with: "}")
                    safeName = safeName.replacingOccurrences(of: "@", with: "-")
                    FirebaseStore().loadDataToFirebase(name: safeName, photo: group.photo50)
                }
                view.onGroupRetrieval(groups: groupsFB)
            }
        }
    }
    
  
}

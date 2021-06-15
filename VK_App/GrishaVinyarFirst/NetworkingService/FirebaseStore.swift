//
//  FirebaseStore.swift
//  GrishaVinyarFirst
//
//  Created by Григорий Виняр on 15.06.2021.
//

import Foundation
import Firebase

class FirebaseStore {
    
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
    func takeUsersGroupToFB() {
        
        NetworkingService().getUserGroups { status in
            switch status {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let groups):
                groups.forEach { group in
                    let safeName = group.name.replacingOccurrences(of: ".", with: "-")
                    FirebaseStore().loadDataToFirebase(name: safeName, photo: group.photo50)
                }
            }
        }
    }
    
  
}

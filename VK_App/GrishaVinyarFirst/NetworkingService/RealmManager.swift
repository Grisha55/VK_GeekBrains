//
//  RealmManager.swift
//  GrishaVinyarFirst
//
//  Created by Григорий Виняр on 05.06.2021.
//

import Foundation
import RealmSwift

class RealmManager {
    
    func getAllFriendsToBase() {
        
        NetworkingService().getFriends { result in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let users):
                do {
                    let realm = try Realm()
                    realm.beginWrite()
                    let oldValue = realm.objects(Item.self)
                    realm.delete(oldValue)
                    realm.add(users)
                    try realm.commitWrite()
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func updatePhotos(for userID: Int? ){
        NetworkingService().getPhotos(userID: userID, completion: { (pictures) in
            do {
                let realm = try Realm()
                let oldValues = realm.objects(Picture.self)
                realm.beginWrite()
                realm.delete(oldValues)
                realm.add(pictures)
                try realm.commitWrite()
            } catch {
                print(error)
            }
        }, onError: { (error) in
            print(error)
        })
    }
    
    func updateAllGroups(name: String) {
        NetworkingService().searchGroups(name: name) { (result) in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let allGroups):
                do {
                    let realm = try Realm()
                    realm.beginWrite()
                    let oldValue = realm.objects(GroupsArray.self)
                    realm.delete(oldValue)
                    realm.add(allGroups)
                    try realm.commitWrite()
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
}

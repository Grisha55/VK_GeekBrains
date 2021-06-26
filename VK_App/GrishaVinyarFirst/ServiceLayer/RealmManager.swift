//
//  RealmManager.swift
//  GrishaVinyarFirst
//
//  Created by Григорий Виняр on 05.06.2021.
//

import Foundation
import RealmSwift

class RealmManager: RealmFriendsServiceProtocol, RealmPhotosManagerProtocol, RealmSearchManagerProtocol {
 
    // Загрузка друзей юзера в Realm
    func getAllFriendsToBase(view: FriendsView) {
        
        NetworkingService().getFriends { result in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let users):
                view.onItemsRetrieval(friends: users)
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
    
    // Загрузка фотографий друзей пользователя в Realm
    func updatePhotos(for userID: Int?, view: PhotosView) {
        NetworkingService().getPhotos(userID: userID, completion: { (pictures) in
            view.onItemsRetrieval(photos: pictures)
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
    
    // Загрузка всех групп в Realm
    func updateAllGroups(view: SearchGroupsView, name: String) {
        NetworkingService().searchGroups(name: name) { (result) in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let allGroups):
                view.onSearchGroupsRetrieval(groups: allGroups)
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

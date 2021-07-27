//
//  RealmManager.swift
//  GrishaVinyarFirst
//
//  Created by Григорий Виняр on 05.06.2021.
//

import Foundation
import RealmSwift

class RealmManager: RealmPhotosManagerProtocol, RealmSearchManagerProtocol {
    
    // Загрузка друзей пользователя в Realm
    func getAllFriendsToBase(view: FriendsView) {
        
        NetworkingService().oldMethodForGettingFriend { result in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let items):
                view.onItemsRetrieval(friends: items)
                do {
                    let realm = try Realm()
                    realm.beginWrite()
                    let oldValues = realm.objects(Item.self)
                    realm.delete(oldValues)
                    realm.add(items)
                    try realm.commitWrite()
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    // Загрузка фотографий друзей пользователя в Realm
    func updatePhotos(for userID: Int?, view: PhotosView) {
        
        NetworkingService().getPhotosWithPromises(userID: userID)
            .done { photos in
                do {
                    let realm = try Realm()
                    let oldValues = realm.objects(Picture.self)
                    realm.beginWrite()
                    realm.delete(oldValues)
                    realm.add(photos, update: .error)
                    try realm.commitWrite()
                } catch {
                    print(error)
                }
            }
            .catch { error in
                print(error.localizedDescription)
            }
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

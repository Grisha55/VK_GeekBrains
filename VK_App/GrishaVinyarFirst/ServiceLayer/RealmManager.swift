//
//  RealmManager.swift
//  GrishaVinyarFirst
//
//  Created by Григорий Виняр on 05.06.2021.
//

import Foundation
import RealmSwift

class RealmManager: RealmPhotosManagerProtocol {
    
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
}

//
//  PhotosPresenter.swift
//  GrishaVinyarFirst
//
//  Created by Григорий Виняр on 19.06.2021.
//

import UIKit
import RealmSwift

protocol PhotosPresenterProtocol {
    init(view: PhotosView, realmPhotosManagerProtocol: RealmPhotosManagerProtocol)
    func viewDidLoad(collectionView: UICollectionView, id: Int?)
}

protocol RealmPhotosManagerProtocol {
    func updatePhotos(for userID: Int?, view: PhotosView)
}

class PhotosPresenter: PhotosPresenterProtocol {
    
    var view: PhotosView
    var pictures: Results<Picture>?
    var token: NotificationToken?
    var realmPhotosManagerProtocol: RealmPhotosManagerProtocol
    
    required init(view: PhotosView, realmPhotosManagerProtocol: RealmPhotosManagerProtocol) {
        self.view = view
        self.realmPhotosManagerProtocol = realmPhotosManagerProtocol
    }
    
    func viewDidLoad(collectionView: UICollectionView, id: Int?) {
        realmPhotosManagerProtocol.updatePhotos(for: id, view: view)
        pairTableAndRealm(collectionView: collectionView)
    }
    
    func pairTableAndRealm(collectionView: UICollectionView) {
        guard let realm = try? Realm() else { return }
        pictures = realm.objects(Picture.self)
        token = pictures?.observe({ changes in
        self.view.onItemsRetrieval(photos: self.pictures)
            
            switch changes {
            case .initial:
                
                collectionView.reloadData()
                
            case .update(_, deletions: _, insertions: _, modifications: let modifications):
                
                collectionView.performBatchUpdates({
                    
                    collectionView.reloadItems(at: modifications.map { IndexPath(row: $0, section: 0) })
                    
                }, completion: nil)
                
            case .error(let error):
                print(error.localizedDescription)
            }
        })
    }
    
}

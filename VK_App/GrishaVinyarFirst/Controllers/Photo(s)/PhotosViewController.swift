//
//  PhotosViewController.swift
//  GrishaVinyarFirst
//
//  Created by Григорий Виняр on 24.04.2021.
//

import UIKit
import RealmSwift

class PhotosViewController: UIViewController {
    
    //MARK: - Properties
    // id пользователя, на которого нажали
    var userID: Int = 0
    
    @IBOutlet var collectionView: UICollectionView!
    
    //MARK: - Properties
    let networkingService = NetworkingService()
    var token: NotificationToken?
    var pictures: Results<Picture>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        RealmManager().updatePhotos(for: userID)
        pairTableAndRealm()
        collectionView.register(UINib(nibName: "PhotoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "photoCell")
    }
    //MARK: - Methods
    func pairTableAndRealm() {
        guard let realm = try? Realm() else { return }
        pictures = realm.objects(Picture.self)
        token = pictures?.observe({ [weak self] changes in
            guard let strongSelf = self else { return }
            
            switch changes {
            case .initial:
                strongSelf.collectionView.reloadData()
                
            case .update(_, deletions: let deletions, insertions: let insertions, modifications: let modifications):
                
                strongSelf.collectionView.performBatchUpdates({
                    
                    strongSelf.collectionView.insertItems(at: insertions.map { IndexPath(row: $0, section: 0) })
                    strongSelf.collectionView.deleteItems(at: deletions.map { IndexPath(row: $0, section: 0) })
                    strongSelf.collectionView.reloadItems(at: modifications.map { IndexPath(row: $0, section: 0) })
                    
                }, completion: nil)
                
            case .error(let error):
                print(error.localizedDescription)
            }
        })
    }
}

//MARK: - UICollectionViewDelegate
extension PhotosViewController: UICollectionViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.collectionView.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.collectionView.transform = .identity
        }
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension PhotosViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        let spacing: CGFloat = 0
        return spacing
    }
}

//MARK: - UICollectionViewDataSource
extension PhotosViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let pictures = pictures else { return 0 }
        return pictures.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as? PhotoCollectionViewCell else { return UICollectionViewCell() }
        guard let pictures = pictures else { return UICollectionViewCell() }
        let imageView = UIImageView()
        let sizes = pictures[indexPath.row].sizes
        let pictureURL = sizes[indexPath.row].src
        
        imageView.sd_setImage(with: URL(string: pictureURL), placeholderImage: UIImage(systemName: "person"))
        
        cell.storageElementsForPhoto(image: imageView.image)
        
        cell.delegate = self
        
        return cell
    }
}

//MARK: - PhotoCollectionViewCellDelegate
extension PhotosViewController: PhotoCollectionViewCellDelegate {
    
    func likeAction(sender: UIButton, label: UILabel) {
        if sender.titleLabel?.text == "🤍" {
            sender.setTitle("❤️", for: .normal)
            label.text = "1"
        } else {
            sender.setTitle("🤍", for: .normal)
            label.text = "0"
        }
        
        UIView.animate(withDuration: 1,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 1,
                       options: .curveLinear) {
            sender.frame.size.height += 5
        } completion: { (_) in
            
        }
    }
}

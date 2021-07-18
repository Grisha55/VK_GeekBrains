//
//  PhotosViewController.swift
//  GrishaVinyarFirst
//
//  Created by Григорий Виняр on 24.04.2021.
//

import UIKit
import RealmSwift

protocol PhotosView {
    func onItemsRetrieval(photos: Results<Picture>?)
}

class PhotosViewController: UIViewController {
    
    //MARK: - Properties
    var userID: Int = 0
    
    @IBOutlet var collectionView: UICollectionView!
    
    //MARK: - Properties
    var token: NotificationToken?
    var pictures: Results<Picture>?
    var presenter: PhotosPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(UINib(nibName: "PhotoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "photoCell")
        
        presenter = PhotosPresenter(view: self, realmPhotosManagerProtocol: RealmManager())
        presenter.viewDidLoad(collectionView: collectionView, id: userID)
    }
}

extension PhotosViewController: PhotosView {
    func onItemsRetrieval(photos: Results<Picture>?) {
        self.pictures = photos
        collectionView.reloadData()
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
        let pictureURL = sizes[indexPath.row].url
        
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

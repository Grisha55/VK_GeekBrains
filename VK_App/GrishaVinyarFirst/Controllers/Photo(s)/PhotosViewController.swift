//
//  PhotosViewController.swift
//  GrishaVinyarFirst
//
//  Created by Григорий Виняр on 24.04.2021.
//

import UIKit

class PhotosViewController: UIViewController {

    var photosArray = [UIImage?]()
    
    let networkengMService = NetworkingService()
    
    @IBOutlet var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        networkengMService.getPhotos()
        
        collectionView.register(UINib(nibName: "PhotoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "photoCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        
    }
    
    func getImages(images: [UIImage?]) {
        self.photosArray = images
    }
}

// UICollectionViewDelegate
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

// UICollectionViewDelegateFlowLayout
extension PhotosViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        let spacing: CGFloat = 0
        return spacing
    }
}

 //UICollectionViewDataSource
extension PhotosViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photosArray.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as? PhotoCollectionViewCell else { return UICollectionViewCell() }

        cell.storageElementsForPhoto(image: photosArray[indexPath.row])

        cell.delegate = self

        return cell
    }
}

// PhotoCollectionViewCellDelegate
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

//
//  PhotosViewController.swift
//  GrishaVinyarFirst
//
//  Created by Григорий Виняр on 24.04.2021.
//

import UIKit

class PhotosViewController: UIViewController {
    
    let networkingService = NetworkingService()
    
    var pictures = [Picture]()
    
    // id пользователя, на которого нажали
    var userID: Int = 0
    
    @IBOutlet var collectionView: UICollectionView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Делаем запрос для получения фоток пользователя, на которого нажали
        networkingService.getPhotos(userID: userID) { [weak self] (result) in
            switch result {
            
            case .failure(let error):
                print(error.localizedDescription)
                
            case .success(let pictures):
                self?.pictures = pictures
                
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                }
            }
        }
        
        collectionView.register(UINib(nibName: "PhotoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "photoCell")
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
        
        return pictures.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as? PhotoCollectionViewCell else { return UICollectionViewCell() }
        
        let imageView = UIImageView()
        
        guard let sizes = pictures[indexPath.row].sizes else { return UICollectionViewCell() }
        
        guard let pictureURL = sizes[indexPath.row].src else { return UICollectionViewCell() }
        
        guard let url = URL(string: pictureURL) else { return UICollectionViewCell() }
        
        do {
            let data = try Data(contentsOf: url)
            
            imageView.image = UIImage(data: data)
            
            cell.storageElementsForPhoto(image: imageView.image)
        } catch {
            
            print(error.localizedDescription)
        }
        
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

//
//  FriendViewController.swift
//  GrishaVinyarFirst
//
//  Created by Григорий Виняр on 18.04.2021.
//

import UIKit
import RealmSwift
import SDWebImage

class FriendViewController: UIViewController {
    
   @IBOutlet weak var tableView: UITableView!
    
    // id друга
    var id = 0
    
    let networkingService = NetworkingService()
    
    var items: Results<Item>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pairTableWithRealm()
        tableView.register(FriendTableViewCell.self, forCellReuseIdentifier: "FriendCell")
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
    }
    
    func pairTableWithRealm() {
        do {
            RealmManager().getAllFriendsToBase()
            let realm = try Realm()
            self.items = realm.objects(Item.self)
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.tableView.reloadData()
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let destVC = segue.destination as? PhotosViewController else { return }
        
        // Передаем id пользователя на экран с его фотографиями
        destVC.userID = id
        RealmManager().updatePhotos(for: id)
    }
    
}
// MARK: - UITableViewDelegate
extension FriendViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0.5,
                       options: .curveEaseInOut) {
            self.tableView.cellForRow(at: indexPath)?.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        } completion: { _ in
            self.tableView.cellForRow(at: indexPath)?.transform = .identity
        }
        guard let items = items else { return }
        let item = items[indexPath.row]
        
        // Получаем id пользователя, который был выбран (на ячейку с именем которого нажали)
        id = item.id 
        
        performSegue(withIdentifier: "fromFriendsToPhotos", sender: self)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
}

// MARK: - UITableViewDataSource
extension FriendViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let items = items else { return 0 }
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath) as? FriendTableViewCell else { return UITableViewCell() }
        guard let items = items else { return UITableViewCell() }
        let item = items[indexPath.row]
        
        let imageView = UIImageView()
        
        imageView.sd_setImage(with: URL(string: item.photo_100), placeholderImage: UIImage(systemName: "person"))
        
        cell.configure(name: "\(item.firstName) \(item.lastName)" , photo: imageView.image)
        
        return cell
    }
    
}

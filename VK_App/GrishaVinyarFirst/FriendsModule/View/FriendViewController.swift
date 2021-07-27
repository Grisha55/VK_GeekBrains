//
//  FriendViewController.swift
//  GrishaVinyarFirst
//
//  Created by Григорий Виняр on 18.04.2021.
//

import UIKit
import RealmSwift
import SDWebImage

protocol FriendsView: AnyObject {
    func onItemsRetrieval(friends: List<Item>?)
}

class FriendViewController: UIViewController {
    
    //MARK: - Properties
   @IBOutlet weak var tableView: UITableView!
    
    // id друга
    var id = 0
    
    var token: NotificationToken?
    
    var items: List<Item>?
    
    var presenter: FriendsPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.register(FriendTableViewCell.self, forCellReuseIdentifier: "FriendCell")
        
        presenter = FriendsPresenter(view: self, realmService: RealmManager(), networkService: NetworkingService())
        presenter.viewDidLoad(tableView: tableView)
    }
    
    //MARK: - Methods
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let destVC = segue.destination as? PhotosViewController else { return }
        
        destVC.userID = id
    }
    
}
// MARK: - FriendsView
extension FriendViewController: FriendsView {
    
    func onItemsRetrieval(friends: List<Item>?) {
        self.items = friends
        tableView.reloadData()
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
        PhotosViewController().userID = id
        performSegue(withIdentifier: "fromFriendsToPhotos", sender: self)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
}

// MARK: - UITableViewDataSource
extension FriendViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let items = items else { return 0 }
        return items.count
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard let cell = cell as? FriendTableViewCell else { return }
        
        guard let items = items else { return }
        
        let item = items[indexPath.row]
        
        guard let url = URL(string: item.photo_100) else { return }
        
        cell.configure(name: "\(item.firstName) \(item.lastName)" , url: url)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath) as? FriendTableViewCell else { return UITableViewCell() }
        
        return cell
    }
    
}

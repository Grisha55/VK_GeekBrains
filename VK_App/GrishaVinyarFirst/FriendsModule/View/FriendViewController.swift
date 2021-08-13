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
    
    //MARK: - Properties
   @IBOutlet weak var tableView: UITableView!
    
    private let friendViewModelFactory = FriendViewModelFactory()
    
    // id друга
    var id = 0
    
    private var friends = [SimpleFriend]()
    
    private var friendViewModels = [FriendViewModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.register(FriendTableViewCell.self, forCellReuseIdentifier: "FriendCell")
        
        FriendAdapter().getFriends { [weak self] (friends) in
            guard let self = self else { return }
            self.friends = friends
            self.friendViewModels = self.friendViewModelFactory.constructFriendViewModels(friends: friends)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        }
    }
    
    //MARK: - Methods
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let destVC = segue.destination as? PhotosViewController else { return }
        
        destVC.userID = id
    }
    
}
// MARK: - FriendsView


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
        let friend = friends[indexPath.row]
        
        // Получаем id пользователя, который был выбран (на ячейку с именем которого нажали)
        id = friend.id
        
        performSegue(withIdentifier: "fromFriendsToPhotos", sender: self)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
}

// MARK: - UITableViewDataSource
extension FriendViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath) as? FriendTableViewCell else { return UITableViewCell() }
        
        let friendViewModel = self.friendViewModels[indexPath.row]
        
        cell.configure(friendViewModel: friendViewModel)
        
        return cell
    }
    
}

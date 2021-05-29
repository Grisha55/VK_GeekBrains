//
//  FriendViewController.swift
//  GrishaVinyarFirst
//
//  Created by Григорий Виняр on 18.04.2021.
//

import UIKit

class FriendViewController: UIViewController {
    
   @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var lettersView: UIView!
    
    @IBOutlet weak var stackWithLetters: UIStackView!
    
    // id друга
    var id = 0
    
    let networkingService = NetworkingService()
    
    private var lettersArray = [String]()
    
    private var buttonsArray = [UIButton]()
    
    var items = [Item]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Получаем данные о всех друзьях пользователя
        networkingService.getFriends { [weak self] (result) in
            switch result {
            
            case .failure(let error):
                print(error.localizedDescription)
                
            case .success(let users):
                
                self?.items = users
                
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
                
            }
        }
        
        tableView.register(FriendTableViewCell.self, forCellReuseIdentifier: "FriendCell")
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let destVC = segue.destination as? PhotosViewController else { return }
        
        // Передаем id пользователя на экран с его фотографиями
        destVC.userID = id
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
        
        let item = items[indexPath.row]
        
        // Получаем id пользователя, который был выбран (на ячейку с именем которого нажали)
        id = item.id ?? 0
        
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
        return items.count
    }
    
    /*func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        let item = items[section]
        
        guard let letter = item.lastName?.first else {return "" }
        
        return String(letter)
    }*/
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath) as? FriendTableViewCell else { return UITableViewCell() }
        
        let item = items[indexPath.row]
        
        let imageView = UIImageView()
        
        guard let photoString = item.photo_100 else { return UITableViewCell() }
        
        guard let url = URL(string: photoString) else { return UITableViewCell() }
        
        do {
            let data = try Data(contentsOf: url)
            
            imageView.image = UIImage(data: data)
            
        } catch {
            
            print(error.localizedDescription)
        }
        
        cell.configure(name: item.lastName ?? "No name" , photo: imageView.image)
        
        return cell
    }
    
}

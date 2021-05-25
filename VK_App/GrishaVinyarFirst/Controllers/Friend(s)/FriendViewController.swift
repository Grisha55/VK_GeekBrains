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
    
    let networkingService = NetworkingService()
    
    private var lettersArray = [String]()
    
    private var buttonsArray = [UIButton]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        networkingService.getFriends()
        
        tableView.register(FriendTableViewCell.self, forCellReuseIdentifier: "FriendCell")
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        setupLettersArray()
        createButtons()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destVC = segue.destination as? PhotosViewController else { return }
        guard let user = sender as? User else { return }
        destVC.getImages(images: user.photosArray)
    }
    
    func createButtons() {
        for letter in lettersArray {
            let button = UIButton()
            button.setTitle(letter, for: .normal)
            button.setTitleColor(.black, for: .normal)
            button.addTarget(self, action: #selector(chooseLetter(button:)), for: .touchUpInside)
            buttonsArray.append(button)
            stackWithLetters.addArrangedSubview(button)
        }
    }
    
    @objc func chooseLetter(button: UIButton) {
        let section = buttonsArray.firstIndex(of: button)
        self.tableView.scrollToRow(at: IndexPath(row: 0, section: Int(section!)), at: .none, animated: true)
    }
    
    func setupLettersArray() {
        for usersArray in DataStorage.shared.arrayOfArraysOfFriends {
            guard let user = usersArray.first else { return }
            guard let letter = user.name.first else { return }
            lettersArray.append(String(letter))
        }
    }
}
// MARK: - UITableViewDelegate
extension FriendViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let user = DataStorage.shared.arrayOfArraysOfFriends[indexPath.section][indexPath.row]
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0.5,
                       options: .curveEaseInOut) {
            self.tableView.cellForRow(at: indexPath)?.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        } completion: { _ in
            self.tableView.cellForRow(at: indexPath)?.transform = .identity
        }

        performSegue(withIdentifier: "fromFriendsToPhotos", sender: user)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
}

// MARK: - UITableViewDataSource
extension FriendViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return DataStorage.shared.arrayOfArraysOfFriends.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataStorage.shared.arrayOfArraysOfFriends[section].count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        let usersArray = DataStorage.shared.arrayOfArraysOfFriends[section].first
        
        guard let letter = usersArray?.name.first else {return "" }
        
        return String(letter)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath) as? FriendTableViewCell else { return UITableViewCell() }
        
        let user = DataStorage.shared.arrayOfArraysOfFriends[indexPath.section][indexPath.row]
        
        cell.configure(name: user.name , photo: user.avatar)
        
        return cell
    }
    
}

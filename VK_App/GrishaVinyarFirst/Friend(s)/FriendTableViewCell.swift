//
//  FriendTableViewCell.swift
//  GrishaVinyarFirst
//
//  Created by Григорий Виняр on 09.04.2021.
//
import UIKit

class FriendTableViewCell: UITableViewCell {

    @IBOutlet weak var nameOfFriendLabel: UILabel!
    
    @IBOutlet weak var photoOfFriend: MyCustomImageView!
    
    @IBOutlet weak var photoView: MyCustomView!
    
    func nilComponentsForFriend() {
        self.nameOfFriendLabel.text = nil
        self.photoOfFriend.image = nil
        self.photoView = nil
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.photoOfFriend.contentMode = .scaleToFill
        nilComponentsForFriend()
    }
    
    func tapPhoto() {
        self.photoOfFriend.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(animationForPhoto))
        self.photoOfFriend.addGestureRecognizer(gesture)
    }
    
    @objc func animationForPhoto() {
        UIView.animate(withDuration: 1,
                       delay: 1,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 1,
                       options: .curveEaseInOut)
        { [weak self] in
            self?.photoOfFriend.frame.size.width += 10
            self?.photoOfFriend.frame.size.height += 10
        } completion: { (_) in
            
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nilComponentsForFriend()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        tapPhoto()
    }
    
    func storageElementsForFriend(name: String, image: UIImage?) {
        self.nameOfFriendLabel.text = name
        self.photoOfFriend.image = image
    }
}

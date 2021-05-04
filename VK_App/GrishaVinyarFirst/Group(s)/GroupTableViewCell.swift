//
//  GroupTableViewCell.swift
//  GrishaVinyarFirst
//
//  Created by Григорий Виняр on 09.04.2021.
//

import UIKit

class GroupTableViewCell: UITableViewCell {

    @IBOutlet weak var groupLabel: UILabel!
    
    @IBOutlet weak var groupImage: UIImageView!
    
    func nilComponentsForGroup() {
        self.groupLabel.text = nil
        self.groupImage.image = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        nilComponentsForGroup()
        tapGroupImage()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nilComponentsForGroup()
    }

    func tapGroupImage() {
        self.groupImage.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(animationForGroupImage))
        groupImage.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func animationForGroupImage() {
        UIView.animate(withDuration: 2,
                       delay: 0.5,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 1,
                       options: .curveEaseInOut)
        { [weak self] in
            self?.groupImage.frame.size.width += 10
            self?.groupImage.frame.size.height += 10
        } completion: { (_) in
            
        }

    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func storageElementsForGroup(groupLabel: String, groupImage: UIImage?) {
        self.groupLabel.text = groupLabel
        self.groupImage.image = groupImage
    }
    
}

//
//  MessageTableViewCell.swift
//  GrishaVinyarFirst
//
//  Created by Григорий Виняр on 21.04.2021.
//

import UIKit

class MessageTableViewCell: UITableViewCell {

    @IBOutlet weak var photo: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    func clearCell() {
        photo.image = nil
        nameLabel.text = nil
    }
    
    func makeAvatarCircle() {
        photo.layer.cornerRadius = photo.frame.width / 2
        photo.contentMode = .scaleToFill
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        clearCell()
        makeAvatarCircle()
    }

    override func prepareForReuse() {
        clearCell()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func configureCell(photo: UIImage?, name: String) {
        self.photo.image = photo
        self.nameLabel.text = name
    }
    
}

//
//  NewsCell.swift
//  GrishaVinyarFirst
//
//  Created by Григорий Виняр on 04.05.2021.
//

import UIKit

class NewsCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var photoImage: UIImageView!
    
    func update() {
        self.nameLabel.text = nil
        self.photoImage.image = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        update()
    }
    
    override func prepareForReuse() {
        update()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(name: String, photo: UIImage?) {
        self.nameLabel.text = name
        self.photoImage.image = photo
    }
    
}

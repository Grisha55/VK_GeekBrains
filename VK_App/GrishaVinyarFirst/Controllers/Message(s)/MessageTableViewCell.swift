//
//  MessageTableViewCell.swift
//  GrishaVinyarFirst
//
//  Created by Григорий Виняр on 21.04.2021.
//

import UIKit

class MessageTableViewCell: UITableViewCell {
    
    private let photoImage: UIImageView = {
        let photo = UIImageView()
        photo.layer.cornerRadius = photo.frame.width / 2
        photo.translatesAutoresizingMaskIntoConstraints = false
        return photo
    }()
    
    private let nameLabel: UILabel = {
        let name = UILabel()
        name.adjustsFontSizeToFitWidth = true
        name.numberOfLines = 0
        name.translatesAutoresizingMaskIntoConstraints = false
        name.text = "Good for you"
        return name
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(photoImage)
        addSubview(nameLabel)
        setPhotoImageConstraints()
        setNameLabelConstraints()
    }
    
    func setPhotoImageConstraints() {
        photoImage.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive             = true
        photoImage.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive      = true
        photoImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive     = true
        photoImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -200).isActive = true
    }
    
    func setNameLabelConstraints() {
        nameLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive                           = true
        nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive          = true
        nameLabel.leadingAnchor.constraint(equalTo: photoImage.trailingAnchor, constant: 10).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(photo: UIImage?, name: String) {
        self.photoImage.image = photo
        self.nameLabel.text = name
    }
    
}

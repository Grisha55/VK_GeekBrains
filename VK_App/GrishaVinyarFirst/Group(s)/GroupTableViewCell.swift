//
//  GroupTableViewCell.swift
//  GrishaVinyarFirst
//
//  Created by Григорий Виняр on 09.04.2021.
//

import UIKit

class GroupTableViewCell: UITableViewCell {

    private let nameLabel: UILabel = {
        let name = UILabel()
        name.textColor = .black
        name.numberOfLines = 0
        name.translatesAutoresizingMaskIntoConstraints = false
        return name
    }()
    
    private let groupImage: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 20
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(nameLabel)
        contentView.addSubview(groupImage)
        setupNameLabel()
        setupGroupImage()
    }
    
    func setupNameLabel() {
        nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive               = true
    }
    
    func setupGroupImage() {
        groupImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
        groupImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive                  = true
        groupImage.widthAnchor.constraint(equalToConstant: 150).isActive                                  = true
        groupImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive            = true
    }
    
    override func prepareForReuse() {
        self.nameLabel.text = nil
        self.groupImage.image = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func storageElementsForGroup(groupLabel: String, groupImage: UIImage?) {
        self.nameLabel.text = groupLabel
        self.groupImage.image = groupImage
    }
    
}

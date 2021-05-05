//
//  FriendTableViewCell.swift
//  GrishaVinyarFirst
//
//  Created by Григорий Виняр on 09.04.2021.
//
import UIKit

class FriendTableViewCell: UITableViewCell {

    private let nameLabel: UILabel = {
        let name = UILabel()
        name.adjustsFontSizeToFitWidth = true
        name.numberOfLines = 0
        name.translatesAutoresizingMaskIntoConstraints = false
        return name
    }()
    
    private let photoImage: UIImageView = {
        let photo = UIImageView()
        photo.clipsToBounds = true
        photo.layer.masksToBounds = true
        photo.layer.cornerRadius = 40
        photo.translatesAutoresizingMaskIntoConstraints = false
        return photo
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(nameLabel)
        addSubview(photoImage)
        setupNameLabel()
        setupPhotoImage()
        animatePhotoImage()
        
    }
    
    func setupNameLabel() {
        nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    func setupPhotoImage() {
        photoImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
        photoImage.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        photoImage.widthAnchor.constraint(equalToConstant: 80).isActive = true
        photoImage.heightAnchor.constraint(equalToConstant: 80).isActive = true
    }
    
    func animatePhotoImage() {
        self.photoImage.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tapPhoto))
        self.photoImage.addGestureRecognizer(gesture)
    }
    
    @objc func tapPhoto() {
        UIView.animate(withDuration: 2.0,
                       animations: { [weak self] in
                        self?.photoImage.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                       },
                       completion: { [weak self] _ in
                        self?.photoImage.transform = .identity
                       })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        self.nameLabel.text = nil
        self.photoImage.image = nil
    }
    
    func configure(name: String, photo: UIImage?) {
        self.nameLabel.text = name
        self.photoImage.image = photo
    }
    
}

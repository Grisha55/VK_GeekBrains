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
        name.textColor = .black
        name.translatesAutoresizingMaskIntoConstraints = false
        return name
    }()
    
    private let photoImage: UIImageView = {
        let photo = UIImageView()
        photo.clipsToBounds = true
        photo.layer.masksToBounds = true
        photo.layer.cornerRadius = 40
        photo.layer.borderWidth = 5
        photo.layer.borderColor = UIColor.black.cgColor
        photo.translatesAutoresizingMaskIntoConstraints = false
        return photo
    }()
    
    private let shadowView: UIView = {
        let shadowView = UIView()
        shadowView.translatesAutoresizingMaskIntoConstraints = false
        shadowView.layer.shadowRadius = 5.0
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowOpacity = 1
        shadowView.layer.shadowOffset = .zero
        return shadowView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(nameLabel)
        contentView.addSubview(shadowView)
        shadowView.addSubview(photoImage)
        setupNameLabel()
        setupShadow()
        animatePhotoImage()
        setupPhotoImage()
        
    }
    
    func setupPhotoImage() {
        photoImage.trailingAnchor.constraint(equalTo: shadowView.trailingAnchor).isActive = true
        photoImage.leadingAnchor.constraint(equalTo: shadowView.leadingAnchor).isActive   = true
        photoImage.bottomAnchor.constraint(equalTo: shadowView.bottomAnchor).isActive     = true
        photoImage.topAnchor.constraint(equalTo: shadowView.topAnchor).isActive           = true
    }
    
    func setupNameLabel() {
        nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive               = true
    }
    
    func setupShadow() {
        shadowView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
        shadowView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive                  = true
        shadowView.widthAnchor.constraint(equalToConstant: 80).isActive                                   = true
        shadowView.heightAnchor.constraint(equalToConstant: 80).isActive                                  = true
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

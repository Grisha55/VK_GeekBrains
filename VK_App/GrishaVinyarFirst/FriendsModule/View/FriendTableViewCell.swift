//
//  FriendTableViewCell.swift
//  GrishaVinyarFirst
//
//  Created by Григорий Виняр on 09.04.2021.
//
import UIKit

class FriendTableViewCell: UITableViewCell {
    
    //MARK: - Properties
    private var urlOfPhoto: URL?
    
    private let nameLabel: UILabel = {
        let name = UILabel()
        name.backgroundColor = .white
        name.adjustsFontSizeToFitWidth = true
        name.numberOfLines = 0
        name.textColor = .black
        name.translatesAutoresizingMaskIntoConstraints = false
        return name
    }()
    
    private let photoImage: UIImageView = {
        let photo = UIImageView()
        photo.backgroundColor = .white
        photo.clipsToBounds = true
        photo.layer.masksToBounds = true
        photo.layer.cornerRadius = 40
        photo.layer.borderWidth = 3
        photo.layer.borderColor = UIColor.cyan.cgColor
        photo.translatesAutoresizingMaskIntoConstraints = false
        return photo
    }()
    
    private let shadowView: UIView = {
        let shadowView = UIView()
        shadowView.translatesAutoresizingMaskIntoConstraints = false
        shadowView.layer.shadowRadius = 5.0
        shadowView.layer.shadowColor = UIColor.purple.cgColor
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
    // Констрейнты для photoImage
    func setupPhotoImage() {
        photoImage.trailingAnchor.constraint(equalTo: shadowView.trailingAnchor).isActive = true
        photoImage.leadingAnchor.constraint(equalTo: shadowView.leadingAnchor).isActive   = true
        photoImage.bottomAnchor.constraint(equalTo: shadowView.bottomAnchor).isActive     = true
        photoImage.topAnchor.constraint(equalTo: shadowView.topAnchor).isActive           = true
    }
    // Констрейнты для nameLabel
    func setupNameLabel() {
        nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive               = true
    }
    // Констрейнты для shadowView
    func setupShadow() {
        shadowView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
        shadowView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive                  = true
        shadowView.widthAnchor.constraint(equalToConstant: 80).isActive                                   = true
        shadowView.heightAnchor.constraint(equalToConstant: 80).isActive                                  = true
    }
    // Констрейнты для photoImage и настройка обработчика нажатий
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
    // Соединение таблицы и ячейки
    func configure(friendViewModel: FriendViewModel) {
        self.nameLabel.text = friendViewModel.fullName
        self.urlOfPhoto = friendViewModel.photoURL
        guard let url = urlOfPhoto else { return }
        photoImage.setImage(at: url)
    }
    
}

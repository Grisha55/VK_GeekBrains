//
//  PhotoCollectionViewCell.swift
//  GrishaVinyarFirst
//
//  Created by Григорий Виняр on 09.04.2021.
//

import UIKit

//MARK: - PhotoCollectionViewCellDelegate
protocol PhotoCollectionViewCellDelegate: AnyObject {
    func likeAction(sender: UIButton, label: UILabel)
}

class PhotoCollectionViewCell: UICollectionViewCell {

    //MARK: Properties
    @IBOutlet weak var photoImage: UIImageView!
    @IBOutlet weak var likeView: UIView!
    @IBOutlet weak var labelForLikes: UILabel!
    @IBOutlet weak var buttonLove: UIButton!
    @IBOutlet weak var stackView: UIStackView!
    
    weak var delegate: PhotoCollectionViewCellDelegate?

    // Настройка photoImage
    func makeBeautifulPhoto() {
        self.photoImage.layer.cornerRadius = 20
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        makeBeautifulPhoto()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.photoImage.image = nil
    }

    // Соединяем ячейку и коллекцию
    func storageElementsForPhoto(image: UIImage?) {
        self.photoImage.image = image
    }
    
    //MARK: - Methods
    @IBAction func buttonLike(_ button: UIButton) {
        self.delegate?.likeAction(sender: button, label: labelForLikes)

    }
    

}

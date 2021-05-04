//
//  PhotoCollectionViewCell.swift
//  GrishaVinyarFirst
//
//  Created by Григорий Виняр on 09.04.2021.
//

import UIKit

protocol PhotoCollectionViewCellDelegate: AnyObject {
    func likeAction(sender: UIButton, label: UILabel)
}

class PhotoCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var photoImage: UIImageView!
    @IBOutlet weak var likeView: UIView!
    @IBOutlet weak var labelForLikes: UILabel!
    @IBOutlet weak var buttonLove: UIButton!
    @IBOutlet weak var stackView: UIStackView!
    
    weak var delegate: PhotoCollectionViewCellDelegate?
    
    func nilComponentsForPhoto() {
        self.photoImage.image = nil
    }

    func makeBeautifulPhoto() {
        self.photoImage.layer.cornerRadius = 20
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        nilComponentsForPhoto()
        makeBeautifulPhoto()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        nilComponentsForPhoto()
    }

    func storageElementsForPhoto(image: UIImage?) {
        self.photoImage.image = image
    }

    @IBAction func buttonLike(_ button: UIButton) {
        self.delegate?.likeAction(sender: button, label: labelForLikes)

    }
    

}

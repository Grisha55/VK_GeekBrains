//
//  NewsTableViewCell.swift
//  GrishaVinyarFirst
//
//  Created by Григорий Виняр on 20.04.2021.
//

import UIKit

protocol NewsTableViewCellDelegate: AnyObject {
    func likesAction(sender: UIButton, label: UILabel)
    func commentsAction(label: UILabel)
    func shareAction(label: UILabel)
}

class NewsTableViewCell: UITableViewCell {

    @IBOutlet weak var viewDownTheImage: UIView!
    
    @IBOutlet weak var imageViewForPhotoOfGroup: UIImageView!
    
    @IBOutlet weak var labelForImage: UILabel!
    
    @IBOutlet weak var bigText: UITextView!
    
    @IBOutlet weak var bigImage: UIImageView!
    
    @IBOutlet weak var secondBigImage: UIImageView!
    
    weak var delegate: NewsTableViewCellDelegate?
    
    
    @IBOutlet weak var labelToLikes: UILabel!
    
    @IBOutlet weak var labelToComments: UILabel!
    
    @IBOutlet weak var labelToShare: UILabel!
    
    func shadowForImage() {
        imageViewForPhotoOfGroup.layer.shadowColor = UIColor.black.cgColor
        imageViewForPhotoOfGroup.layer.shadowRadius = 15
        imageViewForPhotoOfGroup.layer.shadowOpacity = 1
        imageViewForPhotoOfGroup.layer.shadowOffset = .zero
    }
    
    
    func clearCell() {
        viewDownTheImage = nil
        imageViewForPhotoOfGroup.image = nil
        labelForImage.text = nil
        bigText.text = nil
        bigImage.image = nil
        secondBigImage.image = nil
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        clearCell()
        makeCircleImage()
        shadowForImage()
    }

    override func prepareForReuse() {
        clearCell()
    }
    
    func makeCircleImage() {
        imageViewForPhotoOfGroup.layer.cornerRadius = imageViewForPhotoOfGroup.frame.width / 2
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func likeAction(_ sender: UIButton) {
        delegate?.likesAction(sender: sender, label: labelToLikes)
    }
    
    @IBAction func commentsAction(_ sender: UIButton) {
        delegate?.commentsAction(label: labelToComments)
    }
    
    @IBAction func shareAction(_ sender: UIButton) {
        delegate?.shareAction(label: labelToShare)
    }
    
    func configure(imageForPhoto: UIImage?, labelForImage: String, bigText: String, bigImage: UIImage?, secondBigImage: UIImage?) {
        self.imageViewForPhotoOfGroup.image = imageForPhoto
        self.labelForImage.text = labelForImage
        self.bigText.text = bigText
        self.bigImage.image = bigImage
        self.secondBigImage.image = secondBigImage
    }
    
}

//
//  LikesAndCommentsCell.swift
//  GrishaVinyarFirst
//
//  Created by Григорий Виняр on 06.07.2021.
//

import UIKit

class LikesAndCommentsCell: UITableViewCell {

    // MARK: - Properties
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!
    @IBOutlet weak var likesCountLabel: UILabel!
    @IBOutlet weak var commentsCountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(likesCount: Int, commentsCount: Int) {
        self.likesCountLabel.text = String(likesCount)
        self.commentsCountLabel.text = String(commentsCount)
        likesLabel.text = "Likes: "
        commentsLabel.text = "Comments: "
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        likesLabel.text = nil
        commentsLabel.text = nil
        likesCountLabel.text = nil
        commentsCountLabel.text = nil
    }
    
}

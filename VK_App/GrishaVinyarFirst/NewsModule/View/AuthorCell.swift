//
//  AuthorCell.swift
//  GrishaVinyarFirst
//
//  Created by Григорий Виняр on 06.07.2021.
//

import UIKit

class AuthorCell: UITableViewCell {

    @IBOutlet weak var authorImageView: UIImageView!
    
    @IBOutlet weak var dataLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureAuthorCell(authorImageURL: URL, data: String) {
        self.authorImageView.setImage(at: authorImageURL)
        self.dataLabel.text = data
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.authorImageView.image = nil
        self.dataLabel.text = nil
    }
    
}

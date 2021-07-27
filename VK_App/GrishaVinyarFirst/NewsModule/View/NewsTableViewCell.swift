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
    
    @IBOutlet weak var bigText: UILabel!
    
    func clearCell() {
        bigText.text = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        clearCell()
        
    }

    override func prepareForReuse() {
        clearCell()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(bigText: String) {
        self.bigText.text = bigText
    }
    
}

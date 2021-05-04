//
//  MyCustomImageView.swift
//  GrishaVinyarFirst
//
//  Created by Григорий Виняр on 16.04.2021.
//

import UIKit

@IBDesignable class MyCustomImageView: UIImageView {
    
    override init(image: UIImage?) {
        super.init(image: image)
        
        settings()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        settings()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        settings()
    }
    
    func settings() {
        
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 4
        self.layer.cornerRadius = 43
        
    }
        
}

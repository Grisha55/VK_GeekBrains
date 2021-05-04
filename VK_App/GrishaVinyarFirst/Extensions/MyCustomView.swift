//
//  MyCustomView.swift
//  GrishaVinyarFirst
//
//  Created by Григорий Виняр on 17.04.2021.
//

import UIKit

@IBDesignable class MyCustomView: UIView {

    // Изменение цвета тени
    @IBInspectable var shadowColor: UIColor? {
        get {
            return UIColor(cgColor: self.layer.shadowColor!)
        }
        set {
            self.layer.shadowColor = newValue?.cgColor
        }
    }
    
    // Изменение радиуса тени
    @IBInspectable var shadowRadius: CGFloat {
        get {
            return CGFloat(self.layer.shadowRadius)
        }
        set {
            self.layer.shadowRadius = newValue
        }
    }
    
    // Изменение прозрачности тени
    @IBInspectable var shadowOpacity: Float {
        get {
            return self.layer.shadowOpacity
        }
        set {
            self.layer.shadowOpacity = newValue
        }
        
    }
    
    // Изменение смещения цвета
    @IBInspectable var shadowOffset: CGSize {
        get {
            return self.layer.shadowOffset
        }
        set {
            self.layer.shadowOffset = newValue
        }
    }
    
    
    
    // MARK: Если настроить эти методы здесь, то в storyboard это сделать уже будет нельзя
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        //self.layer.shadowColor = UIColor.black.cgColor
        //self.layer.shadowRadius = 10
        //self.layer.shadowOpacity = 1
        //self.layer.shadowOffset = .zero
        
    }
    

}

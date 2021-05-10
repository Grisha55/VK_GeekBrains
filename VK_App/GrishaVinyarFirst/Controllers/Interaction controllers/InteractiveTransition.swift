//
//  IntiractiveTransition.swift
//  GrishaVinyarFirst
//
//  Created by Григорий Виняр on 29.04.2021.
//

import UIKit

class InteractiveTransition: UIPercentDrivenInteractiveTransition {
    var hasStarted = false
    var hasStopped = false
    
    var viewController: UIViewController! {
        didSet {
            let recognizer = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(onPan(recognizer:)))
            recognizer.edges = .left
            self.viewController?.view.addGestureRecognizer(recognizer)
        }
    }
    
    @objc func onPan(recognizer: UIScreenEdgePanGestureRecognizer) {
        
        switch recognizer.state {
        case .began:
            hasStarted = true
            viewController.navigationController?.popViewController(animated: true)
        case .changed:
            let translation = recognizer.translation(in: recognizer.view)
            let relativeTranslation = abs(translation.x) / 50
            let progress = max(0, min(1, relativeTranslation))
            
            hasStopped = progress > 0.35
            update(progress)
        case .cancelled:
            hasStarted = false
            cancel()
        case .ended:
            hasStarted = false
            hasStopped ? finish() : cancel()
        default:
            break
        }
    }
}

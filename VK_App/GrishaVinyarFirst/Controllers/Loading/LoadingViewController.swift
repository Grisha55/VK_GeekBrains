//
//  LaunchScreenController.swift
//  GrishaVinyarFirst
//
//  Created by Григорий Виняр on 23.04.2021.
//

import UIKit

class LoadingViewController: UIViewController {

    @IBOutlet weak var cloudView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pathAnimation()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let loginVC = storyboard.instantiateViewController(identifier: "loginVC")
            loginVC.modalTransitionStyle = .flipHorizontal
            loginVC.modalPresentationStyle = .fullScreen
            self.present(loginVC, animated: true, completion: nil)
        })
    }
    
    func pathAnimation(){
    
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 10, y: 60))
        path.addQuadCurve(to: CGPoint(x: 20, y: 40), controlPoint: CGPoint(x: 5, y: 50))
        path.addQuadCurve(to: CGPoint(x: 40, y: 20), controlPoint: CGPoint(x: 20, y: 20))
        path.addQuadCurve(to: CGPoint(x: 70, y: 20), controlPoint: CGPoint(x: 55, y: 0))
        path.addQuadCurve(to: CGPoint(x: 80, y: 30), controlPoint: CGPoint(x: 80, y: 20))
        path.addQuadCurve(to: CGPoint(x: 110, y: 60), controlPoint: CGPoint(x: 110, y: 30))
        path.close()

        let layerAnimation = CAShapeLayer()
        layerAnimation.path = path.cgPath
        layerAnimation.strokeColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        layerAnimation.fillColor = UIColor.clear.cgColor
        layerAnimation.lineWidth = 8
        layerAnimation.lineCap = .round

        cloudView.layer.addSublayer(layerAnimation)
        
        let pathAnimationEnd = CABasicAnimation(keyPath: "strokeEnd")
        pathAnimationEnd.fromValue = 0
        pathAnimationEnd.toValue = 1
        pathAnimationEnd.duration = 2
        pathAnimationEnd.fillMode = .both
        pathAnimationEnd.isRemovedOnCompletion = false
        layerAnimation.add(pathAnimationEnd, forKey: nil)
        
        let pathAnimationStart = CABasicAnimation(keyPath: "strokeStart")
        pathAnimationStart.fromValue = 0
        pathAnimationStart.toValue = 1
        pathAnimationStart.duration = 2
        pathAnimationStart.fillMode = .both
        pathAnimationStart.isRemovedOnCompletion = false
        pathAnimationStart.beginTime = 1
        
        let animationGroup = CAAnimationGroup()
        animationGroup.duration = 3
        animationGroup.fillMode = CAMediaTimingFillMode.backwards
        animationGroup.animations = [pathAnimationEnd, pathAnimationStart]
        animationGroup.repeatCount = .infinity
        layerAnimation.add(animationGroup, forKey: nil)

    }
}

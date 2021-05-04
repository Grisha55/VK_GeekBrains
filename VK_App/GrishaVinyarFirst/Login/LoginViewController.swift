//
//  ViewController.swift
//  GrishaVinyarFirst
//
//  Created by Григорий Виняр on 03.04.2021.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var loginLabel: UILabel!
    
    @IBOutlet weak var passwordLabel: UILabel!
    
    @IBOutlet weak var loginInput: UITextField!
    var login = ""
    
    @IBOutlet weak var passwordInput: UITextField!
    var password = ""
    
    @IBOutlet weak var buttonIn: UIButton!
    
    let fromLoginToTabBar = "fromLoginToTabBar"
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Подписываемся на два уведомления: одно приходит при появлении клавиатуры
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWasShown), name: UIResponder.keyboardWillShowNotification, object: nil)
        // Второе — когда она пропадает
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillBeHidden(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        labelsAnimation()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Жест нажатия
        let hideKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        // Присваиваем его UIScrollVIew
        scrollView?.addGestureRecognizer(hideKeyboardGesture)
        
        updateText()
        
        self.buttonIn.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(buttonAnimation(recognizer:))))
    }
    
    @objc func buttonAnimation(recognizer: UIPanGestureRecognizer) {
        if recognizer.state == .began {
            print("User start the animation")

        } else if recognizer.state == .changed {
            let translation = recognizer.translation(in: self.view)
            buttonIn.transform = CGAffineTransform(translationX: 0, y: translation.y)
            
        } else if recognizer.state == .ended {
            UIView.animate(withDuration: 2,
                           delay: 0,
                           usingSpringWithDamping: 0.5,
                           initialSpringVelocity: 0.5,
                           options: .curveEaseInOut,
                           animations: {
                            self.buttonIn.transform = .identity
                           },
                           completion: nil)
        }
    }
    
    func labelsAnimation() {
        
        let offset = abs(self.loginLabel.center.y - self.passwordLabel.center.y)
        self.loginLabel.transform = CGAffineTransform(translationX: 0, y: offset)
        self.passwordLabel.transform = CGAffineTransform(translationX: 0, y: -offset)
        
        UIView.animateKeyframes(withDuration: 4,
                                delay: 1,
                                options: .calculationModePaced) {
            
            UIView.addKeyframe(withRelativeStartTime: 1,
                               relativeDuration: 2) {
                self.loginLabel.transform = CGAffineTransform(translationX: 150, y: offset / 2)
                self.passwordLabel.transform = CGAffineTransform(translationX: -150, y: -(offset / 2))
            }
            
            UIView.addKeyframe(withRelativeStartTime: 1.5,
                               relativeDuration: 2) {
                self.loginLabel.transform = .identity
                self.passwordLabel.transform = .identity
            }
        }
    }
    
    func updateText() {
        login = loginInput.text ?? ""
        password = passwordInput.text ?? ""
    }
    
    // Когда клавиатура появляется
    @objc func keyboardWasShown(notification: Notification) {
        
        // Получаем размер клавиатуры
        let info = notification.userInfo! as NSDictionary
        let kbSize = (info.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue).cgRectValue.size
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: kbSize.height, right: 0.0)
        
        // Добавляем отступ внизу UIScrollView, равный размеру клавиатуры
        self.scrollView?.contentInset = contentInsets
        scrollView?.scrollIndicatorInsets = contentInsets
    }
    
    //Когда клавиатура исчезает
    @objc func keyboardWillBeHidden(notification: Notification) {
        // Устанавливаем отступ внизу UIScrollView, равный 0
        let contentInsets = UIEdgeInsets.zero
        scrollView?.contentInset = contentInsets
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func hideKeyboard() {
        self.scrollView?.endEditing(true)
    }
    
    @IBAction func didButtonTap() {
        updateText()
        
        guard login == "admin", password == "123456" else {
            showAlert()
            return
        }
        performSegue(withIdentifier: fromLoginToTabBar, sender: self)
    }
    
    func showAlert() {
        let alertController = UIAlertController(title: "Ошибка", message: "Неверный логин или пароль", preferredStyle: .alert)
        let action = UIAlertAction(title: "Закрыть", style: .cancel, handler: nil)
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
    } 
}

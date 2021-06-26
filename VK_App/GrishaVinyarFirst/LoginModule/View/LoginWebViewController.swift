//
//  LoginWebViewController.swift
//  GrishaVinyarFirst
//
//  Created by Григорий Виняр on 25.05.2021.
//

import UIKit
import WebKit

class LoginWebViewController: UIViewController {
    
    //MARK: - Properties
    let networkingConstanse = NetworkingConstans()
    
    @IBOutlet weak var webView: WKWebView! {
        didSet {
            webView.navigationDelegate = self
        }
    }
    
    var presenter: LoginPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = LoginPresenter(view: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let token = UserDefaults.standard.string(forKey: "Token"),
           let userID = UserDefaults.standard.string(forKey: "UserID") {
            
            SessionApp.shared.token = token
            SessionApp.shared.userID = Int(userID)
            
            performSegue(withIdentifier: "toTabBar", sender: self)
        }
        presenter?.logInToApp(webView: webView)
    }
}

//MARK: - WKNavigationDelegate
extension LoginWebViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        
        // Проверяем URL, на который было совершено перенаправление. Если это нужный нам URL (/blank.html), и в нем есть токен, приступим к его обработке, если же нет, дадим зеленый свет на переход между страницами c помощью метода decisionHandler(.allow)
        guard let url = navigationResponse.response.url, url.path == "/blank.html", let fragment = url.fragment  else {
            decisionHandler(.allow)
            return
        }
        // Дальше мы просто режем строку с параметрами на части, используя как разделители символы & и =. В результате получаем словарь с параметрами.
        let params = fragment
            .components(separatedBy: "&")
            .map { $0.components(separatedBy: "=") }
            .reduce([String: String]()) { result, param in
                var dict = result
                let key = param[0]
                let value = param[1]
                dict[key] = value
                return dict
            }
        
        // Токен имеет ключ “access_token”, Мы можем получить его и использовать в наших запросах к ВК.
        let token = params["access_token"]
        let userID = params["user_id"]
           
        if let token = token, !token.isEmpty, let userID = userID, !userID.isEmpty {
            print("TOKEN = ", token as Any)
            UserDefaults.standard.setValue(token, forKey: "Token")
            UserDefaults.standard.setValue(userID, forKey: "UserID")
            
            performSegue(withIdentifier: "toTabBar", sender: self)
        }
        
        
        decisionHandler(.cancel)
        
    }
    
}

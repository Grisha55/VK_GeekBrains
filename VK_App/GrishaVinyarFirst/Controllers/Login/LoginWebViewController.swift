//
//  LoginWebViewController.swift
//  GrishaVinyarFirst
//
//  Created by Григорий Виняр on 25.05.2021.
//

import UIKit
import WebKit

class LoginWebViewController: UIViewController {
    
    let networkingConstanse = NetworkingConstans()
    
    @IBOutlet weak var webView: WKWebView! {
        didSet {
            webView.navigationDelegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // https://oauth.vk.com/authorize
        
        var constructor = URLComponents()
        constructor.scheme = "https"
        constructor.host = "oauth.vk.com"
        constructor.path = "/authorize"
        constructor.queryItems = [
            URLQueryItem(name: "client_id", value: networkingConstanse.clientId),
            URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
            URLQueryItem(name: "display", value: "mobile"),
            URLQueryItem(name: "scope", value: "262150"),
            URLQueryItem(name: "response_type", value: "token"),
            URLQueryItem(name: "v", value: networkingConstanse.version)
        ]
        guard let url = constructor.url else { return }
        let request = URLRequest(url: url)
        
        webView.load(request)
        
    }
    
}

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
        
        SessionApp.shared.token = token
        
        print(token as Any)
        
        
        decisionHandler(.cancel)
        
        // make the transition to the tabBarVC
        performSegue(withIdentifier: "toTabBar", sender: self)
    }
    
}

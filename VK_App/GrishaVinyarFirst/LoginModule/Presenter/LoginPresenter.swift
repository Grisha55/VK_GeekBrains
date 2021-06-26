//
//  LoginPresenter.swift
//  GrishaVinyarFirst
//
//  Created by Григорий Виняр on 19.06.2021.
//

import Foundation
import WebKit

protocol LoginPresenterProtocol {
    init(view: LoginWebViewController)
    func logInToApp(webView: WKWebView)
}

class LoginPresenter: LoginPresenterProtocol {
    
    var view: LoginWebViewController
    
    required init(view: LoginWebViewController) {
        self.view = view
    }
    
    func logInToApp(webView: WKWebView) {
        // https://oauth.vk.com/authorize
        
        var constructor = URLComponents()
        constructor.scheme = "https"
        constructor.host = "oauth.vk.com"
        constructor.path = "/authorize"
        constructor.queryItems = [
            URLQueryItem(name: "client_id", value: NetworkingConstans().clientId),
            URLQueryItem(name: "display", value: "mobile"),
            URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
            URLQueryItem(name: "scope", value: "270342"),
            URLQueryItem(name: "response_type", value: "token"),
            URLQueryItem(name: "v", value: NetworkingConstans().version),
            
        ]
        guard let url = constructor.url else { return }
        let request = URLRequest(url: url)
        webView.load(request)
    }
}

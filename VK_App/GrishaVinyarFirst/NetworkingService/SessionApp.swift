//
//  SessionApp.swift
//  GrishaVinyarFirst
//
//  Created by Григорий Виняр on 22.05.2021.
//

import Foundation

final class SessionApp {
    
    static var shared = SessionApp()
    
    var token: String?
    var userID: Int?
    
    private init() {}
}

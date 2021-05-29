//
//  User.swift
//  GrishaVinyarFirst
//
//  Created by Григорий Виняр on 26.05.2021.
//

import Foundation

// MARK: - User
class User: Decodable {
    let response: Response?
}

// MARK: - Response
class Response: Decodable {
    let count: Int
    let items: [Item]
}

// MARK: - Item
class Item: Decodable {
    let id: Int?
    let firstName, lastName: String?
    let isClosed, canAccessClosed: Bool?
    let domain: String?
    let city: City?
    let online: Int?
    let trackCode: String?
    let photo_100: String?

    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case isClosed = "is_closed"
        case canAccessClosed = "can_access_closed"
        case domain, city, online
        case trackCode = "track_code"
        case photo_100
    }
}

// MARK: - City
class City: Decodable {
    let id: Int?
    let title: String?
}




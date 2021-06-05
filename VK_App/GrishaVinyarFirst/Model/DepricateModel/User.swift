//
//  User.swift
//  GrishaVinyarFirst
//
//  Created by Григорий Виняр on 26.05.2021.
//

import Foundation
import RealmSwift

// MARK: - User
class User: Object, Codable {
    @objc dynamic var response: Roster?
}

// MARK: - Roster
class Roster: Object, Codable {
    @objc dynamic var count: Int = 0
    var items: List<Item> = List<Item>()
}

// MARK: - Item
class Item: Object, Codable {
    @objc dynamic var id: Int = 0
    @objc dynamic var firstName: String = ""
    @objc dynamic var lastName: String = ""
    @objc dynamic var photo_100: String = ""

    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case photo_100
    }
}


//
//  Group.swift
//  GrishaVinyarFirst
//
//  Created by Григорий Виняр on 27.05.2021.
//

import Foundation
import RealmSwift

// MARK: - Group
class Group: Object, Codable {
    @objc dynamic var response: GroupData?
}

// MARK: - Response
class GroupData: Object, Codable {
    @objc dynamic var count: Int = 0
    var items: List<GroupList> = List<GroupList>()
}

// MARK: - Item
class GroupList: Object, Codable {
    @objc dynamic var id: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var photo50: String = ""

    enum CodingKeys: String, CodingKey {
        case id, name
        case photo50 = "photo_50"
    }
}

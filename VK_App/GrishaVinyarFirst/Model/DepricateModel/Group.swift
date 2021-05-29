//
//  Group.swift
//  GrishaVinyarFirst
//
//  Created by Григорий Виняр on 27.05.2021.
//

import Foundation


// MARK: - Group
class Group: Decodable {
    let response: GroupData?
}

// MARK: - Response
class GroupData: Decodable {
    let count: Int?
    let items: [List]?
}

// MARK: - Item
class List: Decodable {
    let id: Int?
    let name: String?
    let photo50: String?

    enum CodingKeys: String, CodingKey {
        case id, name
        case photo50 = "photo_50"
    }
}

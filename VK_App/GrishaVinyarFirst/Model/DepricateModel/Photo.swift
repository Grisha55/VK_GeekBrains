//
//  Photo.swift
//  GrishaVinyarFirst
//
//  Created by Григорий Виняр on 26.05.2021.
//

import Foundation

// MARK: - Photo
class Photo: Decodable {
    let response: Character?
}

// MARK: - Response
class Character: Decodable {
    let count: Int?
    let items: [Picture]?
}

// MARK: - Item
class Picture: Decodable {
    
    let id: Int?
    let ownerID: Int?
    let sizes: [Size]?

    enum CodingKeys: String, CodingKey {
        
        case id
        case ownerID = "owner_id"
        case sizes
    }
}

// MARK: - Size
class Size: Decodable {
    let height: Int?
    let url, type: String?
    let width: Int?
    let src: String?
}

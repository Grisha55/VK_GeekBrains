//
//  Photo.swift
//  GrishaVinyarFirst
//
//  Created by Григорий Виняр on 26.05.2021.
//

import Foundation
import RealmSwift

// MARK: - Photo
class Photo: Object, Codable {
    @objc dynamic var response: Character?
}

// MARK: - Character
class Character: Object, Codable {
    @objc dynamic var count: Int = 0
    var items: List<Picture> = List<Picture>()
}

// MARK: - Picture
class Picture: Object, Codable {
    
    @objc dynamic var id: Int = 0
    @objc dynamic var ownerID: Int = 0
    var sizes: List<Size> = List<Size>()

    enum CodingKeys: String, CodingKey {
        
        case id
        case ownerID = "owner_id"
        case sizes
    }
}

// MARK: - Size
class Size: Object, Codable {
    @objc dynamic var height: Int = 0
    @objc dynamic var url: String = ""
    @objc dynamic var type: String = ""
    @objc dynamic var width: Int = 0
    @objc dynamic var src: String = ""
}

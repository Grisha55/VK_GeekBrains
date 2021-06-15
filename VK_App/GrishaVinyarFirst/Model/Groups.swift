//
//  Groups.swift
//  GrishaVinyarFirst
//
//  Created by Григорий Виняр on 09.04.2021.
//

import UIKit
import RealmSwift

// MARK: - AllGroups
class AllGroups: Object, Codable {
    @objc dynamic var response: ResponseGroups?
}

// MARK: - ResponseGroups
class ResponseGroups: Object, Codable {
    @objc dynamic var count: Int = 0
    var items: List<GroupsArray> = List<GroupsArray>()
}

// MARK: - GroupsArray
class GroupsArray: Object, Codable {
    
    @objc dynamic var name: String = ""
    @objc dynamic var photo50: String = ""

    enum CodingKeys: String, CodingKey {
        case name
        case photo50 = "photo_50"
    }
}


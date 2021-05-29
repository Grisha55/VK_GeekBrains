//
//  DataStorage.swift
//  GrishaVinyarFirst
//
//  Created by Григорий Виняр on 09.04.2021.
//

import UIKit

final class DataStorage: NSObject {
    
    static let shared = DataStorage()
    
    private override init() {
        super.init()
    }
    
    var usersArray = [Friend]()
    var allGroupsArray = [List]()
    var groupsArray = [List]()
    var arrayOfArraysOfFriends = [[Friend]]()
}

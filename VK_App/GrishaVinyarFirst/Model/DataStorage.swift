//
//  DataStorage.swift
//  GrishaVinyarFirst
//
//  Created by Григорий Виняр on 09.04.2021.
//

import UIKit

class DataStorage: NSObject {
    
    static let shared = DataStorage()
    
    private override init() {
        super.init()
    }
    
    var usersArray = [User]()
    var allGroupsArray = [Groups]()
    var groupsArray = [Groups]()
    var arrayOfArraysOfFriends = [[User]]()
}

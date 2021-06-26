//
//  DataStorage.swift
//  GrishaVinyarFirst
//
//  Created by Григорий Виняр on 09.04.2021.
//

import UIKit
import RealmSwift

final class DataStorage: NSObject {
    
    static let shared = DataStorage()
    
    private override init() {
        super.init()
    }
    
    var groupsArray: Results<GroupList>?
}

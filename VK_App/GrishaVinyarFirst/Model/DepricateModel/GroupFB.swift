//
//  GroupFB.swift
//  GrishaVinyarFirst
//
//  Created by Григорий Виняр on 15.06.2021.
//

import Foundation
import Firebase

struct GroupFB {
    var name: String?
    var photo: String?
    
    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as! [String: Any]
        self.name = snapshotValue["name"] as? String
        self.photo = snapshotValue["photo"] as? String
    }
}

//
//  FriendAdapter.swift
//  GrishaVinyarFirst
//
//  Created by Григорий Виняр on 13.08.2021.
//

import Foundation
import RealmSwift

final class FriendAdapter {
    
    private let networkingService = NetworkingService()
    
    private var realmNotificationToken = [String: NotificationToken]()
    private var token = NotificationToken()
    
    func getFriends(completion: @escaping ([SimpleFriend]) -> Void) {
        
        guard let realm = try? Realm() else { return }
        let friends = realm.objects(Item.self)
        
        token = friends.observe { (changes) in
            
            switch changes {
            case .update(let realmFriends, _,  _, _):
                
                var friends = [SimpleFriend]()
                
                for realmFriend in realmFriends {
                    friends.append(self.friends(from: realmFriend))
                }
                
                completion(friends)
                
            case .initial(_):
                break
            
            case .error(let error):
                fatalError(error.localizedDescription)
            }
        }
        
        self.networkingService.getFriendFromServer()
        
    }
    
    private func friends(from rlmFriend: Item) -> SimpleFriend {
        return SimpleFriend(id: rlmFriend.id,
                            firstName: rlmFriend.firstName,
                            lastName: rlmFriend.lastName,
                            photo_100: rlmFriend.photo_100)
    }
    
}

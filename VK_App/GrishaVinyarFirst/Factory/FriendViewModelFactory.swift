//
//  FriendViewModelFactory.swift
//  GrishaVinyarFirst
//
//  Created by Григорий Виняр on 13.08.2021.
//

import Foundation

class FriendViewModelFactory {
    
    func constructFriendViewModels(friends: [SimpleFriend]) -> [FriendViewModel] {
        return friends.compactMap { self.getFriendViewModel(from: $0) }
    }
    
    private func getFriendViewModel(from friend: SimpleFriend) -> FriendViewModel? {
        let fullName = friend.firstName + " " + friend.lastName
        guard let photoURL = URL(string: friend.photo_100) else { return nil }
        return FriendViewModel(fullName: fullName, photoURL: photoURL)
    }
}

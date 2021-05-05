//
//  AppDelegate.swift
//  GrishaVinyarFirst
//
//  Created by Григорий Виняр on 03.04.2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        setupFriends()
        loadGroups()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    func loadGroups() {
        let firstGroup   = Groups(name: "Food", groupImage: UIImage(named: "еда"))
        let secondGroup  = Groups(name: "Football", groupImage: UIImage(named: "футбол"))
        let thirdGroup   = Groups(name: "Music", groupImage: UIImage(named: "музыка"))
        let fourthGroup  = Groups(name: "Gym", groupImage: UIImage(named: "спортзал"))
        let fifthGroup   = Groups(name: "Photos", groupImage: UIImage(named: "фото"))
        let sixthGroup   = Groups(name: "Movies", groupImage: UIImage(named: "кино"))
        
        DataStorage.shared.allGroupsArray.append(firstGroup)
        DataStorage.shared.allGroupsArray.append(secondGroup)
        DataStorage.shared.allGroupsArray.append(thirdGroup)
        DataStorage.shared.allGroupsArray.append(fourthGroup)
        DataStorage.shared.allGroupsArray.append(fifthGroup)
        DataStorage.shared.allGroupsArray.append(sixthGroup)
        
    }
        
        func setupFriends() {
            let userOne = User(name: "Айболит", age: 40, description: nil, avatar: UIImage(named: "айболит"), photosArray: [UIImage(named: "айболит1"), UIImage(named: "айболит2")])
            let userTwo =  User(name: "Волк", age: 25, description: "Я волк и мне 25 лет", avatar: UIImage(named: "волк"), photosArray: [UIImage(named: "волк1"), UIImage(named: "волк2"), UIImage(named: "волк3")])
            let userThree   = User(name: "Крыса", age: 29, description: "Я крыса и мне 29 лет", avatar: UIImage(named: "крыса"), photosArray: [UIImage(named: "крыса1"), UIImage(named: "крыса2"), UIImage(named: "крыса3")])
            let userFour = User(name: "Лунтик", age: 16, description: "Я лунтик и мне 16 лет", avatar: UIImage(named: "лунтик"), photosArray: [UIImage(named: "лунтик1"), UIImage(named: "лунтик2"), UIImage(named: "лунтик3")])
            let userFive  = User(name: "Халк", age: 40, description: "Я халк и мне 40 лет", avatar: UIImage(named: "халк"), photosArray: [UIImage(named: "халк1"), UIImage(named: "халк2"), UIImage(named: "халк3")])
            let userSix  = User(name: "Чебурашка", age: 12, description: "Я чебурашка и мне 12 лет", avatar: UIImage(named: "чебурашка"), photosArray: [UIImage(named: "чебурашка1"), UIImage(named: "чебурашка2"), UIImage(named: "чебурашка3")])
            let userSeven = User(name: "Крош", age: 20, description: nil, avatar: UIImage(named: "крош"), photosArray: [UIImage(named: "крош1"), UIImage(named: "крош2")])
            let userEight = User(name: "Винни", age: 40, description: nil, avatar: UIImage(named: "винни"), photosArray: [UIImage(named: "винни1")])
            let userNine = User(name: "Кот", age: 30, description: nil, avatar: UIImage(named: "кот"), photosArray: [UIImage(named: "кот")])
            
            
            DataStorage.shared.usersArray.append(userOne)
            DataStorage.shared.usersArray.append(userTwo)
            DataStorage.shared.usersArray.append(userThree)
            DataStorage.shared.usersArray.append(userFour)
            DataStorage.shared.usersArray.append(userFive)
            DataStorage.shared.usersArray.append(userSix)
            DataStorage.shared.usersArray.append(userSeven)
            DataStorage.shared.usersArray.append(userEight)
            
            DataStorage.shared.arrayOfArraysOfFriends.append([userOne]) // а
            DataStorage.shared.arrayOfArraysOfFriends.append([userTwo, userEight]) // в
            DataStorage.shared.arrayOfArraysOfFriends.append([userThree, userSeven, userNine]) // к
            DataStorage.shared.arrayOfArraysOfFriends.append([userFour]) // л
            DataStorage.shared.arrayOfArraysOfFriends.append([userFive]) // х
            DataStorage.shared.arrayOfArraysOfFriends.append([userSix]) // ч
        }
    
}


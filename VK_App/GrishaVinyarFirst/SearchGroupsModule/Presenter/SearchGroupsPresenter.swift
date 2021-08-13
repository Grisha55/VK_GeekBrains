//
//  SearchGroupsPresenter.swift
//  GrishaVinyarFirst
//
//  Created by Григорий Виняр on 19.06.2021.
//

import UIKit
import RealmSwift

class SearchGroupsPresenter {
    
    var searchGroups = [SimpleGroup]()
    var token: NotificationToken?
    
    func setupAlert(controller: UIViewController, indexOfTappedOne: IndexPath) {
        let alertController = UIAlertController(title: "Добавление группы", message: "Хотите ли вы добавить группу?", preferredStyle: .alert)
        let alertActionOne = UIAlertAction(title: "Закрыть", style: .cancel, handler: nil)
        let alertActionTwo = UIAlertAction(title: "Добавить", style: .default) { [weak self] (alert) in
            guard let self = self else { return }
            if alert.isEnabled {
                    
                let tappedElement = self.searchGroups[indexOfTappedOne.row]
                    
                    var safeName = tappedElement.name.replacingOccurrences(of: "", with: "_")
                    safeName = safeName.replacingOccurrences(of: ".", with: "_")
                    safeName = safeName.replacingOccurrences(of: "#", with: "-")
                    safeName = safeName.replacingOccurrences(of: "$", with: "dollar")
                    safeName = safeName.replacingOccurrences(of: "[", with: "{")
                    safeName = safeName.replacingOccurrences(of: "]", with: "}")
                    safeName = safeName.replacingOccurrences(of: "@", with: "dog")
                    safeName = safeName.replacingOccurrences(of: "/", with: "")
                    
                    FirebaseStore().loadDataToFirebase(name: safeName, photo: tappedElement.photo50)
                    
                    controller.navigationController?.popViewController(animated: true)
            }
        }
        
        alertController.addAction(alertActionOne)
        alertController.addAction(alertActionTwo)
        controller.present(alertController, animated: true, completion: nil)
    }
}

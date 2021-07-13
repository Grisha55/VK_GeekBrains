//
//  AsyncOperation.swift
//  GrishaVinyarFirst
//
//  Created by Григорий Виняр on 12.07.2021.
//

import Foundation
import RealmSwift

class AsyncOperation: Operation {
    
    enum State: String {
        case ready, executing, finished
        
        /// Маленький хелпер, который возвращает состояния для KVO
        /// - Returns: `isReady` или `isExecuting` или `isFinished`
        fileprivate var keyPath: String {
            return "is" + self.rawValue.capitalized
        }
    }
    
    private var state: State = State.ready {
        // Уведомляем систему KVO, о том что у нас изменились состояния в операции
        
        // Вызывается в момент установки значений
        willSet {
            self.willChangeValue(forKey: self.state.keyPath)
            self.willChangeValue(forKey: newValue.keyPath)
        }
        
        // Вызывается после установки значений
        didSet {
            self.didChangeValue(forKey: self.state.keyPath)
            self.didChangeValue(forKey: oldValue.keyPath)
        }
    }
    
    override var isAsynchronous: Bool {
        return true
    }
    
    override var isReady: Bool {
        return super.isReady && self.state == .ready
    }
    
    override var isExecuting: Bool {
        return self.state == .executing
    }
    
    override var isFinished: Bool {
        return self.state == .finished
    }
    
    override func start() {
        if self.isCancelled {
            self.state = .finished
        } else {
            self.main()
            self.state = .executing
        }
    }
    
    override func cancel() {
        super.cancel()
        self.state = .finished
    }
    
    /// Set operation as finished
    /// - Tag: finished
    func finished() {
        self.state = .finished
    }
    
}

// Загрузка данных от серевера
class GetFriendsDataFromServer: AsyncOperation {
    
    // Храним токен для отмены
    private var requestToken: URLSessionDataTask?
    
    private(set) var data: Data?
    
    override func cancel() {
        // Останавливаем запрос из сети, если операция отменена
        self.requestToken?.cancel()
        super.cancel()
    }
    
    override func main() {
        let url = URL(string: "https://api.vk.com/method/friends.get")!
        var request = URLRequest(url: url)
        
        let parameters = [
            ["order" : "name"],
            ["fields" : "sex, bdate, city, country, photo_100, photo_200_orig"],
            ["access_token" : SessionApp.shared.token],
            ["v" : NetworkingConstans().version]
        ]
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else { return }
        
        request.httpBody = httpBody
        
        self.requestToken = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            self?.data = data
            self?.finished()
        }
        
        // Делаем запрос
        self.requestToken?.resume()
    }
}

// Парсинг данных в структуру
class ParseFriendsDataInToStruct: AsyncOperation {
    
    private(set) var friends: List<Item>?
    
    override func main() {
        guard let operation = self.dependencies.first as? GetFriendsDataFromServer,
              let data = operation.data
        else {
            return
        }
        
        guard let friends = try? JSONDecoder().decode(User.self, from: data).response?.items else { return }
        self.friends = friends
    }
}

// Сохранение данных в Realm
class SaveFriendsInToRealm: AsyncOperation {
    
    private(set) var friends: List<Item>?
    
    override func main() {
        guard let operation = self.dependencies[1] as? ParseFriendsDataInToStruct,
              let friends = operation.friends
        else { return }
        
        guard let realm = try? Realm() else { return }
        let oldValues = realm.objects(Item.self)
        realm.beginWrite()
        realm.delete(oldValues)
        realm.add(friends)
        try? realm.commitWrite()
    }
}

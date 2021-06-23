//
//  NetworkingService.swift
//  GrishaVinyarFirst
//
//  Created by Григорий Виняр on 25.05.2021.
//

import Foundation
import RealmSwift

protocol NetworkServiceProtocol {
    func getFriends(completion: @escaping (Result<List<Item>, Error>) -> Void)
    func getPhotos(userID: Int?, completion: @escaping (List<Picture>) -> Void, onError: @escaping (Error) -> Void)
    func getUserGroups(completion: @escaping (Result<List<GroupList>, Error>) -> Void)
    func searchGroups(name: String, completion: @escaping (Result<List<GroupsArray>, Error>) -> Void)
}

class NetworkingService: NetworkServiceProtocol {
    
    //MARK: - Properties
    let constanse = NetworkingConstans()
    
    // Загрузка ленты новостей
    func getNewsfeed(completion: @escaping (Result<[News], Error>) -> Void) {
        //https://api.vk.com/method/newsfeed.get?user_ids=7874888&fields=bdate&access_token=a0ad5d98286931c0ba5ec23df4fa03bdf5d8f73bc550d3167813f78ed250d88475cc4fdccd14dfe9a3d8a&v=5.92

        let configuration = URLSessionConfiguration.default
        
        let session = URLSession(configuration: configuration)
        
        var components = URLComponents()

        components.scheme = constanse.scheme
        components.host = constanse.host
        components.path =  "/method/newsfeed.get"
        
        components.queryItems = [
            URLQueryItem(name: "filters", value: "post"),
            URLQueryItem(name: "count", value: "100"),
            URLQueryItem(name: "user_ids", value: String(SessionApp.shared.userID ?? 1)),
            URLQueryItem(name: "access_token", value: SessionApp.shared.token),
            URLQueryItem(name: "v", value: constanse.version)
        ]
        
        guard let url = components.url else { return }
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil {
                completion(.failure(error!))
            }
            guard let data = data else { return }
            
            do {
                let news = try JSONDecoder().decode([News].self, from: data)
                completion(.success(news))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    // Загрузка друзей юзера
    func getFriends(completion: @escaping (Result<List<Item>, Error>) -> Void) {
        
        // https://api.vk.com/method/friends.get
        
        let configuration = URLSessionConfiguration.default
        
        let session = URLSession(configuration: configuration)
        
        var components = URLComponents()
        components.scheme = constanse.scheme
        components.host = constanse.host
        components.path = "/method/friends.get"
        
        components.queryItems = [
            URLQueryItem(name: "order", value: "name"),
            URLQueryItem(name: "fields", value: "sex, bdate, city, country, photo_100, photo_200_orig"),
            URLQueryItem(name: "access_token", value: SessionApp.shared.token),
            URLQueryItem(name: "v", value: constanse.version),
            //URLQueryItem(name: "count", value: "100")
        ]
        
        guard let url = components.url else { return }
        let request = URLRequest(url: url)
        
        let task = session.dataTask(with: request) { data, response, error in
            
            if error != nil {
                completion(.failure(error!))
                return
            }
            
            guard let data = data else {
                completion(.failure(error!))
                return }
            
            do {
                
                let user = try JSONDecoder().decode(User.self, from: data)
                
                guard let items = user.response?.items else { return }
                
                DispatchQueue.main.async {
                    completion(.success(items))
                }
                
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    // Загрузка фотографий друзей пользователя
    func getPhotos(userID: Int?, completion: @escaping (List<Picture>) -> Void, onError: @escaping (Error) -> Void) {
        
        // https://api.vk.com/method/photos.get
        
        let configuration = URLSessionConfiguration.default
        
        let session = URLSession(configuration: configuration)
        
        var components = URLComponents()
        components.scheme = constanse.scheme
        components.host = constanse.host
        components.path = "/method/photos.get"
        
        components.queryItems = [
            URLQueryItem(name: "owner_id", value: String(userID ?? -1)),
            URLQueryItem(name: "album_id", value: "wall"),
            URLQueryItem(name: "photo_sizes", value: "1"),
            URLQueryItem(name: "count", value: "3"),
            URLQueryItem(name: "access_token", value: SessionApp.shared.token),
            URLQueryItem(name: "v", value: constanse.version)
        ]
        
        guard let url = components.url else { return }
        let request = URLRequest(url: url)
        
        let task = session.dataTask(with: request) { data, response, error in
            
            if error != nil {
                onError(error!)
            }
            
            guard let data = data else {
                onError(error!)
                return }
            
            do {
                
                let photos = try JSONDecoder().decode(Photo.self, from: data)
                
                guard let pictures = photos.response?.items else { return }
                
                DispatchQueue.main.async {
                    completion(pictures)
                }
                
            } catch {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
    
    // Загрузка групп пользователя
    func getUserGroups(completion: @escaping (Result<List<GroupList>, Error>) -> Void) {
        
        // https://api.vk.com/method/groups.get
        
        let configuration = URLSessionConfiguration.default
        
        let session = URLSession(configuration: configuration)
        
        var components = URLComponents()
        components.scheme = constanse.scheme
        components.host = constanse.host
        components.path = "/method/groups.get"
        components.queryItems = [
            URLQueryItem(name: "extended", value: "1"),
            URLQueryItem(name: "fields", value: "description"),
            URLQueryItem(name: "access_token", value: SessionApp.shared.token),
            URLQueryItem(name: "v", value: constanse.version)
        ]
        
        guard let url = components.url else { return }
        
        let request = URLRequest(url: url)
        
        let task = session.dataTask(with: request) { data, response, error in
            
            if error != nil {
                completion(.failure(error!))
            }
                
            guard let data = data else {
                completion(.failure(error!))
                return }
            
            do {
                let groups = try JSONDecoder().decode(Group.self, from: data)
                
                guard let items = groups.response?.items else { return }
                
                DispatchQueue.main.async {
                    completion(.success(items))
                }
    
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    // Загрузка групп по поиску
    func searchGroups(name: String, completion: @escaping (Result<List<GroupsArray>, Error>) -> Void) {
        
        // https://api.vk.com/method/groups.search
        
        let configuration = URLSessionConfiguration.default
        
        let session = URLSession(configuration: configuration)
        
        var components = URLComponents()
        components.scheme = constanse.scheme
        components.host = constanse.host
        components.path = "/method/groups.search"
        components.queryItems = [
            URLQueryItem(name: "q", value: name),
            URLQueryItem(name: "sort", value: "0"),
            URLQueryItem(name: "v", value: constanse.version),
            URLQueryItem(name: "access_token", value: SessionApp.shared.token)
        ]
        
        guard let url = components.url else { return }
        
        let request = URLRequest(url: url)
        
        let task = session.dataTask(with: request) { data, response, error in
            
            if error != nil {
                completion(.failure(error!))
                return
            }
            
            guard let data = data else {
                completion(.failure(error!))
                return }
            
            do {
                let group = try JSONDecoder().decode(AllGroups.self, from: data)
                
                guard let items = group.response?.items else { return }
                
                DispatchQueue.main.async {
                    completion(.success(items))
                }
                
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
}

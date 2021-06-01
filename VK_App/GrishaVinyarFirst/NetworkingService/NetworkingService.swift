//
//  NetworkingService.swift
//  GrishaVinyarFirst
//
//  Created by Григорий Виняр on 25.05.2021.
//

import Foundation
import RealmSwift

class NetworkingService {
    
    let constanse = NetworkingConstans()
    
    // MARK: Friends
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
            URLQueryItem(name: "v", value: constanse.version)
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
    
    // MARK: Photos
    func getPhotos(userID: Int?, completion: @escaping (Result<List<Picture>, Error>) -> Void) {
        
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
                completion(.failure(error!))
            }
            
            guard let data = data else {
                completion(.failure(error!))
                return }
            
            do {
                
                let photos = try JSONDecoder().decode(Photo.self, from: data)
                
                guard let pictures = photos.response?.items else { return }
                
                DispatchQueue.main.async {
                    completion(.success(pictures))
                }
                
            } catch {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
    
    // MARK: Groups
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
    
    func searchGroups(name: String, completion: @escaping (Result<List<GroupList>, Error>) -> Void) {
        
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
                let group = try JSONDecoder().decode(Group.self, from: data)
                
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

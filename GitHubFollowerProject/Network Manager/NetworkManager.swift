//
//  NetworkManager.swift
//  GitHubFollowerProject
//
//  Created by Q B on 7/23/20.
//  Copyright © 2020 Quwayne. All rights reserved.
//

import UIKit

class NetworkManager {
    static let shared = NetworkManager()
    private let baseURL = "https://api.github.com/users/"
    let cache = NSCache<NSString, UIImage>()
    
     private init() {}
    
    
    func getFollowers(for username: String, page: Int, completion: @escaping (Result<[Follower], GHFError>) -> Void) {
        
        let endpoint = baseURL + "\(username)/followers?per_page=100&page=\(page)"
        
        guard let url = URL(string: endpoint) else  { completion(.failure(.invalidUsername)) ; return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            guard let data = data else { completion(.failure(.invalidData)); return }
            
            if let _ = error { completion(.failure(.unableToComplete)) }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(.failure(.invalidResponse))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let followers = try decoder.decode([Follower].self, from: data)
                completion(.success(followers))
            } catch {
                completion(.failure(.unableToComplete))
            }
        }
        
        task.resume()
    }
    
    
  func getUser(for username: String, completion: @escaping (Result<User, GHFError>) -> Void) {
        
        let endpoint = baseURL + "\(username)"
        
    guard let url = URL(string: endpoint) else  { completion(.failure(.invalidUsername)) ; return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            
            if let _ = error {
                completion(.failure(.unableToComplete))
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(.failure(.invalidResponse))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                decoder.dateDecodingStrategy = .iso8601 
                let user = try decoder.decode(User.self, from: data)
                completion(.success(user))
            } catch {
                completion(.failure(.unableToComplete))
            }
        }
        
        task.resume()
    }
    
    
    
    
    func downloadImage(from imageURL: String, completion: @escaping (UIImage?) -> Void) {
         
         let cacheKey = NSString(string: imageURL)
         
         if let image = cache.object(forKey: cacheKey) { completion(image); return }
             
        guard let url = URL(string: imageURL) else { completion(nil); return }
         
         let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
             
            guard let self = self,
             error == nil,
             let response = response as? HTTPURLResponse, response.statusCode == 200,
             let data = data,
             let image = UIImage(data: data) else { completion(nil)
                return
            }
             
            self.cache.setObject(image, forKey: cacheKey)
           
            completion(image)
         }
             task.resume()
     }
}

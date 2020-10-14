//
//  PersistenceManager.swift
//  GitHubFollowerProject
//
//  Created by Q B on 8/10/20.
//  Copyright © 2020 Quwayne. All rights reserved.
//

import Foundation

enum PersistenceActionType {
    case add, remove
}

enum PersistenceManager {
    
    static private let defaults = UserDefaults.standard
    enum Keys { static let favorites = "favorites" }
    
    
    static func updateWith(favorite: Follower, actionType: PersistenceActionType, completion: @escaping (GHFError?) -> Void) {
        
        getFavorites { result in
            switch result {
            case .success(var favorites):
                
                
                switch  actionType {
                case .add:
                    guard !favorites.contains(favorite) else {
                        completion(.invalidData)
                        return
                }
                    
                   favorites.append(favorite)
                    
                case .remove:
                    favorites.removeAll { $0.login == favorite.login}
                }
                
                completion(save(favorites: favorites))
            case .failure(let error):
                completion(error)
            }
        }
    }
    
    static func getFavorites(completion: @escaping (Result<[Follower], GHFError>) -> Void) {
        guard let favoritesData = defaults.object(forKey: Keys.favorites) as? Data else {
            completion(.success([]))
            return
        }
        
        do {
            let decoder = JSONDecoder()
            let favorites = try decoder.decode([Follower].self, from: favoritesData)
            completion(.success(favorites))
        } catch {
            completion(.failure(.unableToSave))
        }
    }
    
    
    static func save(favorites: [Follower]) -> GHFError? {
        
        do {
            let encoder = JSONEncoder()
            let encodedFavorites = try encoder.encode(favorites)
            defaults.set(encodedFavorites, forKey: Keys.favorites)
            return nil
        } catch {
            return .unableToSave
        }
    }
}

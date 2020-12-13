//
//  NetworkService.swift
//  facebookFeed
//
//  Created by LeeChan on 12/13/20.
//  Copyright © 2020 MarkiiimarK. All rights reserved.
//

import Foundation
import UIKit

final class NetworkService {
    func getAllPosts(completion: @escaping (Result<[Post], Error>) -> Void) {
        guard let path = Bundle.main.path(forResource: "all_posts", ofType: "json") else {
            completion(.failure(NetworkingError.badUrl))
            return
        }
        
        do {
            let data = try(NSData(contentsOfFile: path, options: NSData.ReadingOptions.mappedIfSafe))
            let response = try JSONDecoder().decode(PostResponse.self, from: data as Data)
            DispatchQueue.main.async {
                completion(.success(response.posts))
            }
//                self.collectionView?.reloadData()
        } catch {
            completion(.failure(error))
        }
    }
    
    func getImage(with url: String, completion: @escaping (Result<UIImage, Error>) -> Void) {
        guard let vUrl = URL(string: url) else {
            completion(.failure(NetworkingError.badUrl))
            return
        }
        let request = URLRequest(url: vUrl)
        URLSession.shared.dataTask(with: request) {
            if let error = $2 {
                completion(.failure(error))
                
            } else if let data = $0 {
                do {
                    guard let image = UIImage(data: data) else {
                        completion(.failure(NetworkingError.invalidData))
                        return
                    }
                    DispatchQueue.main.async {
                        completion(.success(image))
                    }
                }
            }
        }.resume()
    }
}

enum NetworkingError: Error {
    case badUrl
    case invalidData
}

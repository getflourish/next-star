//
//  Network.swift
//  next-star
//
//  Created by jay on 17.01.22.
//

import Foundation

class Network {
    var authorizationToken = "myToken"
    var nextcloudBookmarksHost = "https://your.nextcloud.instance"
    
    func getBookmarks(completion: @escaping (Result<[Bookmark],Error>) -> Void) {
        
        guard let url = URL(string: "\(nextcloudBookmarksHost)/index.php/apps/bookmarks/public/rest/v2/bookmark?limit=50") else { print("Invalid URL!"); return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Basic \(authorizationToken)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error.localizedDescription as! Error))
                return
            }
            
            do {
//                let json = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
//                print(json)
                let bookmarkResponse = try JSONDecoder().decode(BookmarksResponse.self, from: data!)
                completion(.success(bookmarkResponse.data))
            } catch let jsonError {
                completion(.failure(jsonError.localizedDescription as! Error))
            }
        }.resume()
    }
    
    func createBookmark(bookmark: Bookmark) {
        // TO-DO: Implement this
    }
}

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
    
    func updateTagsForBookmark(tags: [String], bookmarkId: Int, completion: @escaping (Result<String,Error>) -> Void)  {
        let params = ["tags": tags]
        
        guard let url = URL(string: "\(nextcloudBookmarksHost)/index.php/apps/bookmarks/public/rest/v2/bookmark/\(bookmarkId)") else { print("Invalid URL!"); return
        }
        print(url)
        print(params)
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
        request.setValue("Basic \(authorizationToken)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error.localizedDescription as! Error))
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! Dictionary<String, AnyObject>
                                print(json)
                completion(.success("yay"))
            } catch {
                print(error)
                completion(.failure(error.localizedDescription as! Error))
            }
            
        }.resume()
        
    }
}

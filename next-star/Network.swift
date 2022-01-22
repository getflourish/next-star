//
//  Network.swift
//  next-star
//
//  Created by jay on 17.01.22.
//

import Foundation

class Network {
    var authorizationToken = ""
    var nextcloudBookmarksUrl = ""
    
    init() {
        self.authorizationToken = ""
        self.nextcloudBookmarksUrl = ""
    }
    
    init(username: String, password: String, serverURL: String) {
        self.authorizationToken = getAuthorizationTokenFromCredentials(username: username, password: password)
        self.nextcloudBookmarksUrl = serverURL
    }
    
    private func getAuthorizationTokenFromCredentials(username: String, password: String) -> String {
        let loginString = String(format: "%@:%@", username, password)
        let loginData = loginString.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString()
        return base64LoginString
    }
    
    func updateCredentials(username: String, password: String, serverURL: String) {
        print("updating credentials in Network to")
        print(username)
        print(password)
        print(serverURL)
        self.authorizationToken = getAuthorizationTokenFromCredentials(username: username, password: password)
        self.nextcloudBookmarksUrl = serverURL
    }
    
    func getBookmarks(completion: @escaping (Result<[Bookmark],Error>) -> Void) {
        
        print("fetching bookmarks using")
        print(self.authorizationToken)
        print(self.nextcloudBookmarksUrl)
        guard let url = URL(string: "\(self.nextcloudBookmarksUrl)/index.php/apps/bookmarks/public/rest/v2/bookmark?limit=50") else { print("Invalid URL!"); return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Basic \(self.authorizationToken)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error.localizedDescription as! Error))
                return
            }
            
            do {
//              let json = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
//              print(json)
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
        
        guard let url = URL(string: "\(self.nextcloudBookmarksUrl)/index.php/apps/bookmarks/public/rest/v2/bookmark/\(bookmarkId)") else { print("Invalid URL!"); return
        }
//        print(url)
//        print(params)
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
        request.setValue("Basic \(self.authorizationToken)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error.localizedDescription as! Error))
                return
            }
            
            do {
//              let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! Dictionary<String, AnyObject>
//              print(json)
                completion(.success("yay"))
            } catch {
                print(error)
                completion(.failure(error.localizedDescription as! Error))
            }
        }.resume()
    }
}

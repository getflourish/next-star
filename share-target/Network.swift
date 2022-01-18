//
//  Network.swift
//  share-target
//
//  Created by jay on 18.01.22.
//

import Foundation

class Network {
    var authorizationToken = "myToken"
    var nextcloudBookmarksHost = "https://your.nextcloud.instance"
    
    func createBookmark(url: String) {
        let params = ["url": url]

        var request = URLRequest(url: URL(string: "\(nextcloudBookmarksHost)/index.php/apps/bookmarks/public/rest/v2/bookmark")!)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Basic \(authorizationToken)=", forHTTPHeaderField: "Authorization")

        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            print(response!)
            do {
                let json = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
                print(json)
            } catch {
                print("error")
            }
        })

        task.resume()
    }
}

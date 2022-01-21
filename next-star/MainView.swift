//
//  MainView.swift
//  next-star
//
//  Created by jay on 20.01.22.
//

import SwiftUI

struct MainView: View {
    @State var hasCredentials = UserDefaults.standard.bool(forKey: "hasCredentials")
    @State var hasCredentialsDrilled = false
    @State var network = Network(username: "", password: "", serverURL: UserDefaults.standard.string(forKey: "nextcloudInstanceURL") ?? "")
    @State var bookmarks: [Bookmark]
    @State var refreshBookmarks: () -> ()
    
    var body: some View {
        VStack {
            if hasCredentials || hasCredentialsDrilled {
                NavigationView {
                    BookmarksView(bookmarks: $bookmarks, network: $network, refreshBookmarks: $refreshBookmarks)
                }
            } else {
                UserCredentialsView(network: $network, hasCredentials: $hasCredentialsDrilled)
            }
        }.onAppear() {
            self.refreshBookmarks = extRefreshBookmarks
            if hasCredentials {
                initializeNetworkFromCredentials()
                loadCacheIfAvailable()
                getBookmarksData()
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(network: Network(), bookmarks: [], refreshBookmarks: {})
    }
}

extension MainView {
    func extRefreshBookmarks() {
        getBookmarksData()
    }
    func getBookmarksData() {
        print("fetching bookmarks at view level")
        network.getBookmarks { (result) in
            switch result {
            case.success(let bookmarks):
                print("success fetching bookmarks at view level")
                DispatchQueue.main.async {
                    self.bookmarks = bookmarks
                    storeBookmarksToCache(bookmarks: bookmarks)
                }
            case.failure(let error):
                print("failure fetching bookmarks at view level")
                print(error.localizedDescription)
            }
        }
    }
    func loadCacheIfAvailable() {
        do {
            let bookmarks: [Bookmark] = try Storage().loadCachedBookmarks()
            self.bookmarks = bookmarks
        }
        catch {
            print("uninitialized cache")
        }
    }
    func storeBookmarksToCache(bookmarks: [Bookmark]) {
        do {
            try Storage().storeBookmarksToCache(bookmarks: bookmarks)
        }
        catch {
            print("Error storing bookmarks to file")
        }
    }
    func initializeNetworkFromCredentials() {
        if (UserDefaults.standard.bool(forKey: "hasCredentials")) {
            do {
                print("initializing network from credentials for server")
                print(UserDefaults.standard.string(forKey: "nextcloudInstanceURL"))
                let credentials = try KeychainManager().getCredentials(server: UserDefaults.standard.string(forKey: "nextcloudInstanceURL") ?? "")
                network.updateCredentials(username: credentials.username, password: credentials.password, serverURL: UserDefaults.standard.string(forKey: "nextcloudInstanceURL") ?? "")
                
            } catch {
                print("error retrieving credentials for server: \(UserDefaults.standard.string(forKey: "nextcloudInstanceURL") ?? "")")
            }
        }
    }
}

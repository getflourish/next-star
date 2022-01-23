import SwiftUI

struct MainView: View {
    // UIState
    @State var hasCredentialsFromDefaults = UserDefaults(suiteName: Constants().GROUP_ID)!.bool(forKey: "hasCredentials")
    @State var hasCredentialsRuntime = false // Needed to re-render the view
    
    // (Dependency) Injected properties
    @State var network = Network(username: "", password: "", serverURL: UserDefaults(suiteName: Constants().GROUP_ID)!.string(forKey: "nextcloudInstanceURL") ?? "")
    @State var bookmarks: [Bookmark]
    @State var refreshBookmarks: () -> ()
    
    var body: some View {
        VStack {
            if hasCredentials(persistedValue: hasCredentialsFromDefaults, runtimeValue: hasCredentialsRuntime) {
                NavigationView {
                    BookmarksView(bookmarks: $bookmarks, network: $network, refreshBookmarks: $refreshBookmarks)
                }
            } else {
                UserCredentialsView(network: $network, hasCredentials: $hasCredentialsRuntime)
            }
        }.onAppear() {
            self.refreshBookmarks = fetchBookmarksData
            if hasCredentialsFromDefaults {
                initializeNetworkFromCredentials()
                loadCacheIfAvailable()
                fetchBookmarksData()
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
    func hasCredentials(persistedValue: Bool, runtimeValue: Bool) -> Bool {
        return persistedValue || runtimeValue
    }
    
    func fetchBookmarksData() {
        network.getBookmarks { (result) in
            switch result {
            case.success(let bookmarks):
                DispatchQueue.main.async {
                    self.bookmarks = bookmarks
                    storeBookmarksToCache(bookmarks: bookmarks)
                }
            case.failure(let error):
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
        if (UserDefaults(suiteName: Constants().GROUP_ID)!.bool(forKey: "hasCredentials")) {
            do {
                let credentials = try KeychainManager().getCredentials(server: UserDefaults(suiteName: Constants().GROUP_ID)!.string(forKey: "nextcloudInstanceURL") ?? "")
                network.updateCredentials(username: credentials.username, password: credentials.password, serverURL: UserDefaults(suiteName: Constants().GROUP_ID)!.string(forKey: "nextcloudInstanceURL") ?? "")
                
            } catch {
                print("error retrieving credentials for server: \(UserDefaults(suiteName: Constants().GROUP_ID)!.string(forKey: "nextcloudInstanceURL") ?? "")")
            }
        }
    }
}

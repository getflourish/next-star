import SwiftUI

struct MainView: View {
    // UIState
    @State var hasCredentialsFromDefaults = UserDefaults(suiteName: Constants().GROUP_ID)!.bool(forKey: "hasCredentials")
    @State var hasCredentialsRuntime = false // Needed to re-render the view
    
    // Notification UI state
    @State var notificationContents = ""
    @State var notificationIsError = false
    @State var notificationShouldDisplay = false
    
    // (Dependency) Injected properties
    @State var network = Network(username: "", password: "", serverURL: UserDefaults(suiteName: Constants().GROUP_ID)!.string(forKey: "nextcloudInstanceURL") ?? "")
    @State var bookmarks: [Bookmark]
    
    // (Dependency) Injected actions
    @State var refreshBookmarksAction: () async -> ()
    @State var displayNotificationAction: (String, Bool) -> ()
    
    var body: some View {
        VStack {
            if (notificationShouldDisplay) {
                NotificationView(content: $notificationContents, isError: $notificationIsError)
            }
            if hasCredentials(persistedValue: hasCredentialsFromDefaults, runtimeValue: hasCredentialsRuntime) {
                
                    BookmarksView(bookmarks: bookmarks, network: $network, refreshBookmarks: $refreshBookmarksAction)
                
            } else {
                UserCredentialsView(network: $network, hasCredentials: $hasCredentialsRuntime, displayNotification: $displayNotificationAction)
            }
        }.task  {
          
            // Set functions to inject
            self.refreshBookmarksAction =  fetchBookmarksData
            self.displayNotificationAction = displayNotification
            
            if hasCredentialsFromDefaults {
                initializeNetworkFromCredentials()
                loadCacheIfAvailable()
                await fetchBookmarksData()
            }
          
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(network: Network(), bookmarks: [], refreshBookmarksAction: {}, displayNotificationAction: {_, _ in })
    }
}

extension MainView {
    func hasCredentials(persistedValue: Bool, runtimeValue: Bool) -> Bool {
        return persistedValue || runtimeValue
    }
    func displayNotification(content: String, isError: Bool) {
        self.notificationContents = content
        self.notificationShouldDisplay = true
        self.notificationIsError = isError
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            self.notificationShouldDisplay = false
        }
    }
    func fetchBookmarksData() async {
        await network.getBookmarks { (result) in
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

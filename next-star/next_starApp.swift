import SwiftUI

@main
struct next_starApp: App {
    var body: some Scene {
        WindowGroup {
            MainView(bookmarks: [], refreshBookmarks: {})
        }
    }
}

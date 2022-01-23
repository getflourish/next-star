import SwiftUI

struct BookmarksView: View {
    @Binding var bookmarks: [Bookmark]
    @Binding var network: Network
    @Binding var refreshBookmarks: () -> ()
    
    var body: some View {
        let viewTitle = "Bookmarks"
        
        VStack {
            List {
                ForEach($bookmarks) { $bookmark in
                    CardView(bookmark: $bookmark, network: $network)
                }
            }
            .onAppear(){
                if bookmarks.isEmpty {
                    refreshBookmarks()
                }
            }
        }
            .navigationTitle(viewTitle)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    NavigationLink(destination: SettingsView()) {
                        Image(systemName: "gear")
                        .accessibilityLabel("Settings")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: NewBookmarkView()) {
                        Image(systemName: "plus")
                        .accessibilityLabel("New bookmark")
                    }
                }
            }
    }
}

struct BookmarksView_Previews: PreviewProvider {
    static var previews: some View {
        BookmarksView(bookmarks: .constant([Bookmark.sampleData[0]]), network: .constant(Network()), refreshBookmarks: .constant({}))
    }
}

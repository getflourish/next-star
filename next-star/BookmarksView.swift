import SwiftUI

struct BookmarksView: View {
  
  var bookmarks: [Bookmark]
  @Binding var network: Network
  @Binding var refreshBookmarks: () async -> ()
  
  var groupDateFormatter: DateFormatter {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "de_CH")
    formatter.setLocalizedDateFormatFromTemplate("d MMMM YYYY")
    
    return formatter
  }
  
  func update(_ result: Array<Bookmark>)-> [[Bookmark]]{
    return  Dictionary(grouping: result){ (element : Bookmark)  in
      groupDateFormatter.string(from: Date(timeIntervalSince1970:element.added))
    }.values.sorted() { $0[0].added > $1[0].added }
  }
  
 
  
  var body: some View {
    let viewTitle = "Bookmarks"
    
    NavigationView {
  
      VStack {
        List {
          
          ForEach(update(bookmarks), id: \.self) { (section: [Bookmark]) in
            
            Section(header: Text( self.groupDateFormatter.string(from: Date(timeIntervalSince1970: section[0].added)))) {
              ForEach(section, id: \.self) { bookmark in
                
                CardView(bookmark: bookmark, network: $network)
              }
              .listStyle(GroupedListStyle())
            }
          }
          
        }
        .navigationTitle(viewTitle)
        .task {
          if bookmarks.isEmpty {
            await refreshBookmarks()
          }
          
        }
        .refreshable {
          await refreshBookmarks()
        }
      
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
    
  }
}
struct BookmarksView_Previews: PreviewProvider {
  static var previews: some View {
    BookmarksView(bookmarks: [Bookmark.sampleData[0]], network: .constant(Network()), refreshBookmarks: .constant({}))
  }
}

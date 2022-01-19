//
//  ContentView.swift
//  next-star
//
//  Created by jay on 17.01.22.
//

import SwiftUI

struct BookmarksView: View {
    @State var bookmarks = [Bookmark]()
    
    var body: some View {
        let viewTitle = "Bookmarks"
        
        VStack {
            List {
                ForEach(bookmarks) { bookmark in
                    CardView(bookmark: bookmark)
                }
            }.onAppear(){
                loadCacheIfAvailable()
                getBookmarksData()
            }
        }.navigationTitle(viewTitle)
    }
}

struct BookmarksView_Previews: PreviewProvider {
    static var previews: some View {
        BookmarksView(bookmarks: [])
    }
}

extension BookmarksView {
    func getBookmarksData() {
        Network().getBookmarks { (result) in
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
}

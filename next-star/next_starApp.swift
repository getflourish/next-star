//
//  next_starApp.swift
//  next-star
//
//  Created by jay on 17.01.22.
//

import SwiftUI

@main
struct next_starApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                BookmarksView(bookmarks: [])
            }
        }
    }
}

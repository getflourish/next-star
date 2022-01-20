//
//  MainView.swift
//  next-star
//
//  Created by jay on 20.01.22.
//

import SwiftUI

struct MainView: View {
    @State var hasCredentials = true
    
    var body: some View {
        if hasCredentials {
            NavigationView {
                BookmarksView(bookmarks: [])
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

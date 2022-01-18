//
//  CardView.swift
//  next-star
//
//  Created by jay on 17.01.22.
//

import SwiftUI

struct CardView: View {
    let bookmark: Bookmark
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Link(bookmark.title,
                 destination: URL(string: bookmark.url)!)
                .padding(.top, 4)
            Spacer()
            Text(bookmark.tags.joined(separator: ", "))
                .foregroundColor(.blue)
                .padding(4)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 0.5))
                .frame(maxWidth: .infinity, alignment: .trailing)

            Spacer()
        }
    }
}

struct CardView_Previews: PreviewProvider {
    static var bookmark = Bookmark.sampleData[0]
    static var previews: some View {
        CardView(bookmark: bookmark)
            .previewLayout(.fixed(width: 400, height: 60))
    }
}

//
//  CardView.swift
//  next-star
//
//  Created by jay on 17.01.22.
//

import SwiftUI

struct CardView: View {
    @Binding var bookmark: Bookmark

    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Button(bookmark.title, action: {})
                .onTapGesture {
                    UIApplication.shared.open(URL(string: bookmark.url)!)
                }
                .onLongPressGesture {
                    // TO-DO: Navigate to edit bookmark
                }
                .padding(.top, 4)
            Spacer()
            HStack {
                NavigationLink(destination: EditBookmarkTagsView(bookmark: $bookmark)) {
                    Button(action: {}) {
                        Text("Edit tags")
                    }   
                }
                ForEach(bookmark.tags, id: \.self) { tag in
                    Text(tag).foregroundColor(.blue)
                        .padding(4)
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 0.5))
                }
            }.frame(maxWidth: .infinity, alignment: .trailing)

            Spacer()
        }
    }
}

struct CardView_Previews: PreviewProvider {
    static var bookmark = Bookmark.sampleData[0]
    static var previews: some View {
        CardView(bookmark: .constant(bookmark))
            .previewLayout(.fixed(width: 400, height: 60))
    }
}

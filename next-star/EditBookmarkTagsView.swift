//
//  EditBookmarkTagsView.swift
//  next-star
//
//  Created by jay on 19.01.22.
//

import SwiftUI

struct EditBookmarkTagsView: View {
    @Binding var bookmark: Bookmark
    @State private var newTag: String = ""
    var viewTitle = "Edit tags"
    
    var body: some View {
        VStack {
            Text(bookmark.title).font(.title)
            
            Text("Current tags:").font(.title2)
            HStack {
                ForEach(bookmark.tags, id: \.self) { tag in
                    Text(tag).foregroundColor(.blue)
                        .padding(4)
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 0.5))
                }
            }
            Form {
                TextField(
                    "Enter the new tag here",
                    text: $newTag
                ).disableAutocorrection(true)
                Button("Add tag", action: {
                    if (!self.bookmark.tags.contains(newTag)) {
                        print(newTag)
                        var newTags = self.bookmark.tags
                        print(newTags)
                        newTags.append(newTag)
                        self.bookmark.tags = newTags
                        print(self.bookmark.tags)

                        updateTagsForBookmark(tags: newTags, bookmarkId: bookmark.id)
                    }
                })
            }
        }.navigationTitle(viewTitle)
    }
}

struct EditBookmarkTagsView_Previews: PreviewProvider {
    static var previews: some View {
        EditBookmarkTagsView(bookmark: .constant(Bookmark.sampleData[0]))
    }
}

extension EditBookmarkTagsView {
    func updateTagsForBookmark(tags: [String], bookmarkId: Int) {
        Network().updateTagsForBookmark(tags: tags, bookmarkId: bookmarkId) { (result) in
            switch result {
            case.success(_):
                break
            case.failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

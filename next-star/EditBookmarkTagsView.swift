import SwiftUI

struct EditBookmarkTagsView: View {
    @Binding var bookmark: Bookmark
    @Binding var network: Network
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
                    .autocapitalization(UITextAutocapitalizationType.none)
                Button("Add tag", action: {
                    if (!self.bookmark.tags.contains(newTag)) {
                        var newTags = self.bookmark.tags
                        newTags.append(newTag)
                        self.bookmark.tags = newTags

                        updateTagsForBookmark(tags: newTags, bookmarkId: bookmark.id)
                    }
                })
            }
        }.navigationTitle(viewTitle)
    }
}

struct EditBookmarkTagsView_Previews: PreviewProvider {
    static var previews: some View {
        EditBookmarkTagsView(bookmark: .constant(Bookmark.sampleData[0]), network: .constant(Network()))
    }
}

extension EditBookmarkTagsView {
    func updateTagsForBookmark(tags: [String], bookmarkId: Int) {
        network.updateTagsForBookmark(tags: tags, bookmarkId: bookmarkId) { (result) in
            switch result {
            case.success(_):
                break
            case.failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

import SwiftUI

struct CardView: View {
  var bookmark: Bookmark
  @Binding var network: Network
  
  // Convert String to Date
  
    var body: some View {
        VStack(alignment: .leading) {
          Text(Date(timeIntervalSince1970: bookmark.added), style: .date).font(.caption).foregroundColor(.secondary).foregroundColor(.primary)
          
          
          Button( action: {}) {
            Text(bookmark.title).font(.title2)
          }
                .onTapGesture {
                    UIApplication.shared.open(URL(string: bookmark.url)!)
                }
                .onLongPressGesture {
                    // TO-DO: Navigate to edit bookmark
                }
          Text(bookmark.url).font(.caption).foregroundColor(.secondary).foregroundColor(.primary)
          
          
          Spacer()
            HStack {
                ForEach(bookmark.tags, id: \.self) { tag in
                  Text(tag).foregroundColor(.blue).font(.caption)
                        .padding(4)
                        .overlay(RoundedRectangle(cornerRadius: 2).stroke(Color.blue, lineWidth: 0.5))
                }
              Button(action: {}) {
                Image(systemName: "ellipsis")
              }.contextMenu {
               
              }.frame(maxWidth: .infinity, alignment: .trailing)
        
            }
        }.padding()
    }
}

struct CardView_Previews: PreviewProvider {
    static var bookmark = Bookmark.sampleData[0]
    static var previews: some View {
        CardView(bookmark: bookmark, network: .constant(Network()))
            .previewLayout(.fixed(width: 400, height: 200))
    }
}

import Foundation

struct Bookmark: Identifiable, Codable, Hashable {
    var id: Int
    var title: String
    var description: String
    var url: String
    var tags: [String]
    var added: Double
}


extension Bookmark {
    static let sampleData: [Bookmark] =
    [
      Bookmark(id: 1, title: "Jay.cat", description: "This is the description", url: "https://jay.cat", tags: ["music"], added: 1643023283 )
    ]
}

import Foundation

struct Bookmark: Identifiable, Codable {
    var id: Int
    var title: String
    var url: String
    var tags: [String]
}


extension Bookmark {
    static let sampleData: [Bookmark] =
    [
        Bookmark(id: 1, title: "Jay.cat", url: "https://jay.cat", tags: ["music"])
    ]
}

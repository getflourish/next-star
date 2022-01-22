import Foundation

struct BookmarksResponse: Codable {
    var status: String
    var data: [Bookmark]
}

import Foundation

class Storage {
    var filePath = "cache"
    
    private func storeCache(string: String) {
        let path = FileManager.default.urls(for: .documentDirectory,
                                            in: .userDomainMask)[0].appendingPathComponent(filePath)

        if let stringData = string.data(using: .utf8) {
            try? stringData.write(to: path)
        }
    }
    
    private func loadCache() throws -> String {
        let url = FileManager.default.urls(for: .documentDirectory,
                                              in: .userDomainMask)[0].appendingPathComponent(filePath)

        do {
            let data = try Data(contentsOf: url)
            let str = String(decoding: data, as: UTF8.self)
            return str
        } catch {
            throw error
        }
    }
    
    func loadCachedBookmarks() throws -> [Bookmark] {
        do {
            let bookmarksString = try loadCache()
            let decoder = JSONDecoder()
            let bookmarks = try decoder.decode([Bookmark].self, from: bookmarksString.data(using: .utf8)!)
            return bookmarks
        } catch {
            throw error
        }
    }
    
    func storeBookmarksToCache(bookmarks: [Bookmark]) throws {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted

        do {
            let data = try encoder.encode(bookmarks)
            let bookmarksString = String(data: data, encoding: .utf8)!
            storeCache(string: bookmarksString)
        } catch {
            throw error
        }
    }
}

//
//  BookmarksResponse.swift
//  next-star
//
//  Created by jay on 17.01.22.
//

import Foundation

struct BookmarksResponse: Codable {
    var status: String
    var data: [Bookmark]
}

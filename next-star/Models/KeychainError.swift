//
//  KeychainError.swift
//  next-star
//
//  Created by jay on 20.01.22.
//

import Foundation

enum KeychainError: Error {
    case noPassword
    case unexpectedPasswordData
    case unhandledError(status: OSStatus)
}

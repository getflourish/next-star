//
//  KeychainManager.swift
//  next-star
//
//  Created by jay on 20.01.22.
//

import Foundation

class KeychainManager {
    
    func getCredentials(server: String) throws -> Credentials {
        let query: [String: Any] = [kSecClass as String: kSecClassInternetPassword,
                                    kSecAttrServer as String: server,
                                    kSecMatchLimit as String: kSecMatchLimitOne,
                                    kSecReturnAttributes as String: true,
                                    kSecReturnData as String: true]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        guard status != errSecItemNotFound else { throw KeychainError.noPassword }
        guard status == errSecSuccess else { throw KeychainError.unhandledError(status: status) }
        
        guard let existingItem = item as? [String : Any],
            let passwordData = existingItem[kSecValueData as String] as? Data,
            let password = String(data: passwordData, encoding: String.Encoding.utf8),
            let account = existingItem[kSecAttrAccount as String] as? String
        else {
            throw KeychainError.unexpectedPasswordData
        }
        let credentials = Credentials(username: account, password: password)
        return credentials
    }
    
    func setCredentials(credentials: Credentials, server: String) throws {
        if (hasCredentials(server: server)) {
            try deleteCredentials(server: server)
        }
        
        let account = credentials.username
        let password = credentials.password.data(using: String.Encoding.utf8)!
        print("Setting credentials to")
        print(account)
        print(password)
   
        let query: [String: Any] = [kSecClass as String: kSecClassInternetPassword,
                                    kSecAttrAccount as String: account,
                                    kSecAttrServer as String: server,
                                    kSecValueData as String: password]

        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else {
            throw KeychainError.unhandledError(status: status)
        }
    }
    
    func hasCredentials(server: String) -> Bool {
        do {
            try getCredentials(server: server)
            print("has credentials for \(server)")
            return true
        }
        catch {
            return false
        }
    }
    
    func deleteCredentials(server: String) throws {
        let query: [String: Any] = [kSecClass as String: kSecClassInternetPassword,
                                    kSecAttrServer as String: server]
        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else { throw KeychainError.unhandledError(status: status) }
    }
}

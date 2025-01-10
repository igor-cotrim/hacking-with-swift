//
//  StorageService.swift
//  Swift
//
//  Created by Igor Cotrim on 09/01/25.
//

import Foundation

class StorageService: StorageServiceProtocol {
    enum Keys {
        static let people = "people"
    }
    
    func save(_ data: Data, forKey key: String) {
        UserDefaults.standard.set(data, forKey: key)
    }
    
    func load(forKey key: String) -> Data? {
        return UserDefaults.standard.data(forKey: key)
    }
}

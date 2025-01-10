//
//  StorageServiceProtocol.swift
//  Swift
//
//  Created by Igor Cotrim on 09/01/25.
//

import Foundation

protocol StorageServiceProtocol {
    func save(_ data: Data, forKey key: String)
    func load(forKey key: String) -> Data?
}

//
//  UserDefaultsWordStorage.swift
//  Swift
//
//  Created by Igor Cotrim on 10/01/25.
//

import Foundation

private enum UserDefaultsKeys {
    static let savedWords = "saveWords"
    static let currentWord = "saveCurrentWord"
}

protocol WordStorageProtocol {
    func getWords() -> [String]
    func getCurrentWord() -> String
    func saveWord(_ word: String)
    func saveCurrentWord(_ word: String)
    func clearStorage()
}

final class UserDefaultsWordStorage: WordStorageProtocol {
    private let defaults = UserDefaults.standard
    
    func getWords() -> [String] {
        defaults.array(forKey: UserDefaultsKeys.savedWords) as? [String] ?? []
    }
    
    func getCurrentWord() -> String {
        defaults.string(forKey: UserDefaultsKeys.currentWord) ?? ""
    }
    
    func saveWord(_ word: String) {
        var words = getWords()
        words.append(word)
        defaults.set(words, forKey: UserDefaultsKeys.savedWords)
    }
    
    func saveCurrentWord(_ word: String) {
        defaults.set(word, forKey: UserDefaultsKeys.currentWord)
    }
    
    func clearStorage() {
        defaults.removeObject(forKey: UserDefaultsKeys.savedWords)
        defaults.removeObject(forKey: UserDefaultsKeys.currentWord)
    }
}

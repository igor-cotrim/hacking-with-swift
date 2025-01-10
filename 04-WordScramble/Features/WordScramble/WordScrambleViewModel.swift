//
//  WordScrambleViewModel.swift
//  04-WordScramble
//
//  Created by Igor Cotrim on 24/12/24.
//

import Foundation
import UIKit

final class WordScrambleViewModel {
    private(set) var allWords: [String] = []
    private(set) var usedWords: [String] = []
    private var currentWord: String = ""
    private let storage: WordStorageProtocol
    
    var onGameStart: ((String) -> Void)?
    var onWordAdded: ((IndexPath) -> Void)?
    var showErrorMessage: ((String, String) -> Void)?
    
    init(storage: WordStorageProtocol = UserDefaultsWordStorage()) {
        self.storage = storage
    }
    
    private func loadWords() {
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt"),
           let startWords = try? String(contentsOf: startWordsURL, encoding: .utf8) {
            allWords = startWords.components(separatedBy: "\n")
        }
        
        if allWords.isEmpty {
            allWords = ["silkworm"]
        }
    }
    
    private func validate(_ word: String) -> ValidationResult {
        let lowerWord = word.lowercased()
        
        if !isPossible(word: lowerWord) {
            return .invalid("Word not possible", "You can't make words out of letters you don't have!")
        }
        if !isOriginal(word: lowerWord) {
            return .invalid("Word already used", "Be more original, please!")
        }
        if !isReal(word: lowerWord) {
            return .invalid("Word not recognized", "You can't just make them up, you know!")
        }
        
        return .valid
    }
    
    private func isPossible(word: String) -> Bool {
        var tempWord = currentWord.lowercased()
        
        if word == tempWord { return false }
        
        for character in word {
            guard let index = tempWord.firstIndex(of: character) else { return false }
            tempWord.remove(at: index)
        }
        
        return true
    }
    
    private func isOriginal(word: String) -> Bool {
        !usedWords.contains(word)
    }
    
    private func isReal(word: String) -> Bool {
        guard word.count >= 3 else { return false }
        
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(
            in: word,
            range: range,
            startingAt: 0,
            wrap: false,
            language: "en"
        )
        
        return misspelledRange.location == NSNotFound
    }
}

// MARK: - Public funcs
extension WordScrambleViewModel {
    func startGame() {
        loadWords()
        
        if storage.getWords().isEmpty || storage.getCurrentWord().isEmpty {
            currentWord = allWords.randomElement() ?? "silkworm"
            storage.saveCurrentWord(currentWord)
            usedWords.removeAll()
        } else {
            usedWords = storage.getWords()
            currentWord = storage.getCurrentWord()
        }
        
        onGameStart?(currentWord)
    }
    
    func restartGame() {
        loadWords()
        currentWord = allWords.randomElement() ?? "silkworm"
        storage.clearStorage()
        usedWords.removeAll()
        onGameStart?(currentWord)
    }
    
    func submit(answer: String) {
        let validationResult = validate(answer.lowercased())
        
        switch validationResult {
        case .valid:
            let lowerAnswer = answer.lowercased()
            storage.saveWord(lowerAnswer)
            usedWords.insert(lowerAnswer, at: 0)
            onWordAdded?(IndexPath(row: 0, section: 0))
        case .invalid(let title, let message):
            showErrorMessage?(title, message)
        }
    }
}

// MARK: - Supporting Types
private enum ValidationResult {
    case valid
    case invalid(String, String)
}

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
    
    var onGameStart: ((String) -> Void)?
    var onWordAdded: ((IndexPath) -> Void)?
    var showErrorMessage: ((String, String) -> Void)?
    
    private func loadWords() {
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordsURL, encoding: .utf8) {
                allWords = startWords.components(separatedBy: "\n")
            }
        }
        
        if allWords.isEmpty {
            allWords = ["silkworm"]
        }
    }
    
    private func isPossible(word: String) -> Bool {
        var tempWord = currentWord.lowercased()
        
        if word.lowercased() == tempWord {
            return false
        }
        
        for character in word {
            if let index = tempWord.firstIndex(of: character) {
                tempWord.remove(at: index)
            } else {
                return false
            }
        }
        
        return true
    }
    
    private func isOriginal(word: String) -> Bool {
        return !usedWords.contains(word)
    }
    
    private func isReal(word: String) -> Bool {
        guard word.count >= 3 else {
            return false
        }
        
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        
        return misspelledRange.location == NSNotFound
    }
}

// MARK: - Public funcs
extension WordScrambleViewModel {
    func startGame() {
        loadWords()
        currentWord = allWords.randomElement() ?? "silkworm"
        usedWords.removeAll()
        onGameStart?(currentWord)
    }
    
    func submit(answer: String) {
        let lowerAnswer = answer.lowercased()
        
        if !isPossible(word: lowerAnswer) {
            showErrorMessage?("Word not possible", "You can't make words out of letters you don't have!")
        } else if !isOriginal(word: lowerAnswer) {
            showErrorMessage?("Word already used", "Be more original, please!")
        } else if !isReal(word: lowerAnswer) {
            showErrorMessage?("Word not recognized", "You can't just make them up, you know!")
        } else {
            usedWords.insert(answer.lowercased(), at: 0)
            onWordAdded?(IndexPath(row: 0, section: 0))
        }
    }
}

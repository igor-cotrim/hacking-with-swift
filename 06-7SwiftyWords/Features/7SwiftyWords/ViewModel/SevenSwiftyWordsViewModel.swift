//
//  SevenSwiftyWordsViewModel.swift
//  06-7SwiftyWords
//
//  Created by Igor Cotrim on 02/01/25.
//

import Foundation

final class SevenSwiftyWordsViewModel {
    // MARK: - Published properties
    var onScoreUpdated: ((Int) -> Void)?
    var onCluesUpdated: ((String) -> Void)?
    var onAnswersUpdated: ((String) -> Void)?
    var onLevelCompleted: (() -> Void)?
    var onWrongAnswer: (() -> Void)?
    var onLettersUpdated: (([String]) -> Void)?
    var onCurrentAnswerUpdated: ((String) -> Void)?
    var onClearButtons: (() -> Void)?
    var onResetCurrentButtons: (() -> Void)?
    var onMarkButtonsAsUsed: (() -> Void)?
    
    // MARK: - Private properties
    private var score = 0 {
        didSet {
            onScoreUpdated?(score)
        }
    }
    private var currentAnswer: String = "" {
        didSet {
            onCurrentAnswerUpdated?(currentAnswer)
        }
    }
    private var currentAnswersLabel: String?
    private var level = 1
    private var correctAnswersCount = 0
    private var solutions = [String]()
    private var currentWords: [Word] = []
    private var answeredWords: Set<Int> = []
    private var currentAnswersText: String = ""
    
    // MARK: - Private methods
    private func loadLevelData(completion: @escaping (Level?) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            
            guard let levelFilePath = Bundle.main.path(forResource: "level\(self.level)", ofType: "txt"),
                  let levelContents = try? String(contentsOfFile: levelFilePath, encoding: .utf8) else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            
            var words: [Word] = []
            var letterBits: [String] = []
            
            let lines = levelContents.components(separatedBy: "\n").shuffled()
            
            for line in lines {
                let parts = line.components(separatedBy: ": ")
                let answer = parts[0]
                let clue = parts[1]
                
                let solutionWord = answer.replacingOccurrences(of: "|", with: "")
                self.solutions.append(solutionWord)
                
                words.append(Word(answer: solutionWord, clue: clue))
                letterBits += answer.components(separatedBy: "|")
            }
            
            // Voltamos para a main thread para atualizar a UI e completar o carregamento
            DispatchQueue.main.async {
                self.onLettersUpdated?(letterBits.shuffled())
                completion(Level(number: self.level, words: words))
            }
        }
    }
    
    private func updateUI(with words: [Word]) {
        var clueString = ""
        var solutionString = ""
        
        for (index, word) in words.enumerated() {
            clueString += "\(index + 1). \(word.clue)\n"
            
            if answeredWords.contains(index) {
                solutionString += "\(word.answer)\n"
            } else {
                solutionString += "\(word.answer.count) letters\n"
            }
        }
        
        onCluesUpdated?(clueString.trimmingCharacters(in: .whitespacesAndNewlines))
        currentAnswersText = solutionString.trimmingCharacters(in: .whitespacesAndNewlines)
        onAnswersUpdated?(currentAnswersText)
    }
    
    private func handleWrongAnswer() {
        if score > 0 {
            score -= 1
        }
        currentAnswer = ""
        onResetCurrentButtons?()
        onWrongAnswer?()
    }
}

// MARK: - Public Methods
extension SevenSwiftyWordsViewModel {
    func loadLevel() {
        loadLevelData { [weak self] levelData in
            guard let self = self,
                  let levelData = levelData else { return }
            
            self.currentWords = levelData.words
            self.updateUI(with: levelData.words)
        }
    }
    
    func appendLetter(_ letter: String) {
        currentAnswer += letter
    }
    
    func clearCurrentAnswer() {
        currentAnswer = ""
        onClearButtons?()
    }
    
    func submitAnswer() {
        if let solutionPosition = solutions.firstIndex(of: currentAnswer) {
            score += 1
            correctAnswersCount += 1
            answeredWords.insert(solutionPosition)
            
            var splitAnswers = currentAnswersText.components(separatedBy: "\n")
            splitAnswers[solutionPosition] = currentAnswer
            currentAnswersText = splitAnswers.joined(separator: "\n")
            onAnswersUpdated?(currentAnswersText)
            
            onMarkButtonsAsUsed?()
            
            currentAnswer = ""
            
            if correctAnswersCount == 7 {
                correctAnswersCount = 0
                answeredWords.removeAll()
                onLevelCompleted?()
            }
        } else {
            handleWrongAnswer()
        }
    }
    
    func levelUp() {
        level += 1
        if level > 2 {
            level = 1
        }
        solutions.removeAll(keepingCapacity: true)
        answeredWords.removeAll()
        currentAnswersText = ""
        loadLevel()
    }
}

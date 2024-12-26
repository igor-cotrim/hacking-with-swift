//
//  Quiz.swift
//  02-GuessTheFlag
//
//  Created by Igor Cotrim on 17/12/24.
//

import Foundation

struct Quiz {
    let countries = ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
    private(set) var currentCountries: [String] = []
    private(set) var correctAnswerIndex: Int = 0
    private(set) var score: Int = 0
    private(set) var questionNumber: Int = 1
    let totalQuestions = 10
    
    mutating func startNewQuestion() {
        currentCountries = countries.shuffled().prefix(3).map { $0 }
        correctAnswerIndex = Int.random(in: 0...2)
    }
    
    mutating func checkAnswer(index: Int) -> Bool {
        let isCorrect = index == correctAnswerIndex
        score += isCorrect ? 1 : -1
        questionNumber += 1
        
        return isCorrect
    }
    
    mutating func resetGame() {
        score = 0
        questionNumber = 1
    }
    
    var isGameOver: Bool {
        return questionNumber > totalQuestions
    }
}

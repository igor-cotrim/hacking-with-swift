//
//  ScoreManager.swift
//  08-Pachinko
//
//  Created by Igor Cotrim on 08/01/25.
//

import Foundation

class ScoreManager: ScoreManagerProtocol {
    private(set) var score: Int = 0
    var onScoreChanged: ((Int) -> Void)?
    
    func increment() {
        score += 1
        onScoreChanged?(score)
    }
    
    func decrement() {
        if score > 0 {
            score -= 1
            onScoreChanged?(score)
        }
    }
    
    func reset() {
        score = 0
        onScoreChanged?(score)
    }
}

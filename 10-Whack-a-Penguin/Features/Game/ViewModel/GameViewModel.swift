//
//  GameViewModel.swift
//  Swift
//
//  Created by Igor Cotrim on 15/01/25.
//

enum GameState {
    case playing
    case gameOver
}

class GameViewModel {
    private let config = GameConfiguration()
    private(set) var score = 0
    private(set) var numRounds = 0
    private(set) var popupTime: Double
    private(set) var gameState: GameState = .playing
    private var soundService: SoundService?
    
    var onScoreChanged: ((Int) -> Void)?
    var onGameOver: ((Int) -> Void)?
    
    init() {
        self.popupTime = config.initialPopupTime
    }
    
    func setSoundService(_ soundService: SoundService) {
        self.soundService = soundService
    }
    
    func handleCharacterTap(type: CharacterType) {
        switch type {
        case .friend:
            score += config.penaltyScore
            soundService?.playSound(.bad)
        case .enemy:
            score += config.baseScore
            soundService?.playSound(.whack)
        }
        onScoreChanged?(score)
    }
    
    func incrementRound() {
        guard gameState == .playing else { return }
        
        numRounds += 1
        if numRounds >= config.maxRounds {
            gameState = .gameOver
            onGameOver?(score)
            soundService?.playSound(.gameOver)
            return
        }
        popupTime *= config.popupTimeDecayFactor
    }
}

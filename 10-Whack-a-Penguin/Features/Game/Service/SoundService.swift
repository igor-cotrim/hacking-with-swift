//
//  SoundService.swift
//  Swift
//
//  Created by Igor Cotrim on 15/01/25.
//

import SpriteKit

enum GameSound {
    case whack, bad, gameOver
    
    var fileName: String {
        switch self {
        case .whack: return "whack.caf"
        case .bad: return "whackBad.caf"
        case .gameOver: return "GameOver.m4a"
        }
    }
}

class SoundService {
    private weak var scene: SKScene?
    
    init(scene: SKScene) {
        self.scene = scene
    }
    
    func playSound(_ sound: GameSound) {
        guard let scene = scene else { return }
        let action = SKAction.playSoundFileNamed(sound.fileName, waitForCompletion: false)
        scene.run(action)
    }
}

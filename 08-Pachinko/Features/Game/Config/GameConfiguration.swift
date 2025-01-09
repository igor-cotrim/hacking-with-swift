//
//  GameConfiguration.swift
//  08-Pachinko
//
//  Created by Igor Cotrim on 08/01/25.
//

import Foundation

enum GameConfiguration {
    static let backgroundPosition = CGPoint(x: 512, y: 384)
    static let scoreLabelPosition = CGPoint(x: 980, y: 700)
    static let ballsLabelPosition = CGPoint(x: 980, y: 650)
    static let editLabelPosition = CGPoint(x: 80, y: 700)
    static let resetLabelPosition = CGPoint(x: 200, y: 700)
    static let slotPositions = [
        CGPoint(x: 128, y: 32),
        CGPoint(x: 384, y: 32),
        CGPoint(x: 640, y: 32),
        CGPoint(x: 896, y: 32)
    ]
    static let bouncerPositions = [
        CGPoint(x: 0, y: 25),
        CGPoint(x: 256, y: 25),
        CGPoint(x: 512, y: 25),
        CGPoint(x: 768, y: 25),
        CGPoint(x: 1024, y: 25)
    ]
}
